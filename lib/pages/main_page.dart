import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:first_task_flutter/pages/desktop_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';

import 'package:first_task_flutter/bloc/file_converter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

enum ButtonState { init, loading, done }

class _HomePageState extends State<HomePage> {
  ButtonState buttonState = ButtonState.init;

  File? file;
  PlatformFile? platformFile;
  String? selectedItem = 'Выберите расширение';

  var items = [
    'Выберите расширение',
    'txt',
  ];

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    setState(() {
      file = File(result.files.single.path!);
      platformFile = result.files.single;
      final _extension = extension(result.files.single.path!);
      //print(_extension);
      // TO DO
      // fix menu
      //items = extensionMenu(_extension);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isStretched = buttonState == ButtonState.init;
    final isDownloadingDone = buttonState == ButtonState.done;

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return MainWindow(isStretched, isDownloadingDone);
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      return const DesktopLayout();
    } else {
      return MainWindow(isStretched, isDownloadingDone);
    }
  }

  // ignore: non_constant_identifier_names
  Scaffold MainWindow(bool isStretched, bool isDownloadingDone) {
    return Scaffold(
      appBar: AppBar(
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
  }

  // ignore: non_constant_identifier_names
  Container DownloadedFile() {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выбранный файл',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        spreadRadius: 2,
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            platformFile!.name,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${(platformFile!.size / 1024).ceil()} KB',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black26),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  
  }

  // ignore: non_constant_identifier_names
  GestureDetector FileDialogWidget() {
    return GestureDetector(
      onTap: selectFile,
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
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  // ignore: non_constant_identifier_names
  Container FileExtensionWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1, color: Colors.blue),
        )),
        value: selectedItem,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black26,
                        overflow: TextOverflow.ellipsis,
                      )),
                ))
            .toList(),
        onChanged: (item) => setState(() => selectedItem = item),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  OutlinedButton ConvertAndDownloadButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            width: 1,
            color: Colors.blue,
          )),
      onPressed: () async {
        if (platformFile != null) {
          String? outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Выберите, куда вы хотите сохранить файл:',
            fileName: '1.txt',
          );
          setState(() => buttonState = ButtonState.loading);
          await Future.delayed(const Duration(seconds: 3));
          setState(() => buttonState = ButtonState.done);
          await Future.delayed(const Duration(seconds: 3));
          setState(() => buttonState = ButtonState.init);
        }
      },
      child: const Text(
        'Конвертировать и скачать файл',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoadingButton(bool isDownloadingDone) {
    final color = isDownloadingDone ? Colors.green : Colors.blue;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        //borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: isDownloadingDone
            ? const Icon(
                Icons.done,
                size: 48,
                color: Colors.white,
              )
            : const CircularProgressIndicator(
                strokeWidth: 4,
                color: Colors.white,
              ),
      ),
    );
  }
}
