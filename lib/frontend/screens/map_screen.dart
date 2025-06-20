import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(51.1280, 71.4304),
    zoom: 12,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('m1'),
      position: LatLng(51.1280, 71.4304),
      infoWindow: InfoWindow(title: 'Astana HQ'),
    ),
    const Marker(
      markerId: MarkerId('m2'),
      position: LatLng(51.1605, 71.4704),
      infoWindow: InfoWindow(title: 'Branch Office'),
    ),
    const Marker(
      markerId: MarkerId('m3'),
      position: LatLng(51.1434, 71.3984),
      infoWindow: InfoWindow(title: 'Store #1'),
    ),
  };

  Future<void> _goToCurrentLocation() async {
    try {
      // ---------- 1) GPS-сервис ----------
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
          return;
        }
      }

      // ---------- 2) Разрешения ----------
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }

      // ---------- 3) Получаем позицию ----------
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ---------- 4) Центрируем карту ----------
      final GoogleMapController mapCtrl = await _controller.future;
      await mapCtrl.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude),
          14,
        ),
      );

      // ---------- 5) Добавляем маркер “You are here” ----------
      setState(() {
        _markers.removeWhere((m) => m.markerId == const MarkerId('current'));
        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: const InfoWindow(title: 'You are here'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      });
    } catch (e) {
      // Общий catch на любые исключения
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obtaining location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCamera,
        markers: _markers,
        myLocationEnabled: true,          // Показываем “синюю точку”
        myLocationButtonEnabled: false,   // Отключаем стандартную кнопку
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        onMapCreated: (ctrl) {
          // Защита от двойного complete()
          if (!_controller.isCompleted) {
            _controller.complete(ctrl);
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'loc',
            onPressed: _goToCurrentLocation,
            mini: true,
            tooltip: 'My Location',
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'plus',
            onPressed: () async {
              final ctrl = await _controller.future;
              ctrl.animateCamera(CameraUpdate.zoomIn());
            },
            mini: true,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'minus',
            onPressed: () async {
              final ctrl = await _controller.future;
              ctrl.animateCamera(CameraUpdate.zoomOut());
            },
            mini: true,
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
