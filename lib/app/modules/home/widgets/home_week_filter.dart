import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class HomeWeekFilter extends StatelessWidget {

  const HomeWeekFilter({ super.key });

   @override
   Widget build(BuildContext context) {
       return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'DIA DA SEMANA',
            style: context.titleDefaut,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 95,
            child: DatePicker(
              DateTime.now(),
              locale: 'pt_BR',
              initialSelectedDate: DateTime.now(),
              selectionColor: context.primaryColor,
              selectedTextColor: context.primaryColorLight,
              daysCount: 7,                                                   
              ),
              
          ),
                 

        ],

       );
  }
}