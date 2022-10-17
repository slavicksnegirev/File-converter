import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudconvert_client/cloudconvert_client.dart';

part 'file_converter_event.dart';
part 'file_converter_state.dart';

class FileConverterBloc extends Bloc<FileConverterEvent, FileConverterState> {

    Client client = Client(
    apiKey:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjFmNzQyNzZjODAxNjBmMDUyYTBmMzY1Y2RkNWY2ZjFmYWQyYzNiNWVlN2RhYjAzMTRjNmUxNTQwYzg4ZDRiNDMxYzM5NmFjMWE3MTdjM2IiLCJpYXQiOjE2NjU5MjkyNjIuODcwOTA0LCJuYmYiOjE2NjU5MjkyNjIuODcwOTA1LCJleHAiOjQ4MjE2MDI4NjIuODY4MjcsInN1YiI6IjYwMzMyODkwIiwic2NvcGVzIjpbInVzZXIucmVhZCIsInVzZXIud3JpdGUiLCJ0YXNrLnJlYWQiLCJ0YXNrLndyaXRlIiwid2ViaG9vay5yZWFkIiwid2ViaG9vay53cml0ZSIsInByZXNldC5yZWFkIiwicHJlc2V0LndyaXRlIl19.lvSFkOcQ3fKQgH0a6ZJLkBxLfve1IZpzy3Wy5seeIPELrqDviHllVVnN_3Z7olQNfPJoYCNNxikvcw3eoWc3ZNm6fUY5bYrZGLPpsZ6o2ylf3VoQ4vsRIjwmC-OA5NB--G8EVs3lr02aHNBKEqTglvMvYAzrg9tVeRaJxlcZA1bgpVKsXZcxSykIbFw5_2GgMNZMjIv7Tp4GP4PLIHOhaB2Emw1R_3f2ukh50_FdUuiHw0EwweOjgPtHn3fHTbnut8GFXAYAHCSOMTLUoO9Ed-JxgpmUd0D-Q1fvJJtY-G440VHA-M1jEu8bNkW6keTxVZ89920r2sGl25B5MDdgJpJO40mQMIwuvOFrNDzKN1j1QcCi0uVJUEwu3-lZjtatHaSiJYDXWomosNUqu2M0gsIinS4vWO6-2263O6zRm1BWSm0V7mK-1yjops8FjDBQxzBcS5yPEhneWBzRClTB7pW3BEEOx8OZ2YVK5pOuWin9mmLa-lyNWtLzMv7FRSV_9vadTdI3o0B17u8MOcJEkBXNegYFPzgGp-Ny12DjpwyIdC9K_XY6HPy611eWBh6f7D2KE5EHJwZR_1-5IuSo6OFCSB1RPQArAXBLzw_H1AuRAoiPOaKJ5V-OAYObLRbNoQXDa4bXFhR57FHuRMWkS7r4qDkzwytKQjbOdorTOKs',
    baseUrls: BaseUrls.sandbox,
  );
  FileConverterBloc() : super(const FileConverterState()) {
    on<FileConverterEvent>((event, emit) async {
      if (event is FilePickedEvent) {
        filePicked;
      } else if (event is FileExtensionPickedEvent) {
        await fileExtensionPicked;
      } else if (event is FileDownloadEvent) {
        await fileDownload;
      } else if (event is FileConvertEvent) {
        await fileConvert;
      }
    });
  }

  filePicked(
    FilePickedEvent event,
    Emitter<FileConverterState> emit,
  ) async {
    FilePickerResult? result;
    try {
      print('yes');
      result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        emit(state.copyWith(
          chosenFilePath: result.files.first.path,
          chosenFileName: result.files.first.name,
          isLoading: true,
        ));
        final ConverterResult formats =
            await client.getSupportedFormats(state.chosenFilePath);
        if (formats.exception == null) {
          List<String> list = formats.result;
          emit(state.copyWith(
            availableExtensions: list,
            chosenFileExtension: list.isNotEmpty ? list.first : null,
          ));
        } else {
          emit(state.copyWith());
          print(formats.exception);
        }
      }
    } catch (e) {
      print(e);
      emit(const FileConverterState());
    }
  }

  fileExtensionPicked(
      FileExtensionPickedEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    String group = '';
    ConverterResult result =
        await client.getConvertGroup(state.chosenFilePath, event.extension);
    if (result.exception == null) {
      group = result.result;
    } else {
      print(result.exception);
    }
    emit(state.copyWith(
      chosenFileExtension: event.extension,
    ));
  }

  fileConvert(FileConvertEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      ConverterResult result = await client.postJob(
        state.chosenFilePath,
        state.chosenFileExtension,
      );
      if (result.exception == null) {
        print(result.result);
        emit(state.copyWith(
          resultUrl: result.result,
        ));
      } else {
        print(result.exception);
        emit(state.copyWith());
      }
    } catch (e) {
      print(e);
      emit(const FileConverterState());
    }
  }

  // Action Button поменять
  fileDownload(FileDownloadEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    String? directory;
    try {
      directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        await client.downloadResult(
          state.resultUrl,
          state.chosenFileName,
          state.chosenFileExtension,
          directory,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      emit(const FileConverterState());
    }
  }
}