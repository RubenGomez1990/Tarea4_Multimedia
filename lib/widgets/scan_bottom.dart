import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () {
        // Simulamos lectura de un código QR
        String barcodeScanRes = 'https:wef';

        // Buscamos el proveedor en nuestro arbol de Widgets
        final scanListProvider = Provider.of<ScanListProvider>(context,
            listen: false); // Instancia de provider para ScanList
        scanListProvider.scanNuevo(
            barcodeScanRes); // Llamamos al método que hemos creado antes en scanListProvider.

        // Simulamos lectura de un código QR
        String barcodeScanRes1 = 'geo:wef';
        scanListProvider.scanNuevo(barcodeScanRes1);
      },
    );
  }
}
