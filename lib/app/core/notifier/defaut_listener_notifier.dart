import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/core/ui/messages.dart';


class DefaultListenerNotifier {

//variavel para armazenar o changeNotifier
 final DefautChangeNotifer changeNotifier;

//construtor obrigatorio
 DefaultListenerNotifier({
  required this.changeNotifier,
 });

//metodo para adicionar um listener e mostrar o loader
void listener({
  required BuildContext context,// recebe o contexto
  required SucessVoidCallback sucessCallback,// recebe um callback de sucesso
  EverVoidCallback? everCallback,// recebe um callback de sucesso
  ErrorVoidCallback? errorCallback,// recebe um callback de erro opcional
}) {  
    changeNotifier.addListener(() {//adiciona um listener
      if(everCallback != null) {//se o callback de sempre não for nulo
        everCallback(changeNotifier, this);//chama o callback de sempre}
      if(changeNotifier.isSuccess){//se o loading for verdadeiro
            Loader.hide();//esconde o loader

    }else {
        Loader.show(context);//mostra o loader
    }

    if(changeNotifier.hasError){//se tiver erro
      if(errorCallback != null){//se o callback de erro não for nulo
        errorCallback(changeNotifier, this);//chama o callback de erro
      }
      Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');//mostra a mensagem de erro
    } else if(changeNotifier.isSuccess){//se tiver sucesso
      if(sucessCallback != null){//se o callback de sucesso não for nulo
        sucessCallback(changeNotifier, this);//chama o callback de sucesso
      }
    }
    }
  });

}

//metodo para liberar a memoria e fechar o listener
void dispose() {
  changeNotifier.removeListener(() {});//remove o listener
}

}

//! o typedef é usado para criar um alias para um tipo de função existente
//! nesse caso ele criu essa função de sucesso que recebe um DefaultChangeNotifier e um DefaultListenerNotifier
//! e não retorna nada
typedef SucessVoidCallback = void Function(
  DefautChangeNotifer notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorVoidCallback = void Function(
  DefautChangeNotifer notifier, DefaultListenerNotifier listenerInstance);

typedef EverVoidCallback = void Function( //typedef para um callback que sempre será chamado
  DefautChangeNotifer notifier, DefaultListenerNotifier listenerInstance);