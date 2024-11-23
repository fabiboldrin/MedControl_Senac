import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:med_control/controllers/medication_controller.dart';
import 'package:med_control/models/medication.dart';

class MedicationScreen extends StatefulWidget {
  final Medication? medication;

  const MedicationScreen({super.key, this.medication});

  @override
  MedicationScreenState createState() => MedicationScreenState();
}

class MedicationScreenState extends State<MedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _stockController = TextEditingController();
  final List<String> _scheduleTimes = [];
  Color _selectedColor = Colors.blue;
  final _scheduleTimeController = TextEditingController();
  final MedicationController _medicationController = MedicationController();

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      _nameController.text = widget.medication!.name;
      _dosageController.text = widget.medication!.dosage;
      _stockController.text = widget.medication!.stock.toString();
      _scheduleTimes.addAll(widget.medication!.scheduleTimes);
      _selectedColor = Color(int.parse(widget.medication!.colorCode));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _stockController.dispose();
    _scheduleTimeController.dispose();
    super.dispose();
  }

  void _addScheduleTime(String horario) {
    setState(() {
      _scheduleTimes.add(horario);
    });
  }

  void _removeScheduleTime(int index) {
    setState(() {
      _scheduleTimes.removeAt(index);
    });
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState?.validate() ?? false) {
      final medication = Medication(
        id: widget.medication?.id,
        profileId:
            widget.medication?.profileId ?? 0, // Set appropriate profile ID
        name: _nameController.text,
        dosage: _dosageController.text,
        scheduleTimes: _scheduleTimes,
        stock: int.tryParse(_stockController.text) ?? 0,
        colorCode: _selectedColor.value.toString(),
        archived: widget.medication?.archived ?? false,
      );

      await _medicationController.updateMedication(medication);

      Navigator.pop(context);
    }
  }

  Future<void> _archiveMedication() async {
    if (_formKey.currentState?.validate() ?? false) {
      final medication = Medication(
        id: widget.medication?.id,
        profileId:
            widget.medication?.profileId ?? 0, // Set appropriate profile ID
        name: _nameController.text,
        dosage: _dosageController.text,
        scheduleTimes: _scheduleTimes,
        stock: int.tryParse(_stockController.text) ?? 0,
        colorCode: _selectedColor.value.toString(),
        archived: true,
      );

      await _medicationController.updateMedication(medication);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Medicamento"),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosagem'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a dosagem' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? 'Informe uma quantidade válida'
                        : null,
              ),
              const SizedBox(height: 20),
              const Text("Horários Agendados"),
              TextFormField(
                controller: _scheduleTimeController,
                decoration: const InputDecoration(labelText: 'Horário (hh:mm)'),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Adicionar horário"),
                onPressed: () {
                  _addScheduleTime(_scheduleTimeController.text);
                  _scheduleTimeController.text = "";
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _scheduleTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_scheduleTimes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeScheduleTime(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Cor de identificação:"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      Color? pickedColor = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Selecione uma cor'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() => _selectedColor = color);
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Confirmar'),
                              onPressed: () {
                                Navigator.of(context).pop(_selectedColor);
                              },
                            ),
                          ],
                        ),
                      );
                      if (pickedColor != null) {
                        setState(() {
                          _selectedColor = pickedColor;
                        });
                      }
                    },
                    child: Container(
                      width: 110,
                      height: 48,
                      color: _selectedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedication,
                child: const Text("Salvar"),
              ),
              ElevatedButton(
                onPressed: _archiveMedication,
                child: const Text("Arquivar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
