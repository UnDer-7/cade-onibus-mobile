import 'package:cade_onibus_mobile/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../widgets/bus_item_searching.dart';
import '../widgets/bus_item_adding.dart';

import '../providers/bus_selected.dart';
import '../models/bus.dart';
import '../models/category.dart';
import '../resources/df_trans_resource.dart';

class NewBusPage extends StatefulWidget {
    final bool isAdding;
    final Category category;
    NewBusPage({this.isAdding = false, this.category});

    @override
    _NewBusPageState createState() => _NewBusPageState();
}

class _NewBusPageState extends State<NewBusPage> {
    final BehaviorSubject<String> _subject = BehaviorSubject<String>();
    final TextEditingController ctl = TextEditingController();

    List<Bus> _bus = [];
    bool _isLoading = false;

    @override
    void initState(){
        super.initState();
        _subject.debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
            .listen((String input) => _handleDFTransRequest(input));
    }

    @override
    void deactivate() {
        _subject.close();
        super.deactivate();
    }

    @override
    void dispose() {
        super.dispose();
    }

    @override
    Scaffold build(BuildContext context) {
        print('CATEGORY \n${widget.category}');
        final double height = MediaQuery.of(context).size.height;
        final double _width = MediaQuery.of(context).size.width;
        final BusSelected _busSelected = Provider.of<BusSelected>(context);

        return Scaffold(
            bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _buildSaveButton(context),
            ),
            appBar: AppBar(
                centerTitle: true,
                title: Text('Novo Ônibus'),
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        if (_isLoading) LinearProgressIndicator(),
                        if (_busSelected.getAllBusSelected.isNotEmpty || widget.category.buses.isNotEmpty)
                            Container(
                                height: 50,
                                width: _width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _busSelected.getAllBusSelected.length,
                                    itemBuilder: (BuildContext ctx, int i) => _getBusSelectedLabel(_busSelected.getAllBusSelected[i], _busSelected),
                                ),
                            ),
                        _buildSearchTextField(),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: getBusesFoundListHeight(height, _busSelected.getAllBusSelected),
                            child: ListView.builder(
                                itemCount: _bus.length,
                                itemBuilder: (BuildContext ctx, int i) => _getBusItem(_bus[i]),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    int getListItemCount(BusSelected busSelected) {
        final Category category = widget.category;

        if (category != null) return category.buses.length;
        return busSelected.getAllBusSelected.length;
    }
    RaisedButton _buildSaveButton(BuildContext context) =>
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () => Navigator.pop(context),
            child: Text(
                'Salvar',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        );

    Padding _buildSearchTextField() =>
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: TextField(
                autofocus: true,
                onChanged: _textChanged,
                controller: ctl,
                decoration: InputDecoration(
                    prefix: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                            Icons.search,
                            color: Colors.black,
                        ),
                    ),
                    labelText: 'DIGITE UMA LINHA OU CIDADE',
                ),
            ),
        );

    Container _getBusSelectedLabel(Bus bus, BusSelected busSelected) {
        return Container(
            margin: EdgeInsets.only(left: 5, top: 10),
            height: 40,
            width: 95,
            child: RaisedButton(
                padding: EdgeInsets.only(left: 10, right: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Theme
                    .of(context)
                    .primaryColor,
                onPressed: () => busSelected.removeBusSelected = bus,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        Text(
                            bus.numero,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                            ),
                        ),
                        Icon(
                            Icons.cancel,
                            color: Colors.red,
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _getBusItem(Bus bus) {
        if (widget.isAdding) return BusItemAdding(bus);
        return BusItemSearching(bus);
    }

    double getBusesFoundListHeight(double height, List<Bus> buses) {
        if (buses.isNotEmpty) return height / 1.5;
        return height / 1.3;
    }

    set _updateLoadingState(bool val) {
        setState(() => _isLoading = val);
    }

    void _handleDFTransRequest(String input) async {
        if (input.isEmpty) return;

        _updateLoadingState = true;
        try {
            _bus = await DFTransResource.findBus(input);
            if (_bus == null || _bus.length <= 0) {
                _showToast('Nenhum ônibus encontrado', color: ToastUtil.warning);
                return;
            }

            setState(() => _bus);
        } on DioError catch(e) {
            print('Stack\n$e');
            if (e.response == null) {
                _showToast('Algo deu errado', color: ToastUtil.error);
                return;
            }
            if (e.response.statusCode == 400) {
                _showToast('Pesquisa invalida', color: ToastUtil.error);
                return;
            }

            _showToast('Algo deu errado', color: ToastUtil.error, duration: 5);
        } finally {
            _updateLoadingState = false;
        }
    }

    void _showToast(String msg, {Color color = Colors.green, int duration = 4}) {
        ToastUtil.showToast(msg, context, color: color, duration: duration);
    }
    void _textChanged(String input) {
        _subject.add(input);
    }
}
