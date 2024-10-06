import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class Customer extends StatelessWidget {

  const Customer({ super.key });

   @override
   Widget build(BuildContext context) {
       return InkWell(
        onTap: () {},
        child: SizedBox(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[300], // Linha cinza acima
                thickness: 1.5,
                height: 0,
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(.8),
                title: Text('CRISTIANO ALBERTO STROHER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor
                ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('54.99025.5221',
                        style: context.titleDefaut,
                        ),
                    Text('Rua Santa Catarina, 369 - Ap. 101 - Passo Fundo',
                    style: context.titleDefaut,),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete, color: context.secondaryColor),
                ),
              ),
              Divider(
                color: Colors.grey[300], // Linha cinza abaixo
                thickness: 1.5,
                height: 0,
              ),
            ],
          ),
        ));
  }
}