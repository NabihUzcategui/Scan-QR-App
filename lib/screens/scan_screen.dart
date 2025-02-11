import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:zippin_scan/bloc/bloc.dart';
import 'package:zippin_scan/core/Strings/custom_strings.dart';
import 'package:zippin_scan/core/utils/extensions.dart';
import 'package:zippin_scan/data/package_model.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: CustomStrings.qr);
  QRViewController? controller;
  bool _dialogVisible = false;

  @override
  void reassemble() {
    super.reassemble();

    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Pausamos la cámara y evitar lecturas múltiples
      controller.pauseCamera();

      final code = scanData.code ?? '';
      context.read<ScanBloc>().add(
            ScanPackage(code),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomStrings.scanPackageScreen),
      ),
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanLoaded && state.scannedPackages.isNotEmpty) {
            final PackageModel lastScanned = state.scannedPackages.last;

            if (!_dialogVisible) {
              _dialogVisible = true;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  title: Text(CustomStrings.scannedPackage),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${CustomStrings.scannedPackageId}: ${lastScanned.id}'),
                      10.pv,
                      Text(
                          '${CustomStrings.scannedPackageSender}: ${lastScanned.remitente}'),
                      10.pv,
                      Text(
                          '${CustomStrings.scannedPackageRecipient}: ${lastScanned.destinatario}'),
                      10.pv,
                      Text(
                          '${CustomStrings.scannedPackageState}: ${lastScanned.estado}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(CustomStrings.close),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _dialogVisible = false;
                        controller?.resumeCamera();
                      },
                      child: Text(CustomStrings.keepScanning),
                    ),
                  ],
                ),
              ).then((_) {
                _dialogVisible = false;
              });
            }
          }

          if (state is ScanError) {
            if (!_dialogVisible) {
              _dialogVisible = true;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(CustomStrings.error),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(CustomStrings.close),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _dialogVisible = false;
                        controller?.resumeCamera();
                      },
                      child: Text(CustomStrings.keepScanning),
                    ),
                  ],
                ),
              ).then((_) => _dialogVisible = false);
            }
          }
        },
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller;
    super.dispose();
  }
}
