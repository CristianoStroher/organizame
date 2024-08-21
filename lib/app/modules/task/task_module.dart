import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/task/task_page.dart';
import 'package:provider/provider.dart';

class TaskModule extends OrganizameModule {
  TaskModule()
      : super(
          bindings: [
            ChangeNotifierProvider(
              create: (context) => TaskController(),
            ),
          ],
          router: {
            '/task': (context) => TaskPage(controller: context.read()),
          },
        );
}
