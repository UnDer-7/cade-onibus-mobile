import 'package:meta/meta.dart';

class Bus {
    String numero;
    String descricao;
    double tarifa;

    Bus({
        @required this.numero,
        @required this.descricao,
        @required this.tarifa,
    });

    Bus.fromJSON(dynamic json) :
            numero = json['numero'],
            descricao = json['descricao'],
            tarifa = json['tarifa'].toDouble();

    static Map<String, dynamic> toJSON(Bus bus) {
        return {
            'numero': bus.numero,
            'descricao': bus.descricao,
            'tarifa': bus.tarifa,
        };
    }

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Bus: {');
        buffer.writeln('Numero: $numero');
        buffer.writeln('Descricao: $descricao');
        buffer.writeln('Tarifa: $tarifa');
        buffer.write('}');
        return buffer.toString();
    }
}
