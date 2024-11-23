import 'package:flutter/material.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/profile.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileController _profileController = ProfileController();
  List<Profile> _profiles = [];

  List<Profile> get profiles => _profiles;

  // Método para carregar perfis do banco de dados
  Future<void> loadProfiles() async {
    _profiles = await _profileController.getProfiles();
    notifyListeners();
  }

  // Método para adicionar um novo perfil
  Future<void> addProfile(Profile profile) async {
    await _profileController.addProfile(profile);
    await loadProfiles();
  }

  // Método para atualizar um perfil
  Future<void> updateProfile(Profile profile) async {
    await _profileController.updateProfile(profile);
    await loadProfiles();
  }

  // Método para excluir um perfil
  Future<void> deleteProfile(int id) async {
    await _profileController.deleteProfile(id);
    await loadProfiles();
  }
}
