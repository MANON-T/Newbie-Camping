import 'dart:async';

import 'package:flutter/material.dart';

import '../service/auth_service.dart';

const kLoginStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontFamily: 'Itim');

const kErrorMessage = TextStyle(
  fontSize: 16,
  color: Colors.red,
);

const kOrStyle =
    TextStyle(fontSize: 16, color: Colors.orange, fontFamily: 'Itim');

class LoginScreen extends StatefulWidget {
  final AuthService auth;

  const LoginScreen({super.key, required this.auth});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isShowingPassword = true;
  bool _isRegister = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late StreamController errorController;
  late Stream errorStream;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    errorController = StreamController.broadcast();
    errorStream = errorController.stream;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildErrorText(),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Text(
                _isRegister ? 'สมัครสมาชิก' : 'เข้าสู่ระบบ',
                style: kLoginStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildEmailLoginForm(),
              const SizedBox(height: 20),
              _buildSwitchButtons(),
              const SizedBox(height: 20),
              _buildAnonymous(),
            ],
          );
  }

  Widget _buildErrorText() {
    return StreamBuilder(
      stream: errorStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              snapshot.data ?? '',
              style: kErrorMessage,
              textAlign: TextAlign.center,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildEmailLoginForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                labelStyle: const TextStyle(fontFamily: 'Itim', fontSize: 17),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                errorController.add(null);
              },
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    labelStyle: const TextStyle(fontFamily: 'Itim', fontSize: 17),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: _isShowingPassword,
                  onChanged: (value) {
                    errorController.add(null);
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    child: Icon(
                      _isShowingPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        _isShowingPassword = !_isShowingPassword;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  errorController.add('กรุณากรอกข้อมูลให้ครบถ้วน');
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                if (_isRegister) {
                  try {
                    await widget.auth.creatUserWithEmail(
                        emailController.text, passwordController.text);

                    // Check if still mounted before setting state
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } catch (e) {
                    errorController.add(getErrorMessage(e.toString()));
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  try {
                    await widget.auth.loginWithEmail(
                        emailController.text, passwordController.text);

                    // Check if still mounted before setting state
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } catch (e) {
                    errorController.add(getErrorMessage(e.toString()));
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _isRegister ? 'สมัครสมาชิก' : 'เข้าสู่ระบบ',
                style: const TextStyle(fontFamily: 'Itim', fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isRegister = false;
              errorController.add(null);
              emailController.clear();
              passwordController.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRegister ? Colors.grey : Colors.green,
          ),
          child: const Text(
            'เข้าสู่ระบบ',
            style: TextStyle(
                fontFamily: 'Itim', fontSize: 17, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isRegister = true;
              errorController.add(null);
              emailController.clear();
              passwordController.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRegister ? Colors.blue : Colors.grey,
          ),
          child: const Text(
            'สมัครสมาชิก',
            style: TextStyle(
                fontFamily: 'Itim', fontSize: 17, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymous() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'หรือ',
          style: kOrStyle,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            try {
              await widget.auth.login();

              // Check if still mounted before setting state
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            } catch (e) {
              errorController.add(getErrorMessage(e.toString()));
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: const Text(
            'ล็อกอินโดยไม่ระบุชื่อ',
            style: TextStyle(fontFamily: 'Itim', fontSize: 17),
          ),
        ),
      ],
    );
  }

  String getErrorMessage(String errorText) {
    List result = errorText.split("] ");
    return result.last;
  }
}
