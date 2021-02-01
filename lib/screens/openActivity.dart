import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:video_player/video_player.dart';

class OpenActivity extends StatefulWidget {
  final String activityName, timeStamp, name, year;
  OpenActivity(this.activityName, this.timeStamp, this.name, this.year);
  @override
  _OpenActivityState createState() => _OpenActivityState();
}

class _OpenActivityState extends State<OpenActivity> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  Position positon;
  File _image, _file, _video;
  String imUrl, fileUrl, filename, videoUrl, location;
  var _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future getLocation() async {
    positon = await _determinePosition();
    location = "(" +
        positon.latitude.toString().replaceAll('.', '%') +
        "," +
        positon.longitude.toString().replaceAll('.', '%') +
        ")";
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
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
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'MANAGE ACTIVITY',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            (_image != null)
                ? Column(
                    children: [
                      SizedBox(
                        child: Image.file(_image),
                        width: 300,
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () async {
                            pr.style(
                              message: 'Updating..',
                              borderRadius: 10.0,
                              backgroundColor: Colors.white,
                              progressWidget: CircularProgressIndicator(
                                strokeWidth: 5.0,
                              ),
                              elevation: 10.0,
                              insetAnimCurve: Curves.easeInOut,
                            );
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                await pr.show();
                                await uploadData(1);
                                pr.hide();
                                Fluttertoast.showToast(
                                    msg: "Uploaded successfulyy!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[200],
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            } on SocketException catch (_) {
                              Fluttertoast.showToast(
                                  msg: "Internet not connected!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            'Upload',
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
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    await _imgFromCamera(1);
                  },
                  child: Text(
                    'Add Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            (_file != null)
                ? Column(
                    children: [
                      SizedBox(
                        child: Image.file(_file),
                        width: 300,
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () async {
                            pr.style(
                              message: 'Updating..',
                              borderRadius: 10.0,
                              backgroundColor: Colors.white,
                              progressWidget: CircularProgressIndicator(
                                strokeWidth: 5.0,
                              ),
                              elevation: 10.0,
                              insetAnimCurve: Curves.easeInOut,
                            );
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                await pr.show();
                                await uploadData(0);
                                pr.hide();
                                Fluttertoast.showToast(
                                    msg: "Uploaded successfulyy!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[200],
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            } on SocketException catch (_) {
                              Fluttertoast.showToast(
                                  msg: "Internet not connected!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            'Upload',
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
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    await _imgFromCamera(0);
                  },
                  child: Text(
                    'Add Document',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            (_video != null)
                ? Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () async {
                            pr.style(
                              message: 'Updating..',
                              borderRadius: 10.0,
                              backgroundColor: Colors.white,
                              progressWidget: CircularProgressIndicator(
                                strokeWidth: 5.0,
                              ),
                              elevation: 10.0,
                              insetAnimCurve: Curves.easeInOut,
                            );
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                await pr.show();
                                await uploadData(2);
                                pr.hide();
                                Fluttertoast.showToast(
                                    msg: "Uploaded successfulyy!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey[200],
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            } on SocketException catch (_) {
                              Fluttertoast.showToast(
                                  msg: "Internet not connected!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            'Upload',
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
                    ],
                  )
                : Container(),
            Center(
              child: SizedBox(
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    await _videoFromCamera();
                    _controller = VideoPlayerController.file(_video);
                    _initializeVideoPlayerFuture = _controller.initialize();
                  },
                  child: Text(
                    'Record Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _imgFromCamera(int k) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      filename = DateTime.now().toString() + widget.activityName;
      if (k == 1) {
        if (mounted) {
          setState(() {
            _image = File(image.path);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _file = File(image.path);
          });
        }
      }
    }
  }

  _videoFromCamera() async {
    PickedFile video = await _picker.getVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: Duration(minutes: 2));
    filename = DateTime.now().toString() + widget.activityName;
    if (mounted) {
      setState(() {
        _video = File(video.path);
        _controller = VideoPlayerController.file(_video);
      });
    }
  }

  Future uploadData(k) async {
    await _uploadFile(k);
    if (k == 1) {
      await uploadPath("Photos", imUrl);
    }
    if (k == 0) {
      await uploadPath("Documents", fileUrl);
    }
    if (k == 2) {
      await uploadPath("Videos", fileUrl);
    }
  }

  uploadPath(String path, String url) async {
    int j = 0;
    final bgRef = FirebaseDatabase.instance.reference().child("Programs");
    await bgRef
        .child("Activities")
        .child(widget.year)
        .child(widget.activityName)
        .child(widget.timeStamp)
        .child(path)
        .once()
        .then((DataSnapshot data) {
      var k = data.value;
      if (k == null) {
        j = 1;
      }
    });
    if (j == 0) {
      await bgRef
          .child("Activities")
          .child(widget.year)
          .child(widget.activityName)
          .child(widget.timeStamp)
          .child(path)
          .update({
        DateTime.now().toString().replaceAll('.', '%'): {location: url}
      });
    } else {
      await bgRef
          .child("Activities")
          .child(widget.year)
          .child(widget.activityName)
          .child(widget.timeStamp)
          .child(path)
          .set({
        DateTime.now().toString().replaceAll('.', '%'): {location: url}
      });
    }
  }

  Future<void> _uploadFile(int k) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask;
    if (k == 1) {
      uploadTask = storageReference.putFile(_image);
    }
    if (k == 0) {
      uploadTask = storageReference.putFile(_file);
    }
    if (k == 2) {
      uploadTask = storageReference.putFile(_video);
    }
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String link = await downloadUrl.ref.getDownloadURL();
    if (k == 1) {
      if (mounted) {
        setState(() {
          imUrl = link;
        });
      }
    }
    if (k == 0) {
      if (mounted) {
        setState(() {
          fileUrl = link;
        });
      }
    }
    if (k == 2) {
      if (mounted) {
        setState(() {
          videoUrl = link;
        });
      }
    }
  }
}
