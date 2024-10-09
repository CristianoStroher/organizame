import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/visit/customer/customer_controller.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class HeaderCustomer extends StatefulWidget {
  final CustomerObject? customer;

  const HeaderCustomer({super.key, this.customer});

  @override
  State<HeaderCustomer> createState() => _HeaderCustomerState();
}

class _HeaderCustomerState extends State<HeaderCustomer> {
  final _globalKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _addressEC = TextEditingController();
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  CustomerController? _controller;

  @override
  void initState() {
    super.initState();

    // Se for um cliente existente, preenche os campos com os dados do cliente
    if (widget.customer != null) {
      final customer = widget.customer!;
      _nameEC.text = customer.name;
      _phoneEC.text = customer.phone ?? '';
      _addressEC.text = customer.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _phoneEC.dispose();
    _addressEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('NOVO CLIENTE', style: context.titleDefaut),
        const SizedBox(height: 20),
        OrganizameTextformfield(
          label: 'Nome',
          enabled: true,
          controller: _nameEC,
          validator: Validatorless.multiple([
            Validatorless.required('Campo obrigatório'),
          ]),
        ),
        const SizedBox(height: 10),
        OrganizameTextformfield(
          label: 'Contato',
          hintText: '(00) 00000-0000',
          maskFormatter: phoneMaskFormatter,
          enabled: true,
          controller: _phoneEC,
        ),
        const SizedBox(height: 10),
        OrganizameTextformfield(
          label: 'Endereço',
          enabled: true,
          controller: _addressEC,
        ),
        const SizedBox(height: 20),
        OrganizameElevatedButton(
          label: 'Salvar',
          textColor: context.scaffoldBackgroundColor,
          onPressed: () async {
            final formValid = _globalKey.currentState!.validate();
            if (formValid) {
              final name = _nameEC.text;
              final phone = _phoneEC.text;
              final address = _addressEC.text;
              try {
                await context
                    .read<CustomerController>()
                    .saveCustomer(name, phone, address);

                _nameEC.clear();
                _phoneEC.clear();
                _addressEC.clear();

                Messages.of(context).showInfo('Cliente salvo com sucesso');

                setState(() {
                  _controller = context.read<CustomerController>();
                });
              } on Exception catch (e) {
                Messages.of(context).showError('Erro ao salvar cliente');
              }
            }
          },
        ),
      ],
    ));
  }
}
