import 'package:flutter/material.dart';
import '../model/documento.dart';
import '../util/documento_repository.dart';

class TelaDetalheDocumento extends StatefulWidget {
  final Documento documento;

  const TelaDetalheDocumento(this.documento, {Key? key}) : super(key: key);

  @override
  State createState() => TelaDetalheDocumentoState();
}

class TelaDetalheDocumentoState extends State<TelaDetalheDocumento> {
  final DocumentoRepository repository = DocumentoRepository();
  final TextStyle estiloRotulo = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final TextStyle estiloValor = const TextStyle(fontSize: 16.0);

  void _confirmaExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Deseja realmente excluir este documento do GED?"),
          actions: [
            ElevatedButton(
              child: const Text("NÃO"),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            ElevatedButton(
              child: const Text("SIM"),
              onPressed: () {
                Navigator.pop(ctx);
                if (widget.documento.id != null) {
                  repository.deleteDocumento(widget.documento.id!).catchError((e) {
                    debugPrint("Erro ao excluir no Firestore: $e");
                  });
                }
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  String getTextoPrioridade(int prioridade) {
    switch (prioridade) {
      case 1:
        return "1 - ALTA";
      case 2:
        return "2 - MÉDIA";
      case 3:
        return "3 - BAIXA";
      default:
        return prioridade.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Documento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("PROTOCOLO:", style: estiloRotulo),
            Text(widget.documento.numero, style: estiloValor),
            const SizedBox(height: 12),
            Text("ASSUNTO / TÍTULO:", style: estiloRotulo),
            Text(widget.documento.titulo, style: estiloValor),
            const SizedBox(height: 12),
            Text("DESCRIÇÃO:", style: estiloRotulo),
            Text(widget.documento.descricao ?? "Sem descrição", style: estiloValor),
            const SizedBox(height: 12),
            Text("PRIORIDADE:", style: estiloRotulo),
            Text(getTextoPrioridade(widget.documento.prioridade), style: estiloValor),
            const SizedBox(height: 12),
            Text("DATA DE CADASTRO:", style: estiloRotulo),
            Text(widget.documento.data, style: estiloValor),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("EXCLUIR DOCUMENTO", style: TextStyle(color: Colors.white)),
              onPressed: () {
                _confirmaExclusao(context);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text("VOLTAR"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
