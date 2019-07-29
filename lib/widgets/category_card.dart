import 'package:cade_onibus_mobile/models/bus.dart';
import 'package:cade_onibus_mobile/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../providers/bus_selected.dart';
import '../providers/user_provider.dart';

import '../utils/custom_colors.dart';
import '../widgets/bus_item_searching.dart';
import '../models/category.dart';
import '../pages/new_category_page.dart';
import '../pages/new_bus_page.dart';

class CategoryCard extends StatelessWidget {
    final Category _category;
    CategoryCard(this._category);

    @override
    Column build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final Color _cardColor = Color(_category.cardColor);
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);
        final UserProviders userProvider = Provider.of<UserProviders>(context, listen: false);

        return Column(
            children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        if (_category.title != 'Todos') _editCard(_cardColor, context, _busSelected),
                        if (_category.title != 'Todos') Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text('|'),
                        ),
                        if (_category.title != 'Todos') _newBus(_cardColor, context, _busSelected, userProvider),
                        if (_category.title == 'Todos') _todosInfoDialog(_cardColor, context),
                    ],
                ),
                Container(
                    height: _dynamicHeight(height),
                    child: Card(
                        margin: EdgeInsets.all(15),
                        color: Colors.white,
                        child: _cardContent(context, userProvider),
                    ),
                ),
            ],
        );
    }

    GestureDetector _todosInfoDialog(Color cardColor, BuildContext context) =>
        GestureDetector(
            onTap: () => _showTodosInfoDialog(context),
            child: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                    Icons.info,
                    color: CustomColors.switchColor(cardColor)
                ),
            ),
        );

    GestureDetector _editCard(Color cardColor, BuildContext context, final BusSelected busSelected) {
        return GestureDetector(
            onTap: () => _onEditingClick(context, busSelected),
            child: Icon(
                Icons.edit,
                color: CustomColors.switchColor(cardColor),
            ),
        );
    }

    dynamic _onEditingClick(BuildContext context, final BusSelected busSelected) {
        if (_category.title == 'Todos') {
            return showDialog(
                context: context,
                builder: (BuildContext ctx) =>
                    AlertDialog(
                        title: Text('Você não pode editar essa categoria'),
                        content: Text(
                            'A categoria Todos é automaticamente populada com todos seu ônibus',
                            textAlign: TextAlign.start,
                        ),
                        actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('OK'),
                            ),
                        ],
                    ),
            );
        }

        busSelected.setAllBusesSelected = _category.buses;
        return Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext ctx) => NewCategoryPage(_category),
        ));
    }

    GestureDetector _newBus(Color cardColor, BuildContext context, BusSelected busSelected, UserProviders userProvider) {
        return GestureDetector(
            onTap: () => _onAddingBus(userProvider, busSelected, context),
            child: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                    Icons.add,
                    color: CustomColors.switchColor(cardColor),
                ),
            ),
        );
    }

    _onAddingBus(UserProviders userProviders, BusSelected busSelected, BuildContext context) {
        busSelected.setAllBusesSelected = _category.buses;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) =>
                    NewBusPage(
                        isAdding: true,
                    ),
            )).then((_) async {
            _category.buses = busSelected.getAllBusSelected;
            await userProviders.updateCategory(_category);
        });
    }

    Widget _singleBus(BuildContext context, int i, UserProviders userProvider) {
        if (_category.title == 'Todos') {
            return BusItemSearching(_category.buses[i]);
        }

        return Dismissible(
            key: ValueKey(_category.buses[i].numero),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _onDeletingBus(_category.buses[i], _category.uuid, userProvider, context),
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
            child: BusItemSearching(_category.buses[i]),
        );
    }

    Widget _cardContent(BuildContext context, UserProviders userProvider) {
        if (_category.buses.isEmpty) {
            return Container(
                width: double.infinity,
                child: Center(
                    child: Text(
                        'Categoria Vazia\nAdicione mais ônibus clicando no +',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                        ),
                    ),
                ),
            );
        }

        return ListView.builder(
            itemCount: _category.buses.length,
            itemBuilder: (BuildContext ctx, int i) => _singleBus(context, i, userProvider),
        );
    }

    _onDeletingBus(Bus bus, String id, UserProviders userProvider, BuildContext ctx) async {
        try {
            await userProvider.deleteBus(bus, id);
        } on DioError catch(e) {
            print('ERRO AO DELETAR ONIBUS\n$e');
            ToastUtil.showToast('Algo deu errado', ctx, color: ToastUtil.error, duration: 5);
        }
    }

    _showTodosInfoDialog(BuildContext context) =>
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text('Categoria Todos'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        'A categoria Todos contem os ônibus de todas as categorias.\n\n'
                            'Você não pode editar ela (adicionar ou remover ônibus), os ônibus são colocados automaticamene.\n\n'
                            'A categoria Todos tem todos os ônibus cadastrados no site do Cadê Ônibus (cadeonibus.web.app)\n\n'
                            'Se você remover um ônibus de alguma categora e esse ônibus não estiver cadastro em mais nem uma, ele sera excluido da categoria Todos.\n\n'
                            'A categoria Todos não possui ônibus repetidos.',
                        textAlign: TextAlign.start,
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                                'Fechar',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                ),
                            ),
                        )
                    ],
                ),
        );

    double _dynamicHeight(double height) {
        final buses = _category.buses;

        if (buses.isEmpty) return height/12;
        if (buses.length == 1) return height/7.7;
        if (buses.length == 2) return height/4.5;
        if (buses.length == 3) return height/3.2;
        if (buses.length == 4) return height/2.5;
        return height/2.3;
    }

}
