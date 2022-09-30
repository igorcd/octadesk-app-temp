import 'dart:io';

import 'package:flutter/material.dart';

class AttachedPicture extends StatelessWidget {
  final String directory;
  const AttachedPicture(this.directory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(directory), fit: BoxFit.cover);
  }
}
