import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class EnviromentCard extends StatelessWidget {
  final Color color; // Cor de fundo ajustada
  final String text;
  final IconData icon;
  final VoidCallback? onTap; // Adiciona suporte a callback para toques

  const EnviromentCard({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.onTap, // Callback opcional para o toque
  });

  @override
  Widget build(BuildContext context) {
    // Obtém a largura da tela
    final screenWidth = MediaQuery.of(context).size.width;

    // Calcula o tamanho da fonte e do ícone baseado na largura da tela
    final fontSize = screenWidth * 0.045; // 4.2% da largura da tela
    final iconSize = screenWidth * 0.09; // 8% da largura da tela para o ícone

    return InkWell(
      onTap: onTap, // Executa ação quando o card é tocado
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.secondaryColor, // Cor da borda ajustada
          ),
          color: color, // Cor de fundo ajustada
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: context.secondaryColor,
              size: iconSize, // Ícone adaptado ao tamanho da tela
            ),
            const SizedBox(
              height: 10, // Ajusta o espaçamento entre o ícone e o texto
            ),
            Text(
              text.toUpperCase(),
              style: context.titleBig.copyWith(
                color: context.primaryColor, // Ajusta a cor do texto
                fontSize: fontSize, // Fonte adaptada ao tamanho da tela
                height: 1.1, // Ajuste do espaçamento entre linhas
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
