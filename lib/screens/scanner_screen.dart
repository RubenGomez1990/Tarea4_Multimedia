import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanned = false; // El freno para no leer 100 veces el mismo QR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escàner QR")),
      // Usamos un Stack para poner el diseño ENCIMA de la cámara
      body: Stack(
        alignment:
            Alignment.center, // Centramos todo lo que pongamos en el Stack
        children: [
          // 1. CAPA DE FONDO: La cámara a pantalla completa
          MobileScanner(
            onDetect: (capture) {
              if (isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                isScanned = true;
                final String code = barcodes.first.rawValue!;
                Navigator.pop(context, code);
              }
            },
          ),

          // 2. CAPA INTERMEDIA: El recuadro para apuntar
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              // Hacemos que el interior sea totalmente transparente
              color: Colors.transparent,
              // Le ponemos un borde llamativo
              border: Border.all(
                color: Colors
                    .greenAccent, // Puedes cambiarlo a Theme.of(context).primaryColor
                width: 4.0, // Grosor de la línea
              ),
              borderRadius: BorderRadius.circular(16), // Bordes redondeados
            ),
          ),

          // 3. CAPA SUPERIOR: Un textito de ayuda (opcional)
          Positioned(
            bottom: 80, // Lo separamos 80 píxeles desde abajo
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54, // Fondo semitransparente oscuro
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Apunta al código QR',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
