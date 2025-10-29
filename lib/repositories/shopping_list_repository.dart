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
    print('ShoppingListRepository: constructor');
    _startRepository();
  }

  _startRepository() async {
    print('ShoppingListRepository: start repository...');
    await _openBox();
    print('ShoppingListRepository: box opened -> ${box.name}');
    await _readListas();
    print('ShoppingListRepository: read listas -> ${_listas.length}');
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
    print('addList called; box open? ${box.isOpen}');
    await box.put(newList.id, newList);
    _listas.add(newList);
    print('addList after put -> listas length: ${_listas.length}');
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
  Future<void> addProduct(String listId, Product product) async {
    final list = _listas.firstWhere((l) => l.id == listId);
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
