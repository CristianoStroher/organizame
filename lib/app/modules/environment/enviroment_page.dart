import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_page.dart';
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_page.dart';
import 'package:organizame/app/modules/environment/enviromentLivingRoom/living_room_page.dart';
import 'package:organizame/app/modules/environment/widgets/enviroment_card.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:provider/provider.dart'; // Certifique-se de importar o EnviromentCard corretamente

class EnviromentPage extends StatefulWidget {
  final TechnicalVisitController technicalVisitController;
  const EnviromentPage({
    super.key,
    required this.technicalVisitController,
  });

  @override
  State<EnviromentPage> createState() => _EnviromentPageState();
}

class _EnviromentPageState extends State<EnviromentPage> {

  void _navigateToEnvironment(BuildContext context, Map<String, dynamic> environment) {
    final controller = context.read<TechnicalVisitController>();
    
    // Define qual página abrir baseado no tipo de ambiente
    Widget? page;
    switch (environment['text']) {
      case 'Quarto criança':
        page = ChildBedroomPage(
          controller: controller,
        );
        break;
      case 'Cozinha':
        page = KitchenPage(
          controller: controller,
        );
        break;
      case 'Quarto Casal':
        page = LivingRoomPage(
          controller: controller,
        );
        break;        
      default:
        Messages.of(context).showInfo('Ambiente ainda não implementado');
        return;
    }

    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<TechnicalVisitController>.value(
            value: controller,
            child: page!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final environments = [
      {'text': 'Quarto criança','icon': Icons.bedroom_baby,'route': '/childBedroom'},
      {'text': 'Cozinha', 'icon': Icons.kitchen, 'route': '/kitchen'},
      {'text': 'Quarto Casal', 'icon': Icons.weekend, 'route': '/livingRoom'},

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
            onPressed: () async {
              await widget.technicalVisitController.refreshVisits();
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
                  crossAxisSpacing:
                      10, // Espaçamento entre os cards horizontalmente
                  mainAxisSpacing:
                      10, // Espaçamento entre os cards verticalmente
                  childAspectRatio: 1, // Mantém os cards quadrados
                ),
                itemCount: environments.length, // Número de ambientes
                itemBuilder: (context, index) {
                  final environment = environments[index];
                  return EnviromentCard(
                    text: environment['text'] as String,
                    icon: environment['icon'] as IconData,
                    onTap: () => _navigateToEnvironment(context, environment),
                    color: const Color(0xFFFAFFC5),
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
