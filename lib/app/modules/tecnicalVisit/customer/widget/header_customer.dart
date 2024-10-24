import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:validatorless/validatorless.dart';

class HeaderCustomer extends StatefulWidget {
  final CustomerObject? customer;
  final Function(String, String?, String?) onSave;
  final Function(VoidCallback) setClearFormCallback;

  const HeaderCustomer({
    super.key,
    this.customer,
    required this.onSave,
    required this.setClearFormCallback
  });

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

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
    widget.setClearFormCallback(_clearForm);
  }

  void _clearForm() {
    _nameEC.clear();
    _phoneEC.clear();
    _addressEC.clear();
    setState(() {});
  }

  void _loadCustomerData() {
    if (widget.customer != null) {
      setState(() {
        _nameEC.text = widget.customer!.name;
        _phoneEC.text = widget.customer!.phone ?? '';
        _addressEC.text = widget.customer!.address ?? '';
      });
    }
  }

  @override
  void didUpdateWidget(HeaderCustomer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customer != widget.customer) {
      _loadCustomerData();
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
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(widget.customer == null ? 'NOVO CLIENTE' : 'EDITAR CLIENTE',
              style: context.titleDefaut),
          const SizedBox(height: 20),
          OrganizameTextformfield(
            label: 'Nome',
            hintText: 'Nome completo',
            enabled: true,
            controller: _nameEC,
            validator: Validatorless.required('Nome é obrigatório'),
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Contato',
            hintText: '(00) 00000-0000',
            maskFormatter: phoneMaskFormatter,
            enabled: true,
            controller: _phoneEC,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (numericValue.length < 11) {
                  return 'O telefone deve ter 11 dígitos';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Endereço',
            enabled: true,
            controller: _addressEC,
            hintText:  'Rua, nº, bairro, cidade',
          ),
          const SizedBox(height: 20),
          OrganizameElevatedButton(
            label: 'Salvar',
            textColor: context.scaffoldBackgroundColor,
            onPressed: () async {
              final formValid = _globalKey.currentState!.validate();
              if (formValid) {
                final name = _nameEC.text;
                final phone = _phoneEC.text.isNotEmpty ? _phoneEC.text : null;
                final address = _addressEC.text.isNotEmpty ? _addressEC.text : null;
                try {
                  await widget.onSave(name, phone, address);
                  if (mounted) {
                    Messages.of(context).showInfo('Cliente salvo com sucesso');
                    if (widget.customer == null) {
                      _clearForm();
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    Messages.of(context).showError('Erro ao salvar cliente: ${e.toString()}');
                  }
                }
              } else {
                Messages.of(context).showError('Por favor, corrija os campos destacados');
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}