import 'package:meta/meta.dart';
import 'dart:convert';

class Token {
    final String jwtEncoded;
    final _Header header;
    final _Payload payload;

    Token({
        @required this.jwtEncoded,
        @required this.header,
        @required this.payload,
    });

    Token.fromSharedPreferences(dynamic json) :
        jwtEncoded = json['jwtEncoded'],
        payload = _Payload.fromSharedPreferences(json['payload']),
        header = _Header.fromSharedPreferences(json['header']);

    Token.fromJSON({String jwtEncoded, dynamic payload, dynamic header}) :
            jwtEncoded = jwtEncoded,
            payload = _Payload.fromJSON(payload),
            header = _Header.fromJSON(header);

    static String toJSON(Token token) {
        Map<String, dynamic> map = {
            'jwtEncoded': token.jwtEncoded,
            'header': _Header.toJSON(token.header),
            'payload': _Payload.toJSON(token.payload),
        };
        return json.encode(map);
    }

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Token: {');
        buffer.writeln('JwtEncoded: $jwtEncoded');
        buffer.writeln('Header: $header');
        buffer.writeln('Payload: $payload');
        buffer.write('}');
        return buffer.toString();
    }
}

class _Header {
    final String alg;
    final String typ;

    _Header({
        @required this.alg,
        @required this.typ,
    });

    _Header.fromJSON(dynamic json) :
            typ = json['typ'],
            alg = json['alg'];

    _Header.fromSharedPreferences(dynamic json) :
        typ = json['typ'],
        alg = json['alg'];

    static Map<String, dynamic> toJSON(_Header _header) =>
        {
            'alg': _header.alg,
            'typ': _header.typ,
        };

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Header: {');
        buffer.writeln('Alg: $alg');
        buffer.writeln('Typ: $typ');
        buffer.write('}');
        return buffer.toString();
    }
}

class _Payload {
    final String email;
    final DateTime iat;
    final DateTime exp;

    _Payload({
        @required this.email,
        @required this.iat,
        @required this.exp,
    });

    _Payload.fromJSON(dynamic json) :
            email = json['email'],
            iat = DateTime.fromMillisecondsSinceEpoch(json['iat'] * 1000),
            exp = DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000);

    _Payload.fromSharedPreferences(dynamic json) :
        email = json['email'],
        iat = DateTime.parse(json['iat']),
        exp = DateTime.parse(json['exp']);

    static toJSON(_Payload _payload) =>
        {
            'email': _payload.email,
            'iat': _payload.iat.toString(),
            'exp': _payload.exp.toString(),
        };

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Payload: {');
        buffer.writeln('Email: $email');
        buffer.writeln('Iat: $iat');
        buffer.writeln('Exp: $exp');
        buffer.write('}');
        return buffer.toString();
    }
}
