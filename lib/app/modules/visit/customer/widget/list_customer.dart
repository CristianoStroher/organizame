import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/visit/customer/customer_controller.dart';
import 'package:organizame/app/modules/visit/customer/widget/customer.dart';
import 'package:provider/provider.dart';

class ListCustomer extends StatefulWidget {
  const ListCustomer({super.key});
  


  @override
  State<ListCustomer> createState() => _ListCustomerState();
}

class _ListCustomerState extends State<ListCustomer> {

  

  @override
  void initState() {
    super.initState();
    // Chama o método para buscar os clientes assim que a página for carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().findAllCustomers();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('RELAÇÃO DE CLIENTES', 
        style: context.titleDefaut),
        const SizedBox(height: 10),
        Column(
          children: context.select<CustomerController, List<CustomerObject>>(
            (controller) => controller.filteredCustomer)
            .map((c) => Customer(object: c, controller: context.read<CustomerController>()))
            .toList(),
            
        )
      ],
    )
    );
  }
}
