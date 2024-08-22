abstract class TasksRepository {
 
  Future<void> saveTask(DateTime date, DateTime time, String description, {String? observations});
  

}