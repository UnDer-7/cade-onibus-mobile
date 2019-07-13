import 'package:flutter/material.dart';

import '../widgets/bus_category.dart';

class BusTab extends StatelessWidget {
    @override
    ListView build(BuildContext context) =>
        ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext ctx, int i) => BusCategory(),
        );
}
