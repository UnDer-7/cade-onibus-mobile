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

    static Future<bool> isDFTransAvailable() async {
        try {
            final result = await InternetAddress.lookup('https://www.sistemas.dftrans.df.gov.br/linha/find/501/10/short');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                return true;
            }
            return false;
        } on SocketException catch (err, stack) {
            print('Unable to establish a connection with DFTrans');
            print('StackTrace: \t$stack');
            print('ERROR: \n$err');
            Catcher.reportCheckedError(err, stack);
            return false;
        } catch(err, stack) {
            print('Erro while attempt to verify connection with DFTrans');
            print('StackTrace \n$stack');
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }
}
