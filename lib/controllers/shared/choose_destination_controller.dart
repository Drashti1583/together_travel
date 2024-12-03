import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:together_travel/utils/constants/colors.dart';

class ChooseDestinationController extends GetxController {
  final RxString pickupDestination = ''.obs;
  final RxString dropDestination = ''.obs;
  final pickupLatLong = const LatLng(0, 0).obs;
  final dropLatLong = const LatLng(0, 0).obs;
  final pickupCity = ''.obs;
  final dropCity = ''.obs;
  final markers = <Marker>[].obs; // RxList for markers
  final polylines = <Polyline>{}.obs; // Set for polylines
  final Rxn<DateTime> selectedDateTime = Rxn<DateTime>();

  GoogleMapController? mapController;

  void setPickupDestination(String destination, LatLng latLng) {
    pickupDestination.value = destination;
    pickupLatLong.value = latLng;

    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: latLng,
        infoWindow: InfoWindow(title: 'Pickup: $destination'),
      ),
    );
    updatePolyline();
    updateCameraBounds();
  }

  void setDropDestination(String name, LatLng position) {
    dropDestination.value = name;
    dropLatLong.value = position;

    markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: position,
        infoWindow: InfoWindow(title: name),
      ),
    );
    updatePolyline();
    updateCameraBounds();
  }

  void updateCameraBounds() {
    if (markers.isNotEmpty && mapController != null) {
      if (markers.length == 1) {
        final singleMarker = markers.first.position;
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(singleMarker, 15),
        );
      } else {
        final bounds = calculateBounds(markers);
        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }
    }
  }

  void updatePolyline() {
    // Check if both pickup and drop locations are set
    if (pickupLatLong.value.latitude != 0 && dropLatLong.value.latitude != 0) {
      polylines.clear(); // Clear the existing polyline

      // Create a new polyline
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [pickupLatLong.value, dropLatLong.value],
          color: AppColors.primary, // Set line color
          width: 5, // Set line width
        ),
      );
    }
  }

  LatLngBounds calculateBounds(List<Marker> markers) {
    double? north, south, east, west;

    for (var marker in markers) {
      final position = marker.position;
      if (north == null || position.latitude > north) north = position.latitude;
      if (south == null || position.latitude < south) south = position.latitude;
      if (east == null || position.longitude > east) east = position.longitude;
      if (west == null || position.longitude < west) west = position.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(north!, east!),
      southwest: LatLng(south!, west!),
    );
  }
}
