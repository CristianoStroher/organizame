import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/visit/customer/widget/customer.dart';
import 'package:organizame/app/modules/visit/customer/widget/header_customer.dart';
import 'package:provider/provider.dart';

import 'customer_controller.dart';

class CustomerCreatePage extends StatefulWidget {
  final CustomerObject? customer;

  const CustomerCreatePage({super.key, this.customer});

  @override
  State<CustomerCreatePage> createState() => _CustomerCreatePageState();
}

class _CustomerCreatePageState extends State<CustomerCreatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final customerController = context.read<CustomerController>();
        customerController.findAllCustomers();
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
            HeaderCustomer(),
            const SizedBox(height: 20),
            Text('RELAÇÃO DE CLIENTES', style: context.titleDefaut),
            const SizedBox(height: 10),
            Expanded(
              child: customerController.filteredCustomer.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: customerController.filteredCustomer.length,
                      itemBuilder: (context, index) {
                        final customer = customerController.filteredCustomer[index];
                        return Customer(
                          object: customer,
                          controller: customerController,
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
