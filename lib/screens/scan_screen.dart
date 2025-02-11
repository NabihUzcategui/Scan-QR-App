import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:zippin_scan/bloc/bloc.dart';
import 'package:zippin_scan/core/Strings/custom_strings.dart';
import 'package:zippin_scan/data/package_model.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _dialogVisible = false; // Para evitar mostrar múltiples diálogos

  @override
  void reassemble() {
    super.reassemble();
    // Reanudar la cámara al re-ensamblar la pantalla (ej. hot reload o reanudación)
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  // Se invoca cuando el QRView está listo
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Pausamos la cámara para evitar lecturas múltiples
      controller.pauseCamera();
      // Lanzamos el evento al bloc
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
        title: const Text('Escanear Código'),
      ),
      // Usamos BlocListener para reaccionar una sola vez a los cambios
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) {
          // Si el estado está cargado y hay al menos un paquete escaneado
          if (state is ScanLoaded && state.scannedPackages.isNotEmpty) {
            // Obtenemos el último paquete agregado
            final PackageModel lastScanned = state.scannedPackages.last;

            // Evitamos mostrar múltiples diálogos si el BLoC emite varios estados
            if (!_dialogVisible) {
              _dialogVisible = true;

              showDialog(
                context: context,
                barrierDismissible: false, // usuario debe usar los botones
                builder: (_) => AlertDialog(
                  title: Text(CustomStrings.scannedPackage),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${lastScanned.id}'),
                      const SizedBox(height: 8),
                      Text('Remitente: ${lastScanned.remitente}'),
                      const SizedBox(height: 8),
                      Text('Destinatario: ${lastScanned.destinatario}'),
                      const SizedBox(height: 8),
                      Text('Estado: ${lastScanned.estado}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                        Navigator.of(context)
                            .pop(); // Regresa a la pantalla anterior
                      },
                      child: Text(CustomStrings.close),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                        _dialogVisible = false; // Habilita volver a mostrarlo
                        controller?.resumeCamera(); // Continua con el escaneo
                      },
                      child: Text(CustomStrings.keepScanning),
                    ),
                  ],
                ),
              ).then((_) {
                // Cuando se cierra el diálogo, liberamos el flag
                _dialogVisible = false;
              });
            }
          }

          // Si hay un error (por ejemplo, no se encontró el paquete)
          if (state is ScanError) {
            if (!_dialogVisible) {
              _dialogVisible = true;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // cierra el diálogo
                        Navigator.pop(
                            context); // regresa a la pantalla anterior
                      },
                      child: const Text('Cerrar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // cierra el diálogo de error
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
