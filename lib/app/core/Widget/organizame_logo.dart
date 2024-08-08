import 'package:flutter/material.dart';

class OrganizameLogo extends StatelessWidget {

  final double? height;

  const OrganizameLogo({ super.key,
  this.height });

   @override
   Widget build(BuildContext context) {
       return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logonormal.png', height: height ?? 160,),
          Text('Organizando sua Vida', style:Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFFFFCCE2),
          fontFamily: 'Kanit'),
        
           ),
        ],
       
       );
  }
}