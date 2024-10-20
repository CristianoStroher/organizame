import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/core/Widget/organizame_calendar_button.dart';
import 'package:organizame/app/core/Widget/organizame_time.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:provider/provider.dart';

class TechnicalvisitHeader extends StatefulWidget {
  const TechnicalvisitHeader({super.key});

  @override
  _TechnicalvisitHeader createState() => _TechnicalvisitHeader();
}

class _TechnicalvisitHeader extends State<TechnicalvisitHeader> {
  String? selectedClient;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateEC = TextEditingController();
  final TextEditingController timeEC = TextEditingController();

  bool isFieldsEditable = true;

  @override
  void dispose() {
    dateEC.dispose();
    timeEC.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Função para atualizar os dados do cliente selecionado
  void _updateClientData(String? newValue, List<CustomerObject> clients) {
    setState(() {
      selectedClient = newValue;

      // Procurar o cliente selecionado na lista dinâmica
      final selectedCustomer = clients.firstWhere(
        (customer) => customer.name == newValue,
        orElse: () => CustomerObject(name: '', phone: '', address: ''),
      );

      // Atualizar os campos de telefone e endereço
      phoneController.text = selectedCustomer.phone ?? '';
      addressController.text = selectedCustomer.address ?? '';
      isFieldsEditable = false; // Desabilita os campos
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerController = context.watch<CustomerController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ValueListenableBuilder<List<CustomerObject>>(
        valueListenable: customerController.customersNotifier,
        builder: (context, customers, child) {
          if (customers.isEmpty) {
            return CircularProgressIndicator();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NOVA VISITA TÉCNICA', style: context.titleDefaut),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OrganizameCalendarButton(
                      controller: dateEC,
                      color: const Color(0xFFFAFFC5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OrganizameTimeButton(
                      controller: timeEC,
                      label: 'Hora',
                      color: const Color(0xFFFAFFC5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Dropdown dinâmico para selecionar clientes
              OrganizameDropdownfield(
                label: 'Cliente',
                options: customers.map((customer) => customer.name).toList(),
                selectedOptions: selectedClient,
                onChanged: (newValue) => _updateClientData(newValue, customers),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              OrganizameTextformfield(
                label: 'Telefone',
                hintText: '(99) 99999-9999',
                controller: phoneController,
                enabled: false, // Campo completamente desabilitado
                fillColor: context.secondaryColor
                    .withOpacity(0.5), // Cor de fundo azul claro
                filled: true, // Permite que o campo seja preenchido
                readOnly: true, // Somente leitura
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              OrganizameTextformfield(
                label: 'Endereço',
                hintText: 'Rua, número, bairro',
                controller: addressController,
                enabled: false, // Campo completamente desabilitado
                fillColor: context.secondaryColor
                    .withOpacity(0.5), // Cor de fundo azul claro
                filled: true, // Permite que o campo seja preenchido
                readOnly: true, // Somente leitura
              ),
              const SizedBox(height: 20),
              OrganizameElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/customer/create');
                  if (mounted) {
                    context.read<CustomerController>().refreshCustomers();
                  }
                },
                label: 'Cadastrar Cliente',
                textColor: const Color(0xFFFAFFC5),
              ),
            ],
          );
        },
      ),
    );
  }
}
