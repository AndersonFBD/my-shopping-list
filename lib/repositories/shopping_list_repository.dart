import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/shopping_list.dart';

class ShoppingListRepository extends ChangeNotifier {
  List<ShoppingList> _listas = [];
  late LazyBox box;

  ShoppingListRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readListas();
  }

  _openBox() async {
    box = await Hive.openLazyBox<ShoppingList>(AppConfig().listaComprasBox);
  }

  _readListas() {
    box.keys.forEach((lista) async {
      ShoppingList ldc = await box.get(lista);
      _listas.add(ldc);
      notifyListeners();
    });
  }

  UnmodifiableListView<ShoppingList> get listas =>
      UnmodifiableListView(_listas);

  saveAll(List<ShoppingList> compras) {
    compras.forEach((compra) {
      if (!_listas.any((atual) => atual.id == compra.id)) {
        _listas.add(compra);
        box.put(compra.id, compra);
      }
    });
  }

  remove(ShoppingList compra) {
    _listas.remove(compra);
    box.delete(compra.id);
    notifyListeners();
  }
}
