import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

class PasswordInput extends StatefulWidget {

 final Function _setPassword;

 PasswordInput([this._setPassword]);

  @override
  State<StatefulWidget> createState() {
    return StatefulPasswordInput();
  }
}

class StatefulPasswordInput extends State<PasswordInput> {
  bool obscurePassword = true;
  final TextEditingController _passwordController = new TextEditingController();
  final FocusNode _textFocus = new FocusNode();

  @override
  void initState() {
    _passwordController.addListener(onChange);
    _textFocus.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void updatePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void onChange(){
    widget._setPassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscurePassword,
      maxLength: 8,
      controller: _passwordController,
//      textInputAction: widget._setPassword(_passwordController.text),
//      onEditingComplete: widget._setPassword(_passwordController.text),
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: '',
        labelText: 'Password',
        helperText: 'No more than 8 characters',
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          child: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off,
              semanticLabel:
                  obscurePassword ? 'show password' : 'hide password'),
        ),
      ),
    );
  }
}
