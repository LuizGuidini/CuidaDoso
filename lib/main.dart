import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Firestore
import 'default_connector.dart';  // Certifique-se de que DefaultConnector está correto

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  DefaultConnector connector = await DefaultConnector.initialize(); // Inicializa o DefaultConnector
  runApp(MyApp(connector: connector));  // Passa o connector para o app
}

class MyApp extends StatelessWidget {
  final DefaultConnector connector;

  const MyApp({super.key, required this.connector});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaDoso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(connector: connector),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DefaultConnector connector;
  const MyHomePage({super.key, required this.connector});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CuidaDoso App'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: widget.connector.getDocument('users', 'someUserId'), // Modifique conforme seu Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Nenhum dado encontrado');
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Você tem pressionado o botão esta quantidade de vezes:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Nome: ${data['name']}, Idade: ${data['age']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
