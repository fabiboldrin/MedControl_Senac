import 'package:flutter/material.dart';
import 'package:med_control/views/profile_selection_screen.dart';

void main() {
  runApp(const MedControl());
}

class MedControl extends StatelessWidget {
  const MedControl({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedControl',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfileSelectionScreen(),
      routes: const {
        // Define other routes here
      },
    );
  }
}
