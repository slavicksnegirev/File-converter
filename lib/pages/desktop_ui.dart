import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_task_flutter/bloc/file_converter_bloc.dart';

class DesktopUI extends StatefulWidget {
  const DesktopUI({super.key});

  @override
  State<DesktopUI> createState() => _DesktopUIState();
}

class _DesktopUIState extends State<DesktopUI> {
  @override
  Widget build(BuildContext context) {
    FileConverterBloc fileConverterBloc = FileConverterBloc();
    return  BlocProvider<FileConverterBloc>(
      create: (context) => FileConverterBloc(),
        child: BlocBuilder<FileConverterBloc, FileConverterState>(
            bloc: fileConverterBloc,
            builder: ((context, state) {
              return Scaffold(appBar: AppBar(
        title: const Text('Конвертер файлов'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FileDialogWidget(),
            platformFile != null ? DownloadedFile() : Container(),
            FileExtensionWidget(),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: isStretched
                  ? ConvertAndDownloadButton()
                  : LoadingButton(isDownloadingDone),
            ),
          ],
        ),
      ),
    );
  }}
}