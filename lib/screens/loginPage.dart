import 'package:MG/screens/loginHome.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '', error = '', password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity Manager',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Employee Login',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 5, 50, 0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.0),
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Required' : null,
                              onChanged: (val) {
                                setState(() {
                                  name = val.trim();
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Name',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              validator: (val) =>
                                  val.isEmpty ? 'Required' : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val.trim();
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          pr.style(
                            message: 'Signing in...',
                            borderRadius: 10.0,
                            backgroundColor: Colors.white,
                            progressWidget: CircularProgressIndicator(
                              strokeWidth: 5.0,
                            ),
                            elevation: 10.0,
                            insetAnimCurve: Curves.easeInOut,
                          );
                          await pr.show();
                          error = '';
                          int res = await login(pr);
                          if (res != 0) {
                            pr.hide();
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new LoginHome(name)));
                          } else {
                            pr.hide();
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )),
      ),
      backgroundColor: Colors.white,
    );
  }

  login(ProgressDialog pr) async {
    int flag = 0;
    final loginRef =
        FirebaseDatabase.instance.reference().child("Programs").child("Users");
    await loginRef.once().then((DataSnapshot data) {
      Map<dynamic, dynamic> users = data.value;
      if (users != null) {
        if (users.containsKey(name)) {
          if (users[name]['password'].toString() == password) {
            flag = 1;
          } else {
            setState(() {
              error = 'Incorrect password';
            });
            return flag;
          }
        } else {
          setState(() {
            error = 'Invalid username';
          });
          return flag;
        }
      }
    });
    return flag;
  }
}
