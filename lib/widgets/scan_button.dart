import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

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
        String barcodeScanRes = 'https://paucasesnovescifp.cat/';

        // Buscamos el proveedor en nuestro arbol de Widgets
        final scanListProvider = Provider.of<ScanListProvider>(context,
            listen: false); // Instancia de provider para ScanList
        ScanModel scanNuevo = ScanModel(valor: barcodeScanRes);
        scanListProvider.scanNuevo(
            barcodeScanRes); // Llamamos al método que hemos creado antes en scanListProvider.
        launchURL(context, scanNuevo);
      },
    );
  }
}
