import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_navigatorbar.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_drawer.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/modules/homeTecnical/widgets/visit.dart';
import 'package:provider/provider.dart';

class TecnicalPage extends StatefulWidget {
  const TecnicalPage({super.key});

  @override
  State<TecnicalPage> createState() => _TecnicalPageState();
}

class _TecnicalPageState extends State<TecnicalPage> {
  int index = 1;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _goToTaskPage(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/visit/create');
    if (result == true) {
      if (mounted) {
        context.read<TechnicalController>().refreshVisits();
      }
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filtrar por cliente'),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Nome do cliente',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchController.clear();
              context.read<TechnicalController>().filterByCustomer('');
            },
            child: Text('Limpar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<TechnicalController>()
                  .filterByCustomer(_searchController.text);
            },
            child: Text('Filtrar'),
          ),
        ],
      ),
    );
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
        title: OrganizameLogoMovie(
          text: 'OrganizaMe',
          part1Color: context.primaryColor,
          part2Color: context.secondaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(OrganizameIcons.filter, 
                size: 20, color: context.primaryColor),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filtrar por cliente',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToTaskPage(context),
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Color(0xFFFAFFC5)),
        tooltip: 'Adicionar visita técnica',
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: const Color(0xFFFAFFC5),
        initialIndex: index,
      ),
      body: Consumer<TechnicalController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!controller.hasVisits) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: context.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma visita técnica encontrada',
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _goToTaskPage(context),
                    child: const Text('Adicionar visita'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshVisits,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.filteredTechnicalVisits.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'VISITAS TÉCNICAS',
                      style: context.titleDefaut,
                    ),
                  );
                }

                final visit = controller.filteredTechnicalVisits[index - 1];
                if (visit.customer == null) return const SizedBox.shrink();

                return Visit(
                  controller: controller,
                  object: visit,
                  onEdit: (visitToEdit) async {
                    final result = await Navigator.of(context).pushNamed(
                      '/visit/edit',
                      arguments: visitToEdit,
                    );
                    if (result == true) {
                      controller.refreshVisits();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}