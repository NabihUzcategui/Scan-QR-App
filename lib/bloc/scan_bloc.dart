import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zippin_scan/bloc/bloc.dart';
import 'package:zippin_scan/data/package_model.dart';
import 'package:zippin_scan/data/package_repository.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final PackageRepository repository;
  final List<PackageModel> _scannedPackages = [];

  ScanBloc(this.repository) : super(ScanInitial()) {
    on<LoadPackages>(_onLoadPackages);
    on<ScanPackage>(_onScanCode);
  }

  Future<void> _onLoadPackages(
    LoadPackages event,
    Emitter<ScanState> emit,
  ) async {
    emit(ScanLoading());
    try {
      await repository.loadPackagesFromJson();
      // Una vez cargados, mostramos estado con la lista vacía de escaneados
      emit(ScanLoaded(
        allPackages: repository.getAllPackages(),
        scannedPackages: [],
      ));
    } catch (e) {
      emit(ScanError('Error cargando los paquetes: $e'));
    }
  }

  void _onScanCode(
    ScanPackage event,
    Emitter<ScanState> emit,
  ) {
    if (state is ScanLoaded) {
      final currentState = state as ScanLoaded;
      final foundPackage = repository.getPackageById(event.code);

      if (foundPackage != null) {
        // Agregamos el paquete escaneado a la lista en memoria.
        _scannedPackages.add(foundPackage);

        emit(
          ScanLoaded(
            allPackages: currentState.allPackages,
            scannedPackages: List.from(_scannedPackages),
          ),
        );
      } else {
        // Podrías manejar un estado de error o notificar que no existe
        emit(ScanError('No se encontró el paquete con código: ${event.code}'));
        // Luego, podrías retornar al estado anterior si gustas
        emit(currentState);
      }
    }
  }
}
