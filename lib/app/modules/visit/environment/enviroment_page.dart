import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/modules/visit/environment/widgets/enviroment_card.dart'; // Certifique-se de importar o EnviromentCard corretamente

class EnviromentPage extends StatelessWidget {
  const EnviromentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista dos ambientes (textos e ícones)
    final environments = [
      {'text': 'Quarto criança', 'icon': Icons.bedroom_baby, 'route': '/childBedroom'},
      {'text': 'Cozinha', 'icon': Icons.kitchen, 'route': '/kitchen'},
      {'text': 'Quarto Casal', 'icon': Icons.weekend, 'route': '/livingRoom'},
      
      // Adicione mais ambientes conforme necessário
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Ambientes',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'SELECIONE O AMBIENTE',
              style: context.titleDefaut,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Dois cards por linha
                  crossAxisSpacing: 10, // Espaçamento entre os cards horizontalmente
                  mainAxisSpacing: 10, // Espaçamento entre os cards verticalmente
                  childAspectRatio: 1, // Mantém os cards quadrados
                ),
                itemCount: environments.length, // Número de ambientes
                itemBuilder: (context, index) {
                  final environment = environments[index];
                  return EnviromentCard(
                    text: environment['text'] as String,
                    icon: environment['icon'] as IconData,
                    onTap: () {
                      Navigator.of(context).pushNamed(environment['route'] as String);
                    }, color: const Color(0xFFFAFFC5),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
