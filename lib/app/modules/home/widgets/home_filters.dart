import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/home/widgets/home_card_filter.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTROS',
          style: context.titleDefaut,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              HomeCardFilter(
                label: 'HOJE',
                color: context.primaryColor,
                borderColor: context.primaryColor,
                textColor: context.scaffoldBackgroundColor,
                linearProgress: context.primaryColorLight,
                value: Colors.white,
              ),
              const HomeCardFilter(
                label: 'AMANHÃ',
                color: Color(0xFFFAFFC5),
                borderColor: Color.fromARGB(255, 185, 193, 52),
                textColor: Color.fromARGB(255, 185, 193, 52),
                value: Color.fromARGB(255, 185, 193, 52),
                linearProgress: Colors.white,
              ),
              const HomeCardFilter(
                label: 'SEMANA',
                color: Color(0xFFDDFFCC),
                borderColor: Color.fromARGB(255, 93, 130, 75),
                textColor: Color.fromARGB(255, 93, 130, 75),
                value: Color.fromARGB(255, 93, 130, 75),
                linearProgress: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
