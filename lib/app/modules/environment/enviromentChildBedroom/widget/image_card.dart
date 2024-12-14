import 'dart:io';

import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class ImageCard extends StatelessWidget {
  final String? description; // Descrição da imagem
  final String? date; // Data formatada
  final String? imagePath; // Caminho da imagem (URL ou local)
  final void Function()? onEdit; // Callback para editar
  final void Function()? onDelete; // Callback para excluir

  const ImageCard({
    super.key,
    this.description = 'Teste',
    this.date,
    this.imagePath,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica se é uma imagem de rede (URL)
    final isNetworkImage = imagePath != null && (imagePath!.startsWith('http') || imagePath!.startsWith('https'));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem com suporte a local ou rede
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
                child: imagePath != null
                    ? (isNetworkImage
                        ? Image.network(
                            imagePath!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                          )
                        : Image.file(
                            File(imagePath!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                          ))
                    : _buildPlaceholder(),
              ),
              // Botões de ação (Editar/Excluir)
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    if (onEdit != null)
                      _buildIconButton(
                        icon: Icons.edit,
                        onPressed: onEdit,
                        color: context.secondaryColor ?? Colors.white,
                      ),
                    const SizedBox(width: 8),
                    if (onDelete != null)
                      _buildIconButton(
                        icon: Icons.delete,
                        onPressed: onDelete,
                        color: context.secondaryColor ?? Colors.white,
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Informações (Descrição e Data)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                if (date != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    date!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder para erros de imagem
  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Botão customizado
  Widget _buildIconButton({
    required IconData icon,
    required void Function()? onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
