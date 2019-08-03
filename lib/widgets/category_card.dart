import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../services/location_service.dart';

import '../widgets/bus_item_detail.dart';

import '../providers/bus_selected.dart';
import '../providers/user_provider.dart';

import '../utils/custom_colors.dart';
import '../utils/toast_util.dart';

import '../models/category.dart';
import '../models/bus.dart';
import '../models/coordinates.dart';

import '../pages/new_category_page.dart';
import '../pages/new_bus_page.dart';
import '../pages/map_page.dart';

class CategoryCard extends StatefulWidget {
    final Category _category;
    CategoryCard(this._category);

    @override
    _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
    final List<Bus> _busesToTrack = [];
    bool _isMultiSelection;
    bool _isLoading;

    @override
    void initState() {
        _isLoading = false;
        _isMultiSelection = false;
        super.initState();
    }

    @override
    WillPopScope build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final double _width = MediaQuery.of(context).size.width;

        final Color _cardColor = Color(widget._category.cardColor);
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);
        final UserProviders userProvider = Provider.of<UserProviders>(context, listen: false);
        final Color _findBusesButtonColor = CustomColors.switchColor(_cardColor);

        return WillPopScope(
            onWillPop: () {
                if (_isMultiSelection) {
                    setState(() => _isMultiSelection = false);
                    _busesToTrack.clear();
                    return Future.value(false);
                }

                _busesToTrack.clear();
                return Future.value(true);
            },
            child: Column(
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                            if (widget._category.title != 'Todos') _editCard(_cardColor, context, _busSelected, userProvider),
                            if (widget._category.title != 'Todos') Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: Text('|'),
                            ),
                            if (widget._category.title != 'Todos') _newBus(_cardColor, context, _busSelected, userProvider),
                            if (widget._category.title == 'Todos') _todosInfoDialog(_cardColor, context),
                        ],
                    ),
                    Container(
                        height: _dynamicHeight(height),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.all(15),
                            color: Colors.white,
                            child: _cardContent(context, userProvider, _cardColor, _width),
                        ),
                    ),
                    if (_isMultiSelection) Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 3),
                        child: RaisedButton(
                            color: _findBusesButtonColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () => _sendToGoogleMaps(context),
                            elevation: 10,
                            child: Text(
                                'Procurar',
                                style: TextStyle(
                                    color: CustomColors.switchColor(_findBusesButtonColor)
                                ),
                            ),
                        ),
                    )
                ],
            ),
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

    GestureDetector _editCard(Color cardColor, BuildContext context, final BusSelected busSelected, final UserProviders userProviders) {
        return GestureDetector(
            onTap: () => _onEditingClick(context, busSelected, userProviders),
            child: Icon(
                Icons.edit,
                color: CustomColors.switchColor(cardColor),
            ),
        );
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

    Widget _singleBus(BuildContext context, int i, UserProviders userProvider, double width, Color cardColor) {
        final Bus bus =  widget._category.buses[i];

        if (widget._category.title == 'Todos') {
            return _buildSingleBusDetail(bus, cardColor);
        }

        return Dismissible(
            key: ValueKey(bus.numero),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _onDeletingBus(bus, widget._category.uuid, userProvider, context),
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
            child: _buildSingleBusDetail(bus, cardColor),
        );
    }

    Row _buildSingleBusDetail(Bus bus, Color cardColor) =>
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                if (_isMultiSelection) Flexible(
                    flex: 2,
                    child: Checkbox(
                        activeColor: cardColor,
                        checkColor: CustomColors.switchColor(cardColor),
                        value: _busesToTrack.any((item) => item.numero == bus.numero),
                        key: Key(bus.numero),
                        onChanged: (value) => _onSelectionBus(bus),
                    ),
                ),
                Flexible(
                    flex: 6,
                    child: BusItemDetail(
                        bus,
                        Color(widget._category.cardColor),
                        !_isMultiSelection,
                    ),
                ),
            ],
        );

    Widget _cardContent(BuildContext context, UserProviders userProvider, Color cardColor, double width) {
        if (_isLoading) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(cardColor),
                ),
            );
        }

        if (widget._category.buses.isEmpty) {
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

        return ListView.separated(
            separatorBuilder: (BuildContext ctx, int i) => Divider(
                color: cardColor,
                indent: 5,
                endIndent: 5,
            ),
            itemCount: widget._category.buses.length,
            itemBuilder: (BuildContext ctx, int i) => GestureDetector(
                onLongPress: () {
                    _isMultiSelection = true;
                    _handleOnTap(context, widget._category.buses[i]);
                },
                onTap: () => _handleOnTap(context, widget._category.buses[i]),
                child: _singleBus(context, i, userProvider, width, cardColor),
            ),
        );
    }

    dynamic _onEditingClick(BuildContext context, final BusSelected busSelected, final UserProviders userProvider) {
        if (widget._category.title == 'Todos') {
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

        busSelected.setAllBusesSelected = widget._category.buses;
        return Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext ctx) => NewCategoryPage(widget._category),
        )).then((value) => _onRemovingCategory(value, userProvider));
    }

    void _showTodosInfoDialog(BuildContext context) =>
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

    void _onRemovingCategory(bool value, UserProviders userProvider) {
        if (value == null || !value) return;
        userProvider.deleteCategory(widget._category);
    }

    void _onSelectionBus(Bus bus) {
        final bool isBusAdded = _busesToTrack.any((test) => test.numero == bus.numero);

        if (isBusAdded) {
            setState(() {
                _busesToTrack.removeWhere((item) => item.numero == bus.numero);
            });
        } else {
            setState(() {
                _busesToTrack.add(bus);
            });
        }
    }

    void _onAddingBus(UserProviders userProviders, BusSelected busSelected, BuildContext context) {
        busSelected.setAllBusesSelected = widget._category.buses;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) =>
                    NewBusPage(
                        isAdding: true,
                    ),
            )).then((res) async {
            if (res == null || res == false) return;
            widget._category.buses = busSelected.getAllBusSelected;
            await userProviders.updateCategory(widget._category);
            busSelected.cleanBusSelected();
        });
    }

    void _onDeletingBus(Bus bus, String id, UserProviders userProvider, BuildContext ctx) async {
        try {
            await userProvider.deleteBus(bus, id);
        } on DioError catch(e) {
            print('ERRO AO DELETAR ONIBUS\n$e');
            ToastUtil.showToast('Algo deu errado', ctx, color: ToastUtil.error, duration: 5);
        }
    }

    void _handleOnTap(BuildContext context, Bus bus) {
        _onSelectionBus(bus);
        if (_isMultiSelection) {
            return;
        }

        _sendToGoogleMaps(context);
    }

    Future _sendToGoogleMaps(BuildContext context) async {
        setState(() => _isLoading = true);
        try {
            final locationService = await LocationService.userLocation;

            final Coordinates userLocation = Coordinates(
                latitude: locationService.latitude,
                longitude: locationService.longitude,
            );

            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    MapPage(
                        userLocation,
                        busesToTrack: _busesToTrack,
                    ),
            )).whenComplete(() {
                _isLoading = false;
                _busesToTrack.clear();
                _isMultiSelection = false;
            });
        } catch(e)  {
            print('Error -> $e');
            _isLoading = false;
        }
    }

    double _dynamicHeight(double height) {
        final buses = widget._category.buses;

        if (buses.isEmpty) return height/12;
        if (buses.length == 1) return height/7.7;
        if (buses.length == 2) return height/4.5;
        if (buses.length == 3) return height/3.2;
        if (buses.length == 4) return height/2.5;
        return height/2.3;
    }
}
