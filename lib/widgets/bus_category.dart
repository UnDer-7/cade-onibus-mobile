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

//                    Container(
//                        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
//                        child: GestureDetector(
//                            onTap: () => setState(() => _isSelect = !_isSelect),
//                            child: Row(
//                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                    Icon(
//                                        widget._category.icon,
//                                        color: CustomColors.switchColor(_cardColor),
//                                    ),
//                                    Text(
//                                        widget._category.title,
//                                        textAlign: TextAlign.left,
//                                        style: TextStyle(
//                                            color: CustomColors.switchColor(_cardColor),
//                                        ),
//                                    ),Icon(
//                                        _arrowIcon,
//                                        color: CustomColors.switchColor(_cardColor),
//                                    )
//                                ],
//                            ),
//                        ),
//                    ),
                    if (_isSelect) Container(
                        height: height/2.5,
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
}
