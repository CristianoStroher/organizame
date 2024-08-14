import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/organizame_icons.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameTextformfield extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  OrganizameTextformfield({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIconButton,
    this.controller,
    this.validator,
    this.focusNode,
  })  : assert(obscureText == true ? suffixIconButton == null : true,
            'ObscureText não pode ser enviado em conjunto com suffixIconButton'),
        obscureTextVN = ValueNotifier(
            obscureText); // Se obscureText for true, suffixIconButton deve ser null

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextVN,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: context.primaryColor,
              fontSize: context.titleDefaut.fontSize,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: context.primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: context.primaryColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            isDense: true,
            suffixIcon: suffixIconButton ??
                (obscureText == true
                    ? IconButton(
                        onPressed: () {
                          obscureTextVN.value = !obscureTextVN.value;
                        },
                        icon: Icon(
                            !obscureTextVN.value
                                ? Organizeicons.eye_slash
                                : Organizeicons.eye,
                            size: 13,
                            color: context.secondaryColor),
                      )
                    : null),
          ),
          obscureText: obscureTextValue,
        );
      },
    );
  }
}
