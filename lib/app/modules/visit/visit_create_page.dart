// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:organizame/app/modules/visit/visit_controller.dart';

class VisitCreatePage extends StatelessWidget {

  VisitController _controller;

  VisitCreatePage({
    super.key,
    required VisitController controller,
  }) : _controller = controller;

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('VISITAS TÉCNICAS'),),
           body: Container(),
       );
  }
}
