import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FotoCapture extends StatefulWidget {
  final Function(File) onFotoTirada;
  final double? tamanhoPreview;

  const FotoCapture({
    Key? key,
    required this.onFotoTirada,
    this.tamanhoPreview = 150,
  }) : super(key: key);

  @override
  State<FotoCapture> createState() => _FotoCaptureState();
}

class _FotoCaptureState extends State<FotoCapture> {
  File? _fotoAtual;
  final ImagePicker _picker = ImagePicker();
  bool _carregando = false;

  Future<bool> _verificarPermissoes() async {
    // Verificar permissão da câmera
    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      statusCamera = await Permission.camera.request();
      if (!statusCamera.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão da câmera é necessária'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    // Verificar permissão de armazenamento
    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      statusStorage = await Permission.storage.request();
      if (!statusStorage.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão de armazenamento é necessária'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _tirarFoto() async {
    if (!await _verificarPermissoes()) return;

    setState(() => _carregando = true);

    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (foto != null) {
        // Criar diretório permanente para a foto
        final dir = await getApplicationDocumentsDirectory();
        final nomeArquivo = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final caminhoDestino = path.join(dir.path, nomeArquivo);

        // Copiar a foto para o diretório permanente
        final arquivoFinal = await File(foto.path).copy(caminhoDestino);

        setState(() {
          _fotoAtual = arquivoFinal;
        });

        widget.onFotoTirada(arquivoFinal);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao capturar foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_fotoAtual != null)
          GestureDetector(
            onTap: () => _mostrarFotoAmpliada(context),
            child: Container(
              width: widget.tamanhoPreview,
              height: widget.tamanhoPreview,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _fotoAtual!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _carregando ? null : _tirarFoto,
          icon: _carregando 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.camera_alt),
          label: Text(_fotoAtual == null ? 'Tirar Foto' : 'Nova Foto'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarFotoAmpliada(BuildContext context) {
    if (_fotoAtual == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Image.file(_fotoAtual!),
            Positioned(
              top: -12,
              right: -12,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}