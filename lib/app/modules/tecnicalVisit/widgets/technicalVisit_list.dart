import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/modules/environment/widgets/enviroment.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:provider/provider.dart';

class TechnicalvisitList extends StatefulWidget {

  const TechnicalvisitList({Key? key}) : super(key: key);

  @override
  State<TechnicalvisitList> createState() => _TechnicalvisitListState();
}

Future<void> _navigateToEnvironmentPage(BuildContext context, TechnicalVisitController controller) async {
  if (controller.canAddEnvironments()) {
    final currentVisit = controller.currentVisit;
    if (currentVisit != null) {
      // Logger().d('Navegando para EnviromentPage com visita: ${currentVisit.id}');
      // Logger().d('Ambientes antes da navegação: ${currentVisit.enviroment?.length ?? 0}');
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ChangeNotifierProvider<TechnicalVisitController>.value(
            value: controller,
            child: EnviromentPage(
                technicalVisitController:
                    controller), // Primeiro abre a página de seleção de ambiente
          ),
        ),
      );
      await controller.refreshVisits();
    }
  }
}

class _TechnicalvisitListState extends State<TechnicalvisitList> {

  @override
  void initState() {
    super.initState();
    // Carrega os dados ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TechnicalVisitController>().refreshVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TechnicalVisitController>(
      builder: (context, controller, _) {
        // Logger().d('Construindo TechnicalvisitList');
        // Logger().d('Visita atual: ${controller.currentVisit?.id}');
        final currentVisit = controller.currentVisit;
        final environments = controller.currentEnvironments;
        final bool canAddEnvironment = controller.canAddEnvironments();
       
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('AMBIENTES', style: context.titleDefaut),
                  const SizedBox(width: 8),
                  Text('(${environments.length})',style: context.titleDefaut),
                ],
              ),
              const SizedBox(height: 10),
              if (environments.isEmpty)
                Text('Nenhum ambiente cadastrado.',
                    style: TextStyle(color: context.primaryColor))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: environments.length,
                  itemBuilder: (context, index) {
                    final environment = environments[index];
                    return Enviroment(
                      enviromentName: environment.name,
                      enviromentDifficulty: environment.difficulty ?? '',
                      enviromentDescription: environment.description ?? '',
                      controller: controller,
                      environmentId: environment.id,
                    );
                  },
                ),
              const SizedBox(height: 20),
              OrganizameElevatedButton(
                onPressed: () {
                  _navigateToEnvironmentPage(context, controller);
                },
                label: 'Adicionar Ambiente',
                textColor: controller.canAddEnvironments()
                    ? const Color(0xFFFAFFC5)
                    : const Color.fromARGB(255, 253, 253, 253),
                backgroundColor: controller.canAddEnvironments()
                    ? context.primaryColor
                    : const Color.fromARGB(255, 189, 189, 222),
              )
            ],
          ),
        );
      },
    );
  }
}
