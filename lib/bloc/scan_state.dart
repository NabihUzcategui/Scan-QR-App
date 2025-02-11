import 'package:equatable/equatable.dart';
import 'package:zippin_scan/data/package_model.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

// Estado inicial
class ScanInitial extends ScanState {}

// Estado de carga

class ScanLoading extends ScanState {}

// Estado de carga exitosa a la lista de paquetes
class ScanLoaded extends ScanState {
  final List<PackageModel> allPackages;
  final List<PackageModel> scannedPackages;

  const ScanLoaded({
    this.allPackages = const [],
    this.scannedPackages = const [],
  });

  @override
  List<Object> get props => [allPackages, scannedPackages];
}

// Estado de carga fallida
class ScanError extends ScanState {
  final String message;

  const ScanError(this.message);

  @override
  List<Object> get props => [message];
}
