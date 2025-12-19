import 'package:expenseek/controllers/home_controller.dart';
import 'package:expenseek/utils/date_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Date filter selector widget
Widget dateFilterSelector(HomeController controller) {
  return Obx(() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<DateFilterType>(
            isExpanded: true,
            value: controller.currentDateFilter.value.type,
            items: DateFilterType.values
                .where((type) => type != DateFilterType.custom)
                .map((type) {
              final filter = DateFilter(type: type);
              return DropdownMenuItem(
                value: type,
                child: Text(filter.getDisplayName()),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                controller.setDateFilter(DateFilter(type: type));
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _showCustomDatePicker(controller),
          tooltip: 'Custom Date Range',
        ),
      ],
    ),
  ));
}

void _showCustomDatePicker(HomeController controller) {
  DateTime? startDate;
  DateTime? endDate;

  Get.dialog(
    AlertDialog(
      title: const Text('Select Date Range'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(
                  startDate != null
                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                      : 'Select start date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      startDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  endDate != null
                      ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                      : 'Select end date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      endDate = picked;
                    });
                  }
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (startDate != null && endDate != null) {
              if (startDate!.isAfter(endDate!)) {
                Get.showSnackbar(const GetSnackBar(
                  title: 'Error',
                  message: 'Start date must be before end date',
                  backgroundColor: Colors.red,
                ));
                return;
              }
              controller.setDateFilter(
                DateFilter(
                  type: DateFilterType.custom,
                  startDate: startDate,
                  endDate: endDate,
                ),
              );
              Get.back();
            } else {
              Get.showSnackbar(const GetSnackBar(
                title: 'Error',
                message: 'Please select both start and end dates',
                backgroundColor: Colors.red,
              ));
            }
          },
          child: const Text('Apply'),
        ),
      ],
    ),
  );
}

