import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/visit/customer/widget/customer.dart';

class ListCustomer extends StatelessWidget {
  const ListCustomer({super.key});

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
        const Column(
          children: [
            Customer(),
          ],
          // children: context
          //     .select<HomeController, List<TaskObject>>(
          //         (controller) => controller.filteredTasks)
          //     .map((t) =>
          //         Task(object: t, controller: context.read<TaskController>()))
          //     .toList(),
        )
      ],
      
    ));
  }
}
