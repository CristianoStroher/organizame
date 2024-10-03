// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/visit/visit_controller.dart';
import 'package:organizame/app/modules/visit/widgets/environment_list.dart';
import 'package:organizame/app/modules/visit/widgets/visit_header.dart';

class VisitCreatePage extends StatelessWidget {


   
  VisitCreatePage({
    super.key,   
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFFC5),
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Visita Técnica',
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
      body: Form(
          child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VisitHeader(),
                  const SizedBox(height: 10),
                  EnvironmentList(
                    environments: [
                      EnvironmentObject(
                        name: 'Ambiente 1',
                        phone: '9999-9999',
                        address: 'Rua 1, 123',
                      ),
                      EnvironmentObject(
                        name: 'Ambiente 2',
                        phone: '9999-9999',
                        address: 'Rua 2, 123',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OrganizameElevatedButton(
                    onPressed: () {},
                    label: 'Salvar',
                    textColor: const Color(0xFFFAFFC5),
                  ),
                  const SizedBox(height: 10),
                  // OrganizameElevatedButton(
                  //   onPressed: () {},
                  //   label: 'Fechar',
                  //   textColor: context.primaryColor,
                  //   backgroundColor: context.scaffoldBackgroundColor,
                  //   borderColor: context.primaryColor,
                  // ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
