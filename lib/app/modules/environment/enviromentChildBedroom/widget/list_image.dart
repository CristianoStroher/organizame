import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_controller.dart';

class ListImage extends StatefulWidget {
  final EnviromentObject? environment;
  final DefautChangeNotifer _controller;
  
  const ListImage({
    super.key,
    this.environment,
    required ChildBedroomController controller,
    }) : _controller = controller;

  @override
  State<ListImage> createState() => _ListImageState();
}

class _ListImageState extends State<ListImage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.environment?.imagens?.isNotEmpty == true)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.environment!.imagens!.length,
            itemBuilder: (context, index) {
              final imagem = widget.environment!.imagens![index];
              Logger().d('Construindo imagem: ${imagem.filePath}');
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Imagem com tratamento para URL/Local
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: _buildImageWidget(imagem),
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
                                  onPressed: () => {}
                                      //_editImageDescription(imagem),
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
                                  onPressed: () => {}//_deleteImage(imagem),
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
          onPressed: (){} , // _captureImage,
          textColor: const Color(0xFFFAFFC5),
        ),
      ],
    );
  }

  //? Método auxiliar para construir a imagem
  Widget _buildImageWidget(ImagensObject imagem) {
    final bool isStorageUrl = imagem.filePath.startsWith('http');
    Logger().d('Tipo de imagem: ${isStorageUrl ? "Storage URL" : "Local"}');
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: isStorageUrl
          ? Image.network(
              imagem.filePath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.primaryColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) {
                Logger().e('Erro ao carregar imagem: $error');
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            )
          : Image.file(
              File(imagem.filePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                Logger().e('Erro ao carregar imagem local: $error');
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // //? Função para capturar a imagem
  // Future<void> _captureImage() async {
  //   try {
  //     Logger().d('Ambiente atual antes de capturar: ${widget.environment?.id}');

  //     //? Primeiro obtém a descrição
  //     final description = await _showDescriptionDialog();

  //     //? verifica se a descrição foi preenchida
  //     if (description != null) {
  //       //? Chama o controller para capturar a imagem
  //       await widget._controller.captureImage(description: description);
  //       //? Atualiza a UI com a imagem capturada
  //       if (imagem != null && mounted) {
  //         await widget._controller.refreshVisits();
  //         //? Atualiza a UI com a imagem capturada
  //         setState(() {}); // Atualiza a UI
  //         Messages.of(context).showInfo('Imagem adicionada com sucesso!');
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       Messages.of(context).showError('Erro ao capturar imagem');
  //     }
  //   }
  // }

  // //? Função para mostrar o dialogo de descrição
  // Future<String?> _showDescriptionDialog() {
  //   final descriptionController = TextEditingController();
  //   return showDialog<String>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Descrição da Imagem', style: context.titleMedium),
  //       content: OrganizameTextformfield(
  //         enabled: true,
  //         label: 'Descrição',
  //         controller: descriptionController,
  //         validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           style: TextButton.styleFrom(
  //             backgroundColor: Color(0xFFFAFFC5),
  //             side: BorderSide(color: context.primaryColor, width: 1),
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //             ),
  //           ),
  //           child: Text('Cancelar',
  //               style: TextStyle(color: context.secondaryColor)),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (descriptionController.text.isNotEmpty) {
  //               Navigator.pop(context, descriptionController.text);
  //             }
  //           },
  //           style: TextButton.styleFrom(
  //             backgroundColor: context.primaryColor,
  //             side: BorderSide(color: context.primaryColor, width: 1),
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //             ),
  //           ),
  //           child: Text('Confirmar',
  //               style: TextStyle(color: Color(0xFFFAFFC5))),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // //? Função para juntar a captura da imagem com a descrição
  // Future<void> _handleImageCapture() async {
  //   try {
  //     //? Primeiro obtém a descrição
  //     final description = await _showDescriptionDialog();

  //     //? Se não tiver descrição, cancela o processo
  //     if (description == null || description.isEmpty) {
  //       return;
  //     }

  //     //? Chama o controller para capturar a imagem
  //     await widget._controller.captureImage(description: description);
  //     Logger().d('Imagem capturada com sucesso!');
  //     //? Atualiza a UI com a imagem capturada
  //     setState(() {
  //       Logger().d('Atualizando UI com imagem capturada');
  //     });

  //     //? Feedback de sucesso
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Imagem capturada com sucesso!')),
  //       );
  //     }
  //   } catch (e) {
  //     // Tratamento de erro na view
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Erro ao capturar imagem: $e')),
  //       );
  //     }
  //   }
  // }

  
  // //? Método auxiliar para construir a imagem
  // Widget _buildImageWidget(ImagensObject imagem) {
  //   final bool isStorageUrl = imagem.filePath.startsWith('http');
  //   Logger().d('Tipo de imagem: ${isStorageUrl ? "Storage URL" : "Local"}');
  //   return SizedBox(
  //     height: 200,
  //     width: double.infinity,
  //     child: isStorageUrl
  //         ? Image.network(
  //             imagem.filePath,
  //             fit: BoxFit.cover,
  //             loadingBuilder: (context, child, loadingProgress) {
  //               if (loadingProgress == null) return child;
  //               return Container(
  //                 color: Colors.grey[200],
  //                 child: Center(
  //                   child: CircularProgressIndicator(
  //                     color: context.primaryColor,
  //                     value: loadingProgress.expectedTotalBytes != null
  //                         ? loadingProgress.cumulativeBytesLoaded /
  //                             loadingProgress.expectedTotalBytes!
  //                         : null,
  //                   ),
  //                 ),
  //               );
  //             },
  //             errorBuilder: (context, error, stack) {
  //               Logger().e('Erro ao carregar imagem: $error');
  //               return Container(
  //                 color: Colors.grey[200],
  //                 child: const Icon(Icons.error, color: Colors.red),
  //               );
  //             },
  //           )
  //         : Image.file(
  //             File(imagem.filePath),
  //             fit: BoxFit.cover,
  //             errorBuilder: (context, error, stackTrace) {
  //               Logger().e('Erro ao carregar imagem local: $error');
  //               return Container(
  //                 color: Colors.grey[200],
  //                 child: const Icon(Icons.error, color: Colors.red),
  //               );
  //             },
  //           ),
  //   );
  // }
}
