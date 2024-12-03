import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:together_travel/controllers/shared/choose_destination_controller.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/widgets/text_field_widget.dart';
import 'package:together_travel/utils/constants/colors.dart';

class SearchDestinationScreen extends StatelessWidget {
  final String destination;
  const SearchDestinationScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchDestinationController());
    final destinationController = Get.find<ChooseDestinationController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Center(
                  child: Text(
                    'Search Destination',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              SizedBox(height: AppSizes.spacingSM),

              // Search TextField
              TextFieldWidget(
                prefixIcon: Icons.search_outlined,
                labelText: 'Search your destination here...',
                controller: controller.destinationController,
                onChanged: controller.onSearchChanged,
                autoFocus: true,
              ),
              SizedBox(height: AppSizes.spacingSM),

              // Display search results
              Obx(() {
                if (controller.placesSuggestions.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListView.separated(
                  itemCount: controller.placesSuggestions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final place = controller.placesSuggestions[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        place.description ?? 'No Description',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () async {
                        controller.destinationController.text = place.description ?? '';
                        final latLong = await GooglePlacesService().getLatLng(place.description!, isPickup: destination == 'pickup');
                        Get.back(result: {
                          'name': place.description,
                          'latLng': latLong,
                        });

                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDestinationController extends GetxController {
  final destinationController = TextEditingController();
  var placesSuggestions = <Prediction>[].obs;  // Observable list


  // Called when the search text changes
  void onSearchChanged(String query) {
    if (query.isNotEmpty) {
      getPlacesSuggestions(query);
    } else {
      placesSuggestions.clear(); // Clear suggestions when query is empty
    }
  }

  // Fetch Google Places suggestions
  Future<void> getPlacesSuggestions(String query) async {
    final googlePlacesService = GooglePlacesService();
    final suggestions = await googlePlacesService.getAutocompleteSuggestions(query);
    placesSuggestions.value = suggestions; // Update observable list
  }
}

class GooglePlacesService {
  final String apiKey = 'AlzaSyoaB-aVVrtQ76G5SihaySn7eZ3pXRiMr3m';

  Future<List<Prediction>> getAutocompleteSuggestions(String query) async {
    final String url =
        'https://maps.gomaps.pro/maps/api/place/queryautocomplete/json?input=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try{
        final data = json.decode(response.body);
        final predictions = (data['predictions'] as List)
            .map((e) => Prediction.fromJson(e))
            .toList();
        return predictions;
      } catch (e) {
        print(e);
        throw Exception('Failed to load autocomplete results');
      }
    } else {
      throw Exception('Failed to load autocomplete results');
    }
  }

  Future<LatLng> getLatLng(String address, {bool isPickup = true}) async {
    final controller = Get.find<ChooseDestinationController>();
    final String url =
        'https://maps.gomaps.pro/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log(data.toString());

      // Extract latitude and longitude
      final location = data['results'][0]['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);

      // Extract city name
      final city = _extractCity(data);
      if (isPickup) {
        controller.pickupCity.value = city ?? '';
      } else {
        controller.dropCity.value = city ?? '';
      }

      log('City: $city');
      return latLng;
    } else {
      throw Exception('Failed to load geocode results');
    }
  }

// Helper method to extract city name from API response
  String? _extractCity(Map<String, dynamic> data) {
    final components = data['results'][0]['address_components'];
    for (var component in components) {
      if (component['types'].contains('locality')) {
        return component['long_name'];
      }
    }
    return null;
  }

}
