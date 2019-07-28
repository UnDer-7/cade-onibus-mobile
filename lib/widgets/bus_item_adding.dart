import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bus.dart';

import '../providers/bus_selected.dart';

class BusItemAdding extends StatefulWidget {
    final Bus bus;

    BusItemAdding(this.bus);

    @override
    _BusItemState createState() => _BusItemState();
}

class _BusItemState extends State<BusItemAdding> {
    bool _isLoading = false;
    @override
    Widget build(BuildContext context) {
        final BusSelected _busSelected = Provider.of<BusSelected>(context);

        final double _width = MediaQuery
            .of(context)
            .size
            .width;

        return Column(
            children: <Widget>[
                if (_isLoading) Center(
                    child: CircularProgressIndicator(),
                ),
                if (!_isLoading) Row(
                    children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 0),
                            margin: EdgeInsets.only(right: 0),
                            child: Checkbox(
                                value: _isBusSelected(_busSelected),
                                onChanged: (_) => _onCheckboxChanged(_busSelected),
                            ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 0),
                            width: _width / 1.2,
                            child: ListTile(
                                onTap: () => _onCheckboxChanged(_busSelected),
                                onLongPress: () => print('long'),
                                leading: Chip(
                                    label: Text(
                                        widget.bus.numero,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                        ),
                                    ),
                                    backgroundColor: Theme
                                        .of(context)
                                        .primaryColor,
                                ),
                                title: Text(
                                    widget.bus.descricao,
                                    textAlign: TextAlign.center,
                                ),
                                trailing: Text(
                                    'R\$ ${widget.bus.tarifa.toStringAsFixed(
                                        2)}',
                                    style: TextStyle(
                                        color: Colors.red
                                    ),
                                ),
                            ),
                        )
                    ],
                ),
                if (!_isLoading) Divider(
                    color: Colors.black87,
                    indent: 10,
                    endIndent: 10,
                ),
            ],
        );
    }

    void _onCheckboxChanged(BusSelected _busSelected) {
        final buses = _busSelected.getAllBusSelected;
        final bus = widget.bus;
        final isBusAdded = buses.any((item) => item.numero == bus.numero);

        if (isBusAdded) {
            _busSelected.removeBusSelected = bus;
        } else {
            _busSelected.addBusSelected = bus;
        }
    }

    bool _isBusSelected(BusSelected busSelected) {
        final buses = busSelected.getAllBusSelected;
        final bus = widget.bus;
        return buses.any((item) => item.numero == bus.numero);
    }
}
