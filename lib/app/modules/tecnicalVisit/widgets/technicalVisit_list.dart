import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/models/enviroment_object3.dart';
import 'package:organizame/app/modules/environment/widgets/enviroment.dart';

class TechnicalvisitList extends StatelessWidget {
  final List<EnvironmentObject> environments;

  const TechnicalvisitList({
    super.key,
    required this.environments,
  });

  @override
  Widget build(BuildContext context) {
    if (environments.isEmpty) {
      return const Text('Nenhum ambiente cadastrado');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AMBIENTES', style: context.titleDefaut),

          const SizedBox(height: 10),
          // Exibe a lista de ambientes dinamicamente
          Column(
            children: environments.map((environment) {
              return Enviroment(
                enviromentName: environment.name,
                enviromentPhone: environment.difficulty,
                enviromentAdress: environment.observation ?? '',
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          OrganizameElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/environment');
            },
            label: 'Adicionar Ambiente',
            textColor: const Color(0xFFFAFFC5),
          ),
        ],
      ),
    );
  }
}
