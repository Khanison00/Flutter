import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

import 'package:agvscanner/config.dart' as config;


class ParkingPage extends StatefulWidget {
  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  List shoppingList = [];
  String parkingCode = "-----";

  bool isDeleteButtonDisabled = true;
  bool isScanButtonDisabled = false;
  bool isNextButtonDisabled = true;

  final _controller = TextEditingController();
  int countOld = 0;
  List shopInputOld = [];
  List parkInputOld = [];

  @override
  void initState(){
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
    return Container(
          child: Column(
        children: [
          Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: FittedBox(child: Image.asset('images/parkingicon.png'), fit: BoxFit.fill),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Text(
                  'Shopping List',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: TextField(
                  controller: _controller,
                  onChanged: (content) {
                    getTextInput();
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
                height: MediaQuery.of(context).size.height * 0.2,
                child: box_shoppingList(),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                  'Parking: ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  parkingCode,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  ],
                )
              ),
              Container(
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
                    MaterialButton(
                        onPressed: isNextButtonDisabled ? null : buttonNext,
                        disabledColor: Colors.grey,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.done,
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
    );
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
    // Shopping List Len 16
    else if (countNew - countOld == 16) {
      setState(() {
        shopInputOld.add(text.substring(countNew - 16, countNew));
      });
      calculateBarcode(shopInputOld[shopInputOld.length - 1]);
    }
    // Shopping List Len 17
    else if (countNew - countOld == 17) {
      setState(() {
        shopInputOld.add(text.substring(countNew - 17, countNew));
      });
      calculateBarcode(shopInputOld[shopInputOld.length - 1]);
    }
    // Shopping List Len 18
    else if (countNew - countOld == 18) {
      setState(() {
        shopInputOld.add(text.substring(countNew - 18, countNew));
      });
      calculateBarcode(shopInputOld[shopInputOld.length - 1]);
    }

    setState(() {
      this.countOld = countNew;
    });
  }

  void buttonDelete() {
    setState(() {
      this.shoppingList.clear();
      this.parkingCode = '-----';
      this.isDeleteButtonDisabled = true;
      this.isNextButtonDisabled = true;
      this. isScanButtonDisabled = false;
    });
  }

  void buttonScan() {
    scanBarcodeNormal();
  }

  void buttonNext() {
    setState(() {
      postShoppingListParking();
      this.isScanButtonDisabled = false;
    });
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

    calculateBarcode(barcode);
  }

  Future calculateBarcode(barcode) async {
    if(barcode.length == 3 && shoppingList.length > 0) {
      setState(() {
        parkingCode = barcode;
        this.isNextButtonDisabled = false;
        Vibration.vibrate(duration: 300);
        this.isScanButtonDisabled = true;
      });
    }

    if (!mounted) return;
    // ตรวจสอบความยาวของ barcode
    if(barcode == '-1' || barcode.length < 14) {
      return;
    }

    // ตรวจสอบว่าสแกนหรือยัง
    for(int i=0; i<shoppingList.length; i++) {
      if(barcode == shoppingList[i]) { 
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Error',
          desc: 'This barcode scanned.',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
          // สั่นเพื่อแจ้งเตือนว่าสแกนแล้ว
          Vibration.vibrate(duration: 300);
        return; 
      }
    }
    // สั่นเพื่อแจ้งเตือนว่ายังไม่ได้สแกน
    Vibration.vibrate(duration: 300);
    // เพิ่มข้อมูลเข้าไปใน list

    // check length shoppingList
    if(shoppingList.length == 4) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Error',
          desc: 'จำนวนของ Shopping List จำกัดที่ 4 รายการ.',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          ..show();
      return;
    }

    setState(() {
      this.isDeleteButtonDisabled = false;
      // this.isNextButtonDisabled = true;
      shoppingList.add(barcode);
    });
  }

  Future postShoppingListParking() async {
    String url = config.urlPostShoppingListParking;
    Map json = {"shoppingList": shoppingList, "parkingCode": parkingCode};
    var response = await http.post(url, body: jsonEncode(json));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // print(jsonDecode(response.body)['msg']);
    var msg = jsonDecode(response.body)['msg'];

    if(msg == 0) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'Succes',
        desc:
        'บันทึกข้อมูลเรียบร้อยแล้ว',
        btnOkOnPress: () {
          // debugPrint('OnClcik');
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          // debugPrint('Dialog Dissmiss from callback');
      })
      ..show();
    }
    else{
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        title: 'Error',
        desc: msg,
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }

    setState(() {
      // this.details = jsonDecode(response.body);
      this.shoppingList.clear();
      this.parkingCode = '-----';
      this.isDeleteButtonDisabled = true;
      this.isNextButtonDisabled = true;
    });
  }

  Widget box_shoppingList() {
    return Column(
        children: [
          ListView.builder(
                  shrinkWrap: true,
                  itemCount: shoppingList.length,
                  itemBuilder: (context, index) {
                    return Center(child: Text((index+1).toString() + '. ' + shoppingList[index], 
                                      style: TextStyle(fontSize: 16, color: Colors.black),));
                  },
                )
        ],
    );
  }

  Future checkInternet() async {
    // ตรวจสอบ internet
    String url = config.urlCheckInterNet;
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
        desc: 'Please check the internet network.\nPlease connect to SMART Iot',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
        ..show();
    }
  }
}