import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_colorpicker/block_picker.dart';

import '../providers/categories_provider.dart';
import '../models/category.dart';

class NewCategoryPage extends StatefulWidget {
    @override
    _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
    static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Color _currentColor = Colors.purple;
    String _categoryName;

    @override
    Scaffold build(BuildContext context) {
        CategoriesProviders provider = Provider.of<CategoriesProviders>(context, listen: false);

        return Scaffold(
            bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Theme
                        .of(context)
                        .primaryColor,
                    onPressed: () => _submit(provider, context),
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
                            SizedBox(height: 20),
                            RaisedButton(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () {},
                                child: Text(
                                    'Selecione Seus Ônibus',
                                    style: TextStyle(
                                        color: Colors.white,
                                    ),
                                ),
                            ),
                            SizedBox(height: 30),
                            _buildColorPickerField,
                        ],
                    ),
                ),
            ),
        );
    }

    TextFormField get _buildNameField =>
        TextFormField(
            onSaved: (String input) => _categoryName = input,
            decoration: InputDecoration(
                labelText: 'Nome da Categoria',
            ),
            validator: (String input) {
                if (input.isEmpty) return 'Campo obrigatorio';
                return null;
            },
        );

    Row get _buildColorPickerField =>
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

    void _submit(CategoriesProviders provider, BuildContext context) {
        if (!_formKey.currentState.validate()) return;
        _formKey.currentState.save();

        Category newCategory = Category(
            title: _categoryName,
            cardColor: _currentColor,
            buses: [],
        );
        provider.addCategory = newCategory;

        Navigator.pop(context);
    }
}
