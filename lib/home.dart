import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cruise_app/filter.dart';
import 'package:cruise_app/geolocation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';


class Menu extends StatefulWidget {
  const Menu ({super.key});

  @override
  State<Menu> createState() => _NavigationState();
}

class Camera {
  static bool orientation = true;
}

class _NavigationState extends State<Menu> {
  int currentPageIndex = 0;
  Stream<GyroscopeEvent>? _gyroscopeStream;
  GyroscopeEvent? _gyroscopeEvent;
  String? currentPosition;
  late CameraController _controller;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _controller.initialize();
  }


  bool checkDeviceOrientation(AccelerometerEvent event) {
    if (
    -2 <= event.x.round() && event.x.round() <= 2 &&
        event.y.round() <= 11 && 9 <= event.y.round() &&
        event.z.round() <= 5 && -5 <= event.z.round()
    ) { //
      return true;
    }
    return false;
  }


  @override
  void initState() {
    super.initState();
    _gyroscopeStream = gyroscopeEvents;
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (Camera.orientation && !checkDeviceOrientation(event)) {
        Camera.orientation = false;
      } else if (!Camera.orientation && checkDeviceOrientation(event)) {
        Camera.orientation = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Геолокация',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Координаты',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Камера',
          ),
        ],
      ),
      body: <Widget>[
    Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Добро пожаловать!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Filter()));
                      
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Найти круиз'))
              ],
            )
          ],
        ),
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: determinePosition(),
                  builder: (context, snapshot) {
                    if (currentPosition != null) {
                      return Text(
                        currentPosition!,
                        textAlign: TextAlign.center,
                      );
                    }
                    if (snapshot.hasData){
                      currentPosition = snapshot.data.toString();
                      return Text(
                        snapshot.data.toString(),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        Center(
            child: StreamBuilder<GyroscopeEvent>(
              stream: _gyroscopeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _gyroscopeEvent = snapshot.data;
                }
                return Center(
                  child: Text(
                    "X: ${_gyroscopeEvent?.x.toStringAsFixed(2)}\n"
                        "Y: ${_gyroscopeEvent?.y.toStringAsFixed(2)}\n"
                        "Z: ${_gyroscopeEvent?.z.toStringAsFixed(2)}\n"
                    ),
                );
              },
            ),

          ),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 4/3,
              child: FutureBuilder<void>(
                  future: _initializeCamera(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            FloatingActionButton.large(
                child: const Icon(Icons.camera),
                onPressed: () async {
                  if(Camera.orientation){
                    XFile image = await _controller.takePicture();
                    Directory? directory = await getExternalStorageDirectory();
                    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                    image.saveTo("${directory?.path}/$currentTime.png");
                  } else {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text("Переверните телефон"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Ок")
                          )
                        ],
                      );
                    });
                  }
                }),
          ],
        )
      ][currentPageIndex],
    );
  }

}