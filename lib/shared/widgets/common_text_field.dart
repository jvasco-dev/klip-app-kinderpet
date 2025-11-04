import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class CommonTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData icon;
  final void Function(String)? onChanged;
  final AutovalidateMode? autoValidateMode;

  const CommonTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.autoValidateMode,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late FocusNode _focusNode;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Detectar cuando el campo pierde el foco
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Cuando pierde foco, activamos autovalidación
        setState(() {
          _autoValidateMode = AutovalidateMode.always;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CommonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔹 Si el Bloc manda autovalidateMode = always, actualizamos
    if (widget.autoValidateMode != null &&
        widget.autoValidateMode != _autoValidateMode) {
      setState(() {
        _autoValidateMode = widget.autoValidateMode!;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autovalidateMode: _autoValidateMode,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.only(top: 11),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Icon(widget.icon),
              Container(height: 20, width: 1, color: Colors.grey),
            ],
          ),
        ),
        hintText: widget.hintText,
        filled: true,
        fillColor: AppColors.softWhite,
        hintStyle: TextStyle(color: AppColors.grayNeutral),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grayNeutral),
        ),
        errorStyle: TextStyle(color: Colors.redAccent[700], fontSize: 13),
      ),
    );
  }
}
