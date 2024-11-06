import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/environment/widgets/enviroment.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:provider/provider.dart';

class TechnicalvisitList extends StatelessWidget {
  const TechnicalvisitList({Key? key}) : super(key: key);

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
                  // Se puder adicionar ambientes, permite o clique
                  if (controller.canAddEnvironments()) {
                    Navigator.of(context)
                        .pushNamed('/environment')
                        .then((value) {
                      if (value != null) {
                        controller.addEnvironment(value as EnviromentObject);
                      }
                    });
                  }
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
