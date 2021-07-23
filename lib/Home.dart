import 'package:app_divide_lista/CadastroItem.dart';
import 'package:app_divide_lista/CadastroPessoa.dart';
import 'package:app_divide_lista/DivisaoItens.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[800],
        title: Text("Divide Lista"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: "Pessoas",
            ),
            Tab(
              text: "Itens",
            ),
            Tab(
              text: "Dividir Lista",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CadastroPessoa(),
          CadastroItem(),
          DivisaoItens(),
        ],
      ),
    );
  }
}
