import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:first_task_flutter/bloc/file_converter_bloc.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});
  @override
  Widget build(BuildContext context) {

    bool isFileLoaded = false;
    FileConverterBloc fileConverterBloc = FileConverterBloc();

    return BlocProvider<FileConverterBloc>(
      create: (context) => FileConverterBloc(),
      child: BlocBuilder<FileConverterBloc, FileConverterState>(
        bloc: fileConverterBloc,
        builder: ((context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Конвертер файлов'),
              backgroundColor: Colors.indigo,
            ),
            //backgroundColor: Colors.,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      fileConverterBloc.add(
                        FilePickedEvent(),
                      );
                      isFileLoaded = true;
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Colors.indigo,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50.withOpacity(1.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Iconsax.folder_open,
                                color: Colors.indigo,
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
                      ),
                    ),
                  ),
                  isFileLoaded != false
                      ? Container(
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
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.chosenFileName,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.chosenFileSize,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black26),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
                    child: DropdownButton<String>(
                      // decoration: InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      //   borderSide:
                      //       const BorderSide(width: 1, color: Colors.blue),
                      // )),
                      hint: const Text(
                        "Выберите расширение",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black26,
                        ),
                      ),
                      isExpanded: true,
                      value: state.chosenExtension,
                      items: state.availableExtensions
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black26,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: ((value) {
                        fileConverterBloc.add(
                          FileExtensionPickedEvent(value!),
                        );
                      }),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: state.buttonState == ButtonState.init
                        ? ConvertAndDownloadButton()
                        : LoadingButton(state.buttonState),
                  ),

                  // Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [

                  //       ActionButton(bloc: fileConverterBloc, state: state),
                  //       Padding(
                  //         padding: const EdgeInsets.only(
                  //           top: 30,
                  //         ),
                  //         child: SizedBox(
                  //           height: 40,
                  //           child: Visibility(
                  //             visible: state.isLoading,
                  //             child: const CircularProgressIndicator(
                  //               color: Colors.red,
                  //               value: null,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }),
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
          color: Colors.indigo,
        ),
      ),
      onPressed: () async {
        // if (platformFile != null) {
        //   String? outputFile = await FilePicker.platform.saveFile(
        //     dialogTitle: 'Выберите, куда вы хотите сохранить файл:',
        //     fileName: '1.txt',
        //   );
        //   setState(() => buttonState = ButtonState.loading);
        //   await Future.delayed(const Duration(seconds: 3));
        //   setState(() => buttonState = ButtonState.done);
        //   await Future.delayed(const Duration(seconds: 3));
        //   setState(() => buttonState = ButtonState.init);
        // }
      },
      child: const Text(
        'Конвертировать и скачать файл',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.indigo,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoadingButton(ButtonState buttonState) {
    final color =
        buttonState == ButtonState.download ? Colors.green : Colors.indigo;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        //borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: buttonState == ButtonState.download
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