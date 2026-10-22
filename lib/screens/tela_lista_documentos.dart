import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/documento.dart';
import '../util/documento_repository.dart';
import 'tela_cadastro_documento.dart';
import 'tela_detalhe_documento.dart';

class TelaListaDocumentos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TelaListaDocumentosState();
}

class TelaListaDocumentosState extends State<TelaListaDocumentos> {
  final DocumentoRepository repository = DocumentoRepository();

  void _navegaCadastro() async {
    var resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TelaCadastroDocumento();
        },
      ),
    );

    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Documento cadastrado com sucesso!"),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navegaDetalhes(Documento doc) async {
    var resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TelaDetalheDocumento(doc);
        },
      ),
    );

    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Documento excluído!"),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GED - Protocolos e Documentos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.getDocumentosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar dados: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("Nenhum documento cadastrado."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int position) {
              var docSnapshot = docs[position];
              var data = docSnapshot.data() as Map<String, dynamic>;
              Documento documento = Documento.fromMap(data, docSnapshot.id);

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getColor(documento.prioridade),
                    child: Text(documento.prioridade.toString()),
                  ),
                  title: Text("${documento.numero} - ${documento.titulo}"),
                  subtitle: Text(
                    "Data: ${documento.data}\n${documento.descricao ?? "Sem descrição"}",
                  ),
                  onTap: () {
                    _navegaDetalhes(documento);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navegaCadastro();
        },
        tooltip: "Novo Documento",
        child: const Icon(Icons.add),
      ),
    );
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.green;
    }
  }
}
