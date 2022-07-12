import 'package:flutter/material.dart';
import 'package:salesman/CommonClass/Key.dart';
import 'package:salesman/CommonClass/comHelper.dart';
import 'package:salesman/CommonClass/getTextFormFeild.dart';
import 'package:salesman/Controls/HomeScreen/HomeScreen.dart';
import 'package:salesman/Controls/registration.dart';
import 'package:salesman/DataBaseHandler/DbHelper.dart';
import 'package:salesman/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    dbHelper = DbHelper();
    loginInsertion();
    super.initState();
  }
  loginInsertion() async
  {
    dbHelper.insertUser();
  }
  login() async{
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    }
    else {
      LoginModel loginModel = LoginModel(uid, passwd);
      await dbHelper.getLoginUser(uid, passwd).then((loginData) {
        if (loginData != null) {
          setSP(loginData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Registration()),
                    (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }
  Future setSP(LoginModel loginModel) async {
    final SharedPreferences sp = await _pref;
    sp.setString(MyKey.uName,loginModel.u_name);
    sp.setString(MyKey.uPassword, loginModel.u_password);
    sp.setString(MyKey.loginStatus, "1");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                     Text("Login", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 20,),
                      Text("Login to your account", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        getTextFormField(
                            controller: _conUserId,
                            icon: Icons.person,
                            hintName: 'User ID'),
                        SizedBox(height: 10.0),
                        getTextFormField(
                          controller: _conPassword,
                          icon: Icons.lock,
                          hintName: 'Password',
                          isObscureText: true,
                        ),
                      ],
                    ),
                  ),
                 Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: login,
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Login", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}
