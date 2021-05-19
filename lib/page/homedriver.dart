import 'dart:async';
//import 'dart:ffi';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:geolocator/geolocator.dart';

//import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:move_app_1/controllers/driver_map_controller.dart';
import 'package:move_app_1/page/gotopickup.dart';
import 'package:move_app_1/page/login.dart';
import 'package:move_app_1/page/loginsignup.dart';
import 'package:move_app_1/page/notifacation.dart';
import 'package:move_app_1/page/setting.dart';
import 'package:move_app_1/page/signup.dart';
import 'package:move_app_1/page/support.dart';
//import 'package:move_app_1/providers/auth_provider.dart';
//import 'package:move_app_1/providers/geofire_provider.dart';
import 'package:move_app_1/uidata.dart';
import 'package:move_app_1/widget/clipper.dart';
import 'package:move_app_1/widget/loader2.dart';
import 'package:move_app_1/widget/mybutton.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'history.dart';
import 'mywallet.dart';

class HomeDriverPage extends StatefulWidget {
  HomeDriverPage({Key key}) : super(key: key);

  @override
  _HomeDriverPageState createState() {
    return _HomeDriverPageState();
  }
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  DriverMapController _con = new DriverMapController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _con.dispose();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  //Completer<GoogleMapController> _controller = Completer();
  bool isConnect = true;
  bool isoff = true;
  var isLoading = true;
  int trangthai = 0;
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(14.6262096, -90.562601),
    zoom: 14.0,
  );

  /* LatLng _center = const LatLng(14.6262096, -90.562601);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = const LatLng(14.6262096, -90.562601);*/

  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  //Geolocator _geolocator;
  //Position _position;
  //BitmapDescriptor markerDriver;

  //GeoFireProvider _geoFireProvider;
  //AuthProvider _authProvider;

  AnimationController controller;
  Animation<Offset> offset;
  

  // StreamSubscription<DocumentSnapshot> _statusSuscription;
  //StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  /* @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();

    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
    updateLocation();

    StreamSubscription _positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      markerDriver =
          await createMarkerImagesFromAssets("assets/images/navi96.png");
      _position = position;
    });

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }*/

  /* @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }*/

/////////////////////MARKER/////////////////////

  /* @override
  void didChangeAppLifecycleState(AppLifecycleState state);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,

        icon: BitmapDescriptor.defaultMarker,
        //icon: BitmapDescriptor.fromAsset("assets/images/car.png"),
      ));

     _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,

        //icon: BitmapDescriptor.defaultMarker,
        // icon: BitmapDescriptor.fromAsset("assets/images/navi96.png"),
      ));
    });
  }*/

/////////////////////PERMISOS GPS////////////////////////////////////
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

/////////////////////////////GPS/////////////////////////////////
  /* void saveLocation() async {
    await _geoFireProvider.create(
        _authProvider.getUser().uid, _position.latitude, _position.longitude);
  }

  void connect() {
    if (isConnect) {
      disconnect();
      //
    } else {
      updateLocation();
    }
//
  }

  void disconnect() {
    _geoFireProvider.delete(_authProvider.getUser().uid);
//
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      print("GPS ACTIVADO");
      updateLocation();
      checkIfIsConnect();
//
    } else {
      print("GPS DESACTIVADO");
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        checkIfIsConnect();
        print("ACTIVO GPS");
      }
    }
  }

  void checkIfIsConnect() {
    Stream<DocumentSnapshot> status =
        _geoFireProvider.getLocationByIdStream(_authProvider.getUser().uid);

    _statusSuscription = status.listen((DocumentSnapshot document) {
      if (document.exists) {
        isConnect = true;
      } else {
        isConnect = false;
      }
      refresh();
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      saveLocation();

      setState(() {
        _position = newPosition;
        addMarker("driver", _position.latitude, _position.longitude, "Position",
            "", markerDriver);
        _center = LatLng(newPosition.latitude, newPosition.longitude);

        _lastMapPosition = _center;
        double lat = newPosition.latitude + 0.1;
        //_positioncar1 = LatLng(lat, newPosition.longitude);
        isLoading = false;
      });
      print("lat:" + _position.latitude.toString());
      print("long:" + _position.longitude.toString());
      saveLocation();
      //searchPlace();
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void centerPosition() {
    addMarker("driver", _position.latitude, _position.longitude, "Position", "",
        markerDriver);
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _controller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImagesFromAssets(String path) async {
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
      BitmapDescriptor iconMarker) {
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
  }*/

//////////////////////////FIN GPS/////////////////////////////////
///////////////////LOCATION ICON//////////////////////
  Widget _buildItem(IconData icon, String str1, String des) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            str1,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Text(
          des,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTrangthai0() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 6.0),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage(
                    'assets/images/no_image.png',
                  ),
                  minRadius: 90,
                  maxRadius: 150,
                ),
              ),
              title: Text(
                _con.driver?.email ?? "",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Basic level"),
              trailing: Column(
                children: <Widget>[
                  Text(
                    "\$325",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    "Earned",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                color: UIData.PrimaryColor,
                borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildItem(Mdi.clockOutline, "10.2", "HOURS ONLINE"),
                  _buildItem(Mdi.gauge, "30", "TOTAL DISTANCE"),
                  _buildItem(Mdi.clipboardOutline, "20", "TOTAL JOBS"),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildTrangthai1() {
    return SlideTransition(
      position: offset,
      child: Container(
          //padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(1.0, 6.0),
                  blurRadius: 15.0,
                ),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: UIData.myBackground),
          child: Column(children: <Widget>[
            ListTile(
              leading: Container(
                height: double.infinity,
                // margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: ExactAssetImage(
                        'assets/images/user.jpeg',
                      ),
                    )),
              ),
              title: Text(
                "Trinh Xuan Nhi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Cash payment",
                style: TextStyle(
                    color: UIData.PrimaryColor, fontWeight: FontWeight.bold),
              ),
              trailing: Column(
                children: <Widget>[
                  Text(
                    "\$25",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    "2,2 Km",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "PICK UP",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Ninh Kieu Riverside hotel",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  Text(
                    "DROP OFF",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Luu Huu Phuoc park",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => {
                                print("click"),
                                setState(() {
                                  trangthai = 0;
                                }),
                                //controller.reverse()
                              },
                          child: Text(
                            "Ignore",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        width: 32,
                      ),
                      MyButton(
                          caption: "Accept",
                          onPressed: () {
                            print("Tapped Me");
                            setState(() {
                              trangthai = 0;
                            });
                            Navigator.of(context)
                                .push(new MaterialPageRoute(builder: (context) {
                              return new GotoPickupPage();
                            }));
                          }),
                    ],
                  )
                ],
              ),
            )
          ])),
    );
  }

  Widget _buildthongbao() {
    return AnimatedOpacity(
      opacity: isoff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        color: UIData.PrimaryAssentColor,
        child: ListTile(
          leading: Icon(Mdi.carOff),
          title: Text(
            "Estas fuera de Linea !",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Conectate de Nueva y recibe Viajes"),
        ),
      ),
    );
  }

  _buildDrawer() {
    final String image = 'assets/images/driver.jpeg';
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
                    "Usuario",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                      //height: 30,
                      //width: 150,
                      //color: Colors.green,
                      // alignment: Alignment.topCenter,
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: UIData.PrimaryColor,
                      ),
                      Text("Gold member")
                    ],
                  )),
                  SizedBox(height: 30.0),
                  _buildRow(Mdi.walletOutline, "My Wallet", goid: 1),
                  _buildDivider(),
                  _buildRow(Mdi.history, "History", goid: 2),
                  _buildDivider(),
                  _buildRow(Mdi.bellOutline, "Notification",
                      showBadge: true, goid: 3),
                  _buildDivider(),
                  _buildRow(Mdi.settingsOutline, "Setting", goid: 4),
                  _buildDivider(),
                  _buildRow(Icons.headset, "Support", goid: 5),
                  _buildDivider(),
                  Container(
                      color: UIData.PrimaryColor,
                      child: _buildRow(
                          Icons.directions_car, "New booking (Demo)",
                          goid: 100)),
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
              shadowColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        //onWillPop: _onWillPop,
        child: Scaffold(
            key: _key,
            drawer: _buildDrawer(),
            appBar: new AppBar(
              title: isoff ? Text('EnLinea') : Text('Fuera deLinea'),
              centerTitle: true,
              backgroundColor: Colors.white38,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.menu, color: UIData.Bassic),
                onPressed: () {
                  _key.currentState.openDrawer();
                },
              ),
              actions: <Widget>[
                CupertinoSwitch(
                  activeColor: UIData.PrimaryColor,
                  value: _con.isConnect ? isoff : !isoff,
                  onChanged: (bool value) {
                    setState(() {
                      isoff = !isoff;
                    });
                    _con.connect();
                  },
                ),
              ],
            ),
            body: Stack(children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _con.initialPosition,
                myLocationEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _con.onMapCreated,
                /* initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16.0,
                      ),*/
                markers: Set<Marker>.of(_con.markers.values),
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
//                    isoff
//                        ? SizedBox(
//                            height: 1,
//                          )
//                        : _buildthongbao(),
                    _buildthongbao(),
                    Spacer(),
                    if (trangthai == 0) _buildTrangthai0(),
                    if (trangthai == 1) _buildTrangthai1(),
                  ],
                ),
              ),
            ])));
  }

  _goto(int goid) {
    print("go ${goid}");
    Navigator.of(context).pop(); //close drawer
    switch (goid) {
      case 1:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return MyWalletPage();
          }));
        }
        break;
      case 2:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return HistoryPage();
          }));
        }
        break;
      case 3:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return NotificationPage();
          }));
        }
        break;
      case 4:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return SettingPage();
          }));
        }
        break;
      case 5:
        {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return SupportPage();
          }));
        }
        break;

      case 100:
        {
          setState(() {
            trangthai = 1;
          });
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
            Navigator.pop(context),
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return LoginPage();
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
