import 'package:chatapp/picker/user_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitFn, required this.isloading})
      : super(key: key);
  final void Function(String email, String password, String username,File imageFile,
      bool isLogin, BuildContext context) submitFn;
  final bool isloading;


  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = "";
  String _userPassword = "";
  var isLogin = true;
  File? _userImageFile;
  void pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:const Text("Please pick a image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
    }
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      
      _userName.trim(),
      File(_userImageFile!.path),
      isLogin,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin) UserImage(imagePickFn: pickedImage),
                TextFormField(
                  key: const ValueKey('Email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email address",
                  ),
                  onSaved: (val) {
                    _userEmail = val.toString();
                  },
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('Username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return "Please enter a valid name";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userName = val.toString();
                    },
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                TextFormField(
                  key: const ValueKey('Password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 7) {
                      return "Password should be atleast 7 characters";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _userPassword = val.toString();
                  },
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isloading) const CircularProgressIndicator(),
                if (!widget.isloading)
                  ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(
                      isLogin ? "Login" : "Sign Up",
                    ),
                  ),
                if (!widget.isloading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Create new account"
                          : "I already have an account",
                    ),
                  )
              ],
            )),
      )),
    );
  }
}
