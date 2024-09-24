import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_navigatorbar.dart';
import 'package:organizame/app/modules/home/widgets/home_drawer.dart';

class TecnicalPage extends StatefulWidget {
  TecnicalPage({super.key});

  @override
  State<TecnicalPage> createState() => _TecnicalPageState();
}

class _TecnicalPageState extends State<TecnicalPage> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFFC5),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrganizameLogoMovie(
              text: 'OrganizaMe',
              part1Color: context.primaryColor,
              part2Color: context.secondaryColor,
            ),
            const SizedBox(width: 5),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(OrganizameIcons.filter, size: 20, color: context.primaryColor),
            onSelected: (value) => print('value'),
            itemBuilder: (context) {
              return [
                PopupMenuItem<bool>(
                  value: true,
                  child: Text(
                    'Cliente',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await _goToTaskPage(context);
          // context.read<HomeController>().refreshPage();
        },
        backgroundColor: context.primaryColor,
        child: Icon(Icons.add, color: context.primaryColorLight),
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: const Color(0xFFFAFFC5),
        initialIndex: index,
        
      ),  
    );
  }
}
