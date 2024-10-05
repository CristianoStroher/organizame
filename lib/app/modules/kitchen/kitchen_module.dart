import 'package:flutter/material.dart';
import 'package:organizame/app/core/modules/organizame_module.dart';

class KitchenModule extends OrganizameModule {
  KitchenModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider(
          //   //   create: (context) => KitchenController(),
          //   // ),
          // ],
          routers: {
            '/kitchen': (context) => Container(
                  // controller: context.read(),
                ),
          },
        );
  
}