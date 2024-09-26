import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';

class VisitHeader extends StatelessWidget {
  const VisitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Text(widget.task == null ? 'NOVA VISITA TÉCNICA' : 'ALTERAR VISITA TÉCNICA',
        //   style: context.titleDefaut),
        children: [
          Text('NOVA VISITA TÉCNICA', style: context.titleDefaut),
          const SizedBox(height: 20),
          // Row(
          //   children: [
          //     Expanded(
          //       child: OrganizameCalendarButton(
          //         // controller: dateEC,
          //       ),
          //     ),
          //     const SizedBox(width: 20),
          //     Expanded(
          //       child: OrganizameTimeButton(
          //         // controller: timeEC,
          //         label: 'Hora',
          //       ),
          //     ),
          //   ],
          // ),
          OrganizameTextformfield(
            label: 'Cliente',
            hintText: 'Nome completo',
          ),
          const SizedBox(height: 20),
          OrganizameTextformfield(
            label: 'Telefone',
            hintText: '(99) 99999-9999',
          ),
          const SizedBox(height: 20),
          OrganizameTextformfield(
            label: 'Endereço',
            hintText: 'Rua, número, bairro',
          ),
          const SizedBox(height: 20),
          OrganizameElevatedButton(
            onPressed: () {},
            label: 'Adicionar Cliente',
            textColor: context.scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }
}
