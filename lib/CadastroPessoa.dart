import 'package:app_divide_lista/helper/DBHelper.dart';
import 'package:app_divide_lista/model/pessoa.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class CadastroPessoa extends StatefulWidget {
  @override
  _CadastroPessoaState createState() => _CadastroPessoaState();
}

class _CadastroPessoaState extends State<CadastroPessoa> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  var _db = DBHelper();

  List<DataRow> _rowList = [];

  final Map<String, String> itensMap = {};

  List<Map<String, dynamic>> pessoaItemTemporaria = [];

  List<String> itens = [];
  Contact _contact;

  Future<void> _pegaContato() async {
    try {
      final Contact contato = await ContactsService.openDeviceContactPicker();
      setState(() {
        _contact = contato;
      });
      _nomeController.text = _contact.displayName;
      _telefoneController.text = _contact.phones.first.value;
      print("${_contact.displayName}: ${_contact.phones.first.value}");
    } catch (e) {
      print(e.toString());
    }
  }

  _exibirCadastro({Pessoa pessoa}) {
    String textoSalvarAtualizar = "";
    if (pessoa == null) {
      _nomeController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _nomeController.text = pessoa.nome;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar Pessoa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: Text("Selecione um contato"),
                  onPressed: _pegaContato,
                ),
                TextField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Nome pessoa",
                    hintText: "Digite o nome da pessoa",
                  ),
                ),
                TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: "Telefone da pessoa",
                    hintText: "Digite o telefone da pessoa",
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  print("Salvando item " + _nomeController.text);
                  _salvarAtualizarItem(pessoaSelecionada: pessoa);

                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _salvarAtualizarItem({Pessoa pessoaSelecionada}) async {
    String nome = _nomeController.text;
    String telefone = _telefoneController.text;

    if (pessoaSelecionada == null) {
      Pessoa pessoa =
          Pessoa(nome: nome, itens: itens.join(), telefone: telefone);
      int resultado = await _db.salvarPessoa(pessoa);
      print("resultado salvo:" + resultado.toString());
    } else {
      pessoaSelecionada.nome = nome;
      pessoaSelecionada.itens = pessoaSelecionada.itens;
      pessoaSelecionada.telefone = telefone;
      int resultado = await _db.atualizarPessoas(pessoaSelecionada);
      print("resultado atulizado:" + resultado.toString());
    }

    _nomeController.clear();
    _telefoneController.clear();

    _recuperarPessoas();
  }

  _recuperarPessoas() async {
    List pessoasRecuperadas = await _db.recuperarPessoas(true);
    List<Pessoa> listaTemporaria = [];

    for (var pessoa in pessoasRecuperadas) {
      Pessoa pessoas = Pessoa.fromMap(pessoa);
      listaTemporaria.add(pessoas);
    }

    _rowList.clear();

    for (var pessoa in listaTemporaria) {
      _rowList.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(pessoa.nome),
              onTap: () {
                _exibirCadastro(pessoa: pessoa);
              },
            ),
            DataCell(
              Text(pessoa.telefone),
            ),
            DataCell(
              Icon(Icons.delete),
              onTap: () {
                _removerPessoas(pessoa.id);
              },
            ),
          ],
        ),
      );
    }

    setState(() {});

    listaTemporaria = null;

    print("Itens anotados: " + pessoasRecuperadas.toString());
  }

  _removerPessoas(int id) async {
    await _db.removerPessoas(id);

    _recuperarPessoas();
  }

  _dataTable() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Pessoa',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Contato',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Apagar',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: _rowList,
    );
  }

  @override
  void initState() {
    super.initState();

    _recuperarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[800],
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))),
          ),
          onPressed: () {
            _exibirCadastro();
          },
          child: Text("+ Pessoa"),
        ),
      ],
      body: SingleChildScrollView(
        child: _dataTable(),
      ),
    );
  }
}
