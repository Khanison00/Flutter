import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:siwhapp/screens/showDetailPage.dart';
import 'package:vibration/vibration.dart';
import 'package:siwhapp/config.dart' as config;

class SIWHScanoutPage extends StatefulWidget {
  @override
  _SIWHScanoutPageState createState() => _SIWHScanoutPageState();
}

class _SIWHScanoutPageState extends State<SIWHScanoutPage> {
  String kittingID = '';
  String lineSelect = '';
  Map details;

  String wcCD = '';
  String aCTwsCD = '';
  String kitID = '';

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
    return Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: Color(0xFF044704),
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
                        //       if(state == false) {
                        //         setState(() {
                        //           AwesomeDialog(
                        //             context: context,
                        //             dialogType: DialogType.ERROR,
                        //             animType: AnimType.RIGHSLIDE,
                        //             headerAnimationLoop: false,
                        //             title: 'Error',
                        //             desc: 'AAA',
                        //             btnOkOnPress: () {},
                        //             btnOkIcon: Icons.cancel,
                        //             btnOkColor: Colors.red)
                        //             ..show();
                        //         });
                        //       }
                        //       // else {
                        //       //   fnGetParking();
                        //       // }
                        //     },
                        // ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: TextField(
                    controller: _controller,
                    onChanged: (content) {
                      
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
                height: MediaQuery.of(context).size.height * 0.16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(kitID, style: TextStyle(fontSize: 26, color: Colors.black))
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Line WC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // SizedBox(width: 30),
                  Text('Line ACT WS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      minWidth: 120,
                      height: 50,
                      child: RaisedButton(
                        onPressed: isButtonOffDis ? null : () {
                          setState(() {
                            print('WC');
                            this.lineSelect = wcCD;
                            this.isButtonMainDis = false;
                            this.isNextButtonDisabled = false;
                            buttonNext();
                          });
                        },
                        child: Text(wcCD == '' ? "Line WC" : wcCD, style: TextStyle(fontSize: 18, color: Colors.white),),
                        color: Colors.redAccent,
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 120,
                      height: 50,
                      child: RaisedButton(
                        onPressed: isButtonMainDis ? null : () {
                          setState(() {
                            print('ACT');
                            this.lineSelect = aCTwsCD;
                            this.isButtonOffDis = false;
                            this.isNextButtonDisabled = false;
                            buttonNext();
                          });
                        },
                        child: Text(aCTwsCD == '' ? "Line ACT" : aCTwsCD, style: TextStyle(fontSize: 18, color: Colors.white),),
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
                        onPressed: isScanButtonDisabled ? null : buttonScan,
                        disabledColor: Colors.grey,
                        color: Color(0xFF044704),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.local_shipping_rounded,
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

    void buttonDelete() {
    setState(() {
      this.kittingID = '';
      this.lineSelect = '';
      this.wcCD = '';
      this.aCTwsCD = '';
      this.kitID = '';
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
    getLineFromDB(kittingID);
  }

  void buttonNext() async {
    await postKittingID();
  }


  Future getLineFromDB(kittingID) async {
    var url = config.urlGetLine;
    var response = await http.post(url, body: jsonEncode({"kittingID": kittingID}));
    var data = jsonDecode(response.body);

    if(data['msg'] != 'success') {
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
    else{
      setState(() {
        this.wcCD = data['WC_CD'];
        this.aCTwsCD = data['ACT_WS_CD'];
        this.kitID = data['kittingID'];
        this.isButtonMainDis = false;
        this.isButtonOffDis = false;
      });
    }

    print(wcCD);
    print(aCTwsCD);
  }

  Future postKittingID() async {
    var url = config.urlfnPostSIWH;
    var response = await http.post(url, body: jsonEncode({"kittingID": kitID, "lineSelect": lineSelect}));

    setState(() {
      details = jsonDecode(response.body);
    });

    print(details);

    if(details['msg'] != 'success') {
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
    else{
      // go to detaill page
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowDetailPage(details: details)),
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