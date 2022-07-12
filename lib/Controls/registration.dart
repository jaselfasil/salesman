import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:salesman/CommonClass/Utility.dart';
import 'package:salesman/CommonClass/comHelper.dart';
import 'package:salesman/CommonClass/getTextFormFeild.dart';
import 'package:salesman/Controls/HomeScreen/HomeScreen.dart';
import 'package:salesman/DataBaseHandler/DbHelper.dart';
import 'package:salesman/Model/UserModel.dart';


class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  File _image;
  String imgString;

  final _conUserName = TextEditingController();
  final _conSalary = TextEditingController();
  final _conNationality = TextEditingController();
  final _conDOB = TextEditingController();
  Color text_color;
  var DdMmYyyy = DateFormat('dd-MM-yyyy');
  String _selectedNationalality;
  List<String> natioanality = ["India", "Germany", "Africa"];
  TextEditingController natioanalityController = TextEditingController();
  List<DropdownMenuItem<String>> _dropdownMenuItemsNatioanality = [];
  bool isMode = false;
  bool _value = false;
  int val = -1;
  String gender_value;

  @override
  void initState() {
    // TODO: implement initState
    doloopingNationality();
    dbHelper = DbHelper();
    super.initState();
  }

  doloopingNationality() {
    if (natioanality != null) {
      setState(() {
        _dropdownMenuItemsNatioanality =
            buildDropdownMenuItemsNationality(natioanality);
      });
    }
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItemsNationality(
      List nationality) {
    List<DropdownMenuItem<String>> items = List();
    for (String nationality in nationality) {
      items.add(
        DropdownMenuItem(
          value: nationality,
          child: Text(nationality),
        ),
      );
    }
    return items;
  }

  itemChangeNationality(String selectedNationality) {
    setState(() {
      _selectedNationalality = selectedNationality;
      isMode = true;
//      sentDistrictRequest();
    });
  }
  final _formKey = new GlobalKey<FormState>();
  var dbHelper;
  CreateUser() {
    final form = _formKey.currentState;
    String uname = _conUserName.text;
    String dob = _conDOB.text.toString();
    String salary = _conSalary.text;
    String nationality = _selectedNationalality;
    String gender = gender_value;
   if(form.validate())
     {
       _formKey.currentState.save();
       UserModel uModel = UserModel(uname, dob, salary, nationality,gender,imgString);
       dbHelper.saveData(uModel).then((userData){
         alertDialog(context, "Successfully Saved");
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => HomeScreen()),
         );
       }).catchError((error) {
         print(error);
         alertDialog(context, "Error: Data Save Fail");
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
//                  height: MediaQuery.of(context).size.width * 0.29,
//                  width: MediaQuery.of(context).size.width * 0.29,
                      alignment: Alignment(0, 0),
                      child: PopupMenuButton(
                        offset: Offset(0, 100),
                        child: _image == null
                            ? CircleAvatar(
                                radius: MediaQuery.of(context).size.height * .07,
                                backgroundImage: AssetImage(
                                  "assets/photo.png",
                                ),
                                //backgroundColor: Colors.blueGrey[300],
                              )
                            : CircleAvatar(
                                radius: MediaQuery.of(context).size.height * .07,
                                backgroundColor: Colors.blue,
                                child: CircleAvatar(
                                  backgroundImage: new FileImage(_image),
                                  radius:
                                      MediaQuery.of(context).size.height * .07,
                                )),
                        itemBuilder: (context) {
                          return <PopupMenuItem<ImageSource>>[
                            PopupMenuItem(
                              child: ListTile(
                                title: Text("Camera"),
                                leading: Icon(Icons.camera_alt),
                              ),
                              value: ImageSource.camera,
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text("Gallery"),
                                leading: Icon(Icons.image),
                              ),
                              value: ImageSource.gallery,
                            ),
                          ];
                        },
                        onSelected: chooseImage,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person,
                      hintName: 'Name',
                      isObscureText: false,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
//                    enabled: false,

                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext builder) {
                                return Container(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height /
                                        2.8,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3, right: 3),
                                          child: Align(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .08,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  print("back pressed");
                                                },
                                                child: Text(
                                                  'Done',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .04),
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.topRight,
                                          ),
                                        ),
                                        Expanded(
                                          child: CupertinoDatePicker(
//                                          initialDateTime: DateTime.now(),
                                            initialDateTime: DateTime.now(),
                                            onDateTimeChanged:
                                                (DateTime newdate) {
                                              print(newdate);
                                              setState(() {
                                                text_color = Colors.black;
                                                _conDOB.text =
                                                    DdMmYyyy.format(newdate);
                                              });
                                            },
                                            use24hFormat: true,
                                            maximumDate: new DateTime.now(),
                                            minimumYear: 1900,
                                            maximumYear: 2030,
                                            minuteInterval: 1,
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        ),
                                      ],
                                    ));
                              });
                        },
                        autofocus: false,
                        readOnly: true,

                        keyboardType: TextInputType.phone,
                        controller: _conDOB,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "DOB",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    getTextFormField(
                      controller: _conSalary,
                      icon: Icons.monetization_on_outlined,
                      hintName: 'Salary',
                      isObscureText: false,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          hintText: 'Nationality',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        value: _selectedNationalality,
                        items: _dropdownMenuItemsNatioanality,
                        onChanged: itemChangeNationality,
                      ),
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: Text("Male"),
                          leading: Radio(
                            value: 1,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value;
                                gender_value = "Male";
                                print("value${gender_value}");
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        ListTile(
                          title: Text("Female"),
                          leading: Radio(
                            value: 2,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value;
                                gender_value = "Female";
                                print("value${gender_value}");
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      CreateUser();
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Create",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _image = image;
       imgString = Utility.base64String(_image.readAsBytesSync());
      if (_image != null) {
        // Toast.show("Done", context);
      }
    });
  }
}
