import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/services/appointments_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';

typedef OnTimeSelected = void Function(String selectedTime);

class CustomTimePickerWindow {
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

    final DateFormat brDateFormat = DateFormat('dd/MM/yyyy');
    final DateTime nowDate = DateTime.now();
    final TimeOfDay nowTime = TimeOfDay.fromDateTime(nowDate);
    final DateTime selectedDate = brDateFormat.parse(date);

    final bool isToday =
        nowDate.year == selectedDate.year &&
        nowDate.month == selectedDate.month &&
        nowDate.day == selectedDate.day;

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

                    final isPast =
                        isToday &&
                        (timeSlot.hour < nowTime.hour ||
                            (timeSlot.hour == nowTime.hour &&
                                timeSlot.minute <= nowTime.minute));

                    final isUnavailable =
                        unavailableTimes.contains(timeSlotText) || isPast;

                    return Tooltip(
                      message: isUnavailable ? "Horário indisponível" : "",
                      child: ElevatedButton.icon(
                        onPressed:
                            isUnavailable
                                ? null
                                : () {
                                  onTimeSelected(timeSlotText);
                                  Navigator.pop(context);
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isUnavailable
                                  ? Colors.grey[300]
                                  : const Color(0xFF2D72F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon:
                            isUnavailable
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
                                isUnavailable ? Colors.black38 : Colors.white,
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
