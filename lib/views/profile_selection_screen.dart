import 'package:flutter/material.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/views/new_profile_screen.dart';
import 'package:med_control/views/today_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ProfileSelectionScreenState createState() => ProfileSelectionScreenState();
}

class ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final ProfileController _profileController = ProfileController();
  List<Profile> _profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Carrega perfis do banco de dados
  Future<void> _loadProfiles() async {
    final profiles = await _profileController.getProfiles();
    setState(() {
      _profiles = profiles;
    });
  }

  // Navega para a tela de criação de novo perfil
  void _navigateToAddProfile() async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewProfileScreen()),
    );

    if (result != null) {
      _loadProfiles(); // Recarrega a lista de perfis após adicionar um novo
    }
  }

  // Navega para a tela Hoje para o perfil selecionado
  void _navigateToToday(Profile profile) async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TodayScreen(profile: profile)),
    );

    if (result == true) {
      _loadProfiles(); // Recarrega a lista de perfis ao voltar para a tela
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Perfil'),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Column(
        children: [
          Expanded(
            child: _profiles.isEmpty
                ? const Center(child: Text('Nenhum perfil encontrado.'))
                : ListView.builder(
                    itemCount: _profiles.length,
                    itemBuilder: (context, index) {
                      final profile = _profiles[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(profile.name),
                        subtitle: Text(
                            'Idade: ${DateTime.now().year - int.parse(profile.birthdate.split('/')[2])} anos'),
                        onTap: () => _navigateToToday(profile),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Novo Perfil'),
              onPressed: _navigateToAddProfile,
            ),
          ),
        ],
      ),
    );
  }
}
