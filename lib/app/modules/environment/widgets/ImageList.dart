import 'package:flutter/material.dart';
import 'package:organizame/app/models/imagens_object.dart';

class ImageList extends StatelessWidget {
  final List<ImagensObject> imagens;
  final Function(ImagensObject) onDelete;

  const ImageList({
    Key? key,
    required this.imagens,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagens.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma imagem cadastrada',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: imagens.length,
      itemBuilder: (context, index) {
        final imagem = imagens[index];
        return ImageListItem(
          imagem: imagem,
          onDelete: () => onDelete(imagem),
        );
      },
    );
  }
}

class ImageListItem extends StatelessWidget {
  final ImagensObject imagem;
  final VoidCallback onDelete;

  const ImageListItem({
    Key? key,
    required this.imagem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
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
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            
            // Descrição
            if (imagem.description?.isNotEmpty == true) ...[
              Text(
                'Descrição:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                imagem.description ?? '',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
            ],

            // Data
            Text(
              'Data: ${_formatDate(imagem.dateTime)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),

            // Botão de excluir
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmar exclusão'),
                        content: Text('Deseja realmente excluir esta imagem?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            child: Text('Excluir'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    'Excluir',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}