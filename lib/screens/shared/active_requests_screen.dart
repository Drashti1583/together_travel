import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:together_travel/main.dart';
import 'package:together_travel/utils/constants/colors.dart';

import '../../utils/constants/sizes.dart';

class ActiveRequestsScreen extends StatelessWidget {
  const ActiveRequestsScreen({super.key});

  void _showRequestsDialog(BuildContext context, String tripID) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.all(AppSizes.md),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tripRequests')
                  .where('tripID', isEqualTo: tripID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No requests available.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index].data() as Map<String, dynamic>;

                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String?>(
                              future: fetchCustomerName(request['customerID']),
                              builder: (context, nameSnapshot) {
                                if (!nameSnapshot.hasData) {
                                  return Text('Loading name...');
                                }
                                return Text(
                                  'Customer: ${nameSnapshot.data}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            SizedBox(height: AppSizes.xs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _updateRequestStatus(
                                      requests[index].id, 'approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                  child: Text('Approve'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateRequestStatus(
                                      requests[index].id, 'rejected'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                  ),
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<String?> fetchCustomerName(String customerID) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerID)
          .get();

      return userDoc.exists ? userDoc['name'] as String : null;
    } catch (e) {
      print('Error fetching customer name: $e');
      return null;
    }
  }

  void _updateRequestStatus(String requestID, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('tripRequests')
          .doc(requestID)
          .update({'status': newStatus});

      Get.snackbar(
        'Success',
        'Request has been $newStatus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update request status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Center(
                  child: Text(
                    'Requests',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              SizedBox(height: AppSizes.spacingSM),
              Visibility(
                visible: Get.arguments == 'Driver',
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('driverID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No active requests',
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
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_outlined, size: AppSizes.iconSM, color: AppColors.primary,),
                                                SizedBox(width: AppSizes.xs,),
                                                Text(
                                                  '${trip['journeyTime']}',
                                                  style: Theme.of(context).textTheme.labelLarge,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: AppSizes.xs,),
                                            Row(
                                              children: [
                                                Icon(Icons.route_outlined, size: AppSizes.iconSM, color: AppColors.primary,),
                                                SizedBox(width: AppSizes.xs,),
                                                Text(
                                                  '${trip['distance']}',
                                                  style: Theme.of(context).textTheme.labelLarge,
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
                                          borderRadius: BorderRadius.circular(AppSizes.xs)
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: AppSizes.xs, horizontal: AppSizes.sm),
                                      child: Text(trip['status'].toUpperCase(), style: Theme.of(context).textTheme.labelLarge,),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.my_location, size: AppSizes.iconSM, color: AppColors.primary,),
                                    SizedBox(width: AppSizes.xs,),
                                    Expanded(
                                      child: Text(
                                        '${trip['origin']}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.xs,),
                                Row(
                                  children: [
                                    Icon(Icons.flag, size: AppSizes.iconSM, color: AppColors.primary,),
                                    SizedBox(width: AppSizes.xs,),
                                    Expanded(
                                      child: Text(
                                        '${trip['destination']}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.md),

                                Row(
                                  children: [
                                    Visibility(
                                      visible: trip['status'] != 'started',
                                      child: Expanded(
                                        child: ElevatedButton(
                                          onPressed: (){},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSizes.sm)
                                            )
                                          ),
                                          child: Text('Cancel'),
                                        ),
                                      ),
                                    ),
                                    Visibility(child: SizedBox(width: AppSizes.md,)),
                                    Visibility(
                                      visible: trip['status'] != 'started',
                                      child: Expanded(
                                        child: ElevatedButton(
                                          onPressed: (){},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(AppSizes.sm)
                                              )
                                          ),
                                          child: Text('Start'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: trip['status'] == 'started',
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: (){},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSizes.sm)
                                          )
                                      ),
                                      child: Text('Finish'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.xs,),
                                Visibility(
                                  visible: trip['status'] != 'started',
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        _showRequestsDialog(context, trip['tripID']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.lightTextColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(AppSizes.sm),
                                          )
                                      ),
                                      child: Text('View Requests'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: AppSizes.sm,);
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: Get.arguments == 'Passenger',
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tripRequests')
                      .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No active requests',
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
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_outlined, size: AppSizes.iconSM, color: AppColors.primary,),
                                                SizedBox(width: AppSizes.xs,),
                                                Text(
                                                  '${trip['journeyTime']}',
                                                  style: Theme.of(context).textTheme.labelLarge,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: AppSizes.xs,),
                                            Row(
                                              children: [
                                                Icon(Icons.route_outlined, size: AppSizes.iconSM, color: AppColors.primary,),
                                                SizedBox(width: AppSizes.xs,),
                                                Text(
                                                  '${trip['distance']}',
                                                  style: Theme.of(context).textTheme.labelLarge,
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
                                          borderRadius: BorderRadius.circular(AppSizes.xs)
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: AppSizes.xs, horizontal: AppSizes.sm),
                                      child: Text(trip['status'].toUpperCase(), style: Theme.of(context).textTheme.labelLarge,),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.my_location, size: AppSizes.iconSM, color: AppColors.primary,),
                                    SizedBox(width: AppSizes.xs,),
                                    Expanded(
                                      child: Text(
                                        '${trip['origin']}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.xs,),
                                Row(
                                  children: [
                                    Icon(Icons.flag, size: AppSizes.iconSM, color: AppColors.primary,),
                                    SizedBox(width: AppSizes.xs,),
                                    Expanded(
                                      child: Text(
                                        '${trip['destination']}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.md),

                                Visibility(
                                  visible: trip['status'] != 'started',
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: (){},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSizes.sm)
                                          )
                                      ),
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.xs,),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: AppSizes.sm,);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
