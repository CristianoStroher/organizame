import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_navigatorbar.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_drawer.dart';
import 'package:organizame/app/modules/homeTecnical/widgets/visit.dart';


class TecnicalPage extends StatefulWidget {
  const TecnicalPage({super.key});

  @override
  State<TecnicalPage> createState() => _TecnicalPageState();
}

class _TecnicalPageState extends State<TecnicalPage> {
  int index = 1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _goToTaskPage(BuildContext appcontext) async {
    await Navigator.of(appcontext).pushNamed('/visit/create');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        colorDrawer: const Color(0xFFFAFFC5),
        backgroundButton: const Color(0xFFFAFFC5),
      ),
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
            icon: Icon(OrganizameIcons.filter,
                size: 20, color: context.primaryColor),
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
          await _goToTaskPage(context);
          // context.read<CustomerController>().refreshPage();
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Color(0xFFFAFFC5)),
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: const Color(0xFFFAFFC5),
        initialIndex: index,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('VISITAS TÉCNICAS', style: context.titleDefaut),
                  const SizedBox(height: 10),
                  // Usando uma lista de Visit para demonstrar
                  const Visit(),
                  const Visit(),
                  const Visit(),
                  const Visit(),
                  const Visit(),
                  const Visit(),
                  const Visit(),
                  const SizedBox(height: 20),
                  // Substitua pela lista de visitas se necessário
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
