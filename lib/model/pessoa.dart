class Pessoa {
  int id;
  String nome;
  String itens;

  Pessoa({
    this.nome,
    this.itens,
  });

  Pessoa.fromMap(Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.itens = map["itens"];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      "nome": this.nome,
      "itens": this.itens,
    };
    if(this.id != null){
      map["id"] = this.id;
    }

    return map;
  }

}