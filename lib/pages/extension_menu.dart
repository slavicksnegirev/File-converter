import 'package:flutter/material.dart';

List<String> extensionMenu(final _extension) {
  List<String> newItems = [];
  switch (_extension) {
    case '.csv':
      return newItems = ['numbers'];

    case '.png':
      return newItems = [
        'gif',
        'jpg',
        'pdf',
        'pdfa',
        'png',
        'svg',
        'tiff',
        'watermark'
      ];
  }
  return newItems = ['Выберите расширение'];
}
