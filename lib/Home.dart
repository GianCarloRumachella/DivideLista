import 'package:app_divide_lista/CadastroItem.dart';
import 'package:app_divide_lista/CadastroPessoa.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text("Divide Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              //color: Colors.blueGrey[400],
              child: Text("Cadastrar Itens"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroItem(),
                  ),
                );
              },
            ),
            ElevatedButton(
              //color: Colors.blueGrey[400],
              child: Text("Cadastrar Pessoas"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroPessoa(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
