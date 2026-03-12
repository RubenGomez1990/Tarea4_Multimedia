import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';

// Modifica la barra "insivible" donde está mapa y direcciones e ilumina la opción seleccionada.
class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(
        context); // Declarada instancia de UIProvider para la llamada en la barra.
    final currentIndex = uiProvider
        .selectedMenuOpt; // Index = a la opción de menú seleccionada (usando get)

    return BottomNavigationBar(
        onTap: (int i) => uiProvider.selectedMenuOpt =
            i, // Método "on tap" con el ratón selecciona la opción de menu con un int index = i según el botón que pulses.
        elevation: 0,
        currentIndex: currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: 'Direccions',
          )
        ]);
  }
}
