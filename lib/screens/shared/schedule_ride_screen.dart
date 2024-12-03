import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:together_travel/controllers/shared/schedule_ride_controller.dart';
import 'package:together_travel/utils/constants/colors.dart';
import 'package:together_travel/utils/constants/images.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/widgets/text_container_widget.dart';
import 'package:together_travel/widgets/select_vehicle_widget.dart';

class ScheduleRideScreen extends StatelessWidget {
  const ScheduleRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleRideController());

    Future<void> showDateTimePicker() async {
      // Date Picker
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (selectedDate != null) {
        // Time Picker
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          // Combine date and time
          final pickedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          // Update the controller
          controller.selectedDateTime.value = pickedDateTime;
        }
      }
    }

    String _formatDateTime(DateTime dateTime) {
      final DateFormat formatter = DateFormat('EEE dd MMM yyyy, hh:mm a');
      return formatter.format(dateTime);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Vehicle',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: AppSizes.sm),
                      Row(
                        children: [
                          const SelectVehicleWidget(
                            index: 1,
                            image: AppImages.bikeSVG,
                            text: 'Two Wheeler',
                          ),
                          SizedBox(width: AppSizes.md),
                          const SelectVehicleWidget(
                            index: 2,
                            image: AppImages.carSVG,
                            text: 'Four Wheeler',
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spacingMD),
                      Text(
                        'Schedule Journey',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: AppSizes.sm),
                      ScheduleRadioButtonGroup(
                        selectedIndex: controller.selectedOption,
                        onChanged: (value) {},
                      ),
                      SizedBox(height: AppSizes.sm),
                      Obx(() => TextContainerWidget(
                        icon: Icons.calendar_month_outlined,
                        text: controller.selectedOption.value == 1
                            ? (controller.selectedDateTime.value == null
                            ? 'Choose Pickup Date & Time'
                            : _formatDateTime(
                            controller.selectedDateTime.value!))
                            : _formatDateTime(DateTime.now()),
                        borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusSM),
                        onTap: () {
                          if (controller.selectedOption.value == 1) {
                            showDateTimePicker();
                          }
                        },
                        color: Colors.transparent,
                      )),
                      SizedBox(height: AppSizes.spacingMD),
                      Text(
                        'Passenger Capacity',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: AppSizes.sm),
                      PassengerDropdown(
                        selectedPassengerCount: controller.selectedPassengers,
                        onChanged: (value) {
                          controller.calculateFares();
                        },
                      ),
                      SizedBox(height: AppSizes.spacingMD),
                      Text(
                        'Journey Details',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: AppSizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Est. Journey Time',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Obx(() => Text(
                            controller.estimatedTime.value == '0' ? '0h 0m' : controller.estimatedTime.value.toString(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                        ],
                      ),
                      SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Est. Journey Kilometres',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Obx(() => Text(
                            controller.estimatedDistance.value == '0' ? '0 km' : controller.estimatedDistance.value.toString(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                        ],
                      ),
                      SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Est. Journey Revenue',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Obx(() => Text(
                            '₹${controller.estimatedRevenue.value
                                .toInt()
                                .toString()}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                        ],
                      ),
                      SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Platform Charges',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Obx(() => Text(
                              '₹${controller.platformCharges.value
                                  .toInt()
                                  .toString()}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                        ],
                      ),
                      SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Passenger Charges',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Obx(() => Text(
                            '₹${controller.passengerCharges.value
                                .toInt()
                                .toString()}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppSizes.buttonMD,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.scheduleJourney,
                  child: Text('Schedule Journey'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ScheduleRadioButtonGroup extends StatelessWidget {
  final RxInt selectedIndex;
  final Function(int) onChanged;

  const ScheduleRadioButtonGroup({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        _ScheduleRadioButton(
          label: "Schedule Now",
          value: 0,
          groupValue: selectedIndex.value,
          onChanged: (value) {
            selectedIndex.value = value!;
            onChanged(value);
          },
        ),
        SizedBox(width: AppSizes.md),
        _ScheduleRadioButton(
          label: "Schedule Later",
          value: 1,
          groupValue: selectedIndex.value,
          onChanged: (value) {
            selectedIndex.value = value!;
            onChanged(value);
          },
        ),
      ],
    ));
  }
}

class _ScheduleRadioButton extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const _ScheduleRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
          Text(
            label,
            style: TextStyle(
              color: groupValue == value ? AppColors.primary : AppColors.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PassengerDropdown extends StatelessWidget {
  final RxInt selectedPassengerCount;
  final Function(int) onChanged;

  const PassengerDropdown({
    super.key,
    required this.selectedPassengerCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSM),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          children: [
            const Icon(Icons.group_outlined, color: AppColors.primary,),
            SizedBox(width: AppSizes.md,),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedPassengerCount.value,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      selectedPassengerCount.value = value;
                      onChanged(value);
                    }
                  },
                  items: List.generate(
                    6,
                        (index) => DropdownMenuItem<int>(
                      value: index + 2,
                      child: Text(
                        "${index + 2} Passengers",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.green,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}