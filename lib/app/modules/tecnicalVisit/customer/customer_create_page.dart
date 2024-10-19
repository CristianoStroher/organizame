import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/header_customer.dart';
import 'package:provider/provider.dart';

import 'customer_controller.dart';

class CustomerCreatePage extends StatefulWidget {
  final CustomerObject? customer;

  const CustomerCreatePage({super.key, this.customer});

  @override
  State<CustomerCreatePage> createState() => _CustomerCreatePageState();
}

class _CustomerCreatePageState extends State<CustomerCreatePage> {
  CustomerObject? selectedCustomer;
  VoidCallback? clearFormCallback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final customerController = context.read<CustomerController>();
        customerController.refreshCustomers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerController = context.watch<CustomerController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Cliente',
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderCustomer(
              customer: selectedCustomer,
              onSave: (name, phone, address) async {
                final controller = context.read<CustomerController>();

                final upperName = name.toUpperCase();
                final upperPhone = phone;
                final upperAddress = address;

                if (selectedCustomer == null) {
                  await controller.saveCustomer(
                      upperName, upperPhone, upperAddress);
                } else {
                  await controller.updateCustomer(
                    selectedCustomer!.copyWith(
                      name: upperName,
                      phone: upperPhone,
                      address: upperAddress,
                    ),
                  );
                }

                if (mounted) {
                  setState(() {
                    selectedCustomer = null;
                  });
                }                
                controller.refreshCustomers();
                
                if (clearFormCallback != null) {
                  clearFormCallback!();
                }
              },
              setClearFormCallback: (callback) {
                clearFormCallback = callback;
              },
            ),
            const SizedBox(height: 20),
            Text('RELAÇÃO DE CLIENTES', style: context.titleDefaut),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<List<CustomerObject>>(
                valueListenable: customerController.customersNotifier,
                builder: (context, customers, child) {
                  if (customers.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return Customer(
                        object: customer,
                        controller: context.read<CustomerController>(),
                        onEdit: (editedCustomer) {
                          setState(() {
                            selectedCustomer = editedCustomer;
                          });
                          // Rola a tela para o topo para mostrar o formulário de edição
                          Scrollable.ensureVisible(context,
                              duration: Duration(milliseconds: 300));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}