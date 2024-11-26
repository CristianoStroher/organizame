// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

import './budgets_repository.dart';

class BudgetsRepositoryImpl extends BudgetsRepository {
  final FirebaseFirestore _firestore;
  final String _budgets = 'budgets';

  BudgetsRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> saveBudget(String id, Customer customer, DateTime date,
      String? observation, double value, bool status) async {
    try {
      await _firestore.collection(_budgets).add({
        'id': id,
        'customer': customer,
        'date': date,
        'observation': observation,
        'value': value,
        'status': status,
      });
    } on Exception catch (e) {
      Logger().e('Erro ao salvar o orçamento: $e');
      throw Exception('Erro ao salvar o orçamento: $e');
    }
  }
}
