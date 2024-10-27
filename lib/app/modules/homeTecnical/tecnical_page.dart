import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
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
    final controller = context.read<TechnicalController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filtrar por cliente', style: context.titleMedium),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Nome do cliente',
            prefixIcon: Icon(Icons.search, color: context.secondaryColor),
          ),
          onChanged: (value) {
            if (value.length >= 3) {
              controller.getTechnicalVisitsByCustomer(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              controller.clearFilters();
              Navigator.pop(context);
              Messages.of(context).showInfo('Filtro removido');
            },
            child:
                Text('Limpar', style: TextStyle(color: context.secondaryColor)),
          ),
          TextButton(
            onPressed: () {
              String searchQuery = _searchController.text.trim();
              if (searchQuery.length >= 3) {
                controller.getTechnicalVisitsByCustomer(searchQuery);
                Navigator.pop(context);
                Messages.of(context).showInfo('Filtro aplicado');
              } else {
                Messages.of(context)
                    .showError('Digite pelo menos 3 caracteres para pesquisar');
              }
            },
            child:
                Text('Filtrar', style: TextStyle(color: context.primaryColor)),
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
        tooltip: 'Adicionar visita técnica',
        child: const Icon(Icons.add, color: Color(0xFFFAFFC5)),
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: const Color(0xFFFAFFC5),
        initialIndex: index,
      ),
      
      body: Consumer<TechnicalController>(
        builder: (context, controller, _) {
          print(
              'UI - Estado atual: isLoading=${controller.isLoading}, totalVisitas=${controller.filteredTechnicalVisits.length}');

          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final visits = controller.filteredTechnicalVisits;
          print('UI - Renderizando lista com ${visits.length} visitas');

          if (visits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: context.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.allTechnicalVisits.isEmpty
                        ? 'Nenhuma visita técnica cadastrada'
                        : 'Nenhuma visita encontrada com este filtro',
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  if (!controller.allTechnicalVisits.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          context.read<TechnicalController>().clearFilters();
                          Messages.of(context).showInfo('Filtro removido');
                        },
                        child: Text(
                          'Mostrar todas as visitas',
                          style: TextStyle(color: context.primaryColor),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshVisits,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'VISITAS TÉCNICAS (${visits.length})',
                    style: context.titleDefaut,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      final visit = visits[index];
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
