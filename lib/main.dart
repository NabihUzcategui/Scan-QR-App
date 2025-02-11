import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zippin_scan/bloc/scan_bloc.dart';
import 'package:zippin_scan/bloc/scan_event.dart';
import 'package:zippin_scan/data/package_repository.dart';
import 'package:zippin_scan/screens/screens.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = PackageRepository();

    return BlocProvider(
      create: (BuildContext context) => ScanBloc(repository)..add(LoadPackages()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zippin Scan',
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScanScreen(),
          '/scan': (context) => const ScanScreen(),
          '/scannedPackages': (context) => const ScannedPackagesScreen(),
        },
      ),
    );
  }
}