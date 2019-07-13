import 'package:flutter/material.dart';

import './tabs/main_tabs.dart';

void main() => runApp(CadeVan());

class CadeVan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadê Ônibus',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainTabs(),
    );
  }
}
