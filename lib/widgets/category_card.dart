import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';
import '../widgets/bus_item.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
    final Category _category;

    CategoryCard(this._category);

    @override
    Column build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final Color _cardColor = _category.cardColor;

        return Column(
            children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        _editCard(_cardColor),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text('|'),
                        ),
                        _newBus(_cardColor, context),
                    ],
                ),
                Container(
                    height: _dynamicHeight(height),
                    child: Card(
                        margin: EdgeInsets.all(15),
                        color: Colors.white,
                        child: ListView.builder(
                            itemCount: _category.buses.length,
                            itemBuilder: (BuildContext ctx, int i) => _singleBus(context, i),
                        ),
                    ),
                ),
            ],
        );
    }

    GestureDetector _editCard(Color cardColor) {
        return GestureDetector(
            onTap: () => print('EDIT!'),
            child: Icon(
                Icons.edit,
                color: CustomColors.switchColor(cardColor),
            ),
        );
    }

    GestureDetector _newBus(Color cardColor, BuildContext context) {
        return GestureDetector(
            onTap: () => print('NEW BUS'),
            child: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                    Icons.add,
                    color: CustomColors.switchColor(cardColor),
                ),
            ),
        );
    }

    Dismissible _singleBus(BuildContext context, int i) {
        return Dismissible(
            key: ValueKey(_category.buses[i].numero),
            direction: DismissDirection.endToStart,
            background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                color: Theme
                    .of(context)
                    .errorColor,
                child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                ),
            ),
            child: BusItem(_category.buses[i]),
        );
    }

    double _dynamicHeight(double height) {
        final buses = _category.buses;

        if (buses.length == 1) return height/7.7;
        if (buses.length == 2) return height/4.5;
        if (buses.length == 3) return height/3.2;
        if (buses.length == 4) return height/2.5;
        return height/2.3;
    }

}
