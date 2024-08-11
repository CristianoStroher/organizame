
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/core/ui/messages.dart';

class DefautListenerNotifier {

  final DefautChangeNotifer changeNotifier;
  

  DefautListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SucessVoidCallback sucessCallback,
    }) {
    changeNotifier.addListener(() {
      if (changeNotifier.isLoading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        Messages.of(context).showError(changeNotifier.error ?? 'Erro Interno');
      } else if (changeNotifier.isSucess) {
          sucessCallback(changeNotifier, this);
        }
        
      }


    ); 

  }

  void removeListener() {
    changeNotifier.removeListener(() {});
  }
  
}

typedef SucessVoidCallback = void Function(
  DefautChangeNotifer changeNotifier, DefautListenerNotifier listenerInstance
);
