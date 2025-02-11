class PackageModel {
  final String id;
  final String remitente;
  final String destinatario;
  final String estado;

  PackageModel({
    required this.id,
    required this.remitente,
    required this.destinatario,
    required this.estado,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      remitente: json['remitente'],
      destinatario: json['destinatario'],
      estado: json['estado'],
    );
  }
}
