import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';

class Budgets extends StatelessWidget {
  final BudgetsController controller;
  final BudgetsObject object;
  final Function(TechnicalVisitObject) onEdit;

  Visit({
    super.key,
    required this.controller,
    required this.object,
    required this.onEdit,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão', style: context.titleMedium),
        content: Text('Deseja realmente excluir esta visita técnica?',
            style: TextStyle(color: context.primaryColor, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFFAFFC5),
              side: BorderSide(color: context.primaryColor, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              'Cancelar',
              style: context.titleDefaut,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: context.primaryColor,
              side: BorderSide(color: context.primaryColor, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              'Excluir',
              style: TextStyle(color: Color(0xFFFAFFC5), fontSize: 16),
            ),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        // await controller.deleteBudgets(object);
        Messages.of(context).showInfo('Visita técnica excluída com sucesso');
      } catch (e) {
        Messages.of(context).showError('Erro ao excluir visita técnica');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final environmentCount = object.enviroment?.length ?? 0;
    return Column(
      children: [
        Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1, // Reduzido para 1 para minimizar o espaço
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            object.customer?.name.toUpperCase() ?? 'Cliente não informado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: context.secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  // Text(
                  //   dateFormatData.format(object.date),
                  //   style: context.titleDefaut,
                  // ),
                ],
              ),
              if (object.customer?.address?.isNotEmpty ?? false) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        object.customer!.address!,
                        style: context.titleDefaut,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: SizedBox(
            width: 96,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => onEdit(object),
                  icon: Icon(
                    Icons.edit,
                    color: context.secondaryColor,
                  ),
                  tooltip: 'Editar orçamento',
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: Icon(
                    Icons.delete,
                    color: context.secondaryColor,
                  ),
                  tooltip: 'Excluir orçamento',
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1, // Reduzido para 1 para minimizar o espaço
        ),
      ],
    );
  }
}
