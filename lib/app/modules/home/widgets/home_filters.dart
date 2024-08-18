import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class HomeFilters extends StatefulWidget {

  const HomeFilters({ super.key });

  @override
  State<HomeFilters> createState() => _HomeFiltersState();
}

class _HomeFiltersState extends State<HomeFilters> {
   @override
   Widget build(BuildContext context) {
       return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FILTROS',
            style: context.titleDefaut,
            ),
                    
        ],
       );
  }
}