import 'dart:async';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_application_4/service/api.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class MapScreen extends StatefulWidget {
  final CampsiteModel? campsite;

  const MapScreen({super.key, required this.campsite});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _pAppPlex;
  LatLng? _currentP;
  Set<Marker> _markers = {};

  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor? _currentLocationMarkerIcon;

  @override
  void initState() {
    super.initState();

    if (widget.campsite != null) {
      _pAppPlex = LatLng(
        widget.campsite!.locationCoordinates.latitude,
        widget.campsite!.locationCoordinates.longitude,
      );
    }

    getLocationUpdate();
    _setCustomMarkerIcon();
    _fetchCampsiteLocations();
  }

  void _setCustomMarkerIcon() async {
    _currentLocationMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'images/verified.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        backgroundColor: kSpotifyBackground,
        title: const Text(
          '🗺️ แผนที่สถานที่ตั้งแคมป์',
          style: TextStyle(
            color: kSpotifyTextPrimary,
            fontSize: 18.0,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          _currentP == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) =>
                      _mapController.complete(controller),
                  initialCameraPosition:
                      CameraPosition(target: _currentP!, zoom: 6),
                  markers: {
                    if (_currentP != null)
                      Marker(
                        markerId: const MarkerId("_currentLocation"),
                        icon: _currentLocationMarkerIcon ??
                            BitmapDescriptor.defaultMarker,
                        position: _currentP!,
                      ),
                    if (_pAppPlex != null)
                      Marker(
                        markerId: const MarkerId("_destinationLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _pAppPlex!,
                      ),
                  }.union(_markers),
                  polylines: Set<Polyline>.of(polylines.values),
                ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _currentP != null
                  ? () => _cameraToPosition(_currentP!)
                  : null,
              backgroundColor: kSpotifyAccent,
              child: const Icon(Icons.my_location, color: kSpotifyTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_currentP != null) {
            getPolylinePoints().then((coordinate) {
              generatePolylineFromPoint(coordinate);
            });
          }
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    if (_currentP != null && _pAppPlex != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          mode: TravelMode.driving,
          origin: PointLatLng(_currentP!.latitude, _currentP!.longitude),
          destination: PointLatLng(_pAppPlex!.latitude, _pAppPlex!.longitude),
        ),
        googleApiKey: GOOGLE_API_KEY,
      );

      if (result.points.isNotEmpty) {
        for (var points in result.points) {
          polylineCoordinates.add(LatLng(points.latitude, points.longitude));
        }
      } else {
        print(result.errorMessage);
      }
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoint(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _fetchCampsiteLocations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference campsites = firestore.collection('campsite');

    campsites.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GeoPoint location = doc['location_coordinates'];
        LatLng position = LatLng(location.latitude, location.longitude);

        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
              title: doc['name'],
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      });
    });
  }
}
