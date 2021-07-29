import 'package:permission_handler/permission_handler.dart';
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
    _pedirPermissao();
  }

  Future<void> _pedirPermissao() async {
    PermissionStatus permissionStatus = await _getPermisaoContatos();
    if (permissionStatus == PermissionStatus.granted) {
      final snackBar = SnackBar(
        content: Text("Permissão Concedia"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _gerenciarPermissaoInvalida(permissionStatus);
    }
  }

  Future<PermissionStatus> _getPermisaoContatos() async {
    PermissionStatus permissao = await Permission.contacts.status;
    if (permissao != PermissionStatus.granted &&
        permissao != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permissao;
    }
  }

  void _gerenciarPermissaoInvalida(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(
        content: Text("Acesso aos contatos negado"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(
        content: Text("Contatos não disponiveis no dispositivo"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[800],
        title: Text("Divide Lista"),
        bottom: TabBar(
          indicatorWeight: 8,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Colors.green,
          tabs: [
            Tab(
              text: "Pessoas",
              icon: Icon(Icons.person_sharp),
            ),
            Tab(
              text: "Itens",
              icon: Icon(Icons.emoji_objects),
            ),
            Tab(
              text: "Dividir Lista",
              icon: Icon(Icons.list_alt),
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
