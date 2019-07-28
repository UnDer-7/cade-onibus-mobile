import 'package:flutter/material.dart';

import '../models/bus.dart';

class BusSelected with ChangeNotifier {
    final List<Bus> _busSelected = [];

    List<Bus> get getAllBusSelected => List.unmodifiable(_busSelected);

    set addBusSelected(Bus bus) {
        _busSelected.add(bus);
        notifyListeners();
    }

    set removeBusSelected(Bus bus) {
        _busSelected.removeWhere((item) => item.numero == bus.numero);
        notifyListeners();
    }

    void cleanBusSelected() => _busSelected.clear();
}
