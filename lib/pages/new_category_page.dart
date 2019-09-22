import 'package:cade_onibus_mobile/models/bus.dart';
import 'package:cade_onibus_mobile/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:flutter_colorpicker/block_picker.dart';

import '../providers/user_provider.dart';
import '../providers/bus_selected.dart';
import '../models/category.dart';
import '../pages/new_bus_page.dart';

class NewCategoryPage extends StatefulWidget {
    final Category _categoryToEdit;
    final bool isNew;

    NewCategoryPage([this._categoryToEdit, this.isNew = true]);

    @override
    _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
    static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textEditingController = TextEditingController();

    Color _currentColor = Colors.purple;
    String _categoryName;

    @override
    void initState() {
        if (widget._categoryToEdit != null) {
            final Category category = widget._categoryToEdit;
            _textEditingController.text = category.title;
            _currentColor = Color(category.cardColor);
        }
        super.initState();
    }
    @override
    WillPopScope build(BuildContext context) {
        final UserProviders userProvider = Provider.of<UserProviders>(context, listen: false);
        final BusSelected busSelected = Provider.of<BusSelected>(context, listen: false);
        final double _height = MediaQuery.of(context).size.height;

        return WillPopScope(
            onWillPop: () => _buildLeavePageConfirmationDialog(busSelected, context),
            child: Scaffold(
                bottomNavigationBar: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _buildSaveButton(context, userProvider, busSelected),
                ),
                appBar: AppBar(
                    actions: <Widget>[
                        if (!widget.isNew) PopupMenuButton(
                            onSelected: (value) => _showDeleteCategoryDialog(context, value),
                            itemBuilder: (BuildContext ctx) => [
                                PopupMenuItem(
                                    value: true,
                                    child: Row(
                                        children: <Widget>[
                                            Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                  'Apagar Categoria',
                                                  textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    ],
                    centerTitle: true,
                    title: Text(_appBarTitle),
                ),
                body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Form(
                        key: _formKey,
                        child: ListView(
                            children: <Widget>[
                                _buildNameField,
                                SizedBox(height: 10),
                                _buildColorPickerField,
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Divider(
                                        color: Theme.of(context).primaryColor,
                                        indent: 5,
                                        endIndent: 5,
                                    ),
                                ),
                                SizedBox(height: 10),
                                _buildBusSelectionButton(context),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                        'Ônibus selecionados',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20
                                        ),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 3, color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    height: _height / 2.5,
                                    child: _buildBusSelectedBox(busSelected),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    bool get _isEditing => widget._categoryToEdit != null;

    String get _appBarTitle {
        if (_isEditing) return 'Editando Categoria';
        return 'Nova Categoria';
    }

    Future<bool> _buildLeavePageConfirmationDialog(BusSelected busSelected, BuildContext context) async {
        final answer = await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: Text('Descartar Categoria'),
                    content: Text(
                        'Se você sair sem salvar, todo processo será perdido!',
                        textAlign: TextAlign.start,
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                                busSelected.cleanBusSelected();
                                Navigator.pop(context, true);
                            },
                            child: Text(
                                'Não salvar',
                                style: TextStyle(
                                    color: Colors.red,
                                ),
                            ),
                        ),
                        FlatButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                                'Continuar',
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                            ),
                        )
                    ],
                ),
        );
        return Future.value(answer == null ? false : answer);
    }

    RaisedButton _buildSaveButton(BuildContext context, UserProviders userProvider, BusSelected busSelected) =>
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () => _submit(userProvider, busSelected, context),
            child: Text(
                'Salvar',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        );

    RaisedButton _buildBusSelectionButton(BuildContext context) =>
        RaisedButton(
            color: Theme
                .of(context)
                .primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext ctx) => NewBusPage(isMultiSelection: true),
            )),
            child: Text(
                'Selecione Seus Ônibus',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        );

    ListView _buildBusSelectedBox(BusSelected busSelected) {
        final List<Bus> busesSelected = busSelected.getAllBusSelected;

        return ListView.builder(
            itemCount: busesSelected.length,
            itemBuilder: (BuildContext ctx, int i) =>
                Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(busesSelected[i].numero),
                    onDismissed:
                        (_) => busSelected.removeBusSelected = busesSelected[i],
                    background: _buildSideRemoverContainer(context),
                    child: ListTile(
                        leading: _buildLeading(busesSelected[i].numero, context),
                        title: Text(
                            busesSelected[i].descricao,
                            textAlign: TextAlign.center,
                        ),
                        trailing: Text(
                            'R\$ ${busesSelected[i].tarifa.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.red
                            ),
                        ),
                    ),
                ),
        );
    }

    Container _buildSideRemoverContainer(BuildContext context) =>
        Container(
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
        );

    Chip _buildLeading(String numero, BuildContext context) =>
        Chip(
            label: Text(
                numero,
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                ),
            ),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
        );

    TextFormField get _buildNameField =>
        TextFormField(
            controller: _textEditingController,
            textCapitalization: TextCapitalization.words,
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(7),
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
                        actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                    'Salvar',
                                    style: TextStyle(
                                        color: Colors.green,
                                    ),
                                ),
                            )
                        ],
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

    Future<void> _showDeleteCategoryDialog(BuildContext context, value) async {
        if (value != true) return Future.value(null);

        final answer = await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text('Remover Categoria ${widget._categoryToEdit.title}'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        'Tem certeza que quer remover a categoria ${widget._categoryToEdit.title}?\nVocê não tera como recupera-la'),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                                'Excluir categoria',
                                style: TextStyle(
                                    color: Colors.red,
                                ),
                            ),
                        ),
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                                'Manter Categoria',
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                            ),
                        ),
                    ],
                ),
        );
        Navigator.pop(context, answer);
    }

    Future<void> _submit(UserProviders provider, BusSelected busSelected, BuildContext ctx) async {
        final List<Bus> buses = busSelected.getAllBusSelected;
        if (!_formKey.currentState.validate()) return Future(() {});
        _formKey.currentState.save();

        Category newCategory = Category(
            uuid: _isEditing ? widget._categoryToEdit.uuid : null,
            title: _categoryName,
            cardColor: _currentColor.value,
            buses: buses,
        );

        try {
            if (_isEditing) {
                await provider.updateCategory(newCategory);
            } else {
                await provider.addCategory(newCategory);
            }
            busSelected.cleanBusSelected();
            Navigator.pop(context);
        } on DioError catch(err, stack) {
            if (err.response.statusCode == 400 && err.response.data == 'resource-already-exists') {
                ToastUtil.showToast('Jâ existe uma categoria com esse titulo', ctx, color: ToastUtil.warning);
            }else {
                print('Erro while attempt to save a category');
                print('ERRO: \n$err');
                print('StackTrace: \t$stack');
                ToastUtil.showToast('Erro salvar a categoria', ctx, color: ToastUtil.error, duration: 5);
            }
        }
    }
}
