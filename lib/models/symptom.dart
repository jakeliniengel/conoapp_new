class Symptom {
  final String name;
  final int weight;

  Symptom({this.name, this.weight});

  factory Symptom.fromJson(Map<String, dynamic>json){
    return new Symptom(
    name : json["name"] as String,
    weight : json["weight"] as int
    );
  }

}