part of 'file_converter_bloc.dart';

@immutable
abstract class FileConverterEvent {}

class FilePickedEvent extends FileConverterEvent {
  FilePickedEvent();
}

class FileExtensionPickedEvent extends FileConverterEvent {
  final String extension;
  FileExtensionPickedEvent(this.extension);
}

class FileDownloadEvent extends FileConverterEvent {
  FileDownloadEvent();
}

class FileConvertEvent extends FileConverterEvent {}