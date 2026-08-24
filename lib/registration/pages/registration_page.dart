import 'package:flutter/material.dart';
import 'package:smartdoor/registration/widgets/registration_form.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration'), centerTitle: true),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: RegistrationForm(),
          ),
        ),
      ),
    );
  }
}
