import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  static late final FirebaseFirestore _firestore;

  // Inicializa o conector
  static Future<DefaultConnector> initialize() async {
    _firestore = FirebaseFirestore.instance;
    return DefaultConnector();
  }

  // Método para pegar um documento específico
  Future<DocumentSnapshot> getDocument(String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  // Caso precise adicionar outros métodos para manipular dados, adicione aqui.
}
