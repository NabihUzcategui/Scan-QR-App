
import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar los paquetes
class LoadPackages extends ScanEvent {}

// Evento para escanear un paquete
class ScanPackage extends ScanEvent {
  final String code;

  const ScanPackage(this.code);

  @override
  List<Object> get props => [code];
}