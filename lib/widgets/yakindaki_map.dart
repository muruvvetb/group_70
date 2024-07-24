import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cep_eczane/services/pharmacy_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PharmacyService _pharmacyService = PharmacyService('24t2dDF8FxSx1NQ9Dp6OPOXa1ld503quqyhfjpjFJaHYaneuZJj2FGdSxb1V'); // API anahtarınızı buraya ekleyin
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LatLng? _currentPosition;
  List<LatLng> _pharmacies = [];
  bool _showOnDuty = false;
  bool _initialCameraPositionSet = false; // Yeni değişken

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sadece nöbetçi eczaneleri göster',
                  style: TextStyle(fontSize: 16), // Metin stilini değiştirdik
                ),
                Switch(
                  value: _showOnDuty,
                  onChanged: (value) {
                    setState(() {
                      _showOnDuty = value;
                      _fetchNearbyPharmacies();
                    });
                  },
                  activeColor: Color(0xFF1F3C51), // Açıkken rengini değiştirdik
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 14,
                    ),
                    markers: _createMarkers(),
                    myLocationEnabled: true, // Kullanıcının mevcut konumunu göster
                    myLocationButtonEnabled: true, // Kullanıcının konumuna gitme butonu
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (!_initialCameraPositionSet) {
            _initialCameraPositionSet = true;
            _cameraToPosition(_currentPosition!);
            _fetchNearbyPharmacies();
          }
        });
      }
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 14,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> _fetchNearbyPharmacies() async {
    if (_currentPosition == null) return;
    try {
      final pharmacies = await _pharmacyService.fetchNearbyPharmacies(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        2000,
        onDuty: _showOnDuty,
      );
      setState(() {
        _pharmacies = pharmacies.map<LatLng>((pharmacy) {
          return LatLng(pharmacy['latitude'], pharmacy['longitude']);
        }).toList();
      });
    } catch (e) {
      print('Failed to fetch pharmacies: $e');
    }
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {
      
    };

    for (LatLng pharmacy in _pharmacies) {
      markers.add(
        Marker(
          markerId: MarkerId(pharmacy.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pharmacy,
        ),
      );
    }

    return markers;
  }
}
