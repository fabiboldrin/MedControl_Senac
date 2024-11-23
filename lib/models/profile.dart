class Profile {
  final int? id;
  final String name;
  final String birthdate;
  final String healthHistory;
  final String allergies;

  Profile({
    this.id,
    required this.name,
    required this.birthdate,
    required this.healthHistory,
    required this.allergies,
  });

  // Converte um Map em uma instância de Profile
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as int?,
      name: map['name'] as String,
      birthdate: map['birthdate'] as String,
      healthHistory: map['healthHistory'] as String,
      allergies: map['allergies'] as String,
    );
  }

  // Converte uma instância de Profile em um Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthdate': birthdate,
      'healthHistory': healthHistory,
      'allergies': allergies,
    };
  }
}
