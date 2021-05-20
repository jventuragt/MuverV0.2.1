import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:move_app_1/controllers/client_map_controller.dart';
import 'package:move_app_1/model/client.dart';
import 'package:move_app_1/model/placeobj.dart';
import 'package:move_app_1/page/favorite.dart';

import 'package:geolocator/geolocator.dart';
import 'package:move_app_1/page/loginsignup.dart';
import 'package:move_app_1/page/myride.dart';
import 'package:move_app_1/page/notifacation.dart';
import 'package:move_app_1/page/promo.dart';
import 'package:move_app_1/page/support.dart';
import 'package:move_app_1/service/callapi.dart';
import 'package:move_app_1/service/google_signin_service.dart';
import 'package:move_app_1/uidata.dart';
import 'package:move_app_1/widget/clipper.dart';
import 'package:move_app_1/widget/loader2.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'payment.dart';
import 'selectdestination.dart';

import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _MyTabmapScreenState createState() => _MyTabmapScreenState();
}

class _MyTabmapScreenState extends State<HomePage> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  ClientMapController _con = new ClientMapController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  LatLng _center = const LatLng(14.6262096, -90.562601);
  final Set<Marker> markers = {};
  LatLng _lastMapPosition = const LatLng(14.6262096, -90.562601);

  Geolocator _geolocator;
  Position _position;
  LatLng _positioncar1;
  String diachihinetai = "";
  var isLoading = true;
  final CallApi _callApi = new CallApi();

  final myController1 = TextEditingController();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  /* void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }*/

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });

    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
    updateLocation();

    StreamSubscription positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      _position = position;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _con.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state);

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .timeout(new Duration(seconds: 20));

      setState(() {
        _position = newPosition;

        _center = LatLng(newPosition.latitude, newPosition.longitude);
        _lastMapPosition = _center;
        double lat = newPosition.latitude + 0.1;
        _positioncar1 = LatLng(lat, newPosition.longitude);
      });
      print("lat:" + _position.latitude.toString());
      print("long:" + _position.longitude.toString());
      searchPlace();
    } catch (e) {
      print('Error here 20....: ${e.toString()}');
    }
  }

  Future searchPlace() async {
    print("Buscando....");
    String diachi = await _callApi.findnameplace(
        _position.latitude.toString(), _position.longitude.toString());
    setState(() {
      diachihinetai = diachi;
      isLoading = false;
      myController1.text = diachi;
    });
    print("diachihinetai:" + diachihinetai);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),

        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: diachihinetai,
          //snippet: 'Đánh giá: 5*',
        ),
        //icon: BitmapDescriptor.defaultMarker,
        icon: BitmapDescriptor.fromAsset("assets/images/car.png"),
      ));

      /* _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        
        //icon: BitmapDescriptor.defaultMarker,
        // icon: BitmapDescriptor.fromAsset("assets/images/navi96.png"),
      ));*/
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Estas seguro?'),
            content: new Text('Deseas salir de la App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('SI'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /////////////////////////PERMISOS GPS////////////////////////
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

//////////////////////////comienza diseño/////////////////////
  _buildDrawer() {
    final String image =
        "assets/images/no_image.png"; //TODO Foto Driver con servidor
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: UIData.PrimaryColor,
                      ),
                      onPressed: () {
                        _xacnhanthoat();
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: UIData.PrimaryColor,
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: ExactAssetImage(image),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    _con.clients?.uid ?? "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _con.clients?.email ?? "",
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(Mdi.history, "Viajes", goid: 1),
                  _buildDivider(),
                  _buildRow(Mdi.decagramOutline, "Promociones", goid: 2),
                  _buildDivider(),
                  _buildRow(Mdi.heartOutline, "Mis Favoritos", goid: 3),
                  _buildDivider(),
//                  _buildRow(Mdi.bellOutline, "Notifications",
//                      showBadge: true),

                  _buildRow(Mdi.creditCardOutline, "Mis Pagos", goid: 4),
                  _buildDivider(),
                  _buildRow(Mdi.bellOutline, "Notificaciones",
                      showBadge: true, goid: 5),
                  _buildDivider(),
                  _buildRow(Icons.headset, "Soporte", goid: 6),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _iconMyLocation() {
    return FaIcon(
      FontAwesomeIcons.mapPin, size: 40, color: Colors.blueGrey,

      // Image.asset(
      //  "assets/img/my_location_yellow.png",
      // width: 50,
      //height: 50,
    );
  }

  Widget _buildRow(IconData icon, String title,
      {bool showBadge = false, int goid}) {
    final TextStyle tStyle =
        TextStyle(color: active, fontSize: 16.0, fontWeight: FontWeight.bold);
    return InkWell(
      onTap: () => {_goto(goid)},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          Icon(
            icon,
            //color: active,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: UIData.PrimaryColor,
              elevation: 5.0,
              shadowColor: Colors.black45,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: UIData.PrimaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "3",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 1),
      child: IconButton(
        icon: new Icon(
          Icons.menu,
          color: UIData.bluGrey,
          size: 40,
        ),
        onPressed: () {
          _key.currentState.openDrawer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        drawer: _buildDrawer(),
        body: Stack(
          children: <Widget>[
            isLoading
                ? Center(child: LoaderTwo())
                : GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    markers: Set<Marker>.of(_con.markers.values),
                  ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                      padding: const EdgeInsets.all(22.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: myController1,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.my_location,
                                  color: UIData.Bassic,
                                ),
                                hintText: "Tu Origen",
                                hintStyle: TextStyle(color: Colors.black26),
                                //filled: true,
                                //fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 5.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            onTap: () {
                              _showselectpage();
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: UIData.PrimaryColor,
                                ),
                                hintText: "Tu Destino",
                                hintStyle: TextStyle(color: Colors.black26),
                                //filled: true,
                                //fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 5.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _iconMyLocation(),
            ),
            _buildTop(),
          ],
        ),
      ),
    );
  }

  _showselectpage() {
    print("click");
    LatLng pick = LatLng(_position.latitude, _position.longitude);
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return SelectDesPage(
          placepickobj:
              new Placeobj(placename: diachihinetai, placeLatlng: pick));
    }));
  }

  _goto(int goid) {
    print("go ${goid}");
    Navigator.of(context).pop(); //close drawer
    switch (goid) {
      case 1:
        {
          //TODO las paginas del drawel revisar
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return MyRidePage();
          }));
        }
        break;
      case 2:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return PromoPage();
          }));
        }
        break;
      case 3:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return FavoritePage();
          }));
        }
        break;
      case 4:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return PaymementPage();
          }));
        }
        break;
      case 5:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return NotificationPage();
          }));
        }
        break;
      case 6:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return SupportPage();
          }));
        }
        break;
    }
  }

  void _xacnhanthoat() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "SIGN OUT",
      desc: "Estas seguro?",
      buttons: [
        DialogButton(
          child: Text(
            "SI",
            style: TextStyle(color: UIData.PrimaryColor, fontSize: 20),
          ),
          onPressed: () => {
            googleSignIn.signOut(),
            Navigator.pop(context),
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return LoginSignupPage();
            }))
          },
          color: Colors.black12,
        ),
        DialogButton(
            child: Text(
              "NO",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: UIData.PrimaryColor),
      ],
    ).show();
  }

  void refresh() {
    setState(() {});
  }
}
