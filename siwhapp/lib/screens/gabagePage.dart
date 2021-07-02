import 'dart:convert';
import 'dart:io';
import 'package:siwhapp/config.dart' as config;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:http/http.dart' as http;

class GabagePage extends StatefulWidget {
  @override
  _GabagePageState createState() => _GabagePageState();
}

class _GabagePageState extends State<GabagePage> {
  var lineSelectButton = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Color(0xFF6c779f),
            ),
            child: FittedBox(
                fit: BoxFit.fill,
                child: Stack(
                  children: [
                    Image.asset('images/barcodeicon.png'),
                    Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                        //   LiteRollingSwitch(
                        //     value: true,
                        //     textOn: 'Auto',
                        //     textOff: 'Manual',
                        //     colorOn: Colors.greenAccent[700],
                        //     colorOff: Colors.redAccent[700],
                        //     iconOn: Icons.wb_auto,
                        //     iconOff: Icons.fiber_manual_record,
                        //     textSize: 20,
                        //     onChanged: (bool state) {
                        //       print('Current State of SWITCH IS: $state');
                        //     },
                        // ),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'เลือกโปรแกรมปล่อยรถ AGV',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              height: 60,
              child: RaisedButton(
                child: Text("เก็บขยะ SI\nProgram 28",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                onPressed: () {
                  getAGVSI('SI-Gabage',28);
                },
                color: Color(0xFF6c779f),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                splashColor: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Container(
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              height: 60,
              child: RaisedButton(
                child: Text("เก็บขยะ CU\nProgram 29",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                onPressed: () {
                  getAGVSI('CU-Gabage',29);
                },
                color: Color(0xFF00a2b3),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                splashColor: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Container(
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              height: 60,
              child: RaisedButton(
                child: Text("Part Shipment\nProgram 30",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                onPressed: () {
                  getAGVSI('Part-Shipment',30);
                },
                color: Color(0xFF64cab5),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                splashColor: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Container(
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              height: 60,
              child: RaisedButton(
                child: Text("Manual",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                onPressed: () {
                  getSIManual(context);
                },
                color: Color(0xFF54318D),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                splashColor: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        ],
      ),
    );
  }

  Future getAGVSI(selectButtin,task) async {
    var url = config.getAGVSI;
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    if (data['msg'] == 'success') {
      if (selectButtin == 'SI-Gabage') {
        showDialog1('เก็บขยะ SI', data['ipAgv'], task);
      } else if (selectButtin == 'CU-Gabage') {
        showDialog1('เก็บขยะ CU', data['ipAgv'], task);
      } else if (selectButtin == 'Part-Shipment') {
        showDialog1('Part-Shipment', data['ipAgv'], task);
      }  else if (selectButtin == 'Manual') {
        showDialog1('Manual', data['ipAgv'], task);
      }
    } else {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Error',
          desc: data['msg'],
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    }
  }

  Future showDialog1(msg, ipAGV, task) async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        title: 'Checking !',
        desc: msg + '\n' + 'Program: ' + task.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          socketGOGabage(ipAGV, task);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyHomePage(page: 0)),
          // );
        })
      ..show();
  }
  int _number;
  void getSIManual(BuildContext context) async{
    var url = config.getAGVSI_Manual;
    var response = await http.get(url);
    var resBody = jsonDecode(response.body);
    List data = List();
    setState(() {
      data = resBody;
    });
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        return Container(
      
          width: 100,
          height: 100,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 260, horizontal: 125),
            child: Column(
              children: [
                    DropdownButton<int>(
                      hint: Text("Pick"),
                      value: _number,
                      items: data.map((value) {
                        return new DropdownMenuItem<int>(
                        value: value,
                        child: new Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _number = newVal;
                          
                          print(_number);
                          Navigator.of(context).pop();

                          getAGVSI('Manual', _number);

                      });
                  })],
            ),
          ),
        );
      },
    );

  
  }

  void socketGOGabage(ipAGV, task) async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');
    // send
    Map data = {
      "status": "GOGabage",
      "ipAgv": ipAGV,
      "task": task,
      "Home": 'SIWH'
    };
    socket.add(utf8.encode(jsonEncode(data)));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }
}
