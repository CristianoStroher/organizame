import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';

class Environment extends StatelessWidget {

  const Environment({ super.key });

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Text(widget.task == null ? 'NOVA VISITA TÉCNICA' : 'ALTERAR VISITA TÉCNICA',
        //   style: context.titleDefaut),
        children: [
          Text('AMBIENTES', style: context.titleDefaut),
          Divider(
            thickness: 1, // Define a espessura da linha
            color: context.secondaryColor, // Cor da linha

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