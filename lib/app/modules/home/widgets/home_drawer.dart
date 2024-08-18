
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_provider.dart';

class HomeDrawer extends StatelessWidget {

  const HomeDrawer({ super.key });

   @override
   Widget build(BuildContext context) {
       return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: context.primaryColorLight,
              ),
              child: Row(
                children: [
                  Selector<AuthProvider, String>( //seleciona o valor do usuario
                    selector: (context, authProvider) {
                      return authProvider.user?.photoURL ??
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';//seleciona a imagem do usuario ou uma imagem padrão
                    },
                    builder: (_, value, __ ) {
                      return CircleAvatar( //cria um avatar circular
                        backgroundImage: NetworkImage(value), //imagem do avatar
                        radius: 30, //raio do avatar
                      );
                    },
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Nome do usuário',
                        style: context.textTheme.titleMedium,),
                    ),
                  ), 
                ],
              )
            ),
          ],
        ),
       );
      
  }
}