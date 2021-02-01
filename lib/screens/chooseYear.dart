import 'package:MG/screens/loginHome.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseYear extends StatefulWidget {
  final String name;
  final List<String> privelages;
  ChooseYear(this.name, this.privelages);
  @override
  _ChooseYearState createState() => _ChooseYearState();
}

class _ChooseYearState extends State<ChooseYear> {
  String year;
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Choose Year: ',
            style: TextStyle(fontSize: 25),
          ),
          Center(
            child: DropdownButton<String>(
              value: year,
              onChanged: (String newValue) {
                setState(() {
                  year = newValue;
                });
              },
              items: widget.privelages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (year != null && year.isNotEmpty) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new LoginHome(widget.name, year)));
                } else {
                  Fluttertoast.showToast(
                      msg: "Choose year",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text(
                'Submit',
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
    );
  }
}
