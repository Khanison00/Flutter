import 'dart:convert';

import 'package:agvscanner/screen/detailspage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:vibration/vibration.dart';

import 'package:agvscanner/config.dart' as config;


class ScanOutPage extends StatefulWidget {
  @override
  _ScanOutPageState createState() => _ScanOutPageState();
}

class Item {
  const Item(this.mode, this.icon);
  final String mode;
  final Icon icon;
}

class _ScanOutPageState extends State<ScanOutPage> {
  String parkingCode = '';
  String getParking = '';
  Map details;

  bool isDeleteButtonDisabled = true;
  bool isScanButtonDisabled = true;
  bool isNextButtonDisabled = true;

  final _controller = TextEditingController();
  int countOld = 0;
  List parkInputOld = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
    ]);

    checkInternet();
    fnGetParking();
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
    List widParking = [
      Text(getParking, style: TextStyle(fontSize: 50, color: Colors.black26)),
      Text(parkingCode, style: TextStyle(fontSize: 70, color: Colors.green)),
    ];

    return Column(
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
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.25, 
                    //       // height: 200,
                    //       width: MediaQuery.of(context).size.width * 0.9,
                    //       ),
                    //     LiteRollingSwitch(
                    //       value: true,
                    //       textOn: 'Auto',
                    //       textOff: 'Manual',
                    //       colorOn: Colors.greenAccent[700],
                    //       colorOff: Colors.redAccent[700],
                    //       iconOn: Icons.wb_auto,
                    //       iconOff: Icons.fiber_manual_record,
                    //       textSize: 20,
                    //       onChanged: (bool state) {
                    //         print('Current State of SWITCH IS: $state');
                    //         if(state == false) {
                    //           setState(() {
                    //             this.getParking = 'Manual Mode';
                    //             this.isScanButtonDisabled = false;
                    //           });
                    //         }
                    //         else {
                    //           fnGetParking();
                    //         }
                    //       },
                    //   ),
                    //   ],
                    // ),
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
                'Parking Code',
                style: TextStyle(
                  fontSize: 25,
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
              height: MediaQuery.of(context).size.height * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  parkingCode == '' ? widParking[0] : widParking[1],
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => fnGetParking(),
                  child: Text('Refresh', style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      onPressed: buttonScan,
                      
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                  ),
                  MaterialButton(
                      onPressed: isNextButtonDisabled ? null : buttonNext,
                      disabledColor: Colors.grey,
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.fast_forward,
                        size: 40,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  void buttonScan() {
    scanBarcodeNormal();
  }

  Future fnGetParking() async {
    String url = config.urlfnGetParking;
    var res = await http.get(url);

    setState(() {
      this.getParking = jsonDecode(res.body)['parkingCode'];

      if(getParking == 'Code Scan') {
        this.isScanButtonDisabled = true;
      }
      else {
        this.isScanButtonDisabled = false;
      }
    });
  }

  void buttonNext() async {
    await postParking();
    if(details['msg'] == 'success') {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(details: details)),
        );
      });
    }
    else{
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Error',
          desc: details['msg'],
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
    }
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
    if(countNew - countOld == 3) {
      setState(() {
        parkInputOld.add(text.substring(countNew - 3, countNew));
      });

      print(parkInputOld[parkInputOld.length - 1]);
      calculateBarcode(parkInputOld[parkInputOld.length - 1]);
    }

    setState(() {
      this.countOld = countNew;
    });
  }

  Future calculateBarcode(barcode) async {
    // ตรวจสอบความยาวของ barcode 
    if(barcode == '-1' || barcode.length < 3 ||  barcode.length > 3) {
      return;
    }

    // ตรวจสอบว่าตรงไหม
    // if(getParking != barcode) {
    //   AwesomeDialog(
    //       context: context,
    //       dialogType: DialogType.ERROR,
    //       animType: AnimType.RIGHSLIDE,
    //       headerAnimationLoop: false,
    //       title: 'Error',
    //       desc: 'บาร์โค้ดไม่ตรงกัน โปรดสแกนใหม่',
    //       btnOkOnPress: () {},
    //       btnOkIcon: Icons.cancel,
    //       btnOkColor: Colors.red)
    //       ..show();
    //       // สั่นเพื่อแจ้งเตือนว่าสแกนแล้ว
    //       Vibration.vibrate(duration: 300);
    //   return;
    // }

    // สั่นเพื่อแจ้งเตือนว่าสแกนแล้ว
    Vibration.vibrate(duration: 300);

    setState(() {
      this.isNextButtonDisabled = false;
      this.isScanButtonDisabled = true;
      this.parkingCode = barcode;
    });
  }

  Future postParking() async {
    var url = config.urlfnPostParking;
    var response = await http.post(url, body: jsonEncode({"parkingCode": parkingCode}));
    var data = jsonDecode(response.body);

    if(data['msg'] == 'success') {
      setState(() {
        details = jsonDecode(response.body);
        print(details);
      });
    }
    else{
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
        desc: 'Please check the internet network.\nPlease connect to STTB_AGV',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }
  }
}