import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

import '../widgets/bus_item.dart';

import '../models/bus.dart';

import '../utils/custom_colors.dart';

import '../resources/df_trans_resource.dart';

class NewBusScreen extends StatefulWidget {
    @override
    _NewBusScreenState createState() => _NewBusScreenState();
}

class _NewBusScreenState extends State<NewBusScreen> {
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
        _subject.close();
        super.dispose();
    }

    @override
    Scaffold build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Novo Ônibus'),
            ),
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        if (_isLoading) LinearProgressIndicator(),
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
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            height: height / 1.3,
                            child: ListView.builder(
                                itemCount: _bus.length,
                                itemBuilder: (BuildContext ctx, int i) => BusItem(_bus[i]),
                            ),
                        )
                    ],
                ),
            ),
        );
    }

    set _updateLoadingState(bool val) {
        setState(() => _isLoading = val);
    }

    void _handleDFTransRequest(String input) async {
        _updateLoadingState = true;
        try {
            _bus = await DFTransResource.findBus(input);
            if (_bus == null || _bus.length <= 0) {
                _showToast('Nenhum ônibus encontrado', color: Colors.deepOrangeAccent);
                return;
            }

            setState(() => _bus);
        } on DioError catch(e) {
            if (e.response.statusCode == 400) {
                _showToast('Pesquisa invalida', color: Theme.of(context).errorColor);
                return;
            }

            _showToast('Algo deu errado', color: Theme.of(context).errorColor, duration: 5);
        } finally {
            _updateLoadingState = false;
        }
    }

    void _showToast(String msg, {Color color = Colors.grey, int duration = 4}) => Toast.show(
        msg,
        context,
        gravity: Toast.TOP,
        backgroundColor: color,
        textColor: CustomColors.switchColor(Colors.deepOrange),
        duration: duration,
    );

    void _textChanged(String input) {
        if (input.isEmpty) return;
        _subject.add(input);
    }
}
