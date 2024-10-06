import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/customer/customer_controller.dart';
import 'package:organizame/app/modules/customer/customer_create_page.dart';
import 'package:provider/provider.dart';

class CustomerModule extends OrganizameModule {
  CustomerModule()
      : super(
          bindings: [
            ChangeNotifierProvider(create: (context) => CustomerController(
              customerService: context.read(),
            )),

                      ],
          routers: {
            '/customer_create': (context) => CustomerCreatePage(
              controller: Provider.of<CustomerController>(context, listen: false),

            ),
          }, 
        );
}
