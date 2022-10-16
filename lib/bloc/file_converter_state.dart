part of 'file_converter_bloc.dart';

enum ButtonState { init, loading, done }

@immutable
class FileConverterState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenFileExtension;
  final List<String> availableExtensions;
  final String resultUrl;
  final bool isLoading;

  const FileConverterState(
      {this.chosenFilePath = '',
      this.chosenFileName = '',
      this.chosenFileExtension = '',
      this.availableExtensions = const [],
      this.resultUrl = '',
      this.isLoading = false});

  FileConverterState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? chosenFileExtension,
    List<String>? availableExtensions,
    String? resultUrl,
    bool isLoading = false,
  }) {
    return FileConverterState(
        chosenFilePath: chosenFilePath ?? this.chosenFilePath,
        chosenFileName: chosenFileName ?? this.chosenFileName,
        chosenFileExtension: chosenFileExtension ?? this.chosenFileExtension,
        availableExtensions: availableExtensions ?? this.availableExtensions,
        resultUrl: resultUrl ?? this.resultUrl,
        isLoading: isLoading);
  }
}