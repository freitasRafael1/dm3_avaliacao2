class Documento {
  String? id;
  String numero;
  String titulo;
  String? descricao;
  int prioridade;
  String data;

  Documento({
    this.id,
    required this.numero,
    required this.titulo,
    this.descricao,
    required this.prioridade,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      "numero": numero,
      "titulo": titulo,
      "descricao": descricao,
      "prioridade": prioridade,
      "data": data,
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map, String documentId) {
    return Documento(
      id: documentId,
      numero: map["numero"] ?? "",
      titulo: map["titulo"] ?? "",
      descricao: map["descricao"],
      prioridade: map["prioridade"] ?? 3,
      data: map["data"] ?? "",
    );
  }
}
