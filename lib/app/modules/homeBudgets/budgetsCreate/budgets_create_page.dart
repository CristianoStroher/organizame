
import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo_movie.dart';
import 'package:organizame/app/core/widget/organizame_textfield.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';

class BudgetsCreatePage extends StatefulWidget {
  final BudgetsController _controller;
  final BudgetsObject? object;


  const BudgetsCreatePage({
    super.key,
    required BudgetsController controller,
    this.object
    }) : _controller = controller;

  @override
  State<BudgetsCreatePage> createState() => _BudgetsCreatePageState();
}

class _BudgetsCreatePageState extends State<BudgetsCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final observationsEC = TextEditingController();
  final valueEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.primaryColorLight,
        automaticallyImplyLeading: false,
        title: OrganizameLogoMovie(
          text: 'Orçamento',
          part1Color: context.primaryColor,
          part2Color: context.primaryColor,
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: context.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Form(
        key: _globalKey,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.object == null ? 'NOVA ORÇAMENTO' : 'EDITAR ORÇAMENTO',
                        style: context.titleDefaut),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120, // Ajusta a altura total
                      child: OrganizameTextField(
                        controller: observationsEC,
                        label: 'Observações',
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OrganizameElevatedButton(
                      label: widget.object != null ? 'Atualizar' : 'Salvar',
                      onPressed: () {
                        _handleSave();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}