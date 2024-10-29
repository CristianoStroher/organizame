import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/ui/messages.dart';

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
  bool _initialized = false;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.technicalVisit != null) {
      _loadVisitData();
      _initialized = true;
    }
  }

  void _loadVisitData() {
    selectedClient.value = widget.technicalVisit!.customer;
    // Formatando apenas a data, sem a hora
    dateEC.text = DateFormat('dd/MM/yyyy').format(widget.technicalVisit!.date);
    timeEC.text =
        TimeOfDay.fromDateTime(widget.technicalVisit!.time).format(context);
  }

  @override
  void dispose() {
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
                    initialClient: widget.technicalVisit?.customer,
                    initialDate: widget.technicalVisit?.date,
                    initialTime: widget.technicalVisit != null
                        ? TimeOfDay.fromDateTime(widget.technicalVisit!.time)
                        : null,
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
                    label:
                        widget.technicalVisit != null ? 'Atualizar' : 'Salvar',
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
      Messages.of(context)
          .showError('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    if (selectedClient.value == null) {
      Messages.of(context).showError('Por favor, selecione um cliente.');
      return;
    }

    try {
      // Parse da data - Ajustado para lidar com o formato ISO
      final DateTime dateValue = DateTime.parse(dateEC.text);

      // Parse da hora
      final timeParts = timeEC.text.split(':');
      final TimeOfDay timeOfDay = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );

      // Combina data e hora
      final DateTime timeValue = DateTime(
        dateValue.year,
        dateValue.month,
        dateValue.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      if (widget.technicalVisit != null) {
        // Modo edição
        final updatedVisit = TechnicalVisitObject(
          id: widget.technicalVisit!.id,
          date: dateValue,
          time: timeValue,
          customer: selectedClient.value!,
        );

        await widget._controller.updateVisit(updatedVisit);
        Messages.of(context).showInfo('Visita técnica atualizada com sucesso!');
      } else {
        // Modo criação
        await widget._controller.saveTechnicalVisit(
          dateValue,
          timeValue,
          selectedClient.value!,
        );
        Messages.of(context).showInfo('Visita técnica salva com sucesso!');
      }

      Navigator.of(context).pop(true);
    } catch (e, s) {
      Logger().e('Erro ao salvar visita técnica: $e');
      Logger().e(s);
      Messages.of(context).showError('Erro ao salvar visita técnica: $e');
    }
  }
}
