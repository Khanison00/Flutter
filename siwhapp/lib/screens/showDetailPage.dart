import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:siwhapp/config.dart' as config;
import 'package:siwhapp/homePage.dart';
import 'package:siwhapp/main.dart';
import 'package:siwhapp/screens/siwhScanoutPage.dart';


class ShowDetailPage extends StatefulWidget {
  final Map details;
  ShowDetailPage({Key key, @required this.details}) : super(key: key);

  @override
  _ShowDetailPageState createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
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
          backgroundColor: Color(0xFF6c779f),
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
                                DataCell(Text(widget.details['AGVNO'] == null ? 'null' : widget.details['AGVNO'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Planlot', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['PLAN_LOT'] == null ? '-' : widget.details['PLAN_LOT'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Line', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['line'] == null ? '-' : widget.details['line'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Quality', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['SUPPLY_QTY'].toString() == null ?  '-' : widget.details['SUPPLY_QTY'].toString(), style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('OFF_LINE', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['OFF_LINE'] == null ? '-' : widget.details['OFF_LINE'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('ENTRY_TIME', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['ENTRY_TIME'] == null ? '-' : widget.details['ENTRY_TIME'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('USER_ID', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['USER_ID'] == null ? '-' : widget.details['USER_ID'], style: TextStyle(fontSize: fontSize))),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('task', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold))),
                                DataCell(Text(widget.details['task'] == null ? '-' : widget.details['task'], style: TextStyle(fontSize: fontSize))),
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
                                      MaterialPageRoute(builder: (context) => MyHomePage(page: 0)),
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
    Navigator.pop(context);
    print('no back');
    return Future<bool>.value(false);;
  }

  void socketGO() async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);
    print('connected');
    print(socket);
    // send
    Map data = {
      "status": "GO",
      "ipAgv": widget.details['ipAgv'],
      "task": widget.details['task'],
      "Home": widget.details['Home']
  };

  print(data);
    socket.add(utf8.encode( jsonEncode(data) ));
    print('PASS');
    print('PASS');
    print(jsonEncode(data));
    print('PASS');
    print('PASS');
    print(utf8.encode( jsonEncode(data) ));
    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));

    socket.close();
  }
}