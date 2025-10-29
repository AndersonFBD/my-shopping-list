import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/model/shopping_list.dart';

class ShoppingListRepository extends ChangeNotifier {
  List<ShoppingList> _listas = [];
  late LazyBox<ShoppingList> box;

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

  Future<void> _readListas() async {
    _listas.clear();
    for (final key in box.keys) {
      final ShoppingList? ldc = await box.get(key);
      if (ldc != null) _listas.add(ldc);
    }
    _listas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> addList(ShoppingList newList) async {
    await box.put(newList.id, newList);
    _listas.add(newList);
    notifyListeners();
  }

  UnmodifiableListView<ShoppingList> get listas =>
      UnmodifiableListView(_listas);

  Future<void> updateList(ShoppingList updatedList) async {
    final index = _listas.indexWhere((l) => l.id == updatedList.id);
    if (index != -1) {
      _listas[index] = updatedList;
      await box.put(updatedList.id, updatedList);
      notifyListeners();
    }
  }

  Future<void> removeList(String id) async {
    _listas.removeWhere((compra) => compra.id == id);
    await box.delete(id);
    notifyListeners();
  }

  // ================ CRUD de produtos ================ //

  // acrescentar um produto à lista
  Future<void> addProduct(String ListId, Product product) async {
    final list = _listas.firstWhere((l) => l.id == ListId);
    list.items.add(product);
    await updateList(list);
  }

  //remover produto da lista
  Future<void> removeProduct(String listId, Product product) async {
    final list = _listas.firstWhere((l) => l.id == listId);
    list.items.removeWhere((p) => p.description == product.description);
    await updateList(list);
  }

  // marcar um produto da lista
  Future<void> toggleProductCheck(String listId, Product product) async {
    final list = _listas.firstWhere((l) => l.id == listId);
    final index = list.items.indexWhere(
      (p) => p.description == product.description,
    );
    if (index != -1) {
      list.items[index].gotItem = !list.items[index].gotItem;
      await updateList(list);
    }
  }
}
