import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../routes.dart';

import '../models/category.dart';
import '../models/bus.dart';

import '../widgets/bus_category.dart';

class BusTab extends StatelessWidget {
    final List<Category> _categories = [
        Category(
            title: 'Casa',
            cardColor: Colors.green,
            icon: Icons.home,
            buses: [
                Bus(
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
                ),
                Bus(
                    numero: '501.4',
                    descricao: 'Sobradinho II-II / Eixo-Norte/Sul',
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
                ),
                Bus(
                    numero: '517',
                    descricao: 'Sobradinho II / W3-Norte/Sul',
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
                )
            ],
        ),
        Category(
            title: 'Faculdade',
            cardColor: Colors.red,
            icon: Icons.school,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Casa da Namorada',
            cardColor: Colors.black,
            icon: Icons.school,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Faculdade do grande marcelão',
            cardColor: Colors.white,
            icon: Icons.school,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
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
                        tarifa: 2.50
                    )
                ),
            ],
        )
    ];

    @override
    Scaffold build(BuildContext context) =>
        Scaffold(
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        onTap: () => Navigator.pushNamed(context, Routes.NEW_BUS_SCREEN),
                        child: Icon(Icons.directions_bus),
                        label: 'Novo Ônibus'
                    ),
                    SpeedDialChild(
                        onTap: () => Navigator.pushNamed(context, Routes.NEW_CATEGORY_SCREEN),
                        child: Icon(Icons.category),
                        label: 'Nova Categoria'
                    ),
                ],
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                        colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Theme.of(context).primaryColor.withOpacity(0.8),
                            Theme.of(context).primaryColor.withOpacity(0.6),
                            Theme.of(context).primaryColor.withOpacity(0.5),
                            Theme.of(context).primaryColor.withOpacity(0.4),
                            Theme.of(context).primaryColor.withOpacity(0.4),
                        ],
                    ),
                ),
                child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (BuildContext ctx, int i) => BusCategory(_categories[i]),
                ),
            ),
        );
}
