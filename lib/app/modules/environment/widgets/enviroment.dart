import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_page.dart';
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_page.dart';
import 'package:organizame/app/modules/environment/enviromentLivingRoom/living_room_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';

class Enviroment extends StatelessWidget {
  final String enviromentName;
  final String enviromentDifficulty;
  final String enviromentDescription;
  final String environmentId;
  final TechnicalVisitController controller;

  const Enviroment({
    super.key,
    required this.enviromentName,
    required this.enviromentDifficulty,
    required this.enviromentDescription,
    required this.controller,
    required this.environmentId,
  });

  void _navigateToSpecificEnvironment(BuildContext context) {
    Logger().d('Navegando para ambiente ID: $environmentId');

    // Busca o ambiente específico na lista de ambientes da visita atual
    final currentEnvironment = controller.currentVisit?.enviroment?.firstWhere(
      (env) => env.id == environmentId,
      orElse: () {
        Logger().e('Ambiente não encontrado: $environmentId');
        return EnviromentObject(
          id: environmentId,
          name: enviromentName,
          difficulty: enviromentDifficulty,
          descroiption: enviromentDifficulty,
        );
      },
    );

    Logger().d('Ambiente encontrado: ${currentEnvironment?.toMap()}');

    if (currentEnvironment == null) {
      Messages.of(context).showError('Ambiente não encontrado na visita atual');
      return;
    }

    switch (enviromentName.toUpperCase()) {
      case 'QUARTO CRIANÇA':
      case 'QUARTO DE CRIANÇA':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChildBedroomPage(
              controller: controller,
              environment: currentEnvironment, // Passa o ambiente encontrado
            ),
          ),
        );
        break;

      case 'COZINHA':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KitchenPage(
              controller: controller,
              environment: currentEnvironment,
            ),
          ),
        );
        break;

      case 'QUARTO DE CASAL':
      case 'QUARTO CASAL':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LivingRoomPage(
              controller: controller,
              enviroment: currentEnvironment,
            ),
          ),
        );
        break;

      default:
        Messages.of(context)
            .showInfo('Página não disponível para este ambiente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToSpecificEnvironment(context),
      child: Column(
        children: [
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 0,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(8), // Ajuste de padding
            title: Text(
              enviromentName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.primaryColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(enviromentDifficulty, style: context.titleDefaut),
                Text(enviromentDescription, style: context.titleDefaut),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Remover Ambiente', style: context.titleMedium),
                    content: Text(
                      'Tem certeza que deseja remover este ambiente?',
                      style:
                          TextStyle(color: context.primaryColor, fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFFAFFC5),
                          side:
                              BorderSide(color: context.primaryColor, width: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                          side:
                              BorderSide(color: context.primaryColor, width: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          'Excluir',
                          style:
                              TextStyle(color: Color(0xFFFAFFC5), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await controller.removeEnvironment(environmentId);
                    if (context.mounted) {
                      Messages.of(context)
                          .showInfo('Ambiente removido com sucesso!');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Messages.of(context)
                          .showError('Erro ao remover ambiente');
                    }
                  }
                }
              },
              icon: Icon(Icons.delete, color: context.secondaryColor),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 0,
          ),
        ],
      ),
    );
  }
}
