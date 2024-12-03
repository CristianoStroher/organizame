import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_page.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pdfLib;

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

  Future<void> _handleStatusChange(BuildContext context, bool newStatus) async {
    if (!context.mounted) return;

    final updatedBudget = BudgetsObject(
        id: object.id,
        customer: object.customer,
        date: object.date,
        observation: object.observation,
        value: object.value,
        status: newStatus);

    try {
      Loader.show(context);
      await controller.updateBudget(updatedBudget);

      if (context.mounted) {
        Loader.hide();
        if (newStatus == true) {
          Messages.of(context).showInfo('Orçamento finalizado com sucesso');
          // Atualiza a lista apenas com os não finalizados
          await controller.filterBudgets(showCompleted: false);
        }
      }
    } catch (e) {
      Loader.hide();
      if (context.mounted) {
        Messages.of(context).showError('Erro ao atualizar status do orçamento');
      }
    }
  }

  Future<void> _handleShare(BuildContext context) async {
    try {
      Loader.show(context);

      // Criar o documento PDF
      final pdf = pdfLib.Document();

      pdf.addPage(
        pdfLib.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'OrganizaMe - Orçamento',
                  style: pdfLib.TextStyle(
                    fontSize: 24,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                pdfLib.SizedBox(height: 20),
                pdfLib.Text('Cliente: ${object.customer.name}'),
                pdfLib.Text('Data: ${dateFormatData.format(object.date)}'),
                pdfLib.Text('Valor: R\$ ${object.value}'),
                if (object.observation?.isNotEmpty ?? false) ...[
                  pdfLib.SizedBox(height: 10),
                  pdfLib.Text('Observações:'),
                  pdfLib.Text(object.observation!),
                ],
                pdfLib.SizedBox(height: 20),
                pdfLib.Text(
                  'Status: ${object.status ? "Finalizado" : "Em aberto"}',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
              ],
            );
          },
        ),
      );

      // Salvar PDF temporariamente
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/orcamento_${object.customer.name}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        Loader.hide();
        // Compartilhar arquivo
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Orçamento - ${object.customer.name}',
          subject: 'Orçamento OrganizaMe',
        );
      }
    } catch (e) {
      Loader.hide();
      if (context.mounted) {
        Messages.of(context).showError('Erro ao gerar PDF do orçamento');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleEdit(context),
      child: SizedBox(
        child: Column(
          children: [
            Divider(color: Colors.grey[300], thickness: 1.5, height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: Icon(
                  object.status
                      ? Icons.gavel // martelo quando FECHADO
                      : Icons.handshake, // aperto de mão quando em ABERTO
                  color: object.status
                      ? context.primaryColor // cor padrão para o martelo
                      : const Color(
                          0xFF2E7D32), // verde escuro para o aperto de mão
                  size: 28,
                ),
                tooltip:
                    object.status ? 'Orçamento fechado' : 'Orçamento em aberto',
                onPressed: () => _handleStatusChange(context, !object.status),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    object.customer.name.length > 20
                        ? '${object.customer.name.substring(0, 20)}...'
                        : object.customer.name,
                    style: TextStyle(
                      fontFamily: context.titleDefaut.fontFamily,
                      color: context.primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  Text('R\$ ${object.value}',
                      style: TextStyle(
                        fontFamily: context.titleDefaut.fontFamily,
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              subtitle: Row(
                children: [
                  const SizedBox(height: 10),
                  Icon(Icons.calendar_today,
                      size: 16, color: context.secondaryColor),
                  const SizedBox(width: 5),
                  Text(dateFormatData.format(object.date),
                      style: TextStyle(
                        fontFamily: context.titleDefaut.fontFamily,
                        color: context.secondaryColor,
                      )),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.share, color: context.secondaryColor),
                    onPressed: () => _handleShare(context),
                    tooltip: 'Compartilhar orçamento',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: context.secondaryColor),
                    onPressed: () => _handleDelete(context),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1.5, height: 0),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    final budgetsController =
        Provider.of<BudgetsController>(context, listen: false);
    final createController =
        Provider.of<BudgetsCreateController>(context, listen: false);

    if (!context.mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetsCreatePage(
          controller: budgetsController,
          createController: createController,
          object: object,
        ),
      ),
    );

    if (result == true && context.mounted) {
      await budgetsController.refreshVisits();
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir orçamento', style: context.titleMedium),
        content: Text('Deseja excluir o orçamento de ${object.customer.name}?',
            style: TextStyle(color: context.primaryColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
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
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: context.primaryColor,
              side: BorderSide(color: context.primaryColor, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Excluir',
                style: TextStyle(color: Color(0xFFDDFFCC), fontSize: 16)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await controller.deleteBudget(object);
    }
  }
}
