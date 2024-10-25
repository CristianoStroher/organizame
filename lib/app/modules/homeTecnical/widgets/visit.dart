import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:intl/intl.dart';

class Visit extends StatelessWidget {

  final TechnicalController controller;
  final TechnicalVisitObject object;
  final dateFormatData = DateFormat('dd/MM/yyyy');
  final dateFormatHora = DateFormat('HH:mm');
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
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta visita técnica?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: context.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await controller.deleteTechnicalVisit(object);
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Visita técnica excluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Erro ao excluir visita técnica'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // // Validação de dados críticos
    // if (object.customer == null) {
    //   return const SizedBox.shrink();
    // }
    return Column(
          children: [
            Divider(
              color: Colors.grey[300], // Linha cinza acima
              thickness: 1.5,
              height: 0,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                object.customer?.name.toUpperCase() ?? 'Cliente não informado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: context.secondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatData.format(object.date),
                        style: context.titleDefaut,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: context.secondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatHora.format(object.time),
                        style: context.titleDefaut,
                      ),
                    ],
                  ),
                  if (object.customer?.address?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onEdit(object),
                    icon: Icon(
                      Icons.edit,
                      color: context.secondaryColor,
                    ),
                    tooltip: 'Editar visita',
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: Icon(
                      Icons.delete,
                      color: context.secondaryColor,
                    ),
                    tooltip: 'Excluir visita',
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300], // Linha cinza acima
              thickness: 1.5,
              height: 0,
            ),
          ],
    );
  }
}