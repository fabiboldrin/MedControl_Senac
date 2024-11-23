import 'package:med_control/database/database_helper.dart';
import 'package:med_control/models/medications_taken.dart';

class MedicationTakenController {
  // Método para obter todos os medicamentos tomados para um perfil específico
  Future<List<MedicationsTaken>> getMedicationsByProfile(int profileId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_taken',
      where: 'profileId = ?',
      whereArgs: [profileId],
    );

    return result.map((json) => MedicationsTaken.fromMap(json)).toList();
  }

  // Método para obter todos os medicamentos tomados para um perfil e data específicos
  Future<List<MedicationsTaken>> getMedicationsTakenByDate(
    int profileId,
    String takenDate,
  ) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'medications_taken',
      where: 'profileId = ? AND takenDate = ?',
      whereArgs: [profileId, takenDate],
    );

    return result.map((json) => MedicationsTaken.fromMap(json)).toList();
  }

  // Método para adicionar um novo medicamento tomado
  Future<int> addMedicationTaken(MedicationsTaken medicationTaken) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('medications_taken', medicationTaken.toMap());
  }
}
