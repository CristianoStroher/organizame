// ignore_for_file: public_member_api_docs, sort_constructors_first
/* nota 09 */

import 'package:flutter/material.dart';
import 'package:organizame/app/core/modules/organizame_page.dart';
import 'package:provider/single_child_widget.dart';

abstract class OrganizameModule {
  /* nota 10 */
  final Map<String, WidgetBuilder> _routers; // Mapa de rotas do módulo
  final List<SingleChildWidget>? _bindings; // Lista de injeção de dependências do módulo.

  OrganizameModule({
    List<SingleChildWidget>? bindings,
    required Map<String, WidgetBuilder> routers,
  })  : _routers = routers,
        _bindings = bindings;


  /* nota 11 */
  Map<String, WidgetBuilder> get routers {
    return _routers.map(
      (key, pageBuilder) => MapEntry(
        key,
        (_) => OrganizamePage(
          bindings: _bindings,
          page: pageBuilder,
        ),
      ),
    );
  }

//metodo para pegar a pagina atraves do path
Widget getPage(String path, BuildContext context) {
    final widgetBuilder = _routers[path];
    if (widgetBuilder != null) {
      return OrganizamePage(
        page: widgetBuilder,
        bindings: _bindings,
      );
    }
    throw Exception('Rota não encontrada');
  }


}
