import 'package:flutter/material.dart';
import 'package:med_control/models/profile.dart';
import 'package:med_control/views/history_screen.dart';
import 'package:med_control/views/profile_screen.dart';
import 'package:med_control/views/today_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final Profile profile;

  const BottomNavigationWidget({super.key, required this.profile});

  @override
  BottomNavigationWidgetState createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: 'Hoje',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Histórico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 0) {
          // Navegar para a tela Hoje
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TodayScreen(
                profile: widget.profile,
              ),
            ),
          );
        } else if (index == 1) {
          // Navegar para a tela Histórico
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(
                profile: widget.profile,
              ),
            ),
          );
        } else if (index == 2) {
          // Navegar para a tela Perfil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                profile: widget.profile,
              ),
            ),
          );
        }
      },
    );
  }
}
