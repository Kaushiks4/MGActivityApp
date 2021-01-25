import 'package:MG/models/activity.dart';
import 'package:MG/screens/addEvent.dart';
import 'package:MG/screens/openActivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginHome extends StatefulWidget {
  final String name;
  LoginHome(this.name);
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool loading = true;
  DateTime now = DateTime.now();
  DateFormat _timeStamp = new DateFormat('dd-MM-yyyy-hh:mm');
  DateFormat _dateFormat = new DateFormat('dd-MM-yyyy');
  String today;
  List<Activity> activities;
  Map<dynamic, dynamic> database;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    activities = new List();
    database = new Map();
    today = _dateFormat.format(now);
    final bgRef = FirebaseDatabase.instance.reference().child("Programs");
    await bgRef.once().then((DataSnapshot data) {
      database = data.value;
    });
    if (database["Events"] != null) {
      if (database["Events"]["25-01-2021"] != null) {
        for (var key in database["Events"]["25-01-2021"].keys) {
          activities.add(Activity(
              timeStamp: key,
              activityName: database["Events"]["25-01-2021"][key]['eventName'],
              village: database["Events"]["25-01-2021"][key]['village']));
        }
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Text(
                'Date: ' + _dateFormat.format(now),
                style: TextStyle(fontSize: 25),
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  )
                : dataBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AddActivity(widget.name, database))),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget dataBody() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          (activities == null || activities.isEmpty)
              ? Center(
                  child: Text(
                    'No Activities found!!',
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    columnSpacing: 15,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Village',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Action',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: activities
                        .map((activity) => DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    activity.activityName,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    activity.village,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  FlatButton(
                                    child: Text(
                                      'Manage',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                    onPressed: () => Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new OpenActivity(
                                                    activity.activityName,
                                                    activity.timeStamp,
                                                    widget.name))),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
        ]),
      );
}
