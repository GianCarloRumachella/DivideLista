import 'package:app_divide_lista/helper/DBHelper.dart';
import 'package:app_divide_lista/model/pessoa.dart';
import 'package:flutter/material.dart';

class CadastroPessoa extends StatefulWidget {
  @override
  _CadastroPessoaState createState() => _CadastroPessoaState();
}

class _CadastroPessoaState extends State<CadastroPessoa> {
  TextEditingController _nomeController = TextEditingController();

  var _db = DBHelper();

  List<DataRow> _rowList = [];

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
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
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
    String itens = "";

    if (pessoaSelecionada == null) {
      Pessoa pessoa = Pessoa(nome: nome, itens: itens);
      int resultado = await _db.salvarPessoa(pessoa);
      print("resultado salvo:" + resultado.toString());
    } else {
      pessoaSelecionada.nome = nome;
      pessoaSelecionada.itens = itens;
      int resultado = await _db.atualizarPessoas(pessoaSelecionada);
      print("resultado atulizado:" + resultado.toString());
    }

    _nomeController.clear();

    _recuperarPessoas();
  }

  _recuperarPessoas() async {
    List pessoasRecuperadas = await _db.recuperarPessoas();
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
            DataCell(Text(pessoa.itens)),
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
//teste
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
            'Itens',
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
        RaisedButton(
          onPressed: () {
            _exibirCadastro();
          },
          child: Text("Adicionar Pessoa"),
        ),
        RaisedButton(
          onPressed: () {
            print("Dividindo a lista");
          },
          child: Text("Dividir Lista"),
        ),
      ],
      body: SingleChildScrollView(
        child: _dataTable(),
      ),
    );
  }
}
