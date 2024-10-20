import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_header.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_list.dart';


class TechnicalvisitCreatePage extends StatefulWidget {

  TechnicalvisitCreatePage({
    super.key,
  });

  @override
  State<TechnicalvisitCreatePage> createState() => _TechnicalvisitCreatePage();
}


class _TechnicalvisitCreatePage extends State<TechnicalvisitCreatePage> {

  @override
  void initState() {
    super.initState();
    
  }

@override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Visita Técnica',
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
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TechnicalvisitHeader(),
                const SizedBox(height: 10),
                TechnicalvisitList(
                  environments: [
                    EnvironmentObject(
                      name: 'QUARTO CASAL',
                      difficulty: 'MODERADO',
                      observation: 'Quarto casal com suíte',
                    ),
                    EnvironmentObject(
                      name: 'COZINHA',
                      difficulty: 'CRÍTICO',
                      observation: 'Cozinha com armários planejados',
                    ),
                    
                  ],
                ),
                const SizedBox(height: 20),
                OrganizameElevatedButton(
                  onPressed: () {},
                  label: 'Salvar',
                  textColor: const Color(0xFFFAFFC5),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
      ),
    );
  }
}
