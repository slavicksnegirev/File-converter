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
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYTgwM2JjMjQ1ZWVhZDU0YTUxMGFjNDhiZTEyYmNiNGJmOTg4YjQwYjZkYTJmMWQ3MjI4ZjA5ODI0MWQxMDdmMDEzNTFjNTc4MTU4MzdmYTEiLCJpYXQiOjE2NjYwMjY3MzMuNTg3NTYyLCJuYmYiOjE2NjYwMjY3MzMuNTg3NTY1LCJleHAiOjQ4MjE3MDAzMzMuNTg1MDUxLCJzdWIiOiI2MDMzMjg5MCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.QiSFLzrfFdQDGbkvWJKRqVOoP8vU_jBqJM-aaqg_fpRNB11k-u2FvjqUqgfBH0QwzuBqgBqIf6zc7hmrYc5NwwvafECpr5AtxuBvGfnRxehnUjeOeqlYsDIuKCF1sUh7bY_F3Q33yLqY-wjUmiJ5at1MFYkpGlLLU75ve1a48vv5F0PekAM17SPVchvtZaEv-1TesM0FjYGCEp71OSACpWXTRCtTGPk3FHRQ6bx7G3E96wthvrwlpwsGYm7DaVBR6U6ZJBtw7AE6c76IvJ-0lDVwW_SS5T9pk2Km3CfRvDp_W5tXBlp1rZANBUnjUapzrAMkoUoX7wpjHjmSmINtIW1ZhFp7JtuP6kBXEuyknoK1zIVlK2Nljz-YxlYb8CJ8UscvXtrSL9Q5X8xcKs_L8Agk_5rPMptf_47EaU5Txs4tniaO7THOyFbPeT6BjyTHi1EHqh2iKfFa1wdfad6f9Lnf25jidrgf4zwRTvziaFD1CMuzfbCb2uafNyL7iReq29k5Ibb1zQNMQTtiJNSYKP-Zy8Zg28Ol8gUHTO0P2M5AP9DNIfoVXvadMhqeEfXgTJWm09U3AWei2-1Rj04uwQPY_FPfxRn63BQJ8KOgV6ALHRDQYZW540u3PlwXXhKsLlUp4y7mno4dqblVYc5UcIIZ1O6A9L68nsLAnFnJrBY',
    baseUrls: BaseUrls.sandbox,
  );

  FileConverterBloc() : super(const FileConverterState()) {
    on<FilePickedEvent>(filePicked);
    on<FileExtensionPickedEvent>(fileExtensionPicked);
    on<FileConvertEvent>(fileConvert);
    on<FileDownloadEvent>(fileDownload);
  }

  filePicked(
    FilePickedEvent event,
    Emitter<FileConverterState> emit,
  ) async {
    FilePickerResult? result;
    PlatformFile? platformFile;
    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        platformFile = result.files.single;
        emit(state.copyWith(
          chosenFilePath: result.files.first.path,
          chosenFileName: result.files.first.name,
          chosenFileSize: '${(platformFile.size / 1024).ceil()} KB',
          isLoading: true,
        ));
        final ConverterResult formats =
            await client.getSupportedFormats(state.chosenFilePath);
        if (formats.exception == null) {
          List<String> list = formats.result;
          if (list.isNotEmpty) {
            ConverterResult result = await client.getConvertGroup(
              state.chosenFilePath,
              list.first,
            );
            if (result.exception != null) {
              emit(
                state.copyWith(
                  exceptionMessage: result.exception!['message'],
                ),
              );
              return;
            }
          }
          emit(
            state.copyWith(
              availableExtensions: list,
              chosenExtension: list.isNotEmpty ? list.first : null,
              buttonState:
                  list.isNotEmpty ? ButtonState.convert : ButtonState.init,
            ),
          );
        } else {
          emit(state.copyWith(exceptionMessage: formats.exception!['message']));
        }
      }
    } catch (e) {
      emit(FileConverterState(exceptionMessage: e.toString()));
    }
  }

  fileExtensionPicked(
      FileExtensionPickedEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    ConverterResult result =
        await client.getConvertGroup(state.chosenFilePath, event.extension);
    if (result.exception == null) {
    } else {
      emit(state.copyWith(exceptionMessage: result.exception!['message']));
      return;
    }
    emit(state.copyWith(
      chosenExtension: event.extension,
      buttonState:
          event.extension == '' ? ButtonState.init : ButtonState.convert,
    ));
  }

  fileConvert(FileConvertEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      ConverterResult result = await client.postJob(
        state.chosenFilePath,
        state.chosenExtension,
      );
      if (result.exception == null) {
        emit(
          state.copyWith(
            resultUrl: result.result,
            buttonState: ButtonState.download,
          ),
        );
      } else {
        emit(state.copyWith(exceptionMessage: result.exception!['message']));
      }
    } catch (e) {
      emit(FileConverterState(exceptionMessage: e.toString()));
    }
  }

  fileDownload(FileDownloadEvent event, Emitter<FileConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    String? directory;
    try {
      directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        await client.downloadResult(
          state.resultUrl,
          state.outputFileName.isNotEmpty
              ? state.outputFileName
              : state.chosenFileName,
          state.chosenExtension,
          directory,
        );
        emit(const FileConverterState());
      } else {
        emit(state.copyWith(exceptionMessage: 'Директория не выбрана'));
      }
    } catch (e) {
      emit(FileConverterState(exceptionMessage: e.toString()));
    }
  }
}
