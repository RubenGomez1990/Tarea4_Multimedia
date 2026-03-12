import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          )
        ],
      ),
      body: _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider =
        Provider.of<UIProvider>(context); // Instancia de UIProvider
    final currentIndex = uiProvider
        .selectedMenuOpt; // Como tenemos un index establecido para cada caso del Switch de la homescreen, recibirá con su provider el index del botón seleccionado

    // Creación temporal de la BBDD
    DBProvider.db.database;
    switch (currentIndex) {
      case 0:
        return MapasScreen();

      case 1:
        return DireccionsScreen();

      default:
        return MapasScreen();
    }
  }
}
