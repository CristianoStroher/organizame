import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameNavigatorbar extends StatefulWidget {
  final int initialIndex;
  final Color color;

  const OrganizameNavigatorbar({
    super.key,
    required this.color,
    this.initialIndex = 0, // Defina um índice inicial
  });

  @override
  _OrganizameNavigatorbarState createState() => _OrganizameNavigatorbarState();
}

class _OrganizameNavigatorbarState extends State<OrganizameNavigatorbar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Inicializa o índice com o valor passado
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/tecnical');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/budget');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // O índice atual controla a cor do ícone
      onTap: _onItemTapped, // Atualiza o índice ao selecionar
      selectedIconTheme: IconThemeData(color: context.primaryColor),
      selectedItemColor: context.primaryColor,
      unselectedIconTheme: IconThemeData(color: context.secondaryColor),
      unselectedItemColor: context.secondaryColor,
      backgroundColor: widget.color,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Visitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.price_change_rounded),
          label: 'Orçamentos',
        ),
      ],
    );
  }
}
