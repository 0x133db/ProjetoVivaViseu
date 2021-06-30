import 'package:flutter/material.dart';
import 'package:vivaviseu/objects.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsContent extends StatelessWidget {
  final Event? event;
  late GoogleMapController mapController;

  EventDetailsContent({this.event});

   void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double lat = double.parse(event!.latitude!);
    double long = double.parse(event!.longitude!);
    final LatLng _center = LatLng(lat, long);
    return Container(
      color: Color.fromARGB(255, 34, 42, 54),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton(
                    onPressed: () {},
                    child: Text(event!.categories![0].category!.name!),
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('Categoria 2'),
                    color: Colors.orangeAccent,
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Container(
                  //margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  width: screenWidth,
                  height: screenHeight * 0.75,
                  //color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        event!.description!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Localização',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 6,
                        color: Colors.white,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(target: _center,
                          zoom: 11.0,
                          ),
                        )
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Promotor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 10,
                        color: Colors.white,
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Links',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.link),
                          SizedBox(width: 7),
                          Text(
                            'Link 1',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.featured_video),
                          SizedBox(width: 7),
                          Text(
                            'Link 2',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
