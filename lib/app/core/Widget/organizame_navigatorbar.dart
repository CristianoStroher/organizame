import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameNavigatorbar extends StatelessWidget {

  const OrganizameNavigatorbar({ super.key });

   @override
   Widget build(BuildContext context) {
       return BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: context.primaryColor),
        selectedItemColor: context.primaryColor,
        unselectedIconTheme: IconThemeData(color: context.secondaryColor),
        unselectedItemColor: context.secondaryColor,
        backgroundColor: context.primaryColorLight,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: context.primaryColor),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: context.secondaryColor),
            label: 'Visitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.price_change_rounded, color: context.secondaryColor),
            label: 'Orçamentos',
            
            ),
        ],
      );
  }
}