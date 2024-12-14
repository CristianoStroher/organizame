import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_controller.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/widget/list_image.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service_impl.dart';
import 'package:provider/provider.dart';

class ChildBedroomPage extends StatefulWidget {
  final TechnicalVisitController controller;
  final EnviromentObject? environment;

  const ChildBedroomPage({
    super.key,
    required this.controller,
    this.environment,
  });

  @override
  State<ChildBedroomPage> createState() => _ChildBedroomPageState();
}

class _ChildBedroomPageState extends State<ChildBedroomPage> {
  late final ChildBedroomController controller;
  late final EnviromentImagesService _imagesService;

  final _formkey = GlobalKey<FormState>();
  final _metragemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _observationController = TextEditingController();
  final Map<EnviromentItensEnum, bool> _selectedItens = {};
  List<XFile>? imagem; // Armazena a imagem capturada

  String? _selectedDifficulty; // Armazena a dificuldade selecionada

  @override
  void initState() {
    super.initState();
    _imagesService = EnviromentImagesServiceImpl(
      repository: context.read<EnviromentImagesRepository>(),
    );
    widget.controller.ensureCurrentVisit();

    controller = ChildBedroomController(
      controller: widget.controller,
      imagenService: _imagesService,
    );

    // Inicializa os campos com os dados existentes
    if (widget.environment != null) {
      _initializeWithExistingEnvironment();
    } else {
      _initializeNewEnvironment();
    }
  }

  //? Função para inicializar o ambiente com os dados existentes
  void _initializeWithExistingEnvironment() {
    if (widget.environment != null) {
      Logger().d("Ambiente recebido: ${widget.environment}");
      Logger().d("Imagens do ambiente: ${widget.environment?.imagens?.length ?? 0}");

      _metragemController.text = widget.environment!.metragem ?? '';
      _descriptionController.text = widget.environment!.descroiption;
      _observationController.text = widget.environment!.observation ?? '';
      _selectedDifficulty = widget.environment!.difficulty;

      // Atualiza o ambiente no controller (incluindo imagens)
      controller.setCurrentEnvironment(widget.environment!);

      // Se existirem imagens, adiciona à lista de imagens do controller
      if (widget.environment!.imagens != null) {
        for (var imagem in widget.environment!.imagens!) {
          Logger().d('Imagem carregada: ${imagem.filePath}');
          // Adiciona à lista de imagens do controller se ainda não existir
          if (!controller.listaImagens.any((img) => img.id == imagem.id)) {
            controller.addImageToList(imagem);
          }
        }
      }

      final itens = widget.environment!.itens ?? {};
      Logger().d("Itens do ambiente: $itens");

      _selectedItens[EnviromentItensEnum.roupas] = itens[EnviromentItensEnum.roupas.name] ?? false;
      _selectedItens[EnviromentItensEnum.calcados] = itens[EnviromentItensEnum.calcados.name] ?? false;
      _selectedItens[EnviromentItensEnum.brinquedos] = itens[EnviromentItensEnum.brinquedos.name] ?? false;
      _selectedItens[EnviromentItensEnum.roupasDeCama] = itens[EnviromentItensEnum.roupasDeCama.name] ?? false;
      _selectedItens[EnviromentItensEnum.outros] = itens[EnviromentItensEnum.outros.name] ?? false;
    }
  }

 //? Função para inicializar um novo ambiente
  void _initializeNewEnvironment() {
    _selectedItens[EnviromentItensEnum.roupas] = false;
    _selectedItens[EnviromentItensEnum.calcados] = false;
    _selectedItens[EnviromentItensEnum.brinquedos] = false;
    _selectedItens[EnviromentItensEnum.roupasDeCama] = false;
    _selectedItens[EnviromentItensEnum.outros] = false;
  }

  @override
  void dispose() {
    _metragemController.dispose();
    _descriptionController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  bool ensureBoolValue(bool? value) {
    return value ?? false;
  }

// Função para converter o mapa de itens para o formato correto
  Map<String, bool> convertSelectedItensToMap() {
    return {
      EnviromentItensEnum.roupas.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.roupas]),
      EnviromentItensEnum.calcados.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.calcados]),
      EnviromentItensEnum.brinquedos.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.brinquedos]),
      EnviromentItensEnum.roupasDeCama.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.roupasDeCama]),
      EnviromentItensEnum.outros.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.outros]),
    };
  }

// Função para atualizar os itens selecionados a partir de um mapa
  void updateSelectedItens(Map<String, bool> newValues) {
    setState(() {
      for (final item in EnviromentItensEnum.values) {
        _selectedItens[item] = newValues[item.name] ?? false;
      }
    });
  }

  //? Função para salvar ou atualizar o ambiente
  Future<void> _handleSaveOrUpdate() async {
    if (_formkey.currentState!.validate()) {
      try {
        if (widget.environment != null) {
          await _updateExistingEnvironment();
        } else {
          await _createNewEnvironment();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
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

  //? Função para atualizar um ambiente existente
  Future<void> _updateExistingEnvironment() async {
    try {
      Logger()
          .d('Iniciando atualização do ambiente: ${widget.environment!.id}');

      // Criar um mapa intermediário com valores não nulos
      final Map<String, bool> itensMap = {
        EnviromentItensEnum.roupas.name: _selectedItens[EnviromentItensEnum.roupas] ?? false,
        EnviromentItensEnum.calcados.name: _selectedItens[EnviromentItensEnum.calcados] ?? false,
        EnviromentItensEnum.brinquedos.name: _selectedItens[EnviromentItensEnum.brinquedos] ?? false,
        EnviromentItensEnum.roupasDeCama.name: _selectedItens[EnviromentItensEnum.roupasDeCama] ?? false,
        EnviromentItensEnum.outros.name: _selectedItens[EnviromentItensEnum.outros] ?? false,
      };

      final updatedEnvironment = EnviromentObject(
        id: widget.environment!.id,
        name: 'QUARTO CRIANÇA',
        descroiption: _descriptionController.text,
        metragem: _metragemController.text,
        difficulty: _selectedDifficulty,
        observation: _observationController.text,
        itens: itensMap,
        imagens: widget.environment!.imagens,
      );

      // metodo para atualizar o ambiente
      Logger().d('Itens a serem atualizados: $itensMap');
      await controller.updateEnvironment(updatedEnvironment);

      if (mounted) {
        Messages.of(context).showInfo('Ambiente atualizado com sucesso!');
      }
    } catch (e) {
      Logger().e('Erro ao atualizar ambiente: $e');
      if (mounted) {
        Messages.of(context).showError('Erro ao atualizar ambiente');
      }
      rethrow;
    }
  }

  //? Função para criar um novo ambiente
  Future<void> _createNewEnvironment() async {
    try {
      // Convertendo o Map<EnviromentItensEnum, bool> para Map<String, bool>
      final Map<String, bool> itensMap = {
        EnviromentItensEnum.roupas.name: _selectedItens[EnviromentItensEnum.roupas] ?? false,
        EnviromentItensEnum.calcados.name: _selectedItens[EnviromentItensEnum.calcados] ?? false,
        EnviromentItensEnum.brinquedos.name: _selectedItens[EnviromentItensEnum.brinquedos] ?? false,
        EnviromentItensEnum.roupasDeCama.name: _selectedItens[EnviromentItensEnum.roupasDeCama] ?? false,
        EnviromentItensEnum.outros.name: _selectedItens[EnviromentItensEnum.outros] ?? false,
      };
      print("itens map => $itensMap");
      await controller.saveEnvironment(
        description: _descriptionController.text,
        metragem: _metragemController.text,
        difficulty: _selectedDifficulty,
        observation: _observationController.text,
        selectedItens: itensMap,
        listaImagens: controller.listaImagens, // Lista de imagens
        
      );

      Logger().d('Ambiente criado com sucesso!');

      if (mounted) {
        Messages.of(context).showInfo('Ambiente criado com sucesso!');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      Logger().e('Erro ao criar novo ambiente: $e');
      if (mounted) {
        Messages.of(context).showError('Erro ao criar ambiente');
      }
      rethrow;
    }
  }
  
  //? contrução da tela
  @override
  Widget build(BuildContext context) {
    final lista = controller.listaImagens;
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
          text: 'Quarto de Criança',
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
                Text(
                    widget.environment != null
                        ? 'ATUALIZAR AMBIENTE'
                        : 'NOVO AMBIENTE',
                    style: context.titleDefaut),
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
                  capitalizeFirstLetter: true,
                  options: [
                    EnviromentItensEnum.roupas.name,
                    EnviromentItensEnum.calcados.name,
                    EnviromentItensEnum.brinquedos.name,
                    EnviromentItensEnum.roupasDeCama.name,
                    EnviromentItensEnum.outros.name,
                  ],
                  color: const Color(0xFFFAFFC5),
                  initialValues: {
                    EnviromentItensEnum.roupas.name:
                        _selectedItens[EnviromentItensEnum.roupas] ?? false,
                    EnviromentItensEnum.calcados.name:
                        _selectedItens[EnviromentItensEnum.calcados] ?? false,
                    EnviromentItensEnum.brinquedos.name:
                        _selectedItens[EnviromentItensEnum.brinquedos] ?? false,
                    EnviromentItensEnum.roupasDeCama.name:
                        _selectedItens[EnviromentItensEnum.roupasDeCama] ??
                            false,
                    EnviromentItensEnum.outros.name:
                        _selectedItens[EnviromentItensEnum.outros] ?? false,
                  },
                  onChanged: (Map<String, bool> newValues) {
                    print("new values => $newValues ");
                    setState(() {
                      _selectedItens[EnviromentItensEnum.calcados] =
                          newValues[EnviromentItensEnum.calcados.name] ?? false;
                      _selectedItens[EnviromentItensEnum.brinquedos] =
                          newValues[EnviromentItensEnum.brinquedos.name] ??
                              false;
                      _selectedItens[EnviromentItensEnum.roupasDeCama] =
                          newValues[EnviromentItensEnum.roupasDeCama.name] ??
                              false;
                      _selectedItens[EnviromentItensEnum.outros] =
                          newValues[EnviromentItensEnum.outros.name] ?? false;
                    });
                    print(
                        " _selectedItens[EnviromentItensEnum.roupasDeCama] => ${_selectedItens[EnviromentItensEnum.roupasDeCama]}");
                  },
                ),
                const SizedBox(height: 10),
                OrganizameTextField(
                  label: 'Observações',
                  maxLines: 4,
                  controller: _observationController,
                ),
                const SizedBox(height: 20),
                Text('IMAGENS (${lista.length})', style: context.titleDefaut,
                ),
                const SizedBox(height: 20),
                ListImage(controller: controller),
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
}
