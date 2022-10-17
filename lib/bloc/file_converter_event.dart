part of 'file_converter_bloc.dart';

@immutable
abstract class FileConverterEvent {}

class FilePickedEvent extends FileConverterEvent {
  late final BuildContext context;
}

class FileExtensionPickedEvent extends FileConverterEvent {
  final String extension;
  FileExtensionPickedEvent(this.extension);
}

class FileConvertEvent extends FileConverterEvent {}

class FileDownloadEvent extends FileConverterEvent {}

class ExceptionCaughtEvent extends FileConverterEvent {
  final String exception;
  ExceptionCaughtEvent(this.exception);
}