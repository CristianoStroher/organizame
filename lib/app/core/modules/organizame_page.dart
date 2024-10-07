// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/* nota 12 */
class OrganizamePage extends StatelessWidget {

  final List<SingleChildWidget>? _bindings;
  final WidgetBuilder _page;
  final BuildContext? appContext;
  const OrganizamePage({
    super.key,
    this.appContext,
    List<SingleChildWidget>? bindings,
    required WidgetBuilder page,
  }) : _bindings = bindings, _page = page;
 

   @override
   Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: _bindings ?? [ Provider(create: (_) => Object())],
      builder: (context, w) {
        return _page(appContext ?? context);
},
    );       
  }
}
