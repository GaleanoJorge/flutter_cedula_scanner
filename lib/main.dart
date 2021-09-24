import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      procesar(_scanBarcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    // procesar(
    //     '0351921253����������������������������PubDSK_1����������������124314731032488086VARGAS����������������������������������PINTO������������������������������������PAULA������������������������������������ANDREA����������������������������������0F19961215150010B+��2C��Ç[ÿm|¢osv¨b²UI:=ÑÓ[¶QÈÒ¥Óh¨WÄfÌ[o¯J²qÎ®ªjµ;¹T Jª,±~i1x¨;H£X%P5¢K|[z;{~·Ò7;ÃÍYwÅÄ`·¿v«¼Gd)~T^KLÓê)"D1(}½7zÌ´åÿ��7C��³Vÿ|Uk{q{d¤ko¡YZÌuJz®r[°QÍYÄPKCeB4Z`CXHo@�?s/vuvl|brn¦|£¼o®c');
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: ListView(
                      // direction: Axis.vertical,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }

  List<String> letras = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'Ñ',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  void procesar(String scanBarcode) {
    print('prueba toma de foto: ' + scanBarcode);
    bool isLetra = true;
    bool lastIsLetra = false;
    int spaces = 0;
    String subCedula = '';
    String Result = '';
    for (int i = 50; i < scanBarcode.length; i++) {
      for (String letra in letras) {
        isLetra = true;
        if (scanBarcode.substring(i, i + 1) == letra) {
          isLetra = true;
          break;
        } else {
          isLetra = false;
        }
      }

      for (String letra in letras) {
        lastIsLetra = false;
        if (scanBarcode.substring(i - 1, i) == letra) {
          lastIsLetra = true;
          break;
        } else {
          lastIsLetra = false;
        }
      }

      if (isLetra && spaces < 4) {
        if (Result == '') {
          subCedula = scanBarcode.substring(i - 10, i);
        }
        Result += scanBarcode.substring(i, i + 1);
      } else if (!isLetra && lastIsLetra && spaces < 4) {
        Result += ' ';
        spaces++;
      }

      if (subCedula != '') {
        while (subCedula.startsWith('0')) {
          subCedula = subCedula.substring(1);
        }
      }

      if ((scanBarcode.substring(i, i + 2) == '0M' ||
              scanBarcode.substring(i, i + 2) == '0F') &&
          spaces == 4) {
        Result += scanBarcode.substring(i + 2, i + 6) +
            ' ' +
            scanBarcode.substring(i + 6, i + 8) +
            ' ' +
            scanBarcode.substring(i + 8, i + 10) +
            ' RH:' +
            scanBarcode.substring(i + 16, i + 18) +
            ' ' +
            scanBarcode.substring(i + 1, i + 2);
        break;
      }
    }
    print(Result + " " + subCedula);
    setState(() {
      _scanBarcode = Result + " " + subCedula;
    });
  }
}
