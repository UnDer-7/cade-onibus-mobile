import './coordinates.dart';

class BusCoordinates {
    Coordinates coordinates;
    Properties properties;

    BusCoordinates({
        this.properties,
        this.coordinates,
    });

    BusCoordinates.fromJson(dynamic json) :
            coordinates = Coordinates.fromJSON(json['geometry']),
            properties = Properties.fromJSON(json['properties']);

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('BusCoordinates: {');
        buffer.writeln('Coordinates: ${coordinates.toString()}');
        buffer.writeln('Properties: ${properties.toString()}');
        buffer.write('}');
        return buffer.toString();
    }
}

class Properties {
    String numero;
    dynamic horario;
    String linha;
    String operadora;
    int idOperadora;

    Properties({
        this.numero,
        this.horario,
        this.linha,
        this.operadora,
        this.idOperadora,
    });

    Properties.fromJSON(Map<String, dynamic> json) :
            numero = json['numero'],
            horario = json['horario'],
            linha = json['linha'],
            operadora = json['operadora'],
            idOperadora = json['id_operadora'];

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Properties: {');
        buffer.writeln('Numero: $numero');
        buffer.writeln('Horario: $horario');
        buffer.writeln('Linha: $linha');
        buffer.writeln('Operadora: $operadora');
        buffer.writeln('IdOperadora: $idOperadora');
        buffer.write('}');
        return buffer.toString();
    }
}
