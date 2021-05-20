import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:move_app_1/model/client.dart';
//import 'package:move_app_1/model/driver.dart';

//import 'package:location/location.dart';
//import 'package:move_app_1/model/drivers.dart';
import 'package:move_app_1/providers/auth_provider.dart';
import 'package:move_app_1/providers/client_provider.dart';
//import 'package:move_app_1/providers/driver_provider.dart';
import 'package:move_app_1/providers/geofire_provider.dart';
import 'package:move_app_1/uidata.dart';

class ClientMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(14.6262096, -90.562601),
    zoom: 14.0,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerdriver;

  GeoFireProvider _geoFireProvider;
  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  //PushNotificationsProvider _pushNotificationsProvider;

  bool isConnect = false;
  // ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSuscription;

  Clients clients;
  String _con;
  String from;
  LatLng fromLatLng;

  String to;
  LatLng toLatLng;

  bool isFromSelected = true;

  places.GoogleMapsPlaces _places =
      places.GoogleMapsPlaces(apiKey: UIData.API_KEY_MAPS);

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    //_pushNotificationsProvider = new PushNotificationsProvider();
    //_progressDialog =
    //    MyProgressDialog.createProgressDialog(context, "Conectandose...");

    markerdriver = await createMarkerImageFromAsset("assets/images/navi96.png");

    checkGPS();
    //saveToken();
    getClientInfo();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> clientStream =
        _clientProvider.getByIdStream(_authProvider.getUser().uid);
    _clientInfoSuscription = clientStream.listen((DocumentSnapshot document) {
      clients = Clients.fromJson(document.data());
      refresh();
    });
  }

/* void saveToken() {
  //  _pushNotificationsProvider.saveToken(_authProvider.getUser().uid, "driver");
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToEditPage() {
    //Navigator.pushNamed(context, "driver/edit");
  }

  void goToHistoryPage() {
    Navigator.pushNamed(context, "driver/history");
  }

  void goToImagenesDriverPages() {
    Navigator.pushNamed(context, "imagenes/driver");
  }

  void goToDriverMostrarImagenes() {
    Navigator.pushNamed(context, "driver/mostrar/imagenes");
  }*/

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
//    controller.setMapStyle("Map ID: b5d6ae2698ed9558");
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geoFireProvider.create(
        _authProvider.getUser().uid, _position.latitude, _position.longitude);

    //  _progressDialog.hide();
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); //Posision una vez
      centerPosition();
      getNearbydriver();
      saveLocation();

      /*addMarker("client", _position.latitude, _position.longitude, "Position",
          "", markerDriver);

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        _position = position;
        addMarker(
            "client",
            _position.latitude,
            _position.longitude,
            "Position",
            "",
            markerDriver); //TODO revisar el video si es markert de usuario o D

        animateCameraToPosition(_position.latitude, _position.longitude);
        saveLocation();
        refresh();
      });*/
    } catch (error) {
      print("Error LOC: $error");
    }
  }

  void getNearbydriver() {
    Stream<List<DocumentSnapshot>> stream = _geoFireProvider.getNearbydriver(
        _position.latitude, _position.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers?.keys) {
        bool remove = true;

        refresh();
        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()["position"]["geopoint"];
        addMarker(d.id, point.latitude, point.longitude, "Conductor Disponible",
            d.id, markerdriver);
      }

      refresh();
    });
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
      saveLocation();
      refresh();
    } else {
      //utils.Snackbar.showSnackbar(context, key, "Activa tu GPS");
    }
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      print("GPS ACTIVADO");
      updateLocation();
    } else {
      print("GPS DESACTIVADO");
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();

        print("ACTIVO GPS");
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescription =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescription;
  }

  void addMarker(
      //
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor icon) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading);

    markers[id] = marker;
  }
}
