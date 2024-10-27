import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';

class Customer extends StatelessWidget {
  final CustomerController controller;
  final CustomerObject object;
  final Function(CustomerObject) onEdit;

  const Customer({
    super.key,
    required this.controller,
    required this.object,
    required this.onEdit,
  });

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
                color: context.primaryColor,
              ),
              overflow:
                  TextOverflow.ellipsis, // Adiciona reticências se necessário
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      // Wrap com Expanded
                      child: Text(
                        object.phone ?? '',
                        style: context.titleDefaut,
                        overflow: TextOverflow
                            .ellipsis, // Adiciona reticências se necessário
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on, // Mudei para ícone de localização
                      size: 16,
                      color: context.secondaryColor,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        object.address ?? '',
                        style: context.titleDefaut,
                        overflow: TextOverflow
                            .ellipsis, // Adiciona reticências se necessário
                        maxLines: 2, // Permite até 2 linhas para o endereço
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: SizedBox(
              // Wrap o trailing em um SizedBox com largura fixa
              width: 96, // Largura para acomodar os dois ícones
              child: Row(
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
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Excluir Cliente',
                                style: context.titleMedium),
                            content: Text(
                                'Deseja realmente excluir o cliente ${object.name}?',
                                style: TextStyle(
                                    fontSize: 16, color: context.primaryColor)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFFAFFC5),
                                  side: BorderSide(
                                      color: context.primaryColor, width: 1),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text('Cancelar',
                                    style: TextStyle(
                                        color: context.secondaryColor)),
                              ),
                              TextButton(
                                onPressed: () {
                                  try {
                                    Navigator.of(context).pop();
                                    controller.deleteCustomer(object);
                                    Messages.of(context).showInfo('Cliente excluído com sucesso'); 
                                  } on Exception catch (e) {
                                    Messages.of(context).showError('Erro ao excluir cliente: $e');
                                  }
                                },
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
                                child: Text('Excluir',
                                    style: TextStyle(color: Color(0xFFFAFFC5))),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
