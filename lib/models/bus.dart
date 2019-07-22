import 'package:meta/meta.dart';

class Bus {
    String id;
    int sequencial;
    String numero;
    String descricao;
    String sentido;
    bool ativa;
    String tipoLinha;
    dynamic operadoras;
    dynamic tiposOnibus;
    FaixaTarifaria faixaTarifaria;
    Bacia bacia;

    Bus({
        this.id,
        @required this.sequencial,
        @required this.numero,
        @required this.descricao,
        @required this.sentido,
        @required this.ativa,
        @required this.tipoLinha,
        @required this.operadoras,
        @required this.tiposOnibus,
        @required this.faixaTarifaria,
        @required this.bacia,
    });

    Bus.fromJSON(dynamic json) :
            sequencial = json['sequencial'],
            numero = json['numero'],
            descricao = json['descricao'],
            sentido = json['sentido'],
            ativa = json['ativa'],
            tipoLinha = json['tipoLinha'],
            operadoras = json['operadoras'],
            tiposOnibus = json['tiposOnibus'],
            faixaTarifaria = FaixaTarifaria.fromJSON(json['faixaTarifaria']),
            bacia = Bacia.fromJSON(json['bacia']);

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Bus: {');
        buffer.writeln('Sequencial: $sequencial');
        buffer.writeln('Numero: $numero');
        buffer.writeln('Descricao: $descricao');
        buffer.writeln('Sentido: $sentido');
        buffer.writeln('Ativa: $ativa');
        buffer.writeln('TipoLinha: $tipoLinha');
        buffer.writeln('Operadoras: $operadoras');
        buffer.writeln('TiposOnibus: $tiposOnibus');
        buffer.writeln('FaixaTarifaria: ${faixaTarifaria.toString()}');
        buffer.writeln('Bacia: ${bacia.toString()}');
        buffer.write('}');
        return buffer.toString();
    }
}

class FaixaTarifaria {
    int sequencial;
    double tarifa;
    String descricao;

    FaixaTarifaria({
        @required this.sequencial,
        @required this.tarifa,
        @required this.descricao,
    });

    FaixaTarifaria.fromJSON(Map<String, dynamic> json) :
            sequencial = json['sequencial'],
            tarifa = json['tarifa'],
            descricao = json['descricao'];

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Faixa Tarifica: {');
        buffer.writeln('Sequencial: $sequencial');
        buffer.writeln('Tarifa: $tarifa');
        buffer.writeln('Descricao: $descricao');
        buffer.write('}');
        return buffer.toString();
    }
}

class Bacia {
    int sequencial;
    String descricao;

    Bacia.fromJSON(Map<String, dynamic> json) :
            sequencial = json['sequencial'],
            descricao = json['descricao'];

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Bacia: {');
        buffer.writeln('Sequencial: $sequencial');
        buffer.writeln('Descricao: $descricao');
        buffer.write('}');
        return buffer.toString();
    }
}
