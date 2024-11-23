import 'package:flutter/material.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/views/profile_selection_screen.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  NewProfileScreenState createState() => NewProfileScreenState();
}

class NewProfileScreenState extends State<NewProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _healthHistoryController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final ProfileController _profileController = ProfileController();

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _healthHistoryController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  // Método para salvar o novo perfil
  Future<Profile?> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final newProfile = Profile(
        name: _nameController.text,
        birthdate: _birthdateController.text,
        healthHistory: _healthHistoryController.text,
        allergies: _allergiesController.text,
      );

      await _profileController.addProfile(newProfile);
      return newProfile;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                    labelText: 'Data de Nascimento (dd/mm/yyyy)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _healthHistoryController,
                decoration:
                    const InputDecoration(labelText: 'Histórico de Saúde'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(labelText: 'Alergias'),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile().then((newProfile) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSelectionScreen(),
                        ),
                      );
                    });
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
