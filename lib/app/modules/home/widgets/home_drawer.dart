import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_provider.dart';

class HomeDrawer extends StatelessWidget {

  final nameVN = ValueNotifier<String>('');

  HomeDrawer({super.key});

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
                  Selector<AuthProvider, String>(
                    //seleciona o valor do usuario
                    selector: (context, authProvider) {
                      return authProvider.user?.photoURL ??
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'; //seleciona a imagem do usuario ou uma imagem padrão
                    },
                    builder: (_, value, __) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.scaffoldBackgroundColor
                                .withOpacity(0.5),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          //cria um avatar circular
                          backgroundImage:
                              NetworkImage(value), //imagem do avatar
                          radius: 30,
                          //raio do avatar
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Selector<AuthProvider, String>(
                        selector: (context, authProvider) =>
                            authProvider.user?.displayName ??
                            'Nome do usuário', //seleciona o nome do usuario ou um nome padrão
                        builder: (_, value, __) {
                          return Text(
                            value,
                            style: TextStyle(
                              color: context.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(height: 20),
          ListTile(
            title: Text('Alterar nome',
                style: TextStyle(color: context.primaryColor)),
            onTap: () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text('Alterar nome', style: context.titleMedium),
                content: TextField(
                  onChanged: (value) => nameVN.value = value,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: context.primaryColor),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar', style: context.titleDefaut),
                  ),
                  TextButton(
                    onPressed: () {
                      final nameValue = nameVN.value;
                      if (nameValue.isNotEmpty) {
                        Messages.of(context).showError('Nome obrigatório');
                      } else {
                        Loader.show(context);
                        context.read<UserService>().updateDisplayName(nameValue);
                        Loader.hide();
                        Navigator.of(context).pop();
                      }
                    } ,
                    child: Text('Salvar', style: TextStyle(color: context.primaryColor, fontSize: 16)),
                  ),
                ],
              ));
            },
          ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: context.primaryColorLight,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: context.primaryColor),
                  ),
                  child: Text(
                    'Sair',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ],
            ),
            onTap: () => context.read<AuthProvider>().logout(), //sair do app
          ),
        ],
      ),
    );
  }
}
