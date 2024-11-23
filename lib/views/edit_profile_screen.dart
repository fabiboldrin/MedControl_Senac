import 'package:flutter/material.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/profile.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthdateController;
  late TextEditingController _healthHistoryController;
  late TextEditingController _allergiesController;
  final ProfileController _profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _birthdateController =
        TextEditingController(text: widget.profile.birthdate);
    _healthHistoryController =
        TextEditingController(text: widget.profile.healthHistory);
    _allergiesController =
        TextEditingController(text: widget.profile.allergies);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _healthHistoryController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  // Método para salvar o perfil atualizado
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profile(
        id: widget.profile.id,
        name: _nameController.text,
        birthdate: _birthdateController.text,
        healthHistory: _healthHistoryController.text,
        allergies: _allergiesController.text,
      );

      await _profileController.updateProfile(updatedProfile);

      Navigator.pop(context, updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
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
                  onPressed: _saveProfile,
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
