import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../uidata.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<NotificationPage> {
  List<String> list1 = [
    "Promocion",
    "Mensaje de Muber app",
    "Mensaje de Muber app"
  ];
  List<String> list2 = [
    "10% off esta semana",
    "Gracias por utilizar Muber app",
    "Tienes promociones pendientes"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildItem(int i) {
    return ListTile(
      leading: Icon(
        Mdi.bellOutline,
        color: UIData.PrimaryColor,
      ),
      title: Text(
        list1[i],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(list2[i]),
    );
  }

  Widget _buildList(context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: UIData.myBackgroundlight,
      child: ListView.builder(
        // Must have an item count equal to the number of items!
        itemCount: 3,
        // A callback that will return a widget.
        itemBuilder: (context, int) {
          // In our case, a DogCard for each doggo.
          return _buildItem(int);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Notificaciones",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: _buildList(context),
      ),
    );
  }
}
