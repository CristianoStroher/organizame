import 'package:flutter/material.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_controller.dart';
import 'package:organizame/app/modules/environment/widgets/generic_environment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:provider/provider.dart';

class ChildBedroomPage extends StatelessWidget {
  final TechnicalVisitController controller;
  final EnviromentObject? environment;

  const ChildBedroomPage({
    super.key,
    required this.controller,
    this.environment,
  });

  @override
  Widget build(BuildContext context) {
    return GenericEnvironmentPage(
      title: 'Quarto de Criança',
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
        final childBedroomController = ChildBedroomController(
          controller: controller,
          imagenService: context.read<EnviromentImagesService>(),
        );
        
        await childBedroomController.saveEnvironment(
          description: environmentData.descroiption,
          metragem: environmentData.metragem ?? '',
          difficulty: environmentData.difficulty,
          observation: environmentData.observation,
          selectedItens: environmentData.itens ?? {},
          listaImagens: environmentData.imagens ?? [],
        );
      },
      onUpdate: (environmentData) async {
        // Implementação específica para atualizar quarto de criança
        final childBedroomController = ChildBedroomController(
          controller: controller,
          imagenService: context.read<EnviromentImagesService>(),
        );
        
        await childBedroomController.updateEnvironment(environmentData);
      },
    );
  }
}