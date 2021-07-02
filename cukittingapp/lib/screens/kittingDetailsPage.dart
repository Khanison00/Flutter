import 'dart:convert';
import 'dart:io';

import 'package:cukittingapp/screens/kittingScanoutPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cukittingapp/config.dart' as config;


class DetailsPage extends StatefulWidget {
  final Map details;
  final String reMark;
  DetailsPage({Key key, @required this.details, @required this.reMark}) : super(key: key);

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

    // socketReady();
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
                                DataCell(Text(widget.details['project'], style: TextStyle(fontSize: fontSize))),
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
                                DataCell(Text('Quality', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['quantity'].toString(), style: TextStyle(fontSize: fontSize))),
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
                                DataCell(Text('Variant', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['variant'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('reMark', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.reMark == null ? 'reMark' : widget.reMark, style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Outplan', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['outplan'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Shift', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['shift'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Product number', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['productnumber'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('TASK', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['task'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      Container(
                  margin: EdgeInsets.all(10),
                  height: 65.0,
                  width: 65.0,
                  child: SizedBox.fromSize(
                    size: Size(65, 65), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Color.fromRGBO(0, 205, 0, 1), // button color
                        child: InkWell(
                          splashColor: Color.fromRGBO(248, 177, 1, 1),
                          // splash color
                          onTap: () {
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
                                    socketGO();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ScanOutPage()),
                                    );
                                  })
                                ..show();
                            print('AAA');
                            
                          },

                          // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.white,
                              ), // icon

                              Text(
                                "GO",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ), // text
                            ],
                          ),
                        ),
                      ),
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
    Navigator.pop(context);
    return Future<bool>.value(false);;
  }

  // void moveButton() async {
  //   print("Move");
  //   socketReady();

  //   setState(() {
  //     this.disMoveButton = true;
  //   });
  // }

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

    // void socketReady() async {
    // Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    // print('connected');

    // // socket.listen((List<int> event) {
    // //   print(utf8.decode(event));
    // // });

    // // send
    // Map data = {
    //   "status": "MOVE",
    //   "ipAgv": widget.details['ipAgv'],
    //   "task": widget.details['task'],
    //   "Home": widget.details['Home']
    // };
    // socket.add(utf8.encode( jsonEncode(data) ));

    // // wait 5 seconds
    // await Future.delayed(Duration(seconds: 3));

    // socket.close();
  // }

  void socketGO() async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');
    print(socket);

    // socket.listen((List<int> event) {
    //   print(utf8.decode(event));
    // });

    // send
    Map data = {
      "status": "GO",
      "ipAgv": widget.details['ipAgv'],
      // "Time": widget.details['Time'],
      "task": widget.details['task'],
      "Home": widget.details['Home']
  };
    print(data);
    print('PASS');
    print('PASS');
    print(jsonEncode(data));
    print('PASS');
    print('PASS');
    print(utf8.encode( jsonEncode(data) ));
    socket.add(utf8.encode( jsonEncode(data) ));
    print('PASS');
    print('PASS');
    

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }

  // void socketGONow() async {
  //   Socket socket = await Socket.connect(config.socketIP, config.socketPort);
  //   print('connected');

  //   // socket.listen((List<int> event) {
  //   //   print(utf8.decode(event));
  //   // });

  //   // send
  //   Map data = {
  //     "status": "GONOW",
  //     "ipAgv": widget.details['ipAgv'],
  //     // "Time": widget.details['Time'],
  //     "task": widget.details['task'],
  //     "Home": widget.details['Home']
  //   };
  //   socket.add(utf8.encode( jsonEncode(data) ));

  //   // wait 5 seconds
  //   await Future.delayed(Duration(seconds: 3));

  //   socket.close();
  // }
}