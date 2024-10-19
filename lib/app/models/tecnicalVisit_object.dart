import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object2.dart';

class TecnicalVisitObject {
  final String id;
  final DateTime date;
  final DateTime time;
  final CustomerObject customer;
  final List<EnviromentObject2>? enviroments;

  TecnicalVisitObject({
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    this.enviroments,
    
  });



}