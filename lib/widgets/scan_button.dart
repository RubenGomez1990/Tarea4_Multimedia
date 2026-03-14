import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/screens/scanner_screen.dart';
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
      // Añadimos 'async' porque vamos a esperar la respuesta de la cámara
      onPressed: () async {
        // 1. Abrimos la pantalla del escáner y ESPERAMOS (await) lo que nos devuelva
        final String? barcodeScanRes = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScannerScreen()),
        );

        // 2. Si el usuario le da a volver atrás sin escanear nada, barcodeScanRes será null.
        // En ese caso, cortamos la ejecución para que no de error.
        if (barcodeScanRes == null) {
          return;
        }

        // 3. Buscamos el proveedor en nuestro árbol de Widgets (listen: false siempre en botones)
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);

        // 4. Llamamos al método que inserta en la BD.
        // OJO AQUÍ: Le ponemos 'await' para que termine de guardarlo y nos devuelva
        // el objeto ScanModel completo (¡ya con su ID autogenerado!).
        final ScanModel scanNuevo =
            await scanListProvider.scanNuevo(barcodeScanRes);

        // 5. Lanzamos la acción (abrir navegador o mapa) usando la utilidad que ya tenías
        launchURL(context, scanNuevo);
      },
    );
  }
}
