import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_task_flutter/bloc/file_converter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class DesktopUI extends StatefulWidget {
  const DesktopUI({super.key});

  @override
  State<DesktopUI> createState() => _DesktopUIState();
}

class _DesktopUIState extends State<DesktopUI> {
  @override
  Widget build(BuildContext context) {
    FileConverterBloc fileConverterBloc = FileConverterBloc();
    return BlocProvider<FileConverterBloc>(
      create: (context) => FileConverterBloc(),
      child: BlocBuilder<FileConverterBloc, FileConverterState>(
        bloc: fileConverterBloc,
        builder: ((context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Конвертер файлов'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      fileConverterBloc.add(FilePickedEvent());
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Colors.blue,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Iconsax.folder_open,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Выберите файл',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black26),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  // platformFile != null ? DownloadedFile() : Container(),
                  // FileExtensionWidget(),
                  // Container(
                  //   height: 50,
                  //   padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  //   child: isStretched
                  //       ? ConvertAndDownloadButton()
                  //       : LoadingButton(isDownloadingDone),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
