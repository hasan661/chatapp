import 'package:chatapp/widgets/authform/authform.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading=false;
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx
  ) async {
    var authResult;

    try {
      setState(() {
          isLoading=true;
        });
      if (isLogin) {
        
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
          
        
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
            await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
              "username":username,
              "email":email
            });
      }
      

    } on PlatformException catch (err) {
      var message = "An error occured please check your credentials!";

      if (err.message != null) {
        message = err.message.toString();
      }
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }catch(err){
      setState(() {
        isLoading=false;
      });
       ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: AuthForm(
        submitFn: _submitAuthForm,
        isloading:isLoading
      )),
    );
  }
}
