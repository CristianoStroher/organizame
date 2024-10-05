import 'package:flutter/material.dart';

class KitchenPage extends StatefulWidget {

  const KitchenPage({ super.key });

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Cozinha'),),
           body: Container(),
       );
  }
}