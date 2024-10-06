import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_checkboxlist.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';

class LivingRoomPage extends StatefulWidget {
  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  String? selectedDifficulty; // Armazena a dificuldade selecionada
  final List<String> options = [
    'Roupas',
    'Calçados',
    'Maquiagens',
    'Roupas de Cama/Cobertas',
    'Acessórios',
    'Outros',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Quarto de Casal',
          part1Color: context.primaryColor,
          part2Color: context.primaryColor,
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: context.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Form(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOVO AMBIENTE', style: context.titleDefaut),
                // Text(widget.enviroment == null ? 'NOVO AMBIENTE' : 'ALTERAR AMBIENTE',
                //         style: context.titleDefaut),
                const SizedBox(height: 20),
                OrganizameTextformfield(label: 'Descrição', enabled: true),
                const SizedBox(height: 10),
                OrganizameTextformfield(label: 'Metragem 2', enabled: true),
                const SizedBox(height: 10),
                OrganizameDropdownfield(label: 'Dificuldade', options: [
                  'Fácil',
                  'Moderado',
                  'Crítico',
                ]),
                const SizedBox(height: 10),
                OrganizameCheckboxlist(
                  options: options,
                  color: const Color(0xFFFAFFC5),
                ),
                const SizedBox(
                  height: 10,
                ),
                OrganizameTextField(label: 'Observações', maxLines: 4),
                const SizedBox(height: 20),
                Text('IMAGENS', style: context.titleDefaut),
                const SizedBox(height: 20),
                OrganizameElevatedButton(
                  label: 'Adicionar Imagens',
                  onPressed: () {},
                  textColor: const Color(0xFFFAFFC5),
                ),
                const SizedBox(height: 20),
                OrganizameElevatedButton(
                  onPressed: () {},
                  label: 'Salvar',
                  textColor: const Color(0xFFFAFFC5),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
