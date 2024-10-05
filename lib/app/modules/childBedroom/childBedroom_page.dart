import 'package:flutter/material.dart';

class ChildBedroomPage extends StatefulWidget {

  const ChildBedroomPage({ super.key });

  @override
  State<ChildBedroomPage> createState() => _ChildBedroomPageState();
}

class _ChildBedroomPageState extends State<ChildBedroomPage> {

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Quarto de Crianças'),),
           body: Container(),
       );
  }
}