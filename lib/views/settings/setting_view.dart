import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: PageStorageKey('settings_page'),
      child: Text(
        'Trang Cài đặt',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
