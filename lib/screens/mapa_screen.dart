import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scan/models/scan_model.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  // El completer es similar a un Future. Hasta que el mapa no está dibujado, no podemos mandarle órdenes.
  final Completer<GoogleMapController> _controller = Completer();

  // Variable de estado para el tipo de mapa
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    // Recibimos los datos del QR
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    // Donde mirará la cámara al iniciarlo
    final CameraPosition puntInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 17, tilt: 50);

    // Chincheta que apunta a nuestras coordenadas
    Set<Marker> markers = <Marker>{};
    markers.add(Marker(
        markerId: const MarkerId('geo-location'), position: scan.getLatLng()));

    return Scaffold(
      // Todo va dentro del Stack para flotar sobre el mapa libremente
      body: Stack(
        children: [
          // Mapa ocupando toda la pantalla
          GoogleMap(
            myLocationEnabled:
                true, // Muestra nuestra ubicación en un punto azul
            myLocationButtonEnabled: false,
            zoomControlsEnabled:
                false, // Ocultamos los botones +/- (es más intuitivo pellizcar la pantalla)
            mapType: mapType, // Botón para cambiar de tipo de mapa
            markers: markers,
            initialCameraPosition: puntInicial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // APPBAR de búsqueda que con SafeArea evita que se meta debajo del notch o de la batería del móvil
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    // Botón para volver atrás.
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      // Mostramos el valor real escaneado en lugar de un texto fijo
                      child: Text(
                        scan.valor,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16),
                        overflow: TextOverflow
                            .ellipsis, // Si es muy largo, lo recorta con "..."
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón de centrar mapa.
          SafeArea(
            child: Align(
              alignment: Alignment.topRight, // Esquina superior derecha
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 70.0,
                    right: 16.0), // top: 70 para que no pise la barra
                child: FloatingActionButton(
                  heroTag:
                      'centrar', // Si hay varios botones flotantes hay que poner tags
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  child: const Icon(Icons.my_location),
                  onPressed: () async {
                    final GoogleMapController
                        controller = // Espera al controlador y ejecuta una animacion de vuelta a la chincheta
                        await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(puntInicial));
                  },
                ),
              ),
            ),
          ),

          // Cambio de capa de mapa
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft, // Esquina inferior izquierda
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 16.0),
                child: FloatingActionButton(
                  heroTag: 'capas',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  child: const Icon(Icons.layers),
                  onPressed: () {
                    setState(() {
                      // Cambiamos a HYBRID para ver el mapa físico CON los nombres de las calles
                      if (mapType == MapType.normal) {
                        mapType = MapType
                            .hybrid; // Muestra foto satélite manteniendo calles y comercios.
                      } else {
                        mapType = MapType.normal;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//TODO: barra de busqueda, botón de volver atrás, botón de centrar en posición, boton cambiar capas.
