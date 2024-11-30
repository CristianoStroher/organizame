import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_page.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:provider/provider.dart';

class Budgets extends StatelessWidget {
  final BudgetsController controller;
  final BudgetsObject object;
  final dateFormatData = DateFormat('dd/MM/yyyy');
  final dateFormatHora = DateFormat('HH:mm');

  Budgets({
    super.key,
    required this.object,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BudgetsCreatePage(
              controller: controller,
              createController: context.read<BudgetsCreateController>(),
              object: object,
            ),
          ),
        ).then((value) async {
          await context.read<BudgetsController>().getAllBudgets();
          await context.read<BudgetsController>().filterBudgets();
        });
      },
      child: SizedBox(
        child: Column(
          children: [
            Divider(
              color: Colors.grey[300], // Linha cinza acima
              thickness: 1.5,
              height: 0,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
                checkColor: context.primaryColor,
                activeColor: Color(0xFFDDFFCC),
                fillColor: WidgetStateProperty.all(Color(0xFFDDFFCC)),
                side: BorderSide(color: context.primaryColor, width: 1),
                value: object.status,
                onChanged: (value) async {
                  // await context.read<HomeController>().finishTask(object);
                  Logger().i('Tarefa finalizada: ${object.customer}');
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    object.customer.name,
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.primaryColor,
                    ),
                  ),
                  Text(
                    'R\$ ${object.value}',
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  const SizedBox(height: 10),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.secondaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    dateFormatData.format(object.date),
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.secondaryColor,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: context.secondaryColor),
                onPressed: () async {
                  final bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:
                          Text('Excluir orçamento', style: context.titleMedium),
                      content: Text(
                        'Deseja excluir o orçamento de ${object.customer.name}?',
                        style: TextStyle(color: context.primaryColor),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFDDFFCC),
                            side: BorderSide(
                                color: context.primaryColor, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text('Cancelar', style: context.titleDefaut),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            side: BorderSide(
                                color: context.primaryColor, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Excluir',
                            style: TextStyle(
                                color: Color(0xFFDDFFCC), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    Loader.show(context);
                    try {
                      final result = await controller.deleteBudget(object);
                      Loader.hide();
                      if (result) {
                        Messages.of(context).showInfo('Orçamento excluído com sucesso');
                      } else {
                        Messages.of(context).showError('Erro ao excluir orçamento');
                      }
                    } catch (e) {
                      Loader.hide();
                      Messages.of(context).showError('Erro ao excluir orçamento');
                    }
                  }
                },
              ),
            ),
            Divider(
              color: Colors.grey[300], // Linha cinza abaixo
              thickness: 1.5,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
