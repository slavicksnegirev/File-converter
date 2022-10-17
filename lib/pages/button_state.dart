import 'package:flutter/material.dart';
import 'package:first_task_flutter/bloc/file_converter_bloc.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.bloc, required this.state});

  final FileConverterBloc bloc;
  final FileConverterState state;

  @override
  Widget build(BuildContext context) {
    switch (state.buttonState) {
      case ButtonState.init:
        {
          return ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.warning),
            label: const Text('Выберите файл'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100]),
          );
        }
      case ButtonState.convert:
        {
          return ElevatedButton.icon(
            onPressed: () {
              bloc.add(FileConvertEvent());
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Конвертировать',
                style: TextStyle(fontSize: 25, color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
          );
        }
      case ButtonState.download:
        {
          return ElevatedButton.icon(
            onPressed: () async {
              bloc.add(FileDownloadEvent());
            },
            icon: const Icon(Icons.file_download),
            label: const Text('Скачать',
                style: TextStyle(fontSize: 25, color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
          );
        }
      default:
        {
          return const RawMaterialButton(
              onPressed: null, child: Text('Unexpected state'));
        }
    }
  }
}