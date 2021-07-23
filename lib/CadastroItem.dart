import 'package:app_divide_lista/model/item.dart';
import 'package:flutter/material.dart';
import 'package:app_divide_lista/helper/DBHelper.dart';

class CadastroItem extends StatefulWidget {
  @override
  _CadastroItemState createState() => _CadastroItemState();
}

class _CadastroItemState extends State<CadastroItem> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _quantidadeController = TextEditingController();

  var _db = DBHelper();

  List<DataRow> _rowList = [];

  _exibirCadastro({Item item}) {
    String textoSalvarAtualizar = "";
    if (item == null) {
      _nomeController.text = "";
      _quantidadeController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _nomeController.text = item.nome;
      _quantidadeController.text = item.quantidade;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar Item"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Nome item",
                    hintText: "Digite o nome do item",
                  ),
                ),
                TextField(
                  controller: _quantidadeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Quantidade do item",
                    hintText: "Digite a quantidade do item",
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
                  _salvarAtualizarItem(itemSelecionado: item);

                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
        });
  }

  _salvarAtualizarItem({Item itemSelecionado}) async {
    String nome = _nomeController.text;
    String quantidade = _quantidadeController.text;

    if (itemSelecionado == null) {
      Item item = Item(nome: nome, quantidade: quantidade);
      int resultado = await _db.salvarItem(item);
      print("resultado salvo:" + resultado.toString());
    } else {
      itemSelecionado.nome = nome;
      itemSelecionado.quantidade = quantidade;
      int resultado = await _db.atualizarItens(itemSelecionado);
      print("resultado atulizado:" + resultado.toString());
    }

    _nomeController.clear();
    _quantidadeController.clear();
    _recuperarItens();
  }

  _recuperarItens() async {
    List itensRecuperados = await _db.recuperarItens();
    List<Item> listaTemporaria = [];

    for (var item in itensRecuperados) {
      Item itens = Item.fromMap(item);
      listaTemporaria.add(itens);
    }

    _rowList.clear();

    for (var item in listaTemporaria) {
      _rowList.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(item.nome)),
            DataCell(
              Text(item.quantidade),
              onTap: () {
                _exibirCadastro(item: item);
              },
            ),
            DataCell(
              Icon(Icons.delete),
              onTap: () {
                _removerItem(item.id);
              },
            ),
          ],
        ),
      );
    }

    setState(() {});

    listaTemporaria = null;

    print("Itens anotados: " + itensRecuperados.toString());
  }

  _removerItem(int id) async {
    await _db.removerItens(id);

    _recuperarItens();
  }

  _dataTable() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Item',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Quantidade',
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

    _recuperarItens();
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
          child: Text("+ Item"),
        ),
      ],
      body: SingleChildScrollView(
        child: _dataTable(),
      ),
    );
  }
}
