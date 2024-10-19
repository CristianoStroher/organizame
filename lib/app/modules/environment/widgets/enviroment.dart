import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class Enviroment extends StatelessWidget {
  final String enviromentPhone;
  final String enviromentName;
  final String enviromentAdress;

  const Enviroment({
    super.key,
    required this.enviromentName,
    required this.enviromentPhone,
    required this.enviromentAdress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Ação quando o ambiente é clicado
      },
      child: Column(
        children: [
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 0,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(8), // Ajuste de padding
            title: Text(
              enviromentName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.primaryColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(enviromentPhone, style: context.titleDefaut),
                Text(enviromentAdress, style: context.titleDefaut),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                // Ação ao deletar o ambiente
              },
              icon: Icon(Icons.delete, color: context.secondaryColor),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 0,
          ),
        ],
      ),
    );
  }
}
