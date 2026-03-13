import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

// Este widget pinta tanto la lista de mapas como de direcciones http
class ScanTiles extends StatelessWidget {
  final String tipus; // recibe el tipus para saber en que lista estamos
  const ScanTiles({Key? key, required this.tipus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(
        context); // Instanciamos el provider de la lista de scans
    final scans = scanListProvider.scans;

    // Renderiza solo los elementos que caben en el móvil
    return ListView.builder(
      itemCount: scans.length, // Nº total de scans
      itemBuilder: (_, index) => Dismissible(
        key: UniqueKey(), // "Código" que identifica el elemento a borrar
        background: Container(
          // Container que será el fondo del Dismissible (es un child de él)
          color: Colors.red,
          child: const Align(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_forever),
            ),
            alignment: Alignment.centerRight,
          ),
        ),
        // Se ejecuta al terminar de deslizar el scan
        onDismissed: (DismissDirection direccion) {
          Provider.of<ScanListProvider>(context,
                  listen: false) // Como estamos en una función, listen: false
              .esborraPerId(scans[index]
                  .id!); // De la posición de este scan, escoge su ID que no podrá ser nula !
        },
        //Aspecto visual del elemento de la lista
        child: ListTile(
          leading: Icon(
            tipus == 'http'
                ? Icons.home_outlined
                : Icons
                    .map_outlined, // Si es http una casita, si es geo un mapita
          ),
          title: Text(
              scans[index].valor), // de la posición del scan, coge su valor QR
          subtitle: Text(scans[index]
              .id
              .toString()), // de la posición del scan, coge su ID (int) y conviertelo a string
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          // Lo que pasará al hacer "click" en el elemento de la lista.
          onTap: () {
            launchURL(context, scans[index]); //Llamamos al metodo
          },
        ),
      ),
    );
  }
}
