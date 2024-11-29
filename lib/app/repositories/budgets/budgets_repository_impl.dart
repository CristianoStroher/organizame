// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';

import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

import './budgets_repository.dart';

class BudgetsRepositoryImpl extends BudgetsRepository {
  final FirebaseFirestore _firestore;
  final String _budgets = 'budgets';

  BudgetsRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> saveBudget(String id, CustomerObject customer, DateTime date,
      String? observation, String value, bool status) async {
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

  @override
  Future<List<BudgetsObject>> getAllBudgets() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection(_budgets).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return BudgetsObject(
          id: doc.id,
          customer: data['customer'] as CustomerObject,
          date: (data['date'] as Timestamp)
              .toDate(), // convertendo o timestamp para DateTime
          observation: data['observation'] as String?,
          value: data['value'] as String,
          status: data['status'] as bool,
        );
      }).toList();
      Logger().i('Orçamentos buscados com sucesso');
    } on Exception catch (e) {
      Logger().e('Erro ao buscar os orçamentos: $e');
      throw Exception('Erro ao buscar os orçamentos: $e');
    }
  }
}
