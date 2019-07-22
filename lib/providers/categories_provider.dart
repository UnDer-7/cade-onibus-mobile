import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/bus.dart';

class CategoriesProviders with ChangeNotifier {
    final List<Category> _categories = [
        Category(
            title: 'Casa',
            cardColor: Colors.green,
            buses: [
                Bus(
                    numero: '501.3',
                    descricao: 'Sobradinho II / Eixo-Norte/Sul',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 5.00
                    )
                ),
                Bus(
                    numero: '501.4',
                    descricao: 'Sobradinho II-II / Eixo-Norte/Sul',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 5.00
                    )
                ),
                Bus(
                    numero: '517',
                    descricao: 'Sobradinho II / W3-Norte/Sul',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 5.00
                    )
                )
            ],
        ),
        Category(
            title: 'Faculdade',
            cardColor: Colors.red,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Casa da Namorada',
            cardColor: Colors.black,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Faculdade do grande marcelão',
            cardColor: Colors.white,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Ta de Sanagem né?',
            cardColor: Colors.blue,
            buses: [
                Bus(
                    numero: '505.3',
                    descricao: 'Sobradinho I - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
                Bus(
                    numero: '505.8',
                    descricao: 'Grande Colorado - Quadra 3-5',
                    ativa: null,
                    bacia: null,
                    operadoras: null,
                    sentido: null,
                    sequencial: null,
                    tipoLinha: null,
                    tiposOnibus: null,
                    id: null,
                    faixaTarifaria: FaixaTarifaria(
                        descricao: null,
                        sequencial: null,
                        tarifa: 2.50
                    )
                ),
            ],
        ),
        Category(
            title: 'Vazio',
            cardColor: Colors.green,
            buses: [],
        )

    ];

    set addCategory(Category category) {
        _categories.add(category);
        notifyListeners();
    }

    List<Category> get getCategory => List.of(_categories);
}
