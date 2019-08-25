import 'package:cade_onibus_mobile/utils/toast_util.dart';
import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../models/category.dart';
import '../utils/custom_colors.dart';
import '../widgets/category_card.dart';
import '../providers/user_provider.dart';

class BusCategory extends StatefulWidget {
    final Category _category;
    final bool isDFTransAvailable;

    BusCategory(this._category, this.isDFTransAvailable);

    @override
    _BusCategoryState createState() => _BusCategoryState();
}

class _BusCategoryState extends State<BusCategory> with SingleTickerProviderStateMixin{
    bool _isSelect = false;
    AnimationController _animationController;

    @override
    void initState() {
        super.initState();
        _animationController =
            AnimationController(
                vsync: this,
                duration: Duration(milliseconds: 300),
            );
    }

    @override
    void dispose() {
        super.dispose();
        _animationController.dispose();
    }
    @override
    Widget build(BuildContext context) {
        final Category _category = widget._category;
        final UserProviders _userProvier = Provider.of<UserProviders>(context);

        final _cardColor = Color(_category.cardColor);

        return Dismissible(
            key: Key(_category.uuid),
            direction: DismissDirection.endToStart,
            dismissThresholds: {
                DismissDirection.endToStart: 0.5,
            },
            confirmDismiss: (_) => _showDeleteCategoryDialog(context),
            onDismissed: (_) => _onDeletingCategory(_userProvier, context),
            background: _buildSideRemoverContainer(context),
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: _cardColor,
                child: Column(
                    children: <Widget>[
                        ListTile(
                            onTap: () => setState(() {
                                _isSelect = !_isSelect;
                                _isSelect
                                    ? _animationController.forward()
                                    : _animationController.reverse();
                            }),
                            leading: _getLeading,
                            title: Text(
                                _category.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: CustomColors.switchColor(_cardColor),
                                ),
                            ),
                            trailing: AnimatedIcon(
                                color: CustomColors.switchColor(_cardColor),
                                icon: AnimatedIcons.list_view,
                                progress: _animationController,
                            ),
                        ),
                        if (_isSelect) CategoryCard(_category, widget.isDFTransAvailable),
                    ],
                ),
            ),
        );
    }

    Container get _getLeading =>
        Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Text(
                    _icon,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: _fontSize,
                    ),
                ),
            ),
        );

    Future<bool> _showDeleteCategoryDialog(BuildContext context) async {
        if (widget._category.title == 'Todos') {
            return await attemptToDeleteTodos(context);
        }

        final answer = await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text('Remover Categoria ${widget._category.title}'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        'Tem certeza que quer remover a categoria ${widget._category
                            .title}?\nVocê não tera como recupera-la'),
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
        return Future.value(answer);
    }

    Future<bool> attemptToDeleteTodos(BuildContext context) async {
        await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
            AlertDialog(
                title: Text('Categoria ${widget._category.title}'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                content: Text('A categoria Todos não pode ser excluida!'),
                actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                            'OK',
                            style: TextStyle(
                                color: Colors.green,
                            ),
                        ),
                    ),
                ],
            ),
        );
        return Future.value(false);
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

    void _onDeletingCategory(UserProviders userProvider, BuildContext ctx) {
        try {
            userProvider.deleteCategory(widget._category);
        } on DioError catch (err, stack) {
            print('Error while attempt to delete category');
            print('ERROR: \n $err');
            print('StackTrace: \t $stack');
            Catcher.reportCheckedError(err, stack);
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
        }
    }

    String get _icon {
        final title = widget._category.title.split(' ');
        StringBuffer finalTitle = StringBuffer();

        if (title.length > 2) {
            final firstLetter = title.first.substring(0, 1);
            final lastLatter = title[1].substring(0, 1);
            finalTitle.write(firstLetter + lastLatter);
            return finalTitle.toString();
        }

        title.forEach((item) {
            finalTitle.write(item.substring(0, 1));
        });
        return finalTitle.toString();
    }

    double get _fontSize {
        if (_icon.length == 2) return 20;
        return 30;
    }

}
