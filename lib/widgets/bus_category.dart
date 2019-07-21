import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/custom_colors.dart';
import '../widgets/category_card.dart';

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
                    if (_isSelect) CategoryCard(widget._category),
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
