import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'custom_colors.dart';

abstract class ToastUtil {
    static final Color warning = Colors.orangeAccent;
    static final Color error = Colors.red;
    static final Color success = Colors.green;

    /// <h1>showToast</h1>
    /// <h3>Show a Toast</h3>
    static void showToast(
        String msg,
        BuildContext context,
        {
            Color color = Colors.green,
            int gravity = 2,
            int duration = 4,
        }) => Toast.show(
        msg,
        context,
        gravity: gravity,
        backgroundColor: color,
        textColor: CustomColors.switchColor(color),
        duration: duration,
    );

}
