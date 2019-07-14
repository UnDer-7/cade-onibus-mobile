import 'package:flutter/material.dart';

import './bus_item.dart';

import '../models/bus.dart';

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
        final double height = MediaQuery.of(context).size.height;
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
                        height: height/2,
                        child: Card(
                            margin: EdgeInsets.all(15),
                            color: Colors.white,
                            child: ListView.builder(
                                itemCount: 10,
                                itemBuilder: (BuildContext ctx, int i) => Dismissible(
                                    key: ValueKey('eae'),
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
                                    child: BusItem(Bus(
                                        numero: '501.3',
                                        descricao: 'Sobradinho II / Eixo-Norte/Sul',
                                        ativa: null,
                                        bacia: null,
                                        operadoras: null,
                                        sentido: null,
                                        sequencial: null,
                                        tipoLinha: null,
                                        tiposOnibus: null,
                                        id: null,
                                        faixaTarifaria: FaixaTarifaria(
                                            descricao: null,
                                            sequencial: null,
                                            tarifa: 5.00
                                        )
                                    )),
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
