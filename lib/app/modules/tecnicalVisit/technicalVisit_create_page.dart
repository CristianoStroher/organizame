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
  final TechnicalVisitObject? technicalVisit;
  final TechnicalVisitController _controller;

  const TechnicalvisitCreatePage({
    super.key,
    this.technicalVisit,
    required controller,
  }) : _controller = controller;

  @override
  State<TechnicalvisitCreatePage> createState() =>
      _TechnicalvisitCreatePageState();
}

class _TechnicalvisitCreatePageState extends State<TechnicalvisitCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final selectedClient = ValueNotifier<CustomerObject?>(null);
  final TextEditingController dateEC = TextEditingController();
  final TextEditingController timeEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    dateEC.dispose();
    timeEC.dispose();
    selectedClient.dispose();
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
                    onClientSelected: (cliente) {
                      selectedClient.value = cliente;
                    },
                    onDateSelected: (date) {
                      dateEC.text = date.toIso8601String();
                    },
                    onTimeSelected: (time) {
                      timeEC.text = time.format(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  TechnicalvisitList(),
                  const SizedBox(height: 20),
                  OrganizameElevatedButton(
                    onPressed: () => _saveVisitTechnical(context),
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

  Future<void> _saveVisitTechnical(BuildContext context) async {
    final formValid = _globalKey.currentState?.validate() ?? false;

    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    if (selectedClient.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um cliente.')),
      );
      return;
    }

    try {
      // Processamento da data
      final DateTime dateValue = DateTime.parse(dateEC.text);

      // Converter TimeOfDay para DateTime
      final TimeOfDay timeOfDay = TimeOfDay.now(); // Pegar o valor do timeEC

      // Criar DateTime com a data selecionada e a hora atual
      final DateTime timeValue = DateTime(
        dateValue.year,
        dateValue.month,
        dateValue.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      await context.read<TechnicalVisitController>().saveTechnicalVisit(
            dateValue,
            timeValue,
            selectedClient.value!,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visita técnica salva com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar visita técnica: $e')),
      );
    }
  }
}
