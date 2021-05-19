import 'package:flutter/material.dart';
import 'package:move_app_1/model/counter.dart';
import 'package:move_app_1/page/verifyotp.dart';
import 'package:provider/provider.dart';

import '../uidata.dart';

class HomePageTest extends StatelessWidget {
  String phone;

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.getCounter()}',
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  color: UIData.PrimaryColor,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(new MaterialPageRoute(builder: (context) {
                      return new OTPScreen();
                    }));
                  },
                  child: Text(
                    "GO",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: counter.increment,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: counter.decrement,
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}