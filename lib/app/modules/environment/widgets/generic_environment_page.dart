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
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service_impl.dart';
import 'package:provider/provider.dart';

class GenericEnvironmentPage extends StatefulWidget {
  final String title; // Título do ambiente
  final String pageTitle; // Título da página (novo/atualizar ambiente)
  final TechnicalVisitController controller;
  final EnviromentObject? environment;
  final List<String> difficultyOptions; // Opções de dificuldade
  final List<EnviromentItensEnum>
      availableItems; // Itens disponíveis para este ambiente
  final Function(EnviromentObject) onSave; // Callback para salvar
  final Function(EnviromentObject) onUpdate; // Callback para atualizar

  const GenericEnvironmentPage({
    super.key,
    required this.title,
    required this.pageTitle,
    required this.controller,
    this.environment,
    required this.difficultyOptions,
    required this.availableItems,
    required this.onSave,
    required this.onUpdate,
  });

  @override
  State<GenericEnvironmentPage> createState() => _GenericEnvironmentPageState();
}

class _GenericEnvironmentPageState extends State<GenericEnvironmentPage> {
  final _formkey = GlobalKey<FormState>();
  final _metragemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _observationController = TextEditingController();
  final Map<EnviromentItensEnum, bool> _selectedItens = {};
  String? _selectedDifficulty;
  late final EnviromentImagesService _imagesService;

  @override
  void initState() {
    super.initState();
    _imagesService = EnviromentImagesServiceImpl(
      repository: context.read<EnviromentImagesRepository>(),
    );
    widget.controller.ensureCurrentVisit();

    if (widget.environment != null) {
      _initializeWithExistingEnvironment();
    } else {
      _initializeNewEnvironment();
    }
  }

  void _initializeWithExistingEnvironment() {
    if (widget.environment != null) {
      _metragemController.text = widget.environment!.metragem ?? '';
      _descriptionController.text = widget.environment!.descroiption;
      _observationController.text = widget.environment!.observation ?? '';
      _selectedDifficulty = widget.environment!.difficulty;

      final itens = widget.environment!.itens ?? {};
      for (var item in widget.availableItems) {
        _selectedItens[item] = itens[item.name] ?? false;
      }
    }
  }

  void _initializeNewEnvironment() {
    for (var item in widget.availableItems) {
      _selectedItens[item] = false;
    }
  }

  Map<String, bool> convertSelectedItensToMap() {
    Map<String, bool> result = {};
    for (var item in widget.availableItems) {
      result[item.name] = _selectedItens[item] ?? false;
    }
    return result;
  }

  Future<void> _handleSaveOrUpdate() async {
    if (_formkey.currentState!.validate()) {
      try {
        final environmentData = EnviromentObject(
          id: widget.environment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Corrigido
          name: widget.title,
          descroiption: _descriptionController.text,
          metragem: _metragemController.text,
          difficulty: _selectedDifficulty,
          observation: _observationController.text,
          itens: convertSelectedItensToMap(),
          imagens: widget.environment?.imagens,
        );

        if (widget.environment != null) {
          await widget.onUpdate(environmentData);
        } else {
          await widget.onSave(environmentData);
        }

        if (mounted) {
          Messages.of(context).showInfo(
            widget.environment != null
                ? 'Ambiente atualizado com sucesso!'
                : 'Ambiente criado com sucesso!',
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          await widget.controller.refreshVisits();
        }
      } catch (e) {
        Logger().e('Erro ao salvar/atualizar ambiente: $e');
        if (mounted) {
          Messages.of(context).showError('Erro ao salvar ambiente');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: widget.title,
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
            onPressed: () => Navigator.of(context).pop(),
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
                Text(widget.pageTitle, style: context.titleDefaut),
                const SizedBox(height: 20),
                OrganizameTextformfield(
                  label: 'Descrição',
                  enabled: true,
                  controller: _descriptionController,
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 10),
                OrganizameTextformfield(
                  label: 'Metragem',
                  enabled: true,
                  controller: _metragemController,
                ),
                const SizedBox(height: 10),
                OrganizameDropdownfield(
                  label: 'Dificuldade',
                  options: widget.difficultyOptions,
                  selectedOptions: _selectedDifficulty,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                OrganizameCheckboxlist(
                  capitalizeFirstLetter: true,
                  options:
                      widget.availableItems.map((e) => e.displayName).toList(),
                  color: const Color(0xFFFAFFC5),
                  initialValues: _selectedItens.map(
                    (key, value) => MapEntry(key.displayName, value),
                  ),
                  onChanged: (Map<String, bool> newValues) {
                    setState(() {
                      for (var item in widget.availableItems) {
                        _selectedItens[item] =
                            newValues[item.displayName] ?? false;
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                OrganizameTextField(
                  label: 'Observações',
                  maxLines: 4,
                  controller: _observationController,
                ),
                const SizedBox(height: 20),
                OrganizameElevatedButton(
                  onPressed: _handleSaveOrUpdate,
                  label: widget.environment != null ? 'Atualizar' : 'Salvar',
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

  @override
  void dispose() {
    _metragemController.dispose();
    _descriptionController.dispose();
    _observationController.dispose();
    super.dispose();
  }
}
