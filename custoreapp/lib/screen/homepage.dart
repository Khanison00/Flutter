import 'dart:io';
import 'package:agvscanner/screen/parkingpage.dart';
import 'package:agvscanner/screen/scanout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyHomePage extends StatefulWidget {
  final int page;
  MyHomePage({Key key, @required this.page}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectPage = 0;
  int _selectedIndex = 0;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
    ]);

    setState(() {
      this._selectedIndex = widget.page;
    });
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  List _widgetOptions = [
    ParkingPage(),
    ScanOutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          child: Scaffold(
      body: SingleChildScrollView(
              child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue[600],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Scan Parking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_car),
            label: 'Scan OUT',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    ),
      onWillPop: _willPopCallback,
    );
  }

  Future<bool> _willPopCallback() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert from App'),
          content: Text('You want to exit the app. ?', style: TextStyle(fontSize: 18)),
          actions: [
            FlatButton(child: Text('No', style: TextStyle(fontSize: 18)), 
            onPressed: (){
              Navigator.pop(context);
            },),
            FlatButton(child: Text('Yes', style: TextStyle(fontSize: 18, color: Colors.redAccent),), 
            onPressed: (){
              Navigator.pop(context);
              exit(0);
            },)
          ],
        );
      }
    );
  }

  Drawer drawer(context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/usericon.png', width: 80, height: 80,),
                  Text(
                    'Mr.Natthapol  Nonthasri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Developer',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent
            ),
          ),
          ListTile(
            leading: Icon(Icons.outbond),
            title: Text('Scan Out', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectPage = 0;
              });
            },
            selected: true,
          ),
          ListTile(
            leading: Icon(Icons.local_parking),
            title: Text('Parking Scan', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectPage = 1;
              });
            },
            selected: true,
          ),
          Divider(
            color: Colors.black45,
            indent: 16,
          ),
          ListTile(
            title: Text(
              'About Me',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}