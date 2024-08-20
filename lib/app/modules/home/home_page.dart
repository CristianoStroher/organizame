import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/Widget/organizame_navigatorbar.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/home/widgets/home_drawer.dart';
import 'package:organizame/app/modules/home/widgets/home_filters.dart';
import 'package:organizame/app/modules/home/widgets/home_header.dart';
import 'package:organizame/app/modules/home/widgets/home_task.dart';
import 'package:organizame/app/modules/home/widgets/home_week_filter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: context.primaryColorLight,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrganizameLogoMovie(),
            SizedBox(width: 5),
            
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(OrganizameIcons.filter,
                size: 20, color: context.primaryColor),
            itemBuilder: (context) {
              return [
                PopupMenuItem<bool>(
                  child: Text(
                    'Mostrar tarefas concluídas',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: context.primaryColor,
        child: Icon(Icons.add, color: context.primaryColorLight),
        ),
      bottomNavigationBar: const OrganizameNavigatorbar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 0.9,
                minHeight: constraints.maxHeight * 0.9,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTask(),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
