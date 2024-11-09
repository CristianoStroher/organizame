import 'package:flutter/material.dart';
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

Future<void> _navigateToEnvironmentPage(
    BuildContext context, TechnicalVisitController controller) async {
  if (controller.canAddEnvironments()) {
    final currentVisit = controller.currentVisit;
if (currentVisit != null) {
        controller.setCurrentVisit(currentVisit); // Garante que o ID está salvo
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<TechnicalVisitController>.value(
              value: controller,
              child: EnviromentPage(technicalVisitController: controller), // Primeiro abre a página de seleção de ambiente
            ),
          ),
        );
      }
  }
}

class _TechnicalvisitListState extends State<TechnicalvisitList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TechnicalVisitController>(
      builder: (context, controller, _) {
        final environments = controller.currentEnvironments;
        final bool canAddEnvironment = controller.canAddEnvironments();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AMBIENTES', style: context.titleDefaut),
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
                      enviromentDescription: environment.observation ?? '',
                      // onDelete: () => controller.removeEnvironment(environment),
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
