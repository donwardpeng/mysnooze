import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

class PasswordInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatefulPasswordInput();
  }
}

class StatefulPasswordInput extends State<PasswordInput> {
  bool obscurePassword = true;

  void updatePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscurePassword,
      maxLength: 8,
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
