import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

class BlockUI extends StatelessWidget {
    final Widget child;
    final StreamController<bool> blockUIController;

    final String flarePath;
    final String flareAnimation;
    final Color bgColor;

    BlockUI({
        @required this.child,
        @required this.blockUIController,
        this.flarePath = 'assets/flare/loading_circle.flr',
        this.flareAnimation = 'Untitled',
        this.bgColor,
    }) : assert(child != null),
            assert(blockUIController != null);

    @override
    Widget build(BuildContext context) {
        return StreamBuilder<bool>(
            stream: blockUIController.stream,
            builder: _handleBody,
        );
    }

    Stack _handleBody(final BuildContext context, final AsyncSnapshot<bool> snap) {
        final double height = MediaQuery.of(context).size.height;
        final double width = MediaQuery.of(context).size.width;

        return Stack(
            children: <Widget>[
                child,
                if (snap.data == true) Container(
                    color: bgColor == null ? Theme.of(context).primaryColor.withOpacity(0.8) : bgColor,
                    height: height,
                    width: width,
                    child: FlareActor(
                        flarePath,
                        animation: flareAnimation,
                    ),
                ),
            ],
        );
    }
}
