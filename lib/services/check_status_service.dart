import 'dart:io';

import 'package:catcher/core/catcher.dart';

abstract class CheckStatusService {
    static Future<bool> isInternetAvailable() async {
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                return true;
            }
            return false;
        } on SocketException catch (_) {
            print('Unable to establish a connection with the internet');
            return false;
        } catch(err, stack) {
            print('Erro while attempt to verify internet connection');
            print('StackTrace \n$stack');
            Catcher.reportCheckedError(err, stack);
            return false;
        }
    }
}
