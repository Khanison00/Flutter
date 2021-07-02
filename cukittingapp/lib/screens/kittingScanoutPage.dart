import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:vibration/vibration.dart';
import 'package:cukittingapp/config.dart' as config;

import 'kittingDetailsPage.dart';

class ScanOutPage extends StatefulWidget {
  @override
  _ScanOutPageState createState() => _ScanOutPageState();
}

class _ScanOutPageState extends State<ScanOutPage> {
  String kittingID = '';
  String reMark = '';
  Map details;

  bool isDeleteButtonDisabled = true;
  bool isScanButtonDisabled = false;
  bool isNextButtonDisabled = true;
  bool isButtonMainDis = true;
  bool isButtonOffDis = true;

  final _controller = TextEditingController();
  int countOld = 0;
  List kittingInputOld = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
    ]);

    checkInternet();
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Stack(
                  children: [
                    Image.asset('images/barcodeicon.png'), 
                  ],
                )
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              child: TextField(
                  controller: _controller,
                  onChanged: (content) {
                    if(!isScanButtonDisabled) {
                      getTextInput();
                    }
                  },
                  autofocus: true,
                  readOnly: true,
                  style: TextStyle(color: Colors.white, fontSize: 0.001),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200)
                    )
                  ),
                ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Text(
                'Kitting ID',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(kittingID, style: TextStyle(fontSize: 26, color: Colors.black))
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                      onPressed: isButtonOffDis ? null : () {
                        setState(() {
                          this.reMark = 'Off-Line';
                          this.isButtonMainDis = false;
                          this.isNextButtonDisabled = false;
                          print(1);
                          buttonNext();
                        });
                      },
                      child: Text("Off-Line", style: TextStyle(fontSize: 18, color: Colors.white),),
                      color: Colors.redAccent,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                      onPressed: isButtonMainDis ? null : () {
                        setState(() {
                          this.reMark = 'Main-Line';
                          this.isButtonOffDis = false;
                          this.isNextButtonDisabled = false;
                          print(2);
                          buttonNext();
                        });
                      },
                      child: Text("Main-Line", style: TextStyle(fontSize: 18, color: Colors.white),),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      onPressed: isDeleteButtonDisabled ? null : buttonDelete,
                      disabledColor: Colors.grey,
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.restore,
                        size: 40,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                  MaterialButton(
                      onPressed: isScanButtonDisabled ? null : buttonScan,
                      disabledColor: Colors.grey,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }

    void buttonDelete() {
    setState(() {
      this.kittingID = '';
      this.reMark = '';
      this.isDeleteButtonDisabled = true;
      this.isNextButtonDisabled = true;
      this. isScanButtonDisabled = false;
      this.isButtonMainDis = true;
      this.isButtonOffDis = true;
    });
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

  void buttonScan() {
    scanBarcodeNormal();
  }

  void buttonNext() async {
    await postKittingID();

    // if(details['msg'] == 'success') {
    //   await postParking();
    //   setState(() {
    //     // Navigator.push(
    //     //   context,
    //     //   MaterialPageRoute(builder: (context) => DetailsPage(details: details)),
    //     // );
    //   });
    // }
    // else{
    //   AwesomeDialog(
    //       context: context,
    //       dialogType: DialogType.ERROR,
    //       animType: AnimType.RIGHSLIDE,
    //       headerAnimationLoop: false,
    //       title: 'Error',
    //       desc: details['msg'],
    //       btnOkOnPress: () {},
    //       btnOkIcon: Icons.cancel,
    //       btnOkColor: Colors.red)
    //       ..show();
    // }
  }

  Future<void> scanBarcodeNormal() async {
    String barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      // barcode = 'Failed to get platform version.';
      barcode = '-1';
    }

    if (!mounted) return;

    calculateBarcode(barcode);
  }

  void getTextInput() {
    int countNew = (_controller.text).length;
    String text = _controller.text;

    // Parking ID
    if(countNew - countOld == 19) {
      setState(() {
        kittingInputOld.add(text.substring(countNew - 19, countNew));
      });

      // print(kittingInputOld[kittingInputOld.length - 1]);
      calculateBarcode(kittingInputOld[kittingInputOld.length - 1]);
    }

    setState(() {
      this.countOld = countNew;
    });
  }

  Future calculateBarcode(barcode) async {
    if(barcode == '-1' || barcode.length != 19) {
      return;
    }

    // สั่นเพื่อแจ้งเตือนว่าสแกนแล้ว
    Vibration.vibrate(duration: 300);

    setState(() {
      this.isScanButtonDisabled = true;
      this.isDeleteButtonDisabled = false;
      this.isButtonMainDis = false;
      this.isButtonOffDis = false;
      this.kittingID = barcode;
    });
  }

  Future getIPAGV() async {
    var url = config.urlfnGetIPAGV;
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    if(data['msg'] != 'success') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: 'Error',
        desc: data['msg'],
        btnOkOnPress: () {
          buttonDelete();
          refreshScreen();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }
    else{
      String agv_no = data['AGVNO'];

      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        title: 'ต้องการใช้งาน AGV ใช่ไหม ?',
        desc:   "AGV no. $agv_no   ||   Program 3",
        btnOkOnPress: () {
          // Send Socket to Server AGV
          sendSocketAGVToArea(data['ipAgv']);
          refreshScreen();
        },
        btnCancelOnPress: () {
          refreshScreen();
        }
      )..show();
    }
  }

  void sendSocketAGVToArea(ipAGV) async {
    Socket socket = await Socket.connect(config.socketIP, config.socketPort);

    Map data = {
      "status": "GOTOLINE",
      "ipAgv": ipAGV,
      "task": 3.toString(),
      "Home": 'CU-KITTING'
    };
    socket.add(utf8.encode( jsonEncode(data) ));
    // wait 5 seconds
    await Future.delayed(Duration(seconds: 3));
    socket.close();
  }

  void refreshScreen() {
    Navigator.pop(context);
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanOutPage()),
    );
  }

  Future postKittingID() async {
    var url = config.urlfnPostKitting;
    var response = await http.post(url, body: jsonEncode({"kittingID": kittingID, "reMark": reMark}));

    setState(() {
      details = jsonDecode(response.body);
    });

    if(details['msg'] != 'success') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: 'Error',
        desc: details['msg'],
        btnOkOnPress: () {
          buttonDelete();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }
    else{
      // go to detaill page
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(details: details, reMark: reMark)),
        );
    }
  }

  Future checkInternet() async {
    // ตรวจสอบ internet
    var url = config.urlCheckInterNet;
    try {
      await http.get(url).timeout(Duration(seconds: 2));
    } catch(e) {
      print(e);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: 'Error',
        desc: 'Please check the internet network.\nPlease connect to SMART IoT',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }
  }
}