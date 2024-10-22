import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_header.dart';
import 'package:organizame/app/modules/tecnicalVisit/widgets/technicalVisit_list.dart';
import 'package:provider/provider.dart';

class TechnicalvisitCreatePage extends StatefulWidget {
  
      TechnicalvisitCreatePage({Key? key}) : super(key: key);

  @override
  State<TechnicalvisitCreatePage> createState() => _TechnicalvisitCreatePageState();
}

class _TechnicalvisitCreatePageState extends State<TechnicalvisitCreatePage> {
  final _globalKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final selectedClient = ValueNotifier<String?>(null);

  

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
    selectedClient.dispose();
  }

  // void _saveVisit(BuildContext context, TechnicalVisitController controller) async {
  //   if (_globalKey.currentState!.validate()) {
  //     try {
  //       // Obter referência ao header
  //       final headerState = context.findAncestorStateOfType<_TechnicalvisitHeader>();
  //       if (headerState == null) {
  //         throw Exception('Não foi possível acessar os dados do cabeçalho');
  //       }

  //       // Converter as strings de data e hora para DateTime
  //       final date = DateFormat('dd/MM/yyyy').parse(headerState.dateEC.text);
  //       final time = DateFormat('HH:mm').parse(headerState.timeEC.text);

  //       // Encontrar o cliente selecionado
  //       final selectedCustomer = headerState.selectedClient;
  //       if (selectedCustomer == null) {
  //         throw Exception('Por favor, selecione um cliente');
  //       }

  //       // Atualizar os detalhes da visita no controller
  //       controller.updateVisitDetails(
  //         customer: CustomerObject(
  //           id: '', // O ID será gerado pelo Firestore
  //           name: selectedCustomer,
  //           phone: headerState.phoneController.text,
  //           address: headerState.addressController.text,
  //         ),
  //         date: date,
  //         time: time,
  //       );

  //       // Salvar a visita
  //       await controller.saveTechnicalVisit(controller.currentVisit!);

  //       if (controller.hasSuccess) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Visita técnica salva com sucesso!')),
  //         );
  //         Navigator.of(context).pop();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Falha ao salvar visita técnica')),
  //         );
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Erro ao salvar visita técnica: $e')),
  //       );
  //     }
  //   }
  // }

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
                    /* dateController: dateController,
                    timeController: timeController,
                    selectedClient: selectedClient, */
                    // onClienteChanged: (cliente) => controller.updateVisitDetails(
                    //   customer: CustomerObject(id: '', name: cliente),
                    // ),
                    // onDataChanged: (data) => controller.updateVisitDetails(date: data),
                    // onTimeChanged: (hora) => controller.updateVisitDetails(time: hora),
                  ),
                  const SizedBox(height: 10),
                  TechnicalvisitList(),
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
          );
        },
      ),
    );
  }

} 
