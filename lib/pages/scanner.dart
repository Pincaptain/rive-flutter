import 'dart:async';

import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class ScannerPage extends StatefulWidget {
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController scannerController;
  StreamSubscription scannerSubscription;

  void onQrViewCreated(QRViewController controller) {
    this.scannerController = controller;

    this.scannerSubscription = scannerController.scannedDataStream.listen((scanData) {
      Navigator.pop(context, scanData);

      scannerSubscription.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQrViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderColor: Colors.teal[400],
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scannerController?.dispose();
    scannerSubscription?.cancel();
  }
}