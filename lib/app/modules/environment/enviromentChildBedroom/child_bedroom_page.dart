import 'package:flutter/material.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_controller.dart';
import 'package:organizame/app/modules/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/environment/widgets/generic_environment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:provider/provider.dart';

class ChildBedroomPage extends StatelessWidget {
  final TechnicalVisitController controller;
  final EnviromentObject? environment;
  final title = 'Quarto de Criança';

  const ChildBedroomPage({
    super.key,
    required this.controller,
    this.environment,
  });

  @override
  Widget build(BuildContext context) {
    return GenericEnvironmentPage(
      title: title,
      pageTitle: environment != null ? 'ATUALIZAR AMBIENTE' : 'NOVO AMBIENTE',
      controller: controller,
      environment: environment,
      difficultyOptions: ['Fácil', 'Moderado', 'Crítico'],
      availableItems: [
        EnviromentItensEnum.roupas,
        EnviromentItensEnum.calcados,
        EnviromentItensEnum.brinquedos,
        EnviromentItensEnum.roupasDeCama,
        EnviromentItensEnum.outros,
      ],
      onSave: (environmentData) async {
        // Implementação específica para salvar quarto de criança
        final enviromentController = context.read<EnviromentController>();
               
        await enviromentController.saveEnvironment(
          description: environmentData.description,
          metragem: environmentData.metragem ?? '',
          difficulty: environmentData.difficulty,
          observation: environmentData.observation,
          selectedItens: environmentData.itens ?? {},
          listaImagens: environmentData.imagens ?? [],
        );
      },
      onUpdate: (environmentData) async {
        // Implementação específica para atualizar quarto de criança
        final enviromentController = context.read<EnviromentController>();
        
        await enviromentController.updateEnvironment(environmentData);
      },
    );
  }


}