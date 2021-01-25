import 'package:MG/screens/loginHome.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddActivity extends StatefulWidget {
  final String name;
  final Map<dynamic, dynamic> database;
  AddActivity(this.name, this.database);
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  bool loading = true;
  List<String> activities, districts, taluks, gps, villages;
  String activity = '',
      district = '',
      taluk = '',
      gp = '',
      village = '',
      noOfParticipants = '',
      timeStamp,
      today;
  DateFormat _timeStamp = new DateFormat('dd-MM-yyyy-hh:mm');
  DateFormat _dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    taluks = new List();
    gps = new List();
    villages = new List();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: 'Creating...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        strokeWidth: 5.0,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
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
      body: loading
          ? CircularProgressIndicator(
              strokeWidth: 3,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Add Event',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: Text(
                      'Activity: ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                    child: SearchableDropdown.single(
                      items: activities.map((exNum) {
                        return (DropdownMenuItem(
                            child: Text(exNum), value: exNum));
                      }).toList(),
                      hint: "Search activity",
                      searchHint: "Type..",
                      onChanged: (value) {
                        activity = value;
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: Text(
                      'District: ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                    child: SearchableDropdown.single(
                      items: districts.map((exNum) {
                        return (DropdownMenuItem(
                            child: Text(exNum), value: exNum));
                      }).toList(),
                      hint: "Search district",
                      searchHint: "Type..",
                      onChanged: (value) {
                        district = value;
                        loadTaluks();
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: Text(
                      'Taluk: ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                    child: SearchableDropdown.single(
                      items: taluks.map((exNum) {
                        return (DropdownMenuItem(
                            child: Text(exNum), value: exNum));
                      }).toList(),
                      hint: "Search taluks",
                      searchHint: "Type..",
                      onChanged: (value) {
                        taluk = value;
                        loadGps();
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: Text(
                      'Gram Panchayat: ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                    child: SearchableDropdown.single(
                      items: gps.map((exNum) {
                        return (DropdownMenuItem(
                            child: Text(exNum), value: exNum));
                      }).toList(),
                      hint: "Search GP..",
                      searchHint: "Type..",
                      onChanged: (value) {
                        gp = value;
                        loadVillages();
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: Text(
                      'Village: ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40, 0),
                    child: SearchableDropdown.single(
                      items: villages.map((exNum) {
                        return (DropdownMenuItem(
                            child: Text(exNum), value: exNum));
                      }).toList(),
                      hint: "Search village",
                      searchHint: "Type..",
                      onChanged: (value) {
                        village = value;
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? 'Required' : null,
                      onChanged: (val) {
                        setState(() {
                          noOfParticipants = val.trim();
                        });
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'No of Participants',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: RaisedButton(
                      onPressed: () async {
                        if (activity != null &&
                            activity.isNotEmpty &&
                            district != null &&
                            district.isNotEmpty &&
                            taluk != null &&
                            taluk.isNotEmpty &&
                            gp != null &&
                            gp.isNotEmpty &&
                            village != null &&
                            village.isNotEmpty) {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm?'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Activity Name : ' + activity,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'District : ' + district,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Taluk : ' + taluk,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'GP : ' + gp,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Village : ' + village,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ((noOfParticipants == null) ||
                                              noOfParticipants.isEmpty)
                                          ? Text(
                                              'Number : 0',
                                              style: TextStyle(fontSize: 20),
                                            )
                                          : Text(
                                              'Number: ' + noOfParticipants,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Create'),
                                    onPressed: () async {
                                      pr.style(
                                        message: 'Updating..',
                                        borderRadius: 10.0,
                                        backgroundColor: Colors.white,
                                        progressWidget:
                                            CircularProgressIndicator(
                                          strokeWidth: 5.0,
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                      );
                                      await pr.show();
                                      await create();
                                      pr.hide();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new LoginHome(widget.name)));
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          activity == null || activity.isEmpty
                              ? showToast("Choose Activity")
                              : district == null || district.isEmpty
                                  ? showToast("Choose District")
                                  : taluk == null || taluk.isEmpty
                                      ? showToast("Choose Taluk")
                                      : gp == null || gp.isEmpty
                                          ? showToast("Choose Gram Panchayat")
                                          : village == null || village.isEmpty
                                              ? showToast("Choose Village")
                                              // ignore: unnecessary_statements
                                              : null;
                        }
                      },
                      child: Text(
                        'Create Event',
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
            ),
    );
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 20.0);
  }

  Future create() async {
    timeStamp = _timeStamp.format(DateTime.now());
    today = _dateFormat.format(DateTime.now());
    final bgRef = FirebaseDatabase.instance.reference().child("Programs");
    await bgRef.child("Activities").child(activity).child(timeStamp).set({
      'district': district,
      'taluk': taluk,
      'gp': gp,
      'village': village,
      'noOfPeople': noOfParticipants,
      'createdBy': widget.name,
    });
    await bgRef.child("Events").child(today).child(timeStamp).set({
      'eventName': activity,
      'village': village,
    });
  }

  loadData() {
    activities = new List();
    districts = new List();
    if (widget.database["Activities"] != null) {
      for (var key in widget.database["Activities"].keys) {
        activities.add(key);
      }
    }
    if (widget.database["Districts"] != null) {
      for (var key in widget.database["Districts"].keys) {
        districts.add(key);
      }
      if (mounted) {
        setState(() {
          district = districts[0];
          loading = false;
        });
      }
      loadTaluks();
    } else {
      districts.add("No district found");
      setState(() {
        loading = false;
      });
    }
  }

  loadTaluks() {
    taluks = new List();
    if (widget.database["Districts"][district]["Taluks"] != null) {
      for (var key in widget.database["Districts"][district]["Taluks"].keys) {
        taluks.add(key);
      }
      if (mounted) {
        setState(() {
          taluk = taluks[0];
        });
      }
      loadGps();
    }
  }

  loadGps() {
    gps = new List();
    if (widget.database["Districts"][district]["Taluks"][taluk]["GPs"] !=
        null) {
      for (var key in widget
          .database["Districts"][district]["Taluks"][taluk]["GPs"].keys) {
        gps.add(key);
      }
      if (mounted) {
        setState(() {
          gp = gps[0];
        });
      }
      loadVillages();
    }
  }

  loadVillages() {
    villages = new List();
    if (widget.database["Districts"][district]["Taluks"][taluk]["GPs"][gp]
            ["Villages"] !=
        null) {
      for (var key in widget
          .database["Districts"][district]["Taluks"][taluk]["GPs"][gp]
              ["Villages"]
          .keys) {
        villages.add(key);
      }
      if (mounted) {
        setState(() {
          village = villages[0];
        });
      }
    }
  }
}
