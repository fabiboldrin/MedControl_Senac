import 'package:med_control/database/database_helper.dart';
import 'package:med_control/models/medication.dart';
import 'package:med_control/models/profile.dart';

class ProfileController {
  // Método para obter todos os perfis
  Future<List<Profile>> getProfiles() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('profiles');
    return result.map((json) => Profile.fromMap(json)).toList();
  }

  // Método para adicionar um novo perfil
  Future<int> addProfile(Profile profile) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('profiles', profile.toMap());
  }

  // Método para atualizar um perfil existente
  Future<int> updateProfile(Profile profile) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Método para excluir um perfil
  Future<int> deleteProfile(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retorna os dados de um perfil específico pelo ID
  Future<Profile?> getProfileById(int profileId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [profileId],
    );

    if (result.isNotEmpty) {
      return Profile.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Retorna uma lista de medicamentos em uso para um perfil específico
  Future<List<Medication>> getMedicationsInUse(int profileId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'medications',
      where: 'profileId = ? AND archived = 0',
      whereArgs: [profileId],
    );

    return result.map((json) => Medication.fromMap(json)).toList();
  }

  // Retorna uma lista de medicamentos arquivados para um perfil específico
  Future<List<Medication>> getArchivedMedications(int profileId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'medications',
      where: 'profileId = ? AND archived = 1',
      whereArgs: [profileId],
    );

    return result.map((json) => Medication.fromMap(json)).toList();
  }
}
