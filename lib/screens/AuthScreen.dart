import 'package:flutter/material.dart';

import '../widgets/CustomTextField.dart';
import '../providers/FirebaseAuthenticationService.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "ToDo List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40,
                ),
              ),
              Center(
                child: AuthCard(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;

  FirebaseAuthenticationService _auth = FirebaseAuthenticationService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void switchLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(deviceSize.width * 0.01),
      height: _authMode == AuthMode.Login
          ? deviceSize.height * 0.45
          : deviceSize.height * 0.55,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomTextField(
                  deviceSize: deviceSize,
                  labelText: 'Email Address',
                  controller: _emailController,
                  icon: Icons.email,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomTextField(
                  deviceSize: deviceSize,
                  labelText: 'Password',
                  controller: _passwordController,
                  icon: Icons.security,
                  obscureText: true,
                  maxLines: 1,
                ),
              ),
              _authMode == AuthMode.Signup
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomTextField(
                            deviceSize: deviceSize,
                            labelText: "Confirm Password",
                            controller: _confirmPasswordController,
                            icon: Icons.security,
                            obscureText: true,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Container(width: 0, height: deviceSize.height * 0.02),
              _isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColor,
                      ),
                    )
                  : RaisedButton(
                      child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceSize.height * 0.025,
                        ),
                      ),
                      onPressed: () async {
                        if (_authMode == AuthMode.Login)
                          _auth.signInWithEmail(
                            context,
                            _emailController.text,
                            _passwordController.text,
                            switchLoading,
                          );
                        else
                          _auth.signUpWithEmail(
                            context,
                            _emailController.text,
                            _passwordController.text,
                            _confirmPasswordController.text,
                            switchLoading,
                          );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: _authMode == AuthMode.Login
                          ? EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.2,
                              vertical: deviceSize.height * 0.01,
                            )
                          : EdgeInsets.symmetric(
                              horizontal: deviceSize.width * 0.17,
                              vertical: deviceSize.height * 0.01,
                            ),
                      color: Theme.of(context).primaryColor,
                    ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FlatButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    style: TextStyle(
                      fontSize: deviceSize.height * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.09,
                    vertical: deviceSize.height * 0.01,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
