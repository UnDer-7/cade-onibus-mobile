import 'dart:async';

import 'package:flutter/material.dart';

import './landpage_page.dart';
import './sign_in_page.dart';
import './sing_up_page.dart';

class MainAuthPage extends StatefulWidget {
    static final int landPage = 1;
    static final int signIn = 0;
    static final int signUp = 2;
    final bool isDFTransAvailable;

    MainAuthPage(this.isDFTransAvailable);

    @override
    _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
    StreamController<bool> _isLoadingStream;
    List<Widget> _pages;

    static final PageController _pageController = PageController(initialPage: MainAuthPage.landPage);

    @override
    void initState() {
        _isLoadingStream = StreamController<bool>.broadcast();
        _pages = [
            SingInPage(_pageController, _isLoadingStream),
            LandPage(_pageController, widget.isDFTransAvailable),
            SingUpPage(_pageController, _isLoadingStream),
        ];
        super.initState();
    }

    @override
    void dispose() {
        _isLoadingStream.close();
        super.dispose();
    }

    @override
    void deactivate() {
        _isLoadingStream.close();
        super.deactivate();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Colors.white,
            child: StreamBuilder(
                stream: _isLoadingStream.stream.asBroadcastStream(),
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
