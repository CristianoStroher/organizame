import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:provider/provider.dart';

class Visit extends StatelessWidget {
  const Visit({super.key});

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
                    Text('2 AMBIENTES',
                        style: context.titleDefaut,
                        ),
                    Text('27/07/2024',
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
