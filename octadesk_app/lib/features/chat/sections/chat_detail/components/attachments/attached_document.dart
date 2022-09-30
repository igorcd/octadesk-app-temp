import 'dart:io';
import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';

class AttachedDocument extends StatelessWidget {
  final String extension;
  final String name;
  final String file;
  final String icon;
  const AttachedDocument({required this.icon, required this.extension, required this.name, required this.file, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = File(file).lengthSync();
    var sizeText = formatBytesHelper(size, 2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: AppSizes.s07,
              ),
              const SizedBox(width: AppSizes.s00_5),
              Text(
                extension.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.s04_5),
              )
            ],
          ),
          const SizedBox(height: AppSizes.s01),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppSizes.s03),
          ),
          Text(
            sizeText,
            style: const TextStyle(fontSize: AppSizes.s02_5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
