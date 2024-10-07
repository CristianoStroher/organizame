import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/visit/customer/customer_controller.dart';

class Customer extends StatefulWidget {

  final CustomerController controller;
  final CustomerObject object;
  

  const Customer({
     super.key,
     required this.controller,
     required this.object,
    });

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
   @override
   Widget build(BuildContext context) {
       return InkWell(
        onTap: () {
          /// função de selecionar o cliente
        },
        child: SizedBox(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300], // Linha cinza acima
                thickness: 1.5,
                height: 0,
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(.8),
                title: Text(
                  widget.object.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor
                ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.object.phone ?? '',
                        style: context.titleDefaut,
                        ),
                    Text(widget.object.address ?? '',
                    style: context.titleDefaut,),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete, color: context.secondaryColor),
                ),
              ),
              Divider(
                color: Colors.grey[300], // Linha cinza abaixo
                thickness: 1.5,
                height: 0,
              ),
            ],
          ),
        ));
  }
}