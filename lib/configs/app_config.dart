import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppConfig extends ChangeNotifier {
  late Box box;
  Map<String, String> locale = {'locale': 'pt_BR'};

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  _startPreferences() async {
    box = await Hive.openBox('preferencias');
  }

  _readLocale() {
    final local = box.get('local') ?? 'pt_BR';
    locale = {'locale': local};
  }

  setLocale(String local) async {
    await box.put('local', local);
    await _readLocale();
  }
}
