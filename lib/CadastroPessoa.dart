import 'package:app_divide_lista/helper/DBHelper.dart';
import 'package:app_divide_lista/model/pessoa.dart';
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
      appBar: AppBar(
        title: Text("Cadastrar Pessoa"),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            _exibirCadastro();
          },
          child: Text("Adicionar Pessoa"),
        ),
        /*  ElevatedButton(
          onPressed: () async {
            //print("Dividindo a lista  $_itensList.length");
            final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
            print(contact);
          },
          child: Text("Pegar Contato"),
        ), */
      ],
      body: SingleChildScrollView(
        child: _dataTable(),
      ),
    );
  }
}
