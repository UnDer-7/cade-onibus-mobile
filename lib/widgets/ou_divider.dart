import 'package:flutter/material.dart';

class OuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Row(
          children: <Widget>[
              Expanded(
                  child: Divider(
                      color: Theme.of(context).primaryColor,
                      height: 30,
                  )
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      'Ou',
                      style: TextStyle(
                          color: Colors.white,
                      ),
                  ),
              ),
              Expanded(
                  child: Divider(
                      color: Theme.of(context).primaryColor,
                  )
              ),
          ]
      );
}
