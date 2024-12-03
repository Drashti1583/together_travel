import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:together_travel/controllers/shared/choose_destination_controller.dart';
import 'package:together_travel/utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class RequestRideScreen extends StatelessWidget {
  const RequestRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChooseDestinationController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Available Trips',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              SizedBox(height: AppSizes.spacingSM),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('trips')
                    .where('origin', isEqualTo: controller.pickupDestination.value) // Example key
                    .where('destination', isEqualTo: controller.dropDestination.value) // Example key
                    .where('status', isEqualTo: 'active')
                    .where('paymentStatus', isEqualTo: 'paid')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No trips available for your selection',
                      ),
                    );
                  }

                  final trips = snapshot.data!.docs;

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: AppSizes.elevation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg, vertical: AppSizes.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        trip['vehicle'] == 'Two Wheeler'
                                            ? Icons.two_wheeler
                                            : Icons.directions_car,
                                        color: AppColors.primary,
                                        size: AppSizes.imageSM,
                                      ),
                                      SizedBox(width: AppSizes.lg),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: AppSizes.iconSM,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: AppSizes.xs),
                                              Text(
                                                '${trip['journeyTime']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: AppSizes.xs),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.route_outlined,
                                                size: AppSizes.iconSM,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: AppSizes.xs),
                                              Text(
                                                '${trip['distance']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.xs),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSizes.xs,
                                        horizontal: AppSizes.sm),
                                    child: Text(
                                      '₹${trip['pricePerSeat']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    size: AppSizes.iconSM,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: AppSizes.xs),
                                  Expanded(
                                    child: Text(
                                      '${trip['origin']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.xs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: AppSizes.iconSM,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: AppSizes.xs),
                                  Expanded(
                                    child: Text(
                                      '${trip['destination']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.md),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _requestTrip(context, trip['tripID']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(AppSizes.sm),
                                    ),
                                  ),
                                  child: Text('Request Trip'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: AppSizes.sm);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestTrip(BuildContext context, String tripID) async {
    final controller = Get.find<ChooseDestinationController>();
    const String apiKey = 'AlzaSyoaB-aVVrtQ76G5SihaySn7eZ3pXRiMr3m';
    final String url =
        'https://maps.gomaps.pro/maps/api/distancematrix/json?destinations=${controller.dropDestination.value}&origins=${controller.pickupDestination.value}&key=$apiKey';
    String distance = '';
    String duration = '';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(data.toString());

        final elements = data['rows'][0]['elements'][0];
        distance = elements['distance']['text']; // in meters
        duration = elements['duration']['text']; // in seconds


      } else {
        throw Exception('Failed to load distance matrix data');
      }
    } catch (e) {
      log('Error: $e');
    }
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
    final user = userData['name'] as String?;
    try {
      await FirebaseFirestore.instance.collection('tripRequests').add({
        'tripID': tripID,
        'customerID': FirebaseAuth.instance.currentUser?.uid,
        'customerName': user,
        'origin': controller.pickupDestination.value,
        'destination': controller.dropDestination.value,
        'distance': distance,
        'journeyTime': duration,
        'status': 'pending',
        'requestTime': FieldValue.serverTimestamp(),
      }).then((value) => Get.back());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send trip request: $e')),
      );
    }
  }
}
