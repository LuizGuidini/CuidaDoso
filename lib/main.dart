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
  bool _showMotoristas = false;

  // Função para alternar a visualização dos motoristas
  void _toggleMotoristas() {
    setState(() {
      _showMotoristas = !_showMotoristas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CuidaDoso App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botão para alternar entre mostrar motoristas ou não
            ElevatedButton(
              onPressed: _toggleMotoristas,
              child: Text(_showMotoristas ? 'Esconder Motoristas' : 'Mostrar Motoristas'),
            ),
            
            // Exibir motoristas usando StreamBuilder quando o botão for pressionado
            if (_showMotoristas) 
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('motoristas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('Nenhum motorista cadastrado');
                  }

                  var motoristas = snapshot.data!.docs;
                  return Column(
                    children: motoristas.map((motorista) {
                      var data = motorista.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text('Nome: ${data['nome']}'),
                        subtitle: Text('Idade: ${data['idade']}'),
                      );
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
