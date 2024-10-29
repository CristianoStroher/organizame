import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/core/Widget/organizame_calendar_button.dart';
import 'package:organizame/app/core/Widget/organizame_time.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:provider/provider.dart';

class TechnicalvisitHeader extends StatefulWidget {
  final CustomerObject? initialClient;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final TechnicalVisitObject? technicalVisit;
  final Function(CustomerObject?)? onClientSelected;
  final Function(DateTime)? onDateSelected;
  final Function(TimeOfDay)? onTimeSelected;

  const TechnicalvisitHeader({
    super.key,
    this.onClientSelected,
    this.onDateSelected,
    this.onTimeSelected,
    this.technicalVisit,
    this.initialClient,
    this.initialDate,
    this.initialTime,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalvisitHeader createState() => _TechnicalvisitHeader();
}

class _TechnicalvisitHeader extends State<TechnicalvisitHeader> {
  String? selectedClient;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateEC = TextEditingController();
  final TextEditingController timeEC = TextEditingController();
  bool isFieldsEditable = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeData();
      _initialized = true;
    }
  }

  void _initializeData() {
    if (widget.initialClient != null) {
      selectedClient = widget.initialClient!.name;
      phoneController.text = widget.initialClient!.phone ?? '';
      addressController.text = widget.initialClient!.address ?? '';
      isFieldsEditable = false;
    }

    if (widget.initialDate != null) {
      dateEC.text = widget.initialDate!.toIso8601String();
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(widget.initialDate!);
      }
    }

    if (widget.initialTime != null) {
      timeEC.text = widget.initialTime!.format(context);
      if (widget.onTimeSelected != null) {
        widget.onTimeSelected!(widget.initialTime!);
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    dateEC.dispose();
    timeEC.dispose();
    super.dispose();
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.initialClient != null
                      ? 'EDITAR VISITA TÉCNICA'
                      : 'NOVA VISITA TÉCNICA',
                  style: context.titleDefaut),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OrganizameCalendarButton(
                      controller: dateEC,
                      color: const Color(0xFFFAFFC5),
                      onDateSelected: widget.onDateSelected,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OrganizameTimeButton(
                      controller: timeEC,
                      label: 'Hora',
                      color: const Color(0xFFFAFFC5),
                      onTimeSelected: (time) {
                        if (widget.onTimeSelected != null) {
                          widget.onTimeSelected!(time);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                enabled: false,
                fillColor: context.secondaryColor.withOpacity(0.5),
                filled: true,
                readOnly: true,
              ),
              const SizedBox(height: 10),
              OrganizameTextformfield(
                label: 'Endereço',
                hintText: 'Rua, número, bairro',
                controller: addressController,
                enabled: false,
                fillColor: context.secondaryColor.withOpacity(0.5),
                filled: true,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              OrganizameElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/customer/create');
                  if (mounted) {
                    context.read<CustomerController>().refreshCustomers();
                  }
                },
                label: 'Novo Cliente',
                textColor: const Color(0xFFFAFFC5),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateClientData(String? newValue, List<CustomerObject> clients) {
    setState(() {
      selectedClient = newValue;

      final selectedCustomer = clients.firstWhere(
        (customer) => customer.name == newValue,
        orElse: () => CustomerObject(name: '', phone: '', address: ''),
      );

      phoneController.text = selectedCustomer.phone ?? '';
      addressController.text = selectedCustomer.address ?? '';
      isFieldsEditable = false;

      if (widget.onClientSelected != null) {
        widget.onClientSelected!(selectedCustomer);
      }
    });
  }
}
