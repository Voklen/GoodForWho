import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:flutter/material.dart';

import 'result.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _torchIconState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'GoodForWho',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _torchIconState,
            builder: (context, state, _) => IconButton(
              icon: state
                  ? const Icon(Icons.flash_on)
                  : const Icon(Icons.flash_off),
              onPressed: () async {
                await CameraController.instance.toggleTorch();
                _torchIconState.value =
                    CameraController.instance.state.torchState;
              },
            ),
          ),
        ],
      ),
      body: BarcodeCamera(
        types: const [
          BarcodeType.ean8,
          BarcodeType.ean13,
          BarcodeType.code128,
        ],
        resolution: Resolution.hd720,
        framerate: Framerate.fps30,
        mode: DetectionMode.pauseVideo,
        position: CameraPosition.back,
        onScan: (code) => Navigator.of(context).push(_createRoute(code)),
        children: const [MaterialPreviewOverlay(animateDetection: false)],
      ),
    );
  }
}

Route _createRoute(Barcode code) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        MyHomePage(title: code.value),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      CameraController.instance.resumeDetector();
      return child;
    },
  );
}
