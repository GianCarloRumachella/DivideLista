class PessoaItem{
  int id;
  String nome;
  String itens;

  PessoaItem({
    this.nome,
    this.itens,
  });

  PessoaItem.fromMap(Map map){
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