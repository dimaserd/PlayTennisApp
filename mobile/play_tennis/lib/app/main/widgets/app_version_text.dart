import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionText extends StatefulWidget {
  const AppVersionText({super.key});

  @override
  State<AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  PackageInfo? packageInfo;

  Future<PackageInfo?> _getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
    return packageInfo;
  }

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) => Text(
        'V ${packageInfo?.version ?? ''}',
        style: const TextStyle().copyWith(
            fontSize: 9, fontStyle: FontStyle.italic, color: Colors.black),
      );
}
