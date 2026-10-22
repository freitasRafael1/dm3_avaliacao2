import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/documento.dart';

class DocumentoRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('documentos');


  Stream<QuerySnapshot> getDocumentosStream() {
    return _collection.orderBy('prioridade').snapshots();
  }


  Future<void> insertDocumento(Documento doc) async {
    await _collection.add(doc.toMap());
  }


  Future<void> updateDocumento(String docId, Documento doc) async {
    await _collection.doc(docId).update(doc.toMap());
  }


  Future<void> deleteDocumento(String docId) async {
    await _collection.doc(docId).delete();
  }
}
