import 'dart:async';
import 'package:chatbot/components/drawer_menu_widget.dart';
import 'package:chatbot/models/report.dart';
import 'package:chatbot/services/database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:intl/intl.dart';
import '../constants.dart';

class CovidMap extends StatefulWidget {
  final VoidCallback openDrawer;
  static const id = 'MapSelect';

  const CovidMap({Key key, this.openDrawer}) : super(key: key);
  @override
  _CovidMapState createState() => _CovidMapState();
}

class _CovidMapState extends State<CovidMap> {
  double latitude;
  double longitude;
  String error = '';
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  void getMarkers(double lat, double long, ReportModel report) {
    MarkerId markerId = MarkerId(report.docID);
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: report.status == 'confirmed'
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
          title: report.status == 'confirmed' ? 'حالة مؤكدة' : 'حالة غير مؤكدة',
          snippet: report.status == 'pending'
              ? 'تاريخ التشخيص: ${DateFormat("MMM").format(report.dateCreated)} ${DateFormat("d").format(report.dateCreated)} - ${DateFormat("jm").format(report.dateCreated)}'
              : 'تاريخ التأكيد: ${DateFormat("MMM").format(report.dateConfirmed)} ${DateFormat("d").format(report.dateCreated)} - ${DateFormat("jm").format(report.dateConfirmed)}'),
    );
    markers[markerId] = _marker;
  }

  void locatePosition() async {
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = p;
    LatLng latlatPosition = LatLng(p.latitude, p.longitude);
    CameraPosition camera =
        new CameraPosition(target: latlatPosition, zoom: 14);
    newGoogleMapContoller.animateCamera(CameraUpdate.newCameraPosition(camera));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
          stream: DatabaseService().getReports(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length >= 0) {
              List<ReportModel> reports = snapshot.data;
              // print(snapshot.data.length);
              for (int i = 0; i < snapshot.data.length; i++) {
                ReportModel report = snapshot.data[i];
                if ((report.status == 'pending' &&
                        report.modelResult == true) ||
                    (report.status == 'confirmed' && report.labResult == true))
                  getMarkers(report.latitude, report.longitude, report);
              }
              int confirmedCases = reports
                  .where((element) =>
                      element.labResult == true &&
                      element.status == 'confirmed')
                  .length;
              int susbects = reports
                  .where((element) =>
                      element.modelResult == true &&
                      element.status == 'pending')
                  .length;

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: GoogleMap(
                            mapType: MapType.terrain,
                            myLocationEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              newGoogleMapContoller = controller;
                              locatePosition();
                            },
                            markers: Set<Marker>.of(markers.values),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: size.height * 0.03,
                      right: size.width * 0.04,
                      child: DrawerMenuWidget(
                        onClicked: widget.openDrawer,
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.1,
                      right: size.width * 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.width * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  susbects.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  'حالة غير مؤكدة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.02,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.width * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  confirmedCases.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  'حالة مؤكدة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }
}
