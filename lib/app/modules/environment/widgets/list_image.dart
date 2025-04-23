import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/imagens_object.dart';

class ListImage extends StatefulWidget {
  final EnviromentObject? environment;
  final Function(String)? onImageCaptured;
  final Function(ImagensObject)? onImageDeleted;
  final Function(ImagensObject, String)? onImageEdited;
  final Color buttonTextColor;
  
  
  const ListImage({
    super.key,
    this.environment,
    this.onImageCaptured,
    this.onImageDeleted,
    this.onImageEdited,
    required this.buttonTextColor,
  });

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
              return _buildImageCard(imagem);
            },
          ),
        const SizedBox(height: 16),
        OrganizameElevatedButton(
          label: 'Adicionar Imagens',
          onPressed: _handleImageCapture,
          textColor: widget.buttonTextColor,
        ),
      ],
    );
  }

  Widget _buildImageCard(ImagensObject imagem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: _buildImageWidget(imagem),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      onPressed: () => _editImageDescription(imagem),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.delete,
                      onPressed: () => _deleteImage(imagem),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildImageInfo(imagem),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildImageInfo(ImagensObject imagem) {
    return Padding(
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
    );
  }

  Widget _buildImageWidget(ImagensObject imagem) {
    final bool isStorageUrl = imagem.filePath.startsWith('http');
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: isStorageUrl
          ? Image.network(
              imagem.filePath,
              fit: BoxFit.cover,
              loadingBuilder: _buildLoadingWidget,
              errorBuilder: _buildErrorWidget,
            )
          : Image.file(
              File(imagem.filePath),
              fit: BoxFit.cover,
              errorBuilder: _buildErrorWidget,
            ),
    );
  }

  Widget _buildLoadingWidget(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
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
  }

  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stack) {
    Logger().e('Erro ao carregar imagem: $error');
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.error, color: Colors.red),
    );
  }

  Future<void> _handleImageCapture() async {
    try {
      final description = await _showDescriptionDialog();
      if (description != null && description.isNotEmpty) {
        await widget.onImageCaptured?.call(description);
        setState(() {});
      }
    } catch (e) {
      Logger().e('Erro ao capturar imagem: $e');
      if (mounted) {
        Messages.of(context).showError('Erro ao capturar imagem');
      }
    }
  }

  Future<void> _editImageDescription(ImagensObject imagem) async {
    final newDescription = await _showDescriptionDialog(
      initialValue: imagem.description,
    );
    if (newDescription != null && newDescription != imagem.description) {
      await widget.onImageEdited?.call(imagem, newDescription);
      setState(() {});
    }
  }

  Future<void> _deleteImage(ImagensObject imagem) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão', style: context.titleMedium),
        content: const Text('Deseja realmente excluir esta imagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.onImageDeleted?.call(imagem);
      setState(() {});
    }
  }

  Future<String?> _showDescriptionDialog({String? initialValue}) {
    final descriptionController = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Descrição da Imagem', style: context.titleMedium),
        content: OrganizameTextformfield(
          enabled: true,
          label: 'Descrição',
          controller: descriptionController,
          validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFAFFC5),
              side: BorderSide(color: context.primaryColor, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Cancelar',
                style: TextStyle(color: context.secondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (descriptionController.text.isNotEmpty) {
                Navigator.pop(context, descriptionController.text);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: context.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text('Confirmar',
                style: TextStyle(color: Color(0xFFFAFFC5))),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}