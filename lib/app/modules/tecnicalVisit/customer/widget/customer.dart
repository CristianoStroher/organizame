import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';


class Customer extends StatelessWidget {
  final CustomerController controller;
  final CustomerObject object;
  final Function(CustomerObject) onEdit;

  const Customer({
    Key? key,
    required this.controller,
    required this.object,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 1),
          Divider(
            color: context.secondaryColor.withOpacity(.5), // Linha cinza acima
            thickness: 0.3,
            height: 0,
          ),
          ListTile(
              contentPadding: const EdgeInsets.all(.8),
              title: Text(
                object.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    object.phone ?? '',
                    style: context.titleDefaut,
                  ),
                  Text(
                    object.address ?? '',
                    style: context.titleDefaut,
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: context.secondaryColor),
                    onPressed: () {
                      onEdit(object);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: context.secondaryColor),
                    onPressed: () async {
                      final bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Excluir Cliente',
                              style: context.titleMedium),
                          content:
                              Text('Deseja realmente excluir ${object.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child:
                                  Text('Cancelar', style: context.titleDefaut),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Excluir',
                                style: TextStyle(
                                  color: context.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        Loader.show(context);
                        try {
                          final result = await context
                              .read<CustomerController>()
                              .deleteCustomer(object);
                          Loader.hide();

                          if (result) {
                            Messages.of(context)
                                .showInfo('Cliente excluído com sucesso');
                          } else {
                            Messages.of(context)
                                .showError('Erro ao excluir cliente');
                          }
                        } on Exception catch (e) {
                          Loader.hide();
                          Messages.of(context)
                              .showError('Erro ao excluir cliente');
                        }
                      }
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
