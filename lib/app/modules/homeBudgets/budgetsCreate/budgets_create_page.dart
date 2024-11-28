import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';
import 'package:validatorless/validatorless.dart';

class BudgetsCreatePage extends StatefulWidget {
  final BudgetsController _controller;
  final BudgetsObject? object;
  final CustomerObject? initialClient; // Cliente inicial
  final Function(CustomerObject?)? onClientSelected; // Função para atualizar o cliente selecionado
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '#.###,##',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  BudgetsCreatePage(
      {super.key,
      required BudgetsController controller,
      this.object,
      this.initialClient,
      this.onClientSelected})
      : _controller = controller;

  @override
  State<BudgetsCreatePage> createState() => _BudgetsCreatePageState();
}

class _BudgetsCreatePageState extends State<BudgetsCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final observationsEC = TextEditingController();
  final valueEC = TextEditingController();
  String? selectedClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFDDFFCC),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Orçamento',
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
        key: _globalKey,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        widget.object == null
                            ? 'NOVA ORÇAMENTO'
                            : 'EDITAR ORÇAMENTO',
                        style: context.titleDefaut),
                    const SizedBox(height: 10),
                    // OrganizameDropdownfield(
                    //   label: 'Cliente',
                    //   options: customers.map((customer) => customer.name).toList(),
                    //   selectedOptions: selectedClient,
                    //   onChanged: (newValue) => _updateClientData(newValue, customers),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Por favor, selecione um cliente';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    OrganizameTextformfield(
                      label: 'Valor',
                      enabled: true,
                      hintText: '0,00',
                      maskFormatter: widget.phoneMaskFormatter,
                      controller: valueEC,
                      validator: (value) =>
                          Validatorless.required('Valor é obrigatório')(value),
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120, // Ajusta a altura total
                      child: OrganizameTextField(
                        controller: observationsEC,
                        label: 'Observações',
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: widget.object != null ? 'Atualizar' : 'Salvar',
                      onPressed: () {
                        // _handleSave();
                      },
                      textColor: Color(0xFFDDFFCC),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateClientData(String? newValue, List<CustomerObject> clients) {
    setState(() {
      selectedClient = newValue;

      final selectedCustomer = clients.firstWhere(
        (customer) => customer.name == newValue,
        orElse: () => CustomerObject(name: ''),
      );

      if (widget.onClientSelected != null) {
        widget.onClientSelected!(selectedCustomer);
      }
    });
  }
}
