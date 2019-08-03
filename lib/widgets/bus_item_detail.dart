import 'package:flutter/material.dart';

import '../models/bus.dart';
import '../utils/custom_colors.dart';

class BusItemDetail extends StatefulWidget {
    final Bus bus;
    final Color _cardColor;
    final bool _isMultiSelection;

    BusItemDetail(this.bus, [this._cardColor, this._isMultiSelection = true]);

    @override
    _BusItemState createState() => _BusItemState();
}

class _BusItemState extends State<BusItemDetail> {

    @override
    Widget build(BuildContext context) {

        return Padding(
            padding: EdgeInsets.all(5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Flexible(
                        flex: 4,
                        child: Container(
                            child: Chip(
                                label: Text(
                                    widget.bus.numero,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: CustomColors.switchColor(getCardColor(context)),
                                    ),
                                ),
                                backgroundColor: getCardColor(context),
                            ),
                        ),
                    ),
                    Flexible(
                        flex: 8,
                        child: Container(
                            child: Text(
                                widget.bus.descricao,
                                textAlign: TextAlign.center,
                            ),
                        ),
                    ),
                    if (widget._isMultiSelection) Flexible(
                        flex: 3,
                        child: Container(
                            child: Text(
                                'R\$ ${widget.bus.tarifa.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.red
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Color getCardColor(BuildContext context) {
        if (widget._cardColor == null) return Theme.of(context).primaryColor;
        return widget._cardColor;
    }
}
