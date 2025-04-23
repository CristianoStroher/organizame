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
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service_impl.dart';
import 'package:provider/provider.dart';

class KitchenPage extends StatefulWidget {
  final TechnicalVisitController controller;
  final EnviromentObject? environment;
  

  const KitchenPage({
    super.key,
    this.environment,
    required this.controller,
  });

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  late final KitchenController controller; // Controller da página
  late final EnviromentImagesService _imagesService;
  String? _selectedDifficulty; // Armazena a dificuldade selecionada

  final _formkey = GlobalKey<FormState>();
  final _metragemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _observationController = TextEditingController();
  final Map<EnviromentItensEnum, bool> _selectedItens = {};
  List<XFile>? imagem; // Armazena a imagem capturada

  @override
  void initState() {
    super.initState();
    _imagesService = EnviromentImagesServiceImpl(
      repository: context.read<EnviromentImagesRepository>(),
    );
    widget.controller.ensureCurrentVisit();

    controller = KitchenController(
      controller: widget.controller,
      imagenService: _imagesService,
    );
    
    if (widget.environment != null) {
      _initializeWithExistingEnvironment();
    } else {
      _initializeNewEnvironment();
    }
  }

  void _initializeWithExistingEnvironment() {
    
    if (widget.environment != null) {
      _metragemController.text = widget.environment!.metragem ?? '';
      _descriptionController.text = widget.environment!.description ?? '';
      _observationController.text = widget.environment!.observation ?? '';
      _selectedDifficulty = widget.environment!.difficulty;
    
      controller.setCurrentEnvironment(widget.environment!);

    // Se existirem imagens, adiciona à lista de imagens do controller
      if (widget.environment!.imagens != null) {
        widget.environment!.imagens!.forEach((imagem) {
          Logger().d('Imagem carregada: ${imagem.filePath}');
          // Adiciona à lista de imagens do controller se ainda não existir
          if (!controller.listaImagens.any((img) => img.id == imagem.id)) {
            controller.addImageToList(imagem);
          }
        });
      }

    final itens = widget.environment!.itens ?? {};
   
      _selectedItens[EnviromentItensEnum.alimentos] = itens[EnviromentItensEnum.alimentos.name] ?? false;
      _selectedItens[EnviromentItensEnum.bebidas] = itens[EnviromentItensEnum.bebidas.name] ?? false;
      _selectedItens[EnviromentItensEnum.eletrodomesticos] = itens[EnviromentItensEnum.eletrodomesticos.name] ?? false;
      _selectedItens[EnviromentItensEnum.itensDeMesa] = itens[EnviromentItensEnum.itensDeMesa.name] ?? false;
      _selectedItens[EnviromentItensEnum.loucas] = itens[EnviromentItensEnum.loucas.name] ?? false;
      _selectedItens[EnviromentItensEnum.panelas] = itens[EnviromentItensEnum.panelas.name] ?? false;
      _selectedItens[EnviromentItensEnum.panosDePrato] = itens[EnviromentItensEnum.panosDePrato.name] ?? false;
      _selectedItens[EnviromentItensEnum.produtosDeLimpeza] = itens[EnviromentItensEnum.produtosDeLimpeza.name] ?? false;
      _selectedItens[EnviromentItensEnum.utensilios] = itens[EnviromentItensEnum.utensilios.name] ?? false;
      _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] = itens[EnviromentItensEnum.utensiliosDeLimpeza.name] ?? false;
      _selectedItens[EnviromentItensEnum.outros] = itens[EnviromentItensEnum.outros.name] ?? false;
    }
  }
  
  void _initializeNewEnvironment() {
    _selectedItens[EnviromentItensEnum.alimentos] = false;
    _selectedItens[EnviromentItensEnum.bebidas] = false;
    _selectedItens[EnviromentItensEnum.eletrodomesticos] = false;
    _selectedItens[EnviromentItensEnum.itensDeMesa] = false;
    _selectedItens[EnviromentItensEnum.loucas] = false;
    _selectedItens[EnviromentItensEnum.panelas] = false;
    _selectedItens[EnviromentItensEnum.panosDePrato] = false;
    _selectedItens[EnviromentItensEnum.produtosDeLimpeza] = false;
    _selectedItens[EnviromentItensEnum.utensilios] = false;
    _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] = false;
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
      EnviromentItensEnum.alimentos.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.alimentos]),
      EnviromentItensEnum.bebidas.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.bebidas]),
      EnviromentItensEnum.eletrodomesticos.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.eletrodomesticos]),
      EnviromentItensEnum.itensDeMesa.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.itensDeMesa]),
      EnviromentItensEnum.loucas.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.loucas]),
      EnviromentItensEnum.panelas.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.panelas]),
      EnviromentItensEnum.panosDePrato.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.panosDePrato]),
      EnviromentItensEnum.produtosDeLimpeza.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.produtosDeLimpeza]),
      EnviromentItensEnum.utensilios.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.utensilios]),
      EnviromentItensEnum.utensiliosDeLimpeza.name: ensureBoolValue(_selectedItens[EnviromentItensEnum.utensiliosDeLimpeza]),
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

  Future<void> _updateExistingEnvironment() async {
    try {
      Logger().d('Iniciando atualização do ambiente: ${widget.environment!.id}');
      
       // Criar um mapa intermediário com valores não nulos
    final Map<String, bool> itensMap = {
        EnviromentItensEnum.alimentos.name: _selectedItens[EnviromentItensEnum.alimentos] ?? false,
        EnviromentItensEnum.bebidas.name: _selectedItens[EnviromentItensEnum.bebidas] ?? false,
        EnviromentItensEnum.eletrodomesticos.name: _selectedItens[EnviromentItensEnum.eletrodomesticos] ?? false,
        EnviromentItensEnum.itensDeMesa.name: _selectedItens[EnviromentItensEnum.itensDeMesa] ?? false,
        EnviromentItensEnum.loucas.name: _selectedItens[EnviromentItensEnum.loucas] ?? false,
        EnviromentItensEnum.panelas.name: _selectedItens[EnviromentItensEnum.panelas] ?? false,
        EnviromentItensEnum.panosDePrato.name: _selectedItens[EnviromentItensEnum.panosDePrato] ?? false,
        EnviromentItensEnum.produtosDeLimpeza.name: _selectedItens[EnviromentItensEnum.produtosDeLimpeza] ?? false,
        EnviromentItensEnum.utensilios.name: _selectedItens[EnviromentItensEnum.utensilios] ?? false,
        EnviromentItensEnum.utensiliosDeLimpeza.name: _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] ?? false,
        EnviromentItensEnum.outros.name: _selectedItens[EnviromentItensEnum.outros] ?? false,
      };

      final updatedEnvironment = EnviromentObject(
        id: widget.environment!.id,
        name: 'COZINHA',
        description: _descriptionController.text,
        metragem: _metragemController.text,
        difficulty: _selectedDifficulty,
        observation: _observationController.text,
        itens: itensMap,
      );

      // Use o controller local para atualizar
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

  Future<void> _createNewEnvironment() async {
  try {
    Logger().d('Iniciando criação de novo ambiente');
    
    // Convertendo o Map<EnviromentItensEnum, bool> para Map<String, bool>
    final Map<String, bool> itensMap = {
      EnviromentItensEnum.alimentos.name: _selectedItens[EnviromentItensEnum.alimentos] ?? false,
      EnviromentItensEnum.bebidas.name: _selectedItens[EnviromentItensEnum.bebidas] ?? false,
      EnviromentItensEnum.eletrodomesticos.name: _selectedItens[EnviromentItensEnum.eletrodomesticos] ?? false,
      EnviromentItensEnum.itensDeMesa.name: _selectedItens[EnviromentItensEnum.itensDeMesa] ?? false,
      EnviromentItensEnum.loucas.name: _selectedItens[EnviromentItensEnum.loucas] ?? false,
      EnviromentItensEnum.panelas.name: _selectedItens[EnviromentItensEnum.panelas] ?? false,
      EnviromentItensEnum.panosDePrato.name: _selectedItens[EnviromentItensEnum.panosDePrato] ?? false,
      EnviromentItensEnum.produtosDeLimpeza.name: _selectedItens[EnviromentItensEnum.produtosDeLimpeza] ?? false,
      EnviromentItensEnum.utensilios.name: _selectedItens[EnviromentItensEnum.utensilios] ?? false,
      EnviromentItensEnum.utensiliosDeLimpeza.name: _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] ?? false,
      EnviromentItensEnum.outros.name: _selectedItens[EnviromentItensEnum.outros] ?? false,
    };

    Logger().d('Itens selecionados para o novo ambiente: $itensMap');
    
    await controller.saveEnvironment(
      description: _descriptionController.text,
      metragem: _metragemController.text,
      difficulty: _selectedDifficulty,
      observation: _observationController.text,
      selectedItens: itensMap,  // Passando o mapa convertido
    );

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

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      'Alimentos',
      'Bebidas',
      'Eletrodomésticos',
      'Itens de Mesa',
      'Louças',
      'Panelas',
      'Panos de Prato',
      'Produtos de Limpeza',
      'Utensílios',
      'Utensílios de Limpeza',
      'Outros',
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Cozinha',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
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
                  options: [
                    EnviromentItensEnum.alimentos.name,
                    EnviromentItensEnum.bebidas.name,
                    EnviromentItensEnum.eletrodomesticos.name,
                    EnviromentItensEnum.itensDeMesa.name,
                    EnviromentItensEnum.loucas.name,
                    EnviromentItensEnum.panelas.name,
                    EnviromentItensEnum.panosDePrato.name,
                    EnviromentItensEnum.produtosDeLimpeza.name,
                    EnviromentItensEnum.utensilios.name,
                    EnviromentItensEnum.utensiliosDeLimpeza.name,
                    EnviromentItensEnum.outros.name,
                  ],                    
                  color: const Color(0xFFFAFFC5),
                  initialValues: {
                    EnviromentItensEnum.alimentos.name: _selectedItens[EnviromentItensEnum.alimentos] ?? false,
                    EnviromentItensEnum.bebidas.name: _selectedItens[EnviromentItensEnum.bebidas] ?? false,
                    EnviromentItensEnum.eletrodomesticos.name: _selectedItens[EnviromentItensEnum.eletrodomesticos] ?? false,
                    EnviromentItensEnum.itensDeMesa.name: _selectedItens[EnviromentItensEnum.itensDeMesa] ?? false,
                    EnviromentItensEnum.loucas.name: _selectedItens[EnviromentItensEnum.loucas] ?? false,
                    EnviromentItensEnum.panelas.name: _selectedItens[EnviromentItensEnum.panelas] ?? false,
                    EnviromentItensEnum.panosDePrato.name: _selectedItens[EnviromentItensEnum.panosDePrato] ?? false,
                    EnviromentItensEnum.produtosDeLimpeza.name: _selectedItens[EnviromentItensEnum.produtosDeLimpeza] ?? false,
                    EnviromentItensEnum.utensilios.name: _selectedItens[EnviromentItensEnum.utensilios] ?? false,
                    EnviromentItensEnum.utensiliosDeLimpeza.name: _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] ?? false,
                    EnviromentItensEnum.outros.name: _selectedItens[EnviromentItensEnum.outros] ?? false,
                  },
                  onChanged: (Map<String, bool> newValues) {
                    setState(() {
                      _selectedItens[EnviromentItensEnum.alimentos] = newValues[EnviromentItensEnum.alimentos.name] ?? false;
                      _selectedItens[EnviromentItensEnum.bebidas] = newValues[EnviromentItensEnum.bebidas.name] ?? false;
                      _selectedItens[EnviromentItensEnum.eletrodomesticos] = newValues[EnviromentItensEnum.eletrodomesticos.name] ?? false;
                      _selectedItens[EnviromentItensEnum.itensDeMesa] = newValues[EnviromentItensEnum.itensDeMesa.name] ?? false;
                      _selectedItens[EnviromentItensEnum.loucas] = newValues[EnviromentItensEnum.loucas.name] ?? false;
                      _selectedItens[EnviromentItensEnum.panelas] = newValues[EnviromentItensEnum.panelas.name] ?? false;
                      _selectedItens[EnviromentItensEnum.panosDePrato] = newValues[EnviromentItensEnum.panosDePrato.name] ?? false;
                      _selectedItens[EnviromentItensEnum.produtosDeLimpeza] = newValues[EnviromentItensEnum.produtosDeLimpeza.name] ?? false;
                      _selectedItens[EnviromentItensEnum.utensilios] = newValues[EnviromentItensEnum.utensilios.name] ?? false;
                      _selectedItens[EnviromentItensEnum.utensiliosDeLimpeza] = newValues[EnviromentItensEnum.utensiliosDeLimpeza.name] ?? false;
                      _selectedItens[EnviromentItensEnum.outros] = newValues[EnviromentItensEnum.outros.name] ?? false;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                OrganizameTextField(label: 'Observações', maxLines: 4,
                controller: _observationController,),
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
                  onPressed: _handleSaveOrUpdate,
                  label: widget.environment != null ? 'Atualizar' : 'Adicionar',
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
