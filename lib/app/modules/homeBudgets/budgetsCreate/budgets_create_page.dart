import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:validatorless/validatorless.dart';

class BudgetsCreatePage extends StatefulWidget {
  final BudgetsCreateController _createController;
  final BudgetsController _controller;
  final BudgetsObject? object;
  final CustomerObject? initialClient; // Cliente inicial
  final Function(CustomerObject?)?
      onClientSelected; // Função para atualizar o cliente selecionado
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '####,##',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final CustomerObject? customer;

  BudgetsCreatePage({
    super.key,
    required BudgetsController controller,
    required BudgetsCreateController createController,
    this.object,
    this.initialClient,
    this.onClientSelected,
    this.customer,
  })  : _controller = controller,
        _createController = createController;

  @override
  State<BudgetsCreatePage> createState() => _BudgetsCreatePageState();
}

class _BudgetsCreatePageState extends State<BudgetsCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final _observationsEC = TextEditingController();
  final _valueEC = TextEditingController();
  String? selectedClient;
  List<CustomerObject> customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    if (widget.object != null) {
      _valueEC.text = widget.object!.value;
      _observationsEC.text = widget.object!.observation ?? '';
      selectedClient = widget.object!.customer.name;
    }
    _valueEC.addListener(_formatValue);
  }

  void _formatValue() {
    String value = _valueEC.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (value.isEmpty) {
      value = '0';
    }

    // Garante que sempre teremos pelo menos 3 dígitos (para ter 2 casas decimais)
    while (value.length < 3) {
      value = '0$value';
    }

    // Separa a parte inteira das decimais
    String integerPart = value.substring(0, value.length - 2);
    String decimalPart = value.substring(value.length - 2);

    // Remove zeros à esquerda da parte inteira, exceto se for zero
    integerPart = integerPart.replaceAll(RegExp(r'^0+'), '');
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    // Formata o valor final
    final formattedValue = '$integerPart,$decimalPart';

    // Atualiza o texto apenas se for diferente para evitar loop infinito
    if (_valueEC.text != formattedValue) {
      _valueEC.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
  }

  @override
  Dispose() {
    _valueEC.removeListener(_formatValue);
    _observationsEC.dispose();
    _valueEC.dispose();
    super.dispose();

  }

  Future<void> _loadCustomers() async {
    try {
      // Assumindo que você tem um método no controller para buscar clientes
      final customersList = await widget._controller.getCustomers();
      setState(() {
        customers = customersList;
      });
    } catch (e) {
      Logger().e('Erro ao carregar clientes: $e');
    }
  }

  Future<void> _handleSave() async {
    if (_globalKey.currentState!.validate()) {
      try {
        final customer = customers.firstWhere(
          (customer) => customer.name == selectedClient,
          orElse: () => CustomerObject(name: ''),
        );

        final budget = BudgetsObject(
            id: widget.object?.id ?? '',
            customer: customer,
            date: DateTime.now(),
            observation: _observationsEC.text,
            value: _valueEC.text,
            status: false);

        if (widget.object != null) {
          await widget._controller.updateBudget(budget);
          Messages.of(context).showInfo('Orçamento atualizado com sucesso');
        } else {
          await widget._createController.saveBudget(budget);
          Messages.of(context).showInfo('Orçamento salvo com sucesso');
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        Messages.of(context).showError('Erro ao salvar orçamento');
      }
    }
  }

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
                    OrganizameDropdownfield(
                      label: 'Cliente',
                      options:
                          customers.map((customer) => customer.name).toList(),
                      selectedOptions: selectedClient,
                      onChanged: (newValue) =>
                          _updateClientData(newValue, customers),
                      validator: Validatorless.multiple([
                        Validatorless.required('Cliente é obrigatório'),
                        (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Selecione um cliente';
                          }
                          return null;
                        },
                      ]),
                    ),
                    const SizedBox(height: 10),
                    OrganizameTextformfield(
                      label: 'Valor',
                      enabled: true,
                      hintText: '0,00',
                      maskFormatter: widget.phoneMaskFormatter,
                      controller: _valueEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('Valor é obrigatório'),
                        (value) {
                          if (value == '0,00' || value == '') {
                            return 'Insira um valor válido';
                          }
                          return null;
                        },
                      ]),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120, // Ajusta a altura total
                      child: OrganizameTextField(
                        controller: _observationsEC,
                        label: 'Observações',
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: widget.object != null ? 'Atualizar' : 'Salvar',
                      onPressed: () {
                        _handleSave();
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
