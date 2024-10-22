import 'package:flutter/material.dart';

import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_header.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_list.dart';
import 'package:provider/provider.dart';

class TechnicalvisitCreatePage extends StatefulWidget {
  const TechnicalvisitCreatePage({Key? key}) : super(key: key);

  @override
  State<TechnicalvisitCreatePage> createState() =>
      _TechnicalvisitCreatePageState();
}

class _TechnicalvisitCreatePageState extends State<TechnicalvisitCreatePage> {
  final _globalKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final selectedClient = ValueNotifier<CustomerObject?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TechnicalVisitController>().initNewVisit();
    });
  }

  @override
  dispose() {
    super.dispose();
    dateController.dispose();
    timeController.dispose();
    selectedClient.dispose();}

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TechnicalVisitController>();

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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Consumer<TechnicalVisitController>(
        builder: (context, controller, _) {
          return Form(
            key: _globalKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TechnicalvisitHeader(
                    onClientSelected: (customer) {
                      selectedClient.value = customer;
                    },
                  ),
                  const SizedBox(height: 10),
                  TechnicalvisitList(),
                  const SizedBox(height: 20),
                  OrganizameElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate() ?? false) {
                        final newVisit = TechnicalVisitObject(
                          id: UniqueKey().toString(), // Gere um ID único
                          data: DateTime.parse(dateController.text), // Converta a data para DateTime
                          hora: DateTime.parse(timeController.text), // Converta a hora para DateTime
                          cliente: selectedClient.value!, // Obtém o cliente selecionado
                          ambientes: [], // Preencha com os ambientes conforme necessário
                          );

                        controller.saveTechnicalVisit(newVisit);

                        Navigator.of(context).pop();
                      }
                    },
                    label: 'Salvar',
                    textColor: const Color(0xFFFAFFC5),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
