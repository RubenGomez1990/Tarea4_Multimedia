import 'package:flutter/material.dart';

// clase para recibir de un provider la UI
class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 1;

  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  set selectedMenuOpt(int index) {
    _selectedMenuOpt = index; // Un index que será "opción" del menu.
    notifyListeners();
  }
}
