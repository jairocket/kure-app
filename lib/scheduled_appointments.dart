import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/custom_form_input_container.dart';
import 'components/custom_form_title.dart';
import 'components/custom_text_input_field.dart';
import 'components/custom_time_picker.dart';
import 'components/date_input.dart';
import 'patient_form.dart';
import 'doctor_form.dart';
import 'report_screen.dart';

final _pacienteController = TextEditingController();
final _medicoController = TextEditingController();
final _dataConsultaController = TextEditingController();
final _horaConsultaController = TextEditingController();

DateTime? _dataConsulta;
TimeOfDay? _horaConsulta;

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isRailExtended = true;
  int selectedIndex = 2;

  Future<void> _selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        _dataConsulta = data;
        _dataConsultaController.text = "${data.day.toString().padLeft(2, '0')}/"
            "${data.month.toString().padLeft(2, '0')}/"
            "${data.year}";
      });
    }
  }

  void _selecionarHora() {
    final List<TimeOfDay> horariosDisponiveis = [];
    for (int h = 9; h <= 16; h++) {
      horariosDisponiveis.add(TimeOfDay(hour: h, minute: 0));
      horariosDisponiveis.add(TimeOfDay(hour: h, minute: 30));
    }

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selecione um horário',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: horariosDisponiveis.length,
                  itemBuilder: (context, index) {
                    final horario = horariosDisponiveis[index];
                    final textoHorario =
                        "${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}";

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _horaConsulta = horario;
                          _horaConsultaController.text = textoHorario;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D72F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        textoHorario,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _agendarConsulta() {
    final isValid = _formKey.currentState!.validate();
    final dataSelecionada = _dataConsulta != null;
    final horaSelecionada = _horaConsulta != null;

    if (isValid && dataSelecionada && horaSelecionada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta agendada com sucesso!')),
      );

      _formKey.currentState!.reset();
      _pacienteController.clear();
      _medicoController.clear();
      _dataConsultaController.clear();
      _horaConsultaController.clear();

      setState(() {
        _dataConsulta = null;
        _horaConsulta = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
    }
  }

  void _cancelarConsulta() {
    _formKey.currentState?.reset();
    _pacienteController.clear();
    _medicoController.clear();
    _dataConsultaController.clear();
    _horaConsultaController.clear();

    setState(() {
      _dataConsulta = null;
      _horaConsulta = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campos do agendamento apagados.')),
    );
  }

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const PatientForm()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const DoctorForm()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ScheduleAppointmentPage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ReportScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              extended: _isRailExtended,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    _isRailExtended = !_isRailExtended;
                  });
                },
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person_add),
                  label: Text("Cadastrar Paciente"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.medical_services),
                  label: Text("Cadastrar Médico"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.event_available),
                  label: Text("Marcar Consulta"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Relatório"),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CustomFormTitle(title: "Marcar Consulta"),
                    const SizedBox(height: 30),
                    CustomFormInputContainer(
                      inputFields: [
                        CustomTextInputField(
                          hintText: "Nome do paciente",
                          controller: _pacienteController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Informe o nome do paciente";
                            }
                            return null;
                          },
                          onSaved: (_) {},
                        ),
                        CustomTextInputField(
                          hintText: "Nome do médico",
                          controller: _medicoController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Informe o nome do médico";
                            }
                            return null;
                          },
                          onSaved: (_) {},
                        ),
                        CustomDateInput(
                          controller: _dataConsultaController,
                          labelText: 'Data da consulta',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Selecione uma data";
                            }
                            return null;
                          },
                          onTap: _selecionarData,
                          onSaved: (_) {},
                        ),
                        CustomTimeInput(
                          controller: _horaConsultaController,
                          labelText: 'Horário da consulta',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Selecione o horário";
                            }
                            return null;
                          },
                          onTap: _selecionarHora,
                          onSaved: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _agendarConsulta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D72F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Agendar Consulta",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: _cancelarConsulta,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 16),
                        side: const BorderSide(
                            color: Color(0xFF2D72F6), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Color(0xFF2D72F6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
