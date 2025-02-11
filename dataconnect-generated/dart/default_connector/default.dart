import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  // Firebase Firestore
  final FirebaseFirestore firestore;

  // Construtor
  DefaultConnector({required this.firestore});

  // Inicializar Firebase
  static Future<DefaultConnector> initialize() async {
    // Inicializando o Firebase
    await Firebase.initializeApp();

    // Obtendo a instância do Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return DefaultConnector(firestore: firestore);
  }

  // Método para acessar um documento no Firestore
  Future<DocumentSnapshot> getDocument(String collection, String documentId) async {
    try {
      // Acessando o documento
      DocumentSnapshot snapshot = await firestore.collection(collection).doc(documentId).get();
      return snapshot;
    } catch (e) {
      throw Exception('Erro ao acessar o documento: $e');
    }
  }

  // Método para adicionar um novo documento no Firestore
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      // Adicionando um documento
      await firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Erro ao adicionar o documento: $e');
    }
  }

  // Método para atualizar um documento no Firestore
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      // Atualizando um documento existente
      await firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar o documento: $e');
    }
  }

  // Método para deletar um documento no Firestore
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      // Deletando um documento
      await firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar o documento: $e');
    }
  }
}
