import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/toast_handler_length.dart';
import 'package:flutter/material.dart';

import 'package:catcher/handlers/email_auto_handler.dart';
import 'package:catcher/handlers/toast_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:catcher/model/toast_handler_gravity.dart';

class CatcherConfig {
    final EmailAutoHandler _email = EmailAutoHandler(
        'smtp.gmail.com',
        587,
        'catcher.cade@gmail.com',
        'CadêÔnibus',
        '666metallica852456',
        ['mateus7532@gmail.com'],
    );

    final ToastHandler _toast = ToastHandler(
        gravity: ToastHandlerGravity.top,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        length: ToastHandlerLength.long,
        textSize: 15,
    );

    final ConsoleHandler _console = ConsoleHandler(
        enableApplicationParameters: false,
        enableDeviceParameters: false,
        enableStackTrace: true,
        enableCustomParameters: false,
    );

    CatcherOptions debugConfig() {
        return CatcherOptions(
            SilentReportMode(),
            [
                _console,
                _toast,
            ],
        );
    }

    CatcherOptions releaseConfig() {
        return CatcherOptions(
            SilentReportMode(),
            [
                _email,
                _toast,
            ],
        );
    }
}
