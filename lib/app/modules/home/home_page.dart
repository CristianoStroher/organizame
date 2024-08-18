import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/Organizame_heart.dart';
import 'package:organizame/app/core/auth/auth_provider.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/home/widgets/home_drawer.dart';
import 'package:organizame/app/modules/home/widgets/home_filters.dart';
import 'package:organizame/app/modules/home/widgets/home_header.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Organiz',
                      style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 30,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: 'Ame',
                      style: TextStyle(
                          color: context.scaffoldBackgroundColor,
                          fontSize: 30,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const OrganizameHeart()
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
