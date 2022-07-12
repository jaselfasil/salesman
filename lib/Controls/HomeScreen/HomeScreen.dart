import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:salesman/Controls/registration.dart';
import 'package:salesman/DataBaseHandler/DbHelper.dart';
import 'package:salesman/Model/UserModel.dart';
import 'dart:convert';

import 'package:searchfield/searchfield.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var dbHelper;
  Uint8List _bytesImage;
  String _selectedCountry;
  @override
  void initState() {
    // TODO: implement initState
    dbHelper = DbHelper();
    userData();
    super.initState();
  }

  List<UserModel> user = [];

  userData() async {
    user = await dbHelper.getUserData();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("SalesMan"),
        backgroundColor: Color(0xff2C4A52),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0,10)
              )]
            ),
            child: SearchField(
              hint: "Search",
              searchInputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey.shade200,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.8),
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
              itemHeight: 50,
              maxSuggestionsInViewPort: 5,
              suggestionsDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              onTap: (value){
                setState(() {
                  _selectedCountry = value;
                  print(_selectedCountry);
                });
              },
              suggestions: ["Jasel Fasil","Rishan","Habeeb Rahman","Ramshadh"],
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: width,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: user.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var item = user[index];
                  return Card(
                    elevation: 4,
                  child: Padding(
                    padding:  EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory( Base64Decoder().convert(item.photo_name),
                              width: 60,height: 50,fit: BoxFit.cover,),
                            ),
                            SizedBox(width: 8,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.user_name),
                                SizedBox(height: 5,),
                                Text("DOB : ${item.dob} , ${item.gender}"),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 15,),
                            Text("Salary : ${item.salary}"),
                            SizedBox(width: 15,),
                            Text("${item.nationality}"),

                          ],
                        ),
                      ],
                    ),
                  ),
                  );

                  /*return Column(
                    children: [
                      Row(
                        children: [
                          // Container(
                          //   width: width * 0.15,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Expanded(
                          //           child: Text(
                          //         "Jasel",
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.black),
                          //       )),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            width: width * 0.17,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  item.user_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.22,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  item.dob,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  item.salary,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  item.nationality,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  item.gender,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                      ),
                    ],
                  );*/
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        label: Text("Add Customer"),
        icon: Icon(Icons.add_outlined),
        onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Registration()),
          );
        },
      ),
    );
  }
}
