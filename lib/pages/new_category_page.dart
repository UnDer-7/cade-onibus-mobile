import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/block_picker.dart';

class NewCategoryPage extends StatefulWidget {

    @override
    _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
    static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Color _currentColor = Colors.purple;
    IconData _curreIcon = Icons.school;

    @override
    Scaffold build(BuildContext context) =>
        Scaffold(
            bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Text(
                        'Salvar',
                        style: TextStyle(
                            color: Colors.white,
                        ),
                    ),
                ),
            ),
            appBar: AppBar(
                centerTitle: true,
                title: Text('Nova Categoria'),
            ),
            body: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                    key: _formKey,
                    child: ListView(
                        children: <Widget>[
                            _buildNameField,
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    _buildColorPickButton(context),
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentColor,
                                        ),
                                        height: 100,
                                        width: 100,
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            ),
        );

    TextFormField get _buildNameField =>
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Nome da Categoria',
            ),
        );

    RaisedButton _buildColorPickButton(BuildContext ctx) =>
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Theme.of(context).primaryColor,
            child: Text(
                'Selecione a Cor da Categoria',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
            onPressed: () => showDialog(
                context: ctx,
                builder: (BuildContext ctx) =>
                    AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        title: Column(
                            children: <Widget>[
                                Text('Escolha uma das Cores'),
                                Divider(
                                    color: Theme.of(context).primaryColor,
                                    indent: 5,
                                    endIndent: 5,
                                ),
                            ],
                        ),
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(5),
                        content: SingleChildScrollView(
                            child: BlockPicker(
                                pickerColor: _currentColor,
                                onColorChanged: _changeCurrentColor,
                            ),
                        ),
                    ),
            ),
        );

    void _changeCurrentColor(Color color) => setState(() => _currentColor = color);

}
