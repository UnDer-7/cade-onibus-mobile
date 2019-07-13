import 'package:flutter/material.dart';

import './bus_item.dart';

import '../utils/custom_colors.dart';

class BusCategory extends StatefulWidget {
    @override
    _BusCategoryState createState() => _BusCategoryState();
}

class _BusCategoryState extends State<BusCategory> {
    bool _isSelect = false;
    Color cardColor = Colors.red;

    @override
    Widget build(BuildContext context) {
        final double width = MediaQuery.of(context).size.height;
        return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: cardColor,
            child: Column(
                children: <Widget>[
                    ListTile(
                        onTap: () => setState(() => _isSelect = !_isSelect),
                        leading: Icon(
                            Icons.home,
                            color: CustomColors.switchColor(cardColor),
                        ),
                        title: Text(
                            'Ônibus para casa',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: CustomColors.switchColor(cardColor),
                            ),
                        ),
                        trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: CustomColors.switchColor(cardColor),
                        ),
                    ),
                    if (_isSelect) Container(
                        height: width/2,
                        child: Card(
                            margin: EdgeInsets.all(15),
                            color: Colors.white,
                            child: ListView.builder(
                                itemCount: 10,
                                itemBuilder: (BuildContext ctx, int i) => BusItem(),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
