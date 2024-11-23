import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_control/controllers/profile_controller.dart';
import 'package:med_control/models/medication.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/views/medication_screen.dart';
import 'package:med_control/views/new_medication_screen.dart';
import 'package:med_control/views/profile_selection_screen.dart';
import 'package:med_control/widgets/bottom_navigation_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  Profile? _profile;
  List<Medication> _medicationsInUse = [];
  List<Medication> _archivedMedications = [];

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profile = await _profileController.getProfileById(widget.profile.id!);

    final medicationsInUse =
        await _profileController.getMedicationsInUse(widget.profile.id!);

    final archivedMedications =
        await _profileController.getArchivedMedications(widget.profile.id!);

    setState(() {
      _profile = profile;
      _medicationsInUse = medicationsInUse;
      _archivedMedications = archivedMedications;

      _isLoaded = true;
    });
  }

  int _calculateAge(String dateOfBirth) {
    // Converte a string para um objeto DateTime
    final birthDate = DateFormat('dd/MM/yyyy').parse(dateOfBirth);

    // Obtém a data atual
    final today = DateTime.now();

    // Calcula a idade inicial
    int age = today.year - birthDate.year;

    // Verifica se o aniversário já passou este ano
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false, // Disables the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.change_circle_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/profile_placeholder.png',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profile!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                child: const Text('Editar perfil'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen(profile: _profile!),
                                    ),
                                  ).then((_) {
                                    _loadProfileData(); // Recarrega dados do perfil após edição
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${_calculateAge(_profile!.birthdate)} anos',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Medicamentos em uso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _medicationsInUse.isEmpty
                      ? const Text('Nenhum medicamento')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _medicationsInUse.length,
                            itemBuilder: (context, index) {
                              final medication = _medicationsInUse[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  iconColor:
                                      Color(int.parse(medication.colorCode)),
                                  title: Text(medication.name),
                                  subtitle: Text(medication.dosage),
                                  trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MedicationScreen(
                                                  medication: medication),
                                        ),
                                      ).then((_) {
                                        _loadProfileData(); // Atualiza a lista de medicamentos após adicionar novo medicamento
                                      });
                                    },
                                    icon: const Icon(Icons.edit_note_outlined),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewMedicationScreen(profile: widget.profile),
                        ),
                      ).then((_) {
                        _loadProfileData(); // Atualiza a lista de medicamentos após adicionar novo medicamento
                      });
                    },
                    child: const Text('Novo medicamento'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Medicamentos arquivados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _archivedMedications.isEmpty
                      ? const Text('Nenhum medicamento')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _archivedMedications.length,
                            itemBuilder: (context, index) {
                              final medication = _archivedMedications[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  iconColor:
                                      Color(int.parse(medication.colorCode)),
                                  title: Text(medication.name),
                                  subtitle: Text(medication.dosage),
                                  trailing: const Icon(
                                    Icons.archive_outlined,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
      bottomNavigationBar: _isLoaded == false
          ? const Center(child: CircularProgressIndicator())
          : BottomNavigationWidget(
              profile: _profile!,
            ),
    );
  }
}
