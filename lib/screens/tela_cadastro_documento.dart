import 'package:flutter/material.dart';
import '../model/documento.dart';
import '../util/documento_repository.dart';

class TelaCadastroDocumento extends StatefulWidget {
  @override
  State createState() => TelaCadastroDocumentoState();
}

class TelaCadastroDocumentoState extends State<TelaCadastroDocumento> {
  final DocumentoRepository repository = DocumentoRepository();

  TextEditingController tcNumero = TextEditingController();
  TextEditingController tcTitulo = TextEditingController();
  TextEditingController tcDescricao = TextEditingController();
  TextEditingController tcPrioridade = TextEditingController();

  InputDecoration decora(String hint) {
    return InputDecoration(
      hintStyle: const TextStyle(fontSize: 16.0),
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Documento"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: tcNumero,
                  decoration: decora("Nº do Protocolo (ex: 2026/001)"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: tcTitulo,
                  decoration: decora("Título / Assunto"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: tcDescricao,
                  decoration: decora("Descrição / Observações"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: tcPrioridade,
                  keyboardType: TextInputType.number,
                  decoration: decora("Prioridade (1 = Alta, 2 = Média, 3 = Baixa)"),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("SALVAR"),
                      onPressed: () {
                        int prio = int.tryParse(tcPrioridade.text) ?? 3;
                        String dataAtual = DateTime.now().toString().substring(0, 16);

                        Documento novoDoc = Documento(
                          numero: tcNumero.text,
                          titulo: tcTitulo.text,
                          descricao: tcDescricao.text,
                          prioridade: prio,
                          data: dataAtual,
                        );


                        repository.insertDocumento(novoDoc).catchError((e) {
                          debugPrint("Erro ao salvar no Firestore: $e");
                        });

                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("CANCELAR"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
