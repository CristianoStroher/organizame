import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_checkboxlist.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';

class ChildBedroomPage extends StatefulWidget {
  final TechnicalVisitController technicalVisitController;

  const ChildBedroomPage({super.key, required this.technicalVisitController});

  @override
  State<ChildBedroomPage> createState() => _ChildBedroomPageState();
}

class _ChildBedroomPageState extends State<ChildBedroomPage> {
  late final ChildBedroomController controller;

  final _formkey = GlobalKey<FormState>();
  final _metragemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _observationController = TextEditingController();
  final Map<EnviromentItensEnum, bool> _selectedItens = {};

  String? _selectedDifficulty; // Armazena a dificuldade selecionada

  @override
  void initState() {
    super.initState();
    Logger().d('ChildBedroomPage initState - Controller tem visita: ${widget.technicalVisitController.currentVisit?.id}');
    Logger().d('ID da visita no controller recebido: ${widget.technicalVisitController.currentVisit?.id}');
    
    widget.technicalVisitController.ensureCurrentVisit();
    
    controller = ChildBedroomController(technicalVisitController: widget.technicalVisitController);
    
    _selectedItens[EnviromentItensEnum.roupas] = false;
    _selectedItens[EnviromentItensEnum.calcados] = false;
    _selectedItens[EnviromentItensEnum.brinquedos] = false;
    _selectedItens[EnviromentItensEnum.roupasDeCama] = false;
    _selectedItens[EnviromentItensEnum.outros] = false;
  }

  
  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      'Roupas',
      'Calçados',
      'Brinquedos',
      'Roupas de Cama/Cobertas',
      'Outros',
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Quarto de Crianças',
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
        key: _formkey,
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
                OrganizameTextformfield(
                  label: 'Descrição',
                  enabled: true,
                  controller: _descriptionController,
                ),
                const SizedBox(height: 10),
                OrganizameTextformfield(
                  label: 'Metragem 2',
                  enabled: true,
                  controller: _metragemController,
                ),
                const SizedBox(height: 10),
                OrganizameDropdownfield(
                  label: 'Dificuldade',
                  options: [
                    'Fácil',
                    'Moderado',
                    'Crítico',
                  ],
                  selectedOptions: _selectedDifficulty, // Valor selecionado
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                OrganizameCheckboxlist(
                  options: options,
                  color: const Color(0xFFFAFFC5),
                ),
                const SizedBox(height: 10),
                OrganizameTextField(
                  label: 'Observações',
                  maxLines: 4,
                  controller: _observationController,
                ),
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
                  onPressed: _saveEnvironment,
                  label: 'Adicionar',
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

  void _saveEnvironment() async {
    if (_formkey.currentState!.validate()) {
      try {
        final environment = await controller.saveEnvironment(
          description: _descriptionController.text,
          metragem: _metragemController.text,
          difficulty: _selectedDifficulty,
          observation: _observationController.text,
          selectedItens: _selectedItens,
        );

        if (mounted) {
          Messages.of(context).showInfo('Ambiente salvo com sucesso!');
          Navigator.of(context).pop(environment);
        }
      } catch (e) {
        Logger().e('Erro ao salvar ambiente: $e');
        Messages.of(context).showError('Erro ao salvar ambiente');
      }
    }
  }
}
