import 'package:flutter/material.dart';
import 'package:kure/services/appointments_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';

typedef OnTimeSelected = void Function(String selectedTime);

class CustomTimePickerModal {
  static Future<void> show({
    required BuildContext context,
    required String date,
    required OnTimeSelected onTimeSelected,
  }) async {
    final appState = context.read<MyAppState>();
    final doctorId = appState.loggedUser?.id;

    if (doctorId == null) return;

    final List<TimeOfDay> availableTimes = List.generate(
      20,
      (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
    );

    final AppointmentsService service = AppointmentsService.instance;
    List<String> unavailableTimes = await service.getUnavailableTimes(
      date,
      doctorId,
    );

    DateTime selectedDate = DateTime.parse(date);
    DateTime now = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selecione um horário',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: availableTimes.length,
                  itemBuilder: (context, index) {
                    final timeSlot = availableTimes[index];
                    final timeSlotText =
                        "${timeSlot.hour.toString().padLeft(2, '0')}:${timeSlot.minute.toString().padLeft(2, '0')}";
                    final isUnavailable = unavailableTimes.contains(
                      timeSlotText,
                    );

                    bool isPast = false;
                    if (selectedDate.year == now.year &&
                        selectedDate.month == now.month &&
                        selectedDate.day == now.day) {
                      final slotDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        timeSlot.hour,
                        timeSlot.minute,
                      );
                      if (slotDateTime.isBefore(now)) {
                        isPast = true;
                      }
                    }

                    return Tooltip(
                      message:
                          isUnavailable
                              ? "Horário indisponível"
                              : isPast
                              ? "Horário já passou"
                              : "",
                      child: ElevatedButton.icon(
                        onPressed:
                            (isUnavailable || isPast)
                                ? null
                                : () {
                                  onTimeSelected(timeSlotText);
                                  Navigator.pop(context);
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (isUnavailable || isPast)
                                  ? Colors.grey[300]
                                  : const Color(0xFF2D72F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon:
                            (isUnavailable || isPast)
                                ? const Icon(
                                  Icons.block,
                                  color: Colors.black38,
                                  size: 16,
                                )
                                : const SizedBox.shrink(),
                        label: Text(
                          timeSlotText,
                          style: TextStyle(
                            color:
                                (isUnavailable || isPast)
                                    ? Colors.black38
                                    : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
