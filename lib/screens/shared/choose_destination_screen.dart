import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:together_travel/controllers/shared/choose_destination_controller.dart';
import 'package:together_travel/screens/shared/search_destination_screen.dart';
import 'package:together_travel/utils/constants/colors.dart';
import 'package:together_travel/utils/constants/routes.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/widgets/container_button_widget.dart';
import 'package:together_travel/widgets/text_container_widget.dart';
import 'package:together_travel/widgets/snackbar_widget.dart';

class ChooseDestinationScreen extends StatelessWidget {
  const ChooseDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChooseDestinationController());
    final role = Get.arguments;

    Future<void> showDateTimePicker() async {
      // Date Picker
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (selectedDate != null) {

          final pickedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );

          controller.selectedDateTime.value = pickedDateTime;
      }
    }

    String _formatDateTime(DateTime dateTime) {
      final DateFormat formatter = DateFormat('EEEE dd MMMM yyyy');
      return formatter.format(dateTime);
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(
                      () => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: controller.pickupLatLong.value.latitude != 0
                          ? controller.pickupLatLong.value
                          : const LatLng(22.3039, 70.8022), // Default center
                      zoom: 12,
                    ),
                    markers: Set<Marker>.of(controller.markers), // Convert RxList to Set
                    polylines: Set<Polyline>.of(controller.polylines), // Add polyline here
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    onMapCreated: (mapController) {
                      controller.mapController = mapController;
                      controller.updateCameraBounds(); // Adjust camera bounds on map creation
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppSizes.borderRadiusMD),
                    topLeft: Radius.circular(AppSizes.borderRadiusMD),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Obx(
                            () => TextContainerWidget(
                              icon: Icons.location_on_outlined,
                          text: controller.pickupDestination.value.isEmpty
                              ? 'Select Pickup Destination'
                              : controller.pickupDestination.value,
                          onTap: () async {
                            final result = await Get.to(
                                  () => const SearchDestinationScreen(destination: 'pickup'),
                            ) as Map<String, dynamic>?;

                            if (result != null) {
                              controller.setPickupDestination(
                                result['name'],
                                result['latLng'],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      Obx(
                            () => TextContainerWidget(
                              icon: Icons.location_on_outlined,
                          text: controller.dropDestination.value.isEmpty
                              ? 'Select Drop Destination'
                              : controller.dropDestination.value,
                          onTap: () async {
                            final result = await Get.to(
                                  () => const SearchDestinationScreen(destination: 'drop'),
                            ) as Map<String, dynamic>?;

                            if (result != null) {
                              controller.setDropDestination(
                                result['name'],
                                result['latLng'],
                              );
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: role == 'Passenger',
                        child: SizedBox(height: AppSizes.md),
                      ),
                      Visibility(
                        visible: role == 'Passenger',
                        child: Obx(() => TextContainerWidget(
                          icon: Icons.calendar_month_outlined,
                          text: controller.selectedDateTime.value == null
                              ? 'Choose Journey Date'
                              : _formatDateTime(
                              controller.selectedDateTime.value!),
                          onTap: () {
                            showDateTimePicker();
                          },
                        )),
                      ),
                      SizedBox(height: AppSizes.lg),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonSM,
                        child: ElevatedButton(
                          onPressed: () {
                            if(controller.pickupCity.value == controller.dropCity.value) {
                              SnackBarWidget.show(message: 'Pickup and Drop city can not be same.', title: 'Error');
                            } else {
                              if(role == 'Passenger'){
                                if(controller.selectedDateTime.value != null) {
                                  Get.toNamed(AppRoutesNames.requestRide);
                                } else {
                                  SnackBarWidget.show(message: 'Please choose journey date to proceed.', title: 'Error');
                                }
                              } else {
                                Get.toNamed(AppRoutesNames.scheduleRide);
                              }
                            }
                          },
                          child: Text(role == 'Driver' ? 'Schedule Your Ride' : 'Search Your Ride'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerButtonWidget(
                    icon: Icons.assignment_outlined,
                    onTap: (){
                      Get.toNamed(AppRoutesNames.activeRequests, arguments: role);
                    }
                  ),
                  ContainerButtonWidget(icon: Icons.logout_outlined, onTap: (){
                    FirebaseAuth.instance.signOut().then((value) => Get.offAllNamed(AppRoutesNames.signIn));
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
