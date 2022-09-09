import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OctaAppVersion extends StatefulWidget {
  const OctaAppVersion({Key? key}) : super(key: key);

  @override
  State<OctaAppVersion> createState() => _OctaAppVersionState();
}

class _OctaAppVersionState extends State<OctaAppVersion> {
  String version = "";

  void _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.s03_5),
      child: Text(
        version,
        style: const TextStyle(fontSize: AppSizes.s03, color: Colors.black26),
      ),
    );
  }
}
