import 'package:flutter/material.dart';

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
                
                title: Text('Teste'),
              )
            ],
          ),
        ));
  }
}
