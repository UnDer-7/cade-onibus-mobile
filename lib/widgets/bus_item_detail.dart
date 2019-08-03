import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../services/location_service.dart';
import '../pages/map_page.dart';
import '../resources/df_trans_resource.dart';
import '../models/bus.dart';
import '../models/coordinates.dart';
import '../utils/custom_colors.dart';

class BusItemDetail extends StatefulWidget {
    final Bus bus;
    final Color _cardColor;
    final bool _isMultiSelection;
    final BehaviorSubject<Bus> _subject;

    BusItemDetail(this.bus, [this._cardColor, this._subject, this._isMultiSelection = true]);

    @override
    _BusItemState createState() => _BusItemState();
}

class _BusItemState extends State<BusItemDetail> {
    bool _isLoading = false;

    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            onLongPress: () {
                widget._subject.add(widget.bus);
            },
            onTap: () => _handleOnTap(context),
            child: Padding(
                padding: EdgeInsets.all(5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Flexible(
                          flex: 4,
                          child: Container(
                              child: Chip(
                                  label: Text(
                                      widget.bus.numero,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: CustomColors.switchColor(getCardColor(context)),
                                      ),
                                  ),
                                  backgroundColor: getCardColor(context),
                              ),
                          ),
                      ),
                      Flexible(
                          flex: 8,
                          child: Container(
                              child: Text(
                                  widget.bus.descricao
                              ),
                          ),
                      ),
                      if (widget._isMultiSelection) Flexible(
                          flex: 3,
                          child: Container(
                              child: Text(
                                  'R\$ ${widget.bus.tarifa.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.red
                                  ),
                              ),
                          ),
                      ),
                  ],
              ),
            ),
        );
    }

    void _handleOnTap(BuildContext context) {
        if (!widget._isMultiSelection) {
            widget._subject.add(widget.bus);
            return;
        }

        sendToGoogleMaps(context);
    }

    Future sendToGoogleMaps(BuildContext context) async {
        setState(() => _isLoading = true);
        try {
            final location = await DFTransResource.findBusLocation(
                widget.bus.numero);
            final locationService = await LocationService.userLocation;

            final Coordinates userLocation = Coordinates(
                latitude: locationService.latitude,
                longitude: locationService.longitude,
            );

            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    MapPage(userLocation, location),
            )).whenComplete(() => _isLoading = false);
        } catch(e)  {
            print('Error -> $e');
            _isLoading = false;
        }
    }

    Color getCardColor(BuildContext context) {
        if (widget._cardColor == null) return Theme.of(context).primaryColor;
        return widget._cardColor;
    }
}
