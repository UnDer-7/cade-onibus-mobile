import 'package:flutter/material.dart';

import './landpage_page.dart';
import './sign_in_page.dart';
import './sing_up_page.dart';

class MainAuthPage extends StatelessWidget {
    static final int landPage = 1;
    static final int signIn = 0;
    static final int signUp = 2;

    final PageController _pageController = PageController(initialPage: landPage);

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Theme.of(context).primaryColor,
            child: PageView(
                physics: BouncingScrollPhysics(),
//            physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: <Widget>[
                    SingInPage(),
                    LandPage(_pageController),
                    SingUpPage(),
                ],
            ),
        );
    }
}
