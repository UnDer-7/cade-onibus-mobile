import 'dart:async';

import 'package:flutter/material.dart';

import './landpage_page.dart';
import './sign_in_page.dart';
import './sing_up_page.dart';

class MainAuthPage extends StatefulWidget {
    static final int landPage = 1;
    static final int signIn = 0;
    static final int signUp = 2;

    @override
    _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
    static final StreamController<bool> _isLoadingStream = StreamController<bool>();

    static final PageController _pageController = PageController(initialPage: MainAuthPage.landPage);

    final List<Widget> _pages = [
        SingInPage(_pageController, _isLoadingStream),
        LandPage(_pageController),
        SingUpPage(_pageController, _isLoadingStream),
    ];

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Theme.of(context).primaryColor,
            child: StreamBuilder(
                stream: _isLoadingStream.stream,
                builder: (_, snap) => _loadPageView(snap),
            ),
        );
    }

    PageView _loadPageView(AsyncSnapshot<bool> snap) {
        if (snap.hasData && snap.data) {
            return PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: _pages,
            );
        } else {
            return PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                children: _pages,
            );
        }
    }
}
