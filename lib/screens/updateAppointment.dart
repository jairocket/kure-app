
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../components/custom_text_input_field.dart';
import '../components/custom_time_picker.dart';
import '../components/custom_title.dart';
import '../components/date_input.dart';
import '../main.dart';
import '../services/appointments_service.dart';

class UpdateAppointment extends StatefulWidget {
  final int appointmentId;
  UpdateAppointment({required this.appointmentId});

  @override
  State<StatefulWidget> createState() {
    return _UpdateAppointmentState(appointmentId: appointmentId);
  }
}

final _patientNameController = TextEditingController();
final _cpfController = TextEditingController();
final _appointmentDateController = TextEditingController();
final _appointmentTimeController = TextEditingController();
final _currencyController = CurrencyTextFieldController(
  currencySymbol: "R\$",
  decimalSymbol: ",",
  thousandSymbol: ".",
);

int? priceInCents;
String? date, time;

final _cpfFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

Future<void> getAppointmentToUpdate(int id) async {
  final AppointmentsService appointmentsService = AppointmentsService.instance;
  try {
   final appointment = await appointmentsService.getAppointmentById(id);
   if(appointment == null) {
     throw Exception("Consulta não encontrada");
   }
   _patientNameController.text = appointment["patient_name"] as String;
   _cpfController.text = appointment["patient_cpf"] as String;
   _currencyController.text = appointment["price_in_cents"].toString();
  } catch (e) {
    rethrow;
  }
}

class _UpdateAppointmentState extends State<UpdateAppointment> {
  _UpdateAppointmentState({required this.appointmentId});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int appointmentId;

  @override
  void initState() {
    super.initState();
    getAppointmentToUpdate(appointmentId);
  }

  Future<void> updateAppointment(appointmentId, date, time, priceInCents) async {
    if (appointmentId == null) {
      throw Exception("É preciso estar logado para agendar uma consulta");
    }
    
    final AppointmentsService patientService = AppointmentsService.instance;
    await patientService.updateAppointment(
        appointmentId,
        date,
        time,
        priceInCents
    );
  }

  Future<void> _datePicker() async {
    DateTime? appointmentDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    initializeDateFormatting("pt_BR", null);

    if (appointmentDate != null) {
      setState(() {
        date = DateFormat.yMd("pt_BR").format(appointmentDate);
        _appointmentDateController.text = DateFormat.yMd(
          "pt_BR",
        ).format(appointmentDate);
      });
    }
  }

  Future<void> _timePicker() async {
    Provider.of<MyAppState>(context, listen: false);

    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione a data primeiro.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final appState = context.watch<MyAppState>();
    final doctorId = appState.loggedUser?.id;

    if (doctorId == null) return;

    final List<TimeOfDay> availableTimes = List.generate(
      20,
          (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
    );

    final AppointmentsService service = AppointmentsService.instance;
    List<String> unavailableTimes = await service.getUnavailableTimes(
      date!,
      doctorId,
    );

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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selecione um horário',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

                    return Tooltip(
                      message: isUnavailable ? "Horário indisponível" : "",
                      child: ElevatedButton.icon(
                        onPressed:
                        isUnavailable
                            ? null
                            : () {
                          setState(() {
                            time = timeSlotText;
                            _appointmentTimeController.text =
                                timeSlotText;
                          });
                          _formKey.currentState?.validate();
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
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _cleanInputData() {
    _formKey.currentState?.reset();
    _cpfController.clear();
    _patientNameController.clear();
    _appointmentDateController.clear();
    _appointmentTimeController.clear();
    _currencyController.clear();

    setState(() {
      date = null;
      time = null;
      priceInCents = null;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTitle(title: "Remarcar Consulta"),
                SizedBox(height: 30),
                CustomTextInputField(
                    hintText: "Nome do paciente",
                    controller: _patientNameController,
                    readOnly: true,
                    inputFormatters: [],
                    validator: (_) {
                      return null;
                    },
                    onSaved: (_) => {}
                ),
                SizedBox(height: 15),
                CustomTextInputField(
                  hintText: "Digite o CPF",
                  controller: _cpfController,
                  readOnly: true,
                  validator: (_) {
                    return null;
                  },
                  inputFormatters: [_cpfFormatter],
                  onChanged: (_) {},
                  onSaved: (_) {},
                ),
                SizedBox(height: 15),
                CustomDateInput(
                  controller: _appointmentDateController,
                  labelText: 'Data da consulta',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Selecione uma data";
                    }
                    return null;
                  },
                  onTap: _datePicker,
                  onSaved: (_) {},
                ),
                SizedBox(height: 15),
                CustomTimeInput(
                  controller: _appointmentTimeController,
                  labelText: 'Horário da consulta',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Selecione o horário";
                    }
                    return null;
                  },
                  onTap: _timePicker,
                  onSaved: (_) {},
                ),
                SizedBox(height: 15),
                CustomTextInputField(
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: "Valor da consulta",
                  controller: _currencyController,
                  validator: (value) {
                    if (value == "") {
                      return "Informe o valor da consulta";
                    }
                    if (_currencyController.intValue < 0) {
                      return "Consulta não pode ser menor que zero";
                    }
                    return null;
                  },
                  onSaved: (value) =>
                  {
                    priceInCents = _currencyController.intValue
                  },
                  inputFormatters: [],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (isValid) {
                      _formKey.currentState!.save();
                      updateAppointment(this.appointmentId, date!, time!, priceInCents!)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Consulta agendada com sucesso!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _cleanInputData();
                      })
                          .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D72F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    "Agendar Consulta",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _cleanInputData,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: const Color(0xFF2D72F6),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      "Limpar campos",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF2D72F6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }}


