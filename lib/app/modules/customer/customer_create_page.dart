import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/modules/customer/widget/customer.dart';

class CustomerCreatePage extends StatefulWidget {
  const CustomerCreatePage({super.key});

  @override
  State<CustomerCreatePage> createState() => _CustomerCreatePageState();
}

class _CustomerCreatePageState extends State<CustomerCreatePage> {
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('NOVO CLIENTE', style: context.titleDefaut),
                    const SizedBox(height: 20),
                    OrganizameTextformfield(
                      label: 'Nome',
                      enabled: true
                    ),
                    const SizedBox(height: 10),
                    OrganizameTextformfield(
                      label: 'Contato',
                      enabled: true
                    ),
                    const SizedBox(height: 10),
                    OrganizameTextformfield(
                      label: 'Endereço',
                      enabled: true
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: 'Salvar',
                      textColor: context.scaffoldBackgroundColor,
                      onPressed: (){}, 
                      ),
                    const SizedBox(height: 20),
                    const Customer(),

                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
