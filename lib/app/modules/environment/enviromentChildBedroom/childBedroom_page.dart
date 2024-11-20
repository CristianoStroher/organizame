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
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_controller.dart';
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

  void _initializeWithExistingEnvironment() {
    if (widget.environment != null) {
      Logger().d("Ambiente recebido: ${widget.environment}");
      _metragemController.text = widget.environment!.metragem ?? '';
      _descriptionController.text = widget.environment!.descroiption ?? '';
      _observationController.text = widget.environment!.observation ?? '';
      _selectedDifficulty = widget.environment!.difficulty;

      final itens = widget.environment!.itens ?? {};
      Logger().d("Itens do ambiente: $itens");

      _selectedItens[EnviromentItensEnum.roupas] = itens[EnviromentItensEnum.roupas.name] ?? false;
      _selectedItens[EnviromentItensEnum.calcados] = itens[EnviromentItensEnum.calcados.name] ?? false;
      _selectedItens[EnviromentItensEnum.brinquedos] = itens[EnviromentItensEnum.brinquedos.name] ?? false;
      _selectedItens[EnviromentItensEnum.roupasDeCama] = itens[EnviromentItensEnum.roupasDeCama.name] ?? false;
      _selectedItens[EnviromentItensEnum.outros] = itens[EnviromentItensEnum.outros.name] ?? false;
    }
  }

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
      EnviromentItensEnum.roupas.name:
          ensureBoolValue(_selectedItens[EnviromentItensEnum.roupas]),
      EnviromentItensEnum.calcados.name:
          ensureBoolValue(_selectedItens[EnviromentItensEnum.calcados]),
      EnviromentItensEnum.brinquedos.name:
          ensureBoolValue(_selectedItens[EnviromentItensEnum.brinquedos]),
      EnviromentItensEnum.roupasDeCama.name:
          ensureBoolValue(_selectedItens[EnviromentItensEnum.roupasDeCama]),
      EnviromentItensEnum.outros.name:
          ensureBoolValue(_selectedItens[EnviromentItensEnum.outros]),
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
      Logger()
          .d('Iniciando atualização do ambiente: ${widget.environment!.id}');

      // Criar um mapa intermediário com valores não nulos
      final Map<String, bool> itensMap = {
        EnviromentItensEnum.roupas.name:
            _selectedItens[EnviromentItensEnum.roupas] ?? false,
        EnviromentItensEnum.calcados.name:
            _selectedItens[EnviromentItensEnum.calcados] ?? false,
        EnviromentItensEnum.brinquedos.name:
            _selectedItens[EnviromentItensEnum.brinquedos] ?? false,
        EnviromentItensEnum.roupasDeCama.name:
            _selectedItens[EnviromentItensEnum.roupasDeCama] ?? false,
        EnviromentItensEnum.outros.name:
            _selectedItens[EnviromentItensEnum.outros] ?? false,
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
      // Convertendo o Map<EnviromentItensEnum, bool> para Map<String, bool>
      final Map<String, bool> itensMap = {
        EnviromentItensEnum.roupas.name:
            _selectedItens[EnviromentItensEnum.roupas] ?? false,
        EnviromentItensEnum.calcados.name:
            _selectedItens[EnviromentItensEnum.calcados] ?? false,
        EnviromentItensEnum.brinquedos.name:
            _selectedItens[EnviromentItensEnum.brinquedos] ?? false,
        EnviromentItensEnum.roupasDeCama.name:
            _selectedItens[EnviromentItensEnum.roupasDeCama] ?? false,
        EnviromentItensEnum.outros.name:
            _selectedItens[EnviromentItensEnum.outros] ?? false,
      };

      await controller.saveEnvironment(
        description: _descriptionController.text,
        metragem: _metragemController.text,
        difficulty: _selectedDifficulty,
        observation: _observationController.text,
        selectedItens: convertSelectedItensToMap(),
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.environment?.imagens?.isNotEmpty ?? false)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.environment!.imagens!.length,
            itemBuilder: (context, index) {
              final imagem = widget.environment!.imagens![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Imagem
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: Image.network(
                            imagem.filePath,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: context.primaryColor,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child:
                                    const Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        // Botões de ação
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _editImageDescription(imagem),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () => _deleteImage(imagem),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Informações da imagem
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imagem.description?.isNotEmpty == true) ...[
                            Text(
                              'Descrição:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              imagem.description!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            'Data: ${_formatDate(imagem.dateTime)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        OrganizameElevatedButton(
          label: 'Adicionar Imagens',
          onPressed: _captureImage,
          textColor: const Color(0xFFFAFFC5),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _captureImage() async {
    try {
      Logger().d('Ambiente atual antes de capturar: ${widget.environment?.id}');
      final description = await _showDescriptionDialog();
      if (description != null) {
        final imagem = await controller.captureAndUploadImage(description);
        if (imagem != null && mounted) {
          await widget.controller.refreshVisits();
          setState(() {}); // Atualiza a UI
          Messages.of(context).showInfo('Imagem adicionada com sucesso!');
        }
      }
    } catch (e) {
      if (mounted) {
        Messages.of(context).showError('Erro ao capturar imagem');
      }
    }
  }

  Future<String?> _showDescriptionDialog() {
    final descriptionController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descrição da Imagem'),
        content: OrganizameTextformfield(
          enabled: true,
          label: 'Descrição',
          controller: descriptionController,
          validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty) {
                Navigator.pop(context, descriptionController.text);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editImageDescription(ImagensObject imagem) async {
    final newDescription = await _showDescriptionDialog();
    if (newDescription != null && mounted) {
      try {
        await controller.updateImageDescription(imagem.id, newDescription);
        setState(() {}); // Atualiza a UI
        if (mounted) {
          Messages.of(context).showInfo('Descrição atualizada com sucesso!');
        }
      } catch (e) {
        if (mounted) {
          Messages.of(context).showError('Erro ao atualizar descrição');
        }
      }
    }
  }

  Future<void> _deleteImage(ImagensObject imagem) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir esta imagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await controller.deleteImage(imagem);
        setState(() {}); // Atualiza a UI
        if (mounted) {
          Messages.of(context).showInfo('Imagem excluída com sucesso!');
        }
      } catch (e) {
        if (mounted) {
          Messages.of(context).showError('Erro ao excluir imagem');
        }
      }
    }
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
                    EnviromentItensEnum.roupas.displayName,
                    EnviromentItensEnum.calcados.displayName,
                    EnviromentItensEnum.brinquedos.displayName,
                    EnviromentItensEnum.roupasDeCama.displayName,
                    EnviromentItensEnum.outros.displayName,
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
                    setState(() {
                      _selectedItens[EnviromentItensEnum.roupas] =
                          newValues[EnviromentItensEnum.roupas.name] ?? false;
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
                  },
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
                _buildImageSection(),
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
