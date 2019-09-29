import 'dart:io';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

abstract class CheckStatusService {
    static final Location _location = Location();

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

    static Future<bool> hasLocationPermission() async {
        return await _location.requestPermission();
    }

    static Future<bool> isGPSAvailable() async {
        final isEnable = await _location.serviceEnabled();
        if (!isEnable) {
            final requested = await _location.requestService();
            if (!requested) {
                return false;
            }
            return true;
        }
        return true;
    }

    static void showGPSRequiredDialog(BuildContext context, [bool permissions = false]) =>
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text(
                        permissions ? 'Permissão de Localização' : 'GPS Desligado',
                        style: TextStyle(
                            color: Colors.red,
                        ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        permissions ? 'O Cadê Ônibus precisa acessar sua localização para rastrear os ônibus' : 'GPS precisa estar ligado para rastrear os ônibus',
                        textAlign: TextAlign.start,
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                                'Fechar',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                ),
                            ),
                        )
                    ],
                ),
        );
}
