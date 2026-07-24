import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ShoppingListRepository extends ChangeNotifier {
  List<ShoppingList> _listas = [];
  LazyBox<ShoppingList>? _box;
  late Future<void> _initialization;
  bool _initialized = false;

  ShoppingListRepository() {
    print('ShoppingListRepository: constructor');
    _initialization = _startRepository();
  }

  Future<void> _startRepository() async {
    print('ShoppingListRepository: start repository...');
    await _openBox();
    print('ShoppingListRepository: box opened -> ${box.name}');
    await _readListas();
    _initialized = true;
    print('ShoppingListRepository: read listas -> ${_listas.length}');
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _initialization;
  }

  _openBox() async {
    _box = await Hive.openLazyBox<ShoppingList>(AppConfig().listaComprasBox);
  }

  LazyBox<ShoppingList> get box {
    final currentBox = _box;
    if (currentBox == null) {
      throw StateError('ShoppingListRepository box was not initialized yet');
    }
    return currentBox;
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
    await _ensureInitialized();
    print('addList called; box open? ${box.isOpen}');
    await box.put(newList.id, newList);
    _listas.add(newList);
    print('addList after put -> listas length: ${_listas.length}');
    notifyListeners();
  }

  UnmodifiableListView<ShoppingList> get listas =>
      UnmodifiableListView(_listas);

  Future<void> updateList(ShoppingList updatedList) async {
    await _ensureInitialized();
    final index = _listas.indexWhere((l) => l.id == updatedList.id);
    if (index != -1) {
      _listas[index] = updatedList;
      await box.put(updatedList.id, updatedList);
      notifyListeners();
    }
  }

  Future<void> removeList(String id) async {
    await _ensureInitialized();
    _listas.removeWhere((compra) => compra.id == id);
    await box.delete(id);
    notifyListeners();
  }

  // Métodos de exportação/importação

  Future<String> exportList(ShoppingList myList) async {
    final exportDir = Directory(AppConfig().exportDir);

    final listFile = File('${exportDir.path}/${myList.name}.mlc');
    var jsonList = jsonEncode(myList.toJson());
    await listFile.writeAsString(jsonList);
    return listFile.path;
  }

  //precisa do endereço do arquivo
  //pega o arquivo a partir do endereço;
  //verificar se é um mlc
  //se for um MLC:
  //converte ele para objeto ao decodificá-lo.
  // se a lista já existir, atualizar a lista com o conteúdo importado;
  // senão, chama o método de adicionar lista com os dados decodificados
  // retorna mensagem de confirmação
  // se não for válido
  //retorna aviso de arquivo inválido

  Future<String> importList(String fileAddress) async {
    try {
      await _ensureInitialized();
      final importedFile = File(fileAddress);

      if (!await importedFile.exists()) {
        return "Arquivo não encontrado";
      }

      if (!importedFile.path.toLowerCase().endsWith('.mlc')) {
        return "arquivo inválido";
      }

      final content = await importedFile.readAsString();
      final decodedJSON = jsonDecode(content);
      final newList = ShoppingList.fromJson(decodedJSON);

      final index = _listas.indexWhere((lista) => lista.id == newList.id);
      if (index != -1) {
        _listas[index] = newList;
        await box.put(newList.id, newList);
      } else {
        _listas.add(newList);
        await box.put(newList.id, newList);
      }

      _listas.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();

      return "Lista ${newList.name} ${index != -1 ? 'atualizada' : 'adicionada'}";
    } catch (e) {
      return "erro ao importar a lista: $e";
    }
  }

  // ================ CRUD de produtos ================ //

  // acrescentar um produto à lista
  Future<void> addProduct(String listId, Product product) async {
    await _ensureInitialized();
    final list = _listas.firstWhere((l) => l.id == listId);
    list.items.add(product);
    await updateList(list);
  }

  //remover produto da lista
  Future<void> removeProduct(String listId, Product product) async {
    await _ensureInitialized();
    final list = _listas.firstWhere((l) => l.id == listId);
    list.items.removeWhere((p) => p.description == product.description);
    await updateList(list);
  }

  // marcar um produto da lista
  Future<void> toggleProductCheck(String listId, Product product) async {
    await _ensureInitialized();
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
