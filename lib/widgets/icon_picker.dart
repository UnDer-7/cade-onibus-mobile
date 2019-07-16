import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

class IconPicker extends StatefulWidget {
    @override
    _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
    final BehaviorSubject<String> _subject = BehaviorSubject<String>();
    Map<String, IconData> _iconsFund = {};

    @override
    void initState() {
        _subject.debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
            .listen((String input) => _handleSearch(input));
        super.initState();
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
    AlertDialog build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
        final double width = MediaQuery.of(context).size.width;

        return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
                children: <Widget>[
                    TextField(
                        onChanged: _textChanged,
                        decoration: InputDecoration(
                            labelText: 'Procure por um icone',
                            suffix: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                    print('NEED TO IMPLIMENT SEARCH');
                                },
                            )
                        ),
                    ),
                    Container(
                        height: height / 1.5,
                        width: width,
                        child: ListView.builder(
                            itemCount: _iconsFund.length,
                            itemBuilder: (BuildContext ctx, int i) =>
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text(
                                            _iconsFund.keys.toList()[i],
                                            style: TextStyle(
                                                fontSize: 20,
                                            ),
                                        ),
                                        Icon(
                                            _iconsFund.values
                                                .toList()[i],
                                            size: 70,
                                        )
                                    ],
                                ),
                        ),
                    ),
                ],
            ),
        );
    }

    void _handleSearch(String input) {
        if (input.isEmpty) return;

        List<String> keysFound = _iconsMap
            .keys
            .where((item) => item.indexOf(input.toLowerCase(), 0) >= 0)
            .toList();

        Map<String, IconData> found = _iconsMap.map((key, value) {
            if (keysFound.contains(key)) return MapEntry(key, value);
            return MapEntry('thisFuckingThing', Icons.remove);
        });
        found.remove('thisFuckingThing');

        setState(() => _iconsFund = found);
    }

    void _textChanged(String input) {
        _subject.add(input);
    }

    Map<String, IconData> get _iconsMap {
        Map<String, IconData> _icons = {
            '360': Icons.threesixty,
            'trezentos sessenta': Icons.threesixty,

            'rotacao 3d': Icons.threed_rotation,
            '3d': Icons.threed_rotation,

            '4k': Icons.four_k,
            'quatro 4': Icons.four_k,

            'ac': Icons.ac_unit,
            'ar condicionado': Icons.ac_unit,

            'despertador': Icons.access_alarm,

            'relogio de parede': Icons.access_time,

            'acessibilidade': Icons.accessibility,

            'cadeira de rodas': Icons.accessible,
            'cadeira de rodas em movimento': Icons.accessible_forward,

            'banco': Icons.account_balance,

            'carteira': Icons.account_balance_wallet,

            'avatar': Icons.account_circle,

            'adb': Icons.adb,

            'add': Icons.add,
            'adicionar': Icons.add,
            'mais': Icons.add,

            'add foto': Icons.add_a_photo,
            'nova foto': Icons.add_a_photo,
        };
        return Map.of(_icons);
    }

}
