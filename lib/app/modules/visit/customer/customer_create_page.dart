import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/visit/customer/customer_controller.dart';
import 'package:organizame/app/modules/visit/customer/widget/customer.dart';
import 'package:organizame/app/modules/visit/customer/widget/header_customer.dart';
import 'package:organizame/app/modules/visit/customer/widget/list_customer.dart';
import 'package:provider/provider.dart';

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
    // Chama o método para buscar os clientes assim que a página for carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().findAllCustomers();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 0.9,
                minHeight: constraints.maxHeight * 0.9,
              ),
              child: Container(
                height: constraints.maxHeight,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderCustomer(),
                      const SizedBox(height: 20),
                      Text('RELAÇÃO DE CLIENTES', style: context.titleDefaut),
                      const SizedBox(height: 10),
                      Column(
                        children: context
                            .select<CustomerController, List<CustomerObject>>(
                                (controller) => controller.filteredCustomer)
                            .map((c) => Customer(
                                object: c,
                                controller: context.read<CustomerController>()))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
