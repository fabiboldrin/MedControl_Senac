import 'dart:convert';

class Medication {
  final int? id;
  final int profileId;
  final String name;
  final String dosage;
  final List<String> scheduleTimes;
  final int stock;
  final String colorCode;
  final bool archived;

  Medication({
    this.id,
    required this.profileId,
    required this.name,
    required this.dosage,
    required this.scheduleTimes,
    required this.stock,
    required this.colorCode,
    this.archived = false,
  });

  // Converte um Map em uma instância de Medication
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      profileId: map['profileId'] as int,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      scheduleTimes: List<String>.from(jsonDecode(map['scheduleTimes'])),
      stock: map['stock'],
      colorCode: map['colorCode'],
      archived: map['archived'] == 1,
    );
  }

  // Converte uma instância de Medication em um Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'name': name,
      'dosage': dosage,
      'scheduleTimes': jsonEncode(scheduleTimes), // Convert list to JSON string
      'stock': stock,
      'colorCode': colorCode,
      'archived': archived ? 1 : 0,
    };
  }

  // Copy method for updating fields without modifying the original object
  Medication copyWith({
    int? id,
    int? profileId,
    String? name,
    String? dosage,
    List<String>? scheduleTimes,
    int? stock,
    String? colorCode,
    bool? archived,
  }) {
    return Medication(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      stock: stock ?? this.stock,
      colorCode: colorCode ?? this.colorCode,
      archived: archived ?? this.archived,
    );
  }
}
