import 'package:flutter/material.dart';
import 'package:med_control/controllers/medication_controller.dart';
import 'package:med_control/controllers/medication_taken_controller.dart';
import 'package:med_control/models/medication.dart';
import 'package:med_control/models/medications_taken.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/widgets/bottom_navigation_widget.dart';

class HistoryScreen extends StatefulWidget {
  final Profile profile;

  const HistoryScreen({super.key, required this.profile});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  final MedicationController _medicationController = MedicationController();
  final MedicationTakenController _medicationTakenController =
      MedicationTakenController();
  List<Medication> _medications = [];
  List<MedicationsTaken> _takenMedications = [];

  @override
  void initState() {
    super.initState();
    _loadTakenMedications();
  }

  Future<void> _loadTakenMedications() async {
    final medications =
        await _medicationController.getMedicationsByProfile(widget.profile.id!);

    final takenMedications = await _medicationTakenController
        .getMedicationsByProfile(widget.profile.id!);

    setState(() {
      _medications = medications;
      _takenMedications = takenMedications;
    });
  }

  // Função para agrupar os dados pela data
  Map<String, List<Map<String, Object>>> _groupByDate(
    List<Map<String, Object>> data,
  ) {
    if (data.isEmpty) return {};

    Map<String, List<Map<String, Object>>> groupedData = {};

    for (var item in data) {
      String date = item['date'] as String; // Obtém a data

      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }

      groupedData[date]?.add(item);
    }

    // Ordenar as chaves (datas)
    var sortedKeys = groupedData.keys.toList()..sort();

    Map<String, List<Map<String, Object>>> sortedGroupedData = {};

    for (var key in sortedKeys) {
      groupedData[key]!.sort((a, b) {
        final timeA = a['scheduleTime'] as String;
        final timeB = b['scheduleTime'] as String;
        return timeA.compareTo(timeB); // Ordena por horário ascendente
      });

      sortedGroupedData[key] = groupedData[key]!;
    }

    return sortedGroupedData;
  }

  List<Map<String, Object>> _getMedicationList() {
    if (_takenMedications.isEmpty || _medications.isEmpty) return [];

    final expandedList = _takenMedications.map((taken) {
      final medication = _medications.where((med) {
        return med.id == taken.medicationId;
      }).first;

      return {
        'medication': medication,
        'date': taken.takenDate,
        'scheduleTime': taken.scheduleTime,
        'takenTime': taken.takenTime,
      };
    }).toList();

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
    final groupedList = _groupByDate(medicationsList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: groupedList.isEmpty
            ? const Text('Nenhum histórico encontrado')
            : Expanded(
                child: ListView.builder(
                  itemCount: groupedList.length,
                  itemBuilder: (context, index) {
                    // Obter a data (chave) e a lista de medicamentos dessa data
                    String date = groupedList.keys.toList()[index];
                    List<Map<String, Object>> medications = groupedList[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho da data
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Lista de medicamentos para essa data
                        ...medications.map((item) {
                          final medication = item['medication'] as Medication;
                          final scheduleTime = item['scheduleTime'] as String;
                          final takenTime = item['takenTime'] as String;

                          // Verificar se é dia ou noite
                          final isDay = _isDuringDay(scheduleTime);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              iconColor: Color(int.parse(medication.colorCode)),
                              leading: isDay
                                  ? const Icon(Icons.sunny)
                                  : const Icon(Icons.nightlight),
                              title: Text(
                                  "${medication.name} ${medication.dosage}"),
                              subtitle: Text(
                                  "Horário: $scheduleTime - Tomado: $takenTime"),
                              trailing: const Icon(Icons.check),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        profile: widget.profile,
      ),
    );
  }
}
