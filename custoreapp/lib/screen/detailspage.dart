import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'homepage.dart';
import 'package:agvscanner/config.dart' as config;


class DetailsPage extends StatefulWidget {
  final Map details;
  DetailsPage({Key key, @required this.details}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // List listAGV = ['3', '4'];
  String agvNo = '0';
  // String dropdownValue = '3';

  bool disMoveButton = false;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
    ]);

    socketReady();
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

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

    return WillPopScope(
      onWillPop: notBack,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Details', style: TextStyle(fontSize: 22),),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
                  child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  // decoration: BoxDecoration(
                  //   color: Colors.red,
                  // ),
                  child: SingleChildScrollView(
                                      child: Column(
                      children: [
                        DataTable(
                          headingRowHeight: 0,
                          dataRowHeight: 40,
                          dividerThickness: 0.8,
                          columnSpacing: 40,
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                '',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          DataColumn(
                              label: Text(
                                '',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('AGV No.', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(agvNo == '0' ? widget.details['AGVNO'] : agvNo, style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Project', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['Project'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Plan lot', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['planlot'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Variant_Color', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['vcolor'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Part No.', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['part'] == null ? 'None' : widget.details['part'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Quality', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['qty'].toString(), style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Area', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['area'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Line', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['line'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Time', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['Time'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('TASK', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['task'].toString(), style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    height: 60,
                    child: RaisedButton(
                      child: Text("Exit", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(page: 0)));
                      },
                      color: Colors.green.shade500,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      splashColor: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    height: 60,
                    child: RaisedButton(
                      child: Text("GO Now", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      onPressed: () {
                        AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              headerAnimationLoop: false,
                              animType: AnimType.TOPSLIDE,
                              title: 'Checking !',
                              desc:
                                  'Press ok button for confirm.',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                // GO GO GO
                                socketGONow();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyHomePage(page: 1)),
                                );
                              })
                            ..show();
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      splashColor: Colors.grey,
                    ),
                  ),
                ),
                  ],
                )
              ],
            ),
        ),
        ),
    );
  }

  Future<bool> notBack() async {
    print('no back');

    return Future<bool>.value(false);;
  }

  void moveButton() async {
    print("Move");
    socketReady();

    setState(() {
      this.disMoveButton = true;
    });
  }

  // Widget drowdown_edit() {
  //   return DropdownButton(
  //             value: dropdownValue,
  //             icon: Icon(Icons.arrow_downward),
  //             iconSize: 24,
  //             elevation: 1,
  //             style: TextStyle(
  //               color: Colors.deepPurple,
  //             ),
  //             underline: Container(
  //               height: 2,
  //               color: Colors.deepPurple,
  //             ),
  //             onChanged: (String newValue) {
  //               setState(() {
  //                 dropdownValue = newValue;
  //                 this.agvNo = newValue;
  //               });
  //             },
  //             items: listAGV
  //             // widget.details['AGVNO'] ['One', 'Two', 'Free', 'Four']
  //             // items: agvs
  //             .map((value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value, style: TextStyle(fontSize: 22),),
  //       );
  //     }).toList(),
  //   );
  // }

    void socketReady() async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');

    // socket.listen((List<int> event) {
    //   print(utf8.decode(event));
    // });

    // send
    Map data = {
      "status": "MOVE",
      "ipAgv": widget.details['ipAgv'],
      "task": widget.details['task'],
      "Home": widget.details['Home']
    };
    socket.add(utf8.encode( jsonEncode(data) ));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }

  void socketGO() async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');

    // socket.listen((List<int> event) {
    //   print(utf8.decode(event));
    // });

    // send
    Map data = {
      "status": "GO",
      "ipAgv": widget.details['ipAgv'],
      "Time": widget.details['Time'],
      "task": widget.details['task'],
      "Home": widget.details['Home']
  };
    socket.add(utf8.encode( jsonEncode(data) ));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }

  void socketGONow() async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');

    // socket.listen((List<int> event) {
    //   print(utf8.decode(event));
    // });

    // send
    Map data = {
      "status": "GONOW",
      "ipAgv": widget.details['ipAgv'],
      "Time": widget.details['Time'],
      "task": widget.details['task'],
      "Home": widget.details['Home']
  };
    socket.add(utf8.encode( jsonEncode(data) ));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }
}