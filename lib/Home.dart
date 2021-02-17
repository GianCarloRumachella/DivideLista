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
      appBar: AppBar(
        title: Text("Divide Lista"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("Menu Inicial"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text("Cadastrar Itens"),
              onTap: () {
                print("abrir cadastro de itens");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroItem()),
                );
              },
            ),
            ListTile(
              title: Text("Cadastrar Pessoas"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroPessoa()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
