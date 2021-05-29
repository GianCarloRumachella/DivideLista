import 'package:app_divide_lista/helper/DBHelper.dart';
import 'package:app_divide_lista/model/item.dart';
import 'package:app_divide_lista/model/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:app_divide_lista/model/PessoaItem.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';


class DivisaoItens extends StatefulWidget {
  @override
  _DivisaoItensState createState() => _DivisaoItensState();
}

class _DivisaoItensState extends State<DivisaoItens> {
  var _db = DBHelper();

  List<DataRow> _rowList = [];
  List<String> _itensList = [];
  final Map<String, String> itensMap = {};

  List<Map<String, dynamic>> pessoaItemTemporaria = [];

  List<String> itens = [];

  String base64Image = 'assets/icon-whats.png';

  _salvarAtualizarPessoaItem(String nome, String itens) async {
    PessoaItem pessoa = PessoaItem(nome: nome, itens: itens);
    int resultado = await _db.salvarPessoaItens(pessoa);
    print("resultado salvo:" + resultado.toString());

    /* if (pessoaSelecionada == null) {
      PessoaItem pessoa = PessoaItem(nome: nome, itens: itens.join());
      int resultado = await _db.salvarPessoaItens(pessoa);
      print("resultado salvo:" + resultado.toString());
    } else {
      pessoaSelecionada.nome = nome;
      pessoaSelecionada.itens = pessoaSelecionada.itens;
      int resultado = await _db.atualizarPessoasItens(pessoaSelecionada);
      print("resultado atulizado:" + resultado.toString());
    } */

    _recuperarPessoasItens();
  }

  _recuperarPessoasItens() async {
    List pessoasItensRecuperadas = await _db.recuperarPessoasItens();
    List<PessoaItem> listaTemporaria = [];

    for (var pessoa in pessoasItensRecuperadas) {
      PessoaItem pessoas = PessoaItem.fromMap(pessoa);
      listaTemporaria.add(pessoas);
    }

    _rowList.clear();

    for (var pessoa in listaTemporaria) {
      _rowList.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(pessoa.nome),
            ),
            DataCell(
              Text(pessoa.itens),
            ),
            DataCell(
              Icon(Icons.share),
              onTap: () {
                FlutterOpenWhatsapp.sendSingleMessage("+5511941139885",
                    "Olá essa mensagem é apenas um teste, lista compartilhada ${pessoa.nome}: ${pessoa.itens}");
              },
            ),
          ],
        ),
      );
    }

    setState(() {});

    listaTemporaria = null;

    print("Itens anotados: " + pessoasItensRecuperadas.toString());
  }

  _removerPessoas(int id) async {
    await _db.removerPessoas(id);

    _recuperarPessoasItens();
  }

  _dividirLista() async {
    List itensRecuperados = await _db.recuperarItens();
    List pessoasRecuperadas = await _db.recuperarPessoas();
    List<Pessoa> pessoaTemp = [];

    int index = 0;

    for (var pessoa in pessoasRecuperadas) {
      Pessoa pessoas = Pessoa.fromMap(pessoa);
      pessoaTemp.add(pessoas);
    }

    _itensList.clear();

    for (var item in itensRecuperados) {
      Item itemTemp = Item.fromMap(item);
      if (int.parse(itemTemp.quantidade) != 0) {
        for (int i = 0; i < int.parse(itemTemp.quantidade); i++) {
          _itensList.add(itemTemp.nome);
        }
      }
    }

    pessoaItemTemporaria.clear();

    //print(_itensList.length);
//CRIAR MAP PARA JUNTAR O NOME E OS ITENS DAQUELA PESSOA -> "NOME", "ITENS" ok
//APOS FINALIZAÇÃO DO FOR ADICIONAR TUDO NO MAP
//SALVAR NA TABELA PESSOAITEM
//MOSTRAR NA TELA
//FAZER REFACTOR NO FINAL PARA ACERTAR TUDO REDONDO
    for (int i = 0; i < pessoaTemp.length; i++) {
      pessoaItemTemporaria.add({'nome': pessoaTemp[i].nome, "itens": ""});
    }

    for (int i = 0; i < _itensList.length; i++) {
      String aux;
      aux = pessoaItemTemporaria[index]["itens"] + " ";
      pessoaItemTemporaria[index]
          .update("itens", (value) => aux + _itensList[i]);
      if (index < pessoaItemTemporaria.length) {
        index = (index + 1) % pessoaItemTemporaria.length;
        //print("index: " + index.toString());
      }
    }

    _apagarLista();

    print(pessoaItemTemporaria);
    //salvando no banco de dados
    for (int i = 0; i < pessoaItemTemporaria.length; i++) {
      Pessoa pessoaTemp = Pessoa.fromMap(pessoaItemTemporaria[i]);
      _salvarAtualizarPessoaItem(pessoaTemp.nome, pessoaTemp.itens);
    }
  }

  _apagarLista() async {
    await _db.removerPessoaItens();
    _recuperarPessoasItens();
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
            'Share',
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
    _recuperarPessoasItens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Divisão de Itens"),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            // print("Dividindo a lista");
            _dividirLista();
          },
          child: Text("Dividir Lista"),
        ),
        ElevatedButton(
          onPressed: () async {
            // print("Dividindo a lista");
            _apagarLista();
          },
          child: Text("Apagar Lista"),
        )
      ],
      body: _dataTable(),
    );
  }
}
