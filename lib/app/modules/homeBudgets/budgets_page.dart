import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_navigatorbar.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/homeBudgets/widgets/budgets.dart';
import 'package:organizame/app/modules/homeTasks/widgets/home_drawer.dart';
import 'package:provider/provider.dart';

class BudgetsPage extends StatefulWidget {
  final BudgetsController _controller;

  const BudgetsPage({
    super.key,
    required BudgetsController controller,
  }) : _controller = controller;

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  int index = 2;
  final TextEditingController _searchController = TextEditingController();
  bool _showingCompleted = false;

  @override
  void initState() {
    super.initState();
    widget._controller.refreshVisits();
    widget._controller.addListener(_handleControllerUpdate);
  }

  void _handleControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget._controller.removeListener(_handleControllerUpdate);
    super.dispose();
  }

  Future<void> _goToTaskPage(BuildContext context) async {
    final controller = context.read<BudgetsController>();
    final result = await Navigator.of(context).pushNamed('/budgets/create');
    if (result == true && mounted) {
      await controller.refreshVisits();
      setState(() {});
    }
  }

  void _toggleCompletedBudgets() {
    setState(() {
      _showingCompleted = !_showingCompleted;
    });
    widget._controller.filterBudgets(showCompleted: _showingCompleted);
    Messages.of(context).showInfo(
      _showingCompleted 
        ? 'Mostrando orçamentos finalizados' 
        : 'Mostrando orçamentos em aberto'
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = context.read<BudgetsController>();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Buscar Orçamentos', style: context.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Nome do cliente',
                  hintStyle: TextStyle(color: context.secondaryColor),
                  prefixIcon: Icon(Icons.search, color: context.secondaryColor),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'De',
                  style: TextStyle(color: context.primaryColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        startDate != null
                            ? DateFormat('dd/MM/yyyy').format(startDate!)
                            : 'Selecione a data inicial',
                        style: TextStyle(color: context.secondaryColor),
                      ),
                    ),
                    if (startDate != null)
                      IconButton(
                        icon: Icon(Icons.clear, color: context.secondaryColor),
                        onPressed: () => setState(() => startDate = null),
                      ),
                  ],
                ),
                trailing: Icon(Icons.calendar_today, color: context.secondaryColor),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => startDate = picked);
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Até',
                  style: TextStyle(color: context.primaryColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        endDate != null
                            ? DateFormat('dd/MM/yyyy').format(endDate!)
                            : 'Selecione a data final',
                        style: TextStyle(color: context.secondaryColor),
                      ),
                    ),
                    if (endDate != null)
                      IconButton(
                        icon: Icon(Icons.clear, color: context.secondaryColor),
                        onPressed: () => setState(() => endDate = null),
                      ),
                  ],
                ),
                trailing: Icon(Icons.calendar_today, color: context.secondaryColor),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => endDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _searchController.clear();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFDDFFCC),
                side: BorderSide(color: context.primaryColor, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Cancelar', style: context.titleDefaut),
            ),
            TextButton(
              onPressed: () {
                final searchQuery = _searchController.text.trim();

                if (startDate != null &&
                    endDate != null &&
                    endDate!.isBefore(startDate!)) {
                  Messages.of(context)
                      .showError('Data final deve ser posterior à data inicial');
                  return;
                }

                controller.filterBudgets(
                  customerName: searchQuery.isNotEmpty ? searchQuery : null,
                  startDate: startDate,
                  endDate: endDate,
                  showCompleted: _showingCompleted,
                );

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: context.primaryColor,
                side: BorderSide(color: context.primaryColor, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Buscar',
                style: TextStyle(color: Color(0xFFDDFFCC), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        colorDrawer: const Color(0xFFDDFFCC),
        backgroundButton: const Color(0xFFDDFFCC),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDFFCC),
        title: OrganizameLogoMovie(
          text: 'OrganizaMe',
          part1Color: context.primaryColor,
          part2Color: context.secondaryColor,
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              OrganizameIcons.filter,
              size: 20,
              color: context.primaryColor
            ),
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                  '${_showingCompleted ? 'Ocultar' : 'Mostrar'} orçamentos finalizados',
                  style: TextStyle(color: context.primaryColor),
                ),
              ),
              PopupMenuItem<String>(
                value: 'search',
                child: Text(
                  'Buscar orçamentos',
                  style: TextStyle(color: context.primaryColor),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == true) {
                _toggleCompletedBudgets();
              } else if (value == 'search') {
                _showSearchDialog(context);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToTaskPage(context),
        backgroundColor: context.primaryColor,
        tooltip: 'Adicionar orçamento',
        child: const Icon(Icons.add, color: Color(0xFFDDFFCC)),
      ),
      bottomNavigationBar: OrganizameNavigatorbar(
        color: const Color(0xFFDDFFCC),
        initialIndex: index,
      ),
      body: Consumer<BudgetsController>(
        builder: (context, controller, _) {
          if (controller.isStauts) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          final budgets = controller.filteredBugets;

          if (budgets.isEmpty) {
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
                    controller.bugets.isEmpty
                        ? 'Nenhum orçamento cadastrado'
                        : _showingCompleted
                            ? 'Nenhum orçamento finalizado'
                            : 'Nenhum orçamento em aberto',
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  if (!controller.bugets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          context.read<BudgetsController>().clearFilters();
                          setState(() => _showingCompleted = false);
                          Messages.of(context).showInfo('Filtros removidos');
                        },
                        child: Text(
                          'Mostrar todos os orçamentos',
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
                    _showingCompleted
                      ? 'ORÇAMENTOS FINALIZADOS (${budgets.length})'
                      : 'ORÇAMENTOS EM ABERTO (${budgets.length})',
                    style: context.titleDefaut,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgets[index];
                      return Budgets(
                        controller: context.read<BudgetsController>(),
                        object: budget,
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
