import 'package:flutter/material.dart';

class LivingRoomPage extends StatefulWidget {

  const LivingRoomPage({ super.key });

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Quarto Casal'),),
           body: Container(),
       );
  }
}