import 'package:flutter/material.dart';

import './bus_item.dart';
import '../models/category.dart';
import '../utils/custom_colors.dart';

class BusCategory extends StatefulWidget {
    final Category _category;

    BusCategory(this._category);

    @override
    _BusCategoryState createState() => _BusCategoryState();
}

class _BusCategoryState extends State<BusCategory> {
    bool _isSelect = false;

    @override
    Widget build(BuildContext context) {
        final _cardColor = widget._category.cardColor;

        final double height = MediaQuery.of(context).size.height;
        return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: _cardColor,
            child: Column(
                children: <Widget>[
                    ListTile(
                        onTap: () => setState(() => _isSelect = !_isSelect),
                        leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                                    _icon,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _fontSize,
                                    ),
                                ),
                            ),
                        ),
                        title: Text(
                            widget._category.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: CustomColors.switchColor(_cardColor),
                            ),
                        ),
                        trailing: Icon(
                            _arrowIcon,
                            color: CustomColors.switchColor(_cardColor),
                        ),
                    ),
                    if (_isSelect) Column(
                        children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    GestureDetector(
                                        onTap: () => print('EDIT!'),
                                        child: Icon(
                                            Icons.edit,
                                            color: CustomColors.switchColor(_cardColor),
                                        ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 7),
                                        child: Text('|'),
                                    ),
                                    GestureDetector(
                                        onTap: () => print('new bus'),
                                        child: Padding(
                                            padding: const EdgeInsets.only(right: 13),
                                            child: Icon(
                                                Icons.add,
                                                color: CustomColors.switchColor(_cardColor),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                            Container(
                                height: _dynamicHeight(height),
                                child: Card(
                                    margin: EdgeInsets.all(15),
                                    color: Colors.white,
                                    child: ListView.builder(
                                        itemCount: widget._category.buses.length,
                                        itemBuilder: (BuildContext ctx, int i) => Dismissible(
                                            key: ValueKey(widget._category.buses[i].numero),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.only(right: 20),
                                                color: Theme.of(context).errorColor,
                                                child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 40,
                                                ),
                                            ),
                                            child: BusItem(widget._category.buses[i]),
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }

    IconData get _arrowIcon {
        if (_isSelect) return Icons.keyboard_arrow_up;
        return Icons.keyboard_arrow_down;
    }

    String get _icon {
        final title = widget._category.title.split(' ');
        StringBuffer finalTitle = StringBuffer();

        if (title.length > 3) {
            final firstLetter = title.first.substring(0, 1);
            final lastLatter = title.last.substring(0, 1);
            finalTitle.write(firstLetter + lastLatter);
        } else {
            title.forEach((item) {
                finalTitle.write(item.substring(0, 1));
            });
        }
        return finalTitle.toString();
    }

    double get _fontSize {
        if (_icon.length == 2) return 20;
        if (_icon.length == 3) return 18;
        return 30;
    }

    double _dynamicHeight(double height) {
        final buses = widget._category.buses;

        if (buses.length == 1) return height/7.7;
        if (buses.length == 2) return height/4.5;
        if (buses.length == 3) return height/3.2;
        if (buses.length == 4) return height/2.5;
        return height/2.3;
    }
}
