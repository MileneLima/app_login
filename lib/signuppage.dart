import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupFormState();
}

class SignupFormState extends State<SignupPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Nome',
            ),
            controller: _nomeController,
          ),
          SizedBox(height: 20.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            controller: _emailController,
          ),
          SizedBox(height: 20.0),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
            ),
            controller: _senhaController,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              cadastrar(
                  context); // Adicione aqui a lógica de cadastro de usuário.
            },
            child: Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  Future cadastrar(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _senhaController.text);

      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nomeController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginApp()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Crie uma senha mais forte!'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este email já esta em uso!'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
    // _firebaseAuth
    //     .createUserWithEmailAndPassword(
    //         email: _emailController.text, password: _senhaController.text)
    //     .then((UserCredential userCredential) {
    //   userCredential.user!.updateDisplayName(_nomeController.text);
    //   Navigator.pushAndRemoveUntil(
    //       context as BuildContext, MaterialPageRoute(builder: (context)), (route) => false);
    // }).catchError((FirebaseAuthException e) {});
  }
}
