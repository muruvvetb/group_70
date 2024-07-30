import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cep_eczane/services/pharmacy_service.dart';

class MapPage extends StatefulWidget {
  final Function(List<dynamic>) onPharmaciesFetched;

  const MapPage({super.key, required this.onPharmaciesFetched});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PharmacyService _pharmacyService = PharmacyService('24t2dDF8FxSx1NQ9Dp6OPOXa1ld503quqyhfjpjFJaHYaneuZJj2FGdSxb1V');
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LatLng? _currentPosition;
  List<dynamic> _pharmacies = [];
  bool _showOnDuty = false;
  bool _initialCameraPositionSet = false;

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
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sadece nöbetçi eczaneleri göster',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _showOnDuty,
                  onChanged: (value) {
                    setState(() {
                      _showOnDuty = value;
                      _fetchNearbyPharmacies();
                    });
                  },
                  activeColor: Color(0xFF1F3C51),
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
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
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

      final pharmaciesWithDistance = pharmacies.map((pharmacy) {
        final distanceKm = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          pharmacy['latitude'],
          pharmacy['longitude'],
        );
        pharmacy['distanceKm'] = distanceKm;
        return pharmacy;
      }).toList();

      setState(() {
        _pharmacies = pharmaciesWithDistance;
        widget.onPharmaciesFetched(pharmaciesWithDistance);
      });
    } catch (e) {
      print('Failed to fetch pharmacies: $e');
    }
  }

 double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295; // Pi/180
  const c = cos;
  final a = 0.5 - c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p)) / 2;
  final distance = 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  return double.parse(distance.toStringAsFixed(2)); // Round to 2 decimal places
}

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    for (var pharmacy in _pharmacies) {
      LatLng position = LatLng(pharmacy['latitude'], pharmacy['longitude']);
      markers.add(
        Marker(
          markerId: MarkerId(pharmacy['pharmacyID'].toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: position,
        ),
      );
    }

    return markers;
  }
}
