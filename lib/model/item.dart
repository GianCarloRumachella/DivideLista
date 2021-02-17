class Item {
  int id;
  String nome;
  String quantidade;

  Item({
    this.nome,
    this.quantidade,
  });

  Item.fromMap(Map map) {
    this.id = map["id"];
    this.nome = map["nome"];
    this.quantidade = map["quantidade"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "quantidade": this.quantidade,
    };
    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}
