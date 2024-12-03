import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:together_travel/widgets/snackbar_widget.dart';
import 'choose_destination_controller.dart';

class ScheduleRideController extends GetxController {
  final RxInt selectedOption = 0.obs;
  final RxInt selectedVehicle = 0.obs; // 0 for Car, 1 for Bike
  final RxInt selectedPassengers = 2.obs; // Number of passengers
  final Rxn<DateTime> selectedDateTime = Rxn<DateTime>();
  // late Razorpay razorpay;
  // Observable values for calculations
  final RxString estimatedTime = '0'.obs;
  final RxString estimatedDistance = '0'.obs;
  final RxDouble estimatedRevenue = 0.0.obs;
  final RxDouble platformCharges = 0.0.obs;
  final RxDouble passengerCharges = 0.0.obs;
  final controller = Get.find<ChooseDestinationController>();


  Future<void> calculateFares() async {
    const String apiKey = 'AlzaSyoaB-aVVrtQ76G5SihaySn7eZ3pXRiMr3m';
    final String url =
        'https://maps.gomaps.pro/maps/api/distancematrix/json?destinations=${controller.dropDestination.value}&origins=${controller.pickupDestination.value}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extracting distance and duration
        final elements = data['rows'][0]['elements'][0];
        final distanceValue = elements['distance']['value']; // in meters
        final durationValue = elements['duration']['value']; // in seconds

        estimatedDistance.value = '${(distanceValue / 1000).toStringAsFixed(1)} km';
        estimatedTime.value = '${(durationValue / 3600).floor()}h ${(durationValue % 3600) ~/ 60}m';

        // Calculate estimated revenue based on vehicle type
        double baseFare;
        double perKmRate;
        double perMinuteRate;

        if (selectedVehicle.value == 2) {
          // Car
          baseFare = 100;
          perKmRate = 12; // Higher rate for car
          perMinuteRate = 3; // Higher rate for car
        } else if(selectedVehicle.value == 1) {
          // Bike
          baseFare = 50;
          perKmRate = 8; // Lower rate for bike
          perMinuteRate = 1.5; // Lower rate for bike
        } else {
          baseFare = 50;
          perKmRate = 8; // Lower rate for bike
          perMinuteRate = 1.5; // Lower rate for bike
        }

        final revenue = baseFare +
            (distanceValue / 1000) * perKmRate +
            (durationValue / 60) * perMinuteRate;

        estimatedRevenue.value = revenue;

        // Calculate platform charges (e.g., 20% of revenue)
        platformCharges.value = revenue * 0.2;

        // Calculate passenger charges
        final passengerFare = revenue / selectedPassengers.value;
        passengerCharges.value = passengerFare;

      } else {
        throw Exception('Failed to load distance matrix data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void handleSuccessPayment(PaymentSuccessResponse response) async {
  //   if(response.paymentId != null) {
  //     await saveData(response.paymentId!);
  //   }
  // }
  //
  // void handleFailurePayment(PaymentFailureResponse response) {
  //   SnackBarWidget.show(message: 'Payment failed: ${response.message}', title: 'Order Failed');
  // }
  //
  // void handleExternalWallet(ExternalWalletResponse response) {
  //   SnackBarWidget.show(message: 'External Wallet: ${response.walletName}', title: 'Wallet');
  // }

  Future<void> scheduleJourney() async {
    if(selectedVehicle.value > 0) {
      await saveData();
    } else {
      SnackBarWidget.show(message: 'Please select a vehicle to proceed.', title: 'Error');
    }
  }

  void openCheckoutPage(int amount) {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Travel Buddy',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@gmail.com'
      },
      'theme': {
        'color': '#386641'
      },
      'external': {
        'wallets': ['paytm', 'googlepay', 'phonepe', 'bhim']
      }
    };

    try {
      // razorpay.open(options);
    } catch (e) {
      print("Error in opening Razorpay: $e");
    }
  }

  String getRandomAlphabet(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> saveData() async {
    final dateTime = selectedDateTime.value ?? DateTime.now();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final docId = getRandomAlphabet(12);
    final data = {
      "tripID": docId,
      "driverID": userId,
      "origin": controller.pickupDestination.value,
      "destination": controller.dropDestination.value,
      "dateTime": dateTime.toString(),
      "seatsAvailable": selectedPassengers.value,
      "pricePerSeat": passengerCharges.value.toInt(),
      "status": "active",
      "paymentStatus": "paid",
      "journeyTime": estimatedTime.value,
      "distance": estimatedDistance.value,
      "journeyRevenue": estimatedRevenue.value,
      "paidAmount": platformCharges.value.toInt(),
      "vehicle": selectedVehicle.value == 1 ? 'Two Wheeler': 'Four Wheeler',
    };
    FirebaseFirestore.instance.collection('trips').doc(docId).set(data).then((value) => Get.back());
  }

  @override
  void onInit() {
    super.onInit();
    // razorpay = Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccessPayment);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleFailurePayment);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }
}
