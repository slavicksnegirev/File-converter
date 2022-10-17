part of 'file_converter_bloc.dart';

enum ButtonState { init, convert, download }

@immutable
class FileConverterState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenFileSize;
  final String chosenExtension;
  final String outputFileName;
  final List<String> availableExtensions;
  final String resultUrl;
  final bool isLoading;
  final ButtonState buttonState;
  final String exceptionMessage;

  const FileConverterState({
    this.chosenFilePath = '',
    this.chosenFileName = '',
    this.chosenFileSize = '',
    this.chosenExtension = '',
    this.outputFileName = '',
    this.availableExtensions = const [],
    this.resultUrl = '',
    this.isLoading = false,
    this.buttonState = ButtonState.init,
    this.exceptionMessage = '',
  });

  FileConverterState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? chosenFileSize,
    String? chosenExtension,
    String? outputFileName,
    List<String>? availableExtensions,
    String? resultUrl,
    bool isLoading = false,
    ButtonState? buttonState,
    String exceptionMessage = '',
  }) {
    return FileConverterState(
      chosenFilePath: chosenFilePath ?? this.chosenFilePath,
      chosenFileName: chosenFileName ?? this.chosenFileName,
      chosenFileSize: chosenFileSize ?? this.chosenFileSize,
      chosenExtension: chosenExtension ?? this.chosenExtension,
      outputFileName: outputFileName ?? this.outputFileName,
      availableExtensions: availableExtensions ?? this.availableExtensions,
      resultUrl: resultUrl ?? this.resultUrl,
      isLoading: isLoading,
      buttonState: buttonState ?? this.buttonState,
      exceptionMessage: exceptionMessage,
    );
  }
}