import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_control/controllers/medication_controller.dart';
import 'package:med_control/controllers/medication_taken_controller.dart';
import 'package:med_control/models/medication.dart';
import 'package:med_control/models/medications_taken.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/widgets/bottom_navigation_widget.dart';

class TodayScreen extends StatefulWidget {
  final Profile profile;

  const TodayScreen({super.key, required this.profile});

  @override
  TodayScreenState createState() => TodayScreenState();
}

class TodayScreenState extends State<TodayScreen> {
  final MedicationController _medicationController = MedicationController();
  final MedicationTakenController _medicationTakenController =
      MedicationTakenController();
  List<Medication> _medications = [];
  List<MedicationsTaken> _takenMedications = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationsForToday();
  }

  Future<void> _loadMedicationsForToday() async {
    final medications =
        await _medicationController.getMedicationsForToday(widget.profile.id!);

    String today = DateFormat('dd/MM/yyyy')
        .format(DateTime.now()); //.add(const Duration(days: 3)));

    final takenMedications = await _medicationTakenController
        .getMedicationsTakenByDate(widget.profile.id!, today);

    setState(() {
      _medications = medications;
      _takenMedications = takenMedications;
    });
  }

  Future<void> _takeMedication(int medicationId, String time) async {
    final now = DateTime.now(); //.add(const Duration(days: 3));
    final dateString = DateFormat('dd/MM/yyyy').format(now);
    final hourString = DateFormat('HH:mm').format(now);

    final medicationTaken = MedicationsTaken(
      profileId: widget.profile.id!,
      medicationId: medicationId,
      scheduleTime: time,
      takenDate: dateString,
      takenTime: hourString,
    );

    await _medicationTakenController.addMedicationTaken(medicationTaken);
    await _medicationController.takeMedication(medicationId);

    _loadMedicationsForToday();
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

  List<Map<String, Object>> _getMedicationList() {
    final baseList = _medications
        .map((medication) {
          // Filtrar os horários que não foram tomados (com base no id e horário)
          final remainingTimes = medication.scheduleTimes.where((time) {
            return !_takenMedications.any((taken) =>
                taken.medicationId == medication.id &&
                taken.scheduleTime == time);
          }).toList();

          // Retornar o medicamento apenas se ainda tiver horários
          if (remainingTimes.isNotEmpty) {
            return Medication(
              id: medication.id,
              name: medication.name,
              colorCode: medication.colorCode,
              dosage: medication.dosage,
              profileId: medication.profileId,
              stock: medication.stock,
              archived: medication.archived,
              scheduleTimes: remainingTimes,
            );
          }
          return null;
        })
        .whereType<Medication>()
        .toList(); // Remove os nulos

    final expandedList = baseList.expand((medication) {
      return medication.scheduleTimes.map((time) {
        return {
          'medication': medication, // Objeto do medicamento
          'time': time, // Horário associado
        };
      }).toList();
    }).toList();

    // Ordenar a lista pelo horário
    expandedList.sort((a, b) {
      final timeA = a['time'] as String;
      final timeB = b['time'] as String;
      return timeA.compareTo(timeB); // Ordena por horário ascendente
    });

    return expandedList;
  }

  bool _isDuringDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);

    // Considera dia entre 06:00 e 18:00
    return hour >= 6 && hour < 18;
  }

  @override
  Widget build(BuildContext context) {
    final medicationsList = _getMedicationList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 48.0, // Padding do topo
          left: 16.0, // Padding da esquerda
          right: 16.0, // Padding da direita
          bottom: 16.0, // Padding da parte inferior
        ),
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
                      widget.profile.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_calculateAge(widget.profile.birthdate)} anos',
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
              "Hoje",
              style: TextStyle(
                fontSize: 48, // Define o tamanho da fonte
                fontWeight: FontWeight.bold, // Opcional: Estilo de fonte
                color: Colors.black, // Opcional: Cor do texto
              ),
            ),
            medicationsList.isEmpty
                ? const Text('Nenhum medicamento encontrado')
                : Expanded(
                    child: ListView.builder(
                      itemCount: medicationsList.length,
                      itemBuilder: (context, index) {
                        final item = medicationsList[index];
                        final medication = item['medication'] as Medication;
                        final time = item['time'] as String;

                        // Verificar se é dia ou noite
                        final isDay = _isDuringDay(time);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            iconColor: Color(int.parse(medication.colorCode)),
                            leading: isDay
                                ? const Icon(Icons.sunny)
                                : const Icon(Icons.nightlight),
                            title:
                                Text("${medication.name} ${medication.dosage}"),
                            subtitle: Text(
                              "Horário: $time - Estoque: ${medication.stock}",
                            ),
                            trailing: IconButton.outlined(
                              onPressed: () {
                                _takeMedication(medication.id!, time);
                              },
                              icon:
                                  const Icon(Icons.medication_liquid_outlined),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        profile: widget.profile,
      ),
    );
  }
}
