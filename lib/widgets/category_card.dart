import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../widgets/bus_item_detail.dart';

import '../providers/bus_selected.dart';
import '../providers/user_provider.dart';

import '../utils/custom_colors.dart';
import '../utils/toast_util.dart';

import '../models/category.dart';
import '../models/bus.dart';

import '../services/check_status_service.dart';
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
                            if (widget._category.title != 'Todos' ) Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: Text('|'),
                            ),
                            if (widget._category.title != 'Todos') _newBus(_cardColor, context, _busSelected, userProvider),
                            if (widget._category.title == 'Todos' || widget._category.title == 'Cadê Ônibus Web') _todosInfoDialog(_cardColor, context, widget._category.title),
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

    GestureDetector _todosInfoDialog(Color cardColor, BuildContext context, String title) =>
        GestureDetector(
            onTap: () => title == 'Todos' ? _showTodosInfoDialog(context) : _showCadeOnibusWebInfoDialog(context),
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

        if (widget._category.buses.isEmpty && widget._category.title != 'Todos') {
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

        if (widget._category.buses.isEmpty && widget._category.title == 'Todos') {
            return Container(
                width: double.infinity,
                child: Center(
                    child: Text(
                        'Crie um categoria clicando no botão inferior e adicione ônibus nela',
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
            builder: (BuildContext ctx) => NewCategoryPage(widget._category, false),
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
                        'Esta categoria contém os ônibus de todas as categorias. '
                            'Você não pode efetuar nenhuma alteração pois os ônibus são adicionados automaticamente.\n\n'
                            'Caso você remova algum ônibus de alguma categoria e o mesmo não estar em nenhuma categoria, ele também será removido da categoria todos. '
                            'Os ônibus desta categorias são únicos ou seja não repetem caso haja ônibus iguais em diferentes categorias\n\n'
                            'Os ônibus do Cadê Ônibus Web vêm dessa categoria',
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

    void _showCadeOnibusWebInfoDialog(BuildContext context) =>
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text('Categoria Cadê Ônibus Web'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        'Categoria gerada a partir dos ônibus cadastrados na versão WEB do cadê ônibus. '
                            'Os ônibus desta categoria são os mesmos da categoria Todos.\n\n'
                            'Sempre que um ônibus for cadastrado na versão Web sera gerado essa categoria.',
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
                        isMultiSelection: true,
                    ),
            )).then((res) async {
            if (res == null || res == false) {
                busSelected.cleanBusSelected();
                return;
            }

            widget._category.buses = busSelected.getAllBusSelected;
            await userProviders.updateCategory(widget._category);
            busSelected.cleanBusSelected();
        });
    }

    void _onDeletingBus(Bus bus, String id, UserProviders userProvider, BuildContext ctx) async {
        try {
            await userProvider.deleteBus(bus, id);
        } on DioError catch(err, stack) {
            print('Erro while attempt to delete bus');
            print('ERRO: \n$err');
            print('StackTrace: \t$stack');
            ToastUtil.showToast('Erro ao deletar ônibus', ctx, color: ToastUtil.error, duration: 5);
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
        final hasPermission = await CheckStatusService.hasLocationPermission();
        if (!hasPermission) {
            CheckStatusService.showGPSRequiredDialog(context, true);
            setState(_clear);
            return;
        }

        final isGPSAvailable = await CheckStatusService.isGPSAvailable();
        if (!isGPSAvailable) {
            CheckStatusService.showGPSRequiredDialog(context);
            setState(_clear);
            return;
        }
        setState(() => _isLoading = true);
        final location = await Location().getLocation();
        final userLocation = LatLng(location.latitude, location.longitude);
        try {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    MapPage(
                        busesToTrack: _busesToTrack,
                        initialLocation: userLocation,
                    ),
            )).whenComplete(_clear);
        } catch(err, stack)  {
            print('Erro while navigating to the MapPage');
            print('ERRO: \n$err');
            print('StackTrace: \t$stack');
        } finally {
            _isLoading = false;
        }
    }

    void _clear() {
        _isLoading = false;
        _busesToTrack.clear();
        _isMultiSelection = false;
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
