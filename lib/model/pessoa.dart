class Pessoa {
  int id;
  String nome;
  String itens;
  String telefone;

 
  Pessoa({
    this.nome,
    this.itens,
    this.telefone
  });

  Pessoa.fromMap(Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.itens = map["itens"];
    this.telefone = map["telefone"];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      "nome": this.nome,
      "itens": this.itens,
      "telefone": this.telefone
    };
    if(this.id != null){
      map["id"] = this.id;
    }

    return map;
  }

}
