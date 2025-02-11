import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(MyApp());  // Inicializa o app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaDoso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),  // Página inicial
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CuidaDoso App'),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          // Aqui, você acessa a coleção 'motoristas' no Firestore
          future: FirebaseFirestore.instance.collection('motoristas').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('Nenhum motorista encontrado');
            }

            // Se houver dados, mostre os motoristas
            var motoristas = snapshot.data!.docs;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Motoristas cadastrados:'),
                ...motoristas.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Documento: ${data['documento']}'),
                      Text('Foto: ${data['foto']}'),
                      Text('Idade: ${data['idade']}'),
                      Text('Nome: ${data['nome']}'),
                      Text('Veículo: ${data['veiculo']}'),
                      const Divider(),  // Linha separadora entre motoristas
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
