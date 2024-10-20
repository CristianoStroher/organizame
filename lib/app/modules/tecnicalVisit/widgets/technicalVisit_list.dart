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

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AMBIENTES', style: context.titleDefaut),
              const SizedBox(height: 10),

              if (environments.isEmpty)
                const Text('Nenhum ambiente cadastrado')
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
                onPressed: () async {
                  final newEnvironment = await Navigator.of(context).pushNamed('/environment') as EnviromentObject?;
                  if (newEnvironment != null) {
                    controller.addEnvironment(newEnvironment);
                  }
                },
                label: 'Adicionar Ambiente',
                textColor: const Color(0xFFFAFFC5),
              ),
            ],
          ),
        );
      },
    );
  }
}