import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameNavigatorbar extends StatelessWidget {

  const OrganizameNavigatorbar({ super.key });

   @override
   Widget build(BuildContext context) {
       return BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 1) {
            Navigator.of(context).pushNamed('/tecnical');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/budget');
          }
        },
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