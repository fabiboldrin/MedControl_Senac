class MedicationsTaken {
  final int? id;
  final int profileId;
  final int medicationId;
  final String scheduleTime;
  final String takenDate;
  final String takenTime;

  MedicationsTaken({
    this.id,
    required this.profileId,
    required this.medicationId,
    required this.scheduleTime,
    required this.takenDate,
    required this.takenTime,
  });

  // Converte um Map em uma instância de MedicationsTaken
  factory MedicationsTaken.fromMap(Map<String, dynamic> map) {
    return MedicationsTaken(
      id: map['id'] as int?,
      profileId: map['profileId'] as int,
      medicationId: map['medicationId'] as int,
      scheduleTime: map['scheduleTime'] as String,
      takenDate: map['takenDate'] as String,
      takenTime: map['takenTime'] as String,
    );
  }

  // Converte uma instância de MedicationsTaken em um Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'medicationId': medicationId,
      'scheduleTime': scheduleTime,
      'takenDate': takenDate,
      'takenTime': takenTime,
    };
  }
}
