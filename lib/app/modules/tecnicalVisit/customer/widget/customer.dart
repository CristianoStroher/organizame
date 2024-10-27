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
                      // Wrap com Expanded
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
                      // ... resto do código do botão delete
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
