import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zippin_scan/data/package_model.dart';

class PackageRepository {
  List<PackageModel> _allPackages = [];

  //carga inicial de datos desde el json local
  Future loadPackagesFromJson() async {
    //carga de datos desde el json local
    final String response = await rootBundle.loadString('assets/packages.json');
    final List<dynamic> json = jsonDecode(response);

    _allPackages = json.map((json) => PackageModel.fromJson(json)).toList();
  }

  //obtiene todos los paquetes
  List<PackageModel> getAllPackages() {
    return _allPackages;
  }

  //obtiene un paquete por su id
  PackageModel? getPackageById(String id) {
    try {
      return _allPackages.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }
}
