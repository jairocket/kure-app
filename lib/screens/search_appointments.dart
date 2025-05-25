import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kure/components/custom_title.dart';
import 'package:kure/components/empty_state.dart';
import 'package:kure/models/appointmentData.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/appointments_service.dart';
import 'package:searchable_listview/searchable_listview.dart';

class SearchAppointments extends StatefulWidget {
  @override
  State<SearchAppointments> createState() => _SearchAppointmentsState();
}

class _SearchAppointmentsState extends State<SearchAppointments> {
  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    if (appState.loggedUser != null) {
      appState.setAppointmentDataList(appState.loggedUser!.id);
    }
  }

  final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _controller = TextEditingController();

  Future<void> cancelAppointmentById(int id) async {
    final AppointmentsService appointmentsService =
        AppointmentsService.instance;
    await appointmentsService.cancelAppointmentById(id);
  }

  Widget _buildTile(AppointmentData appointment, BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListTile(
      hoverColor: Colors.grey,
      onTap: () => {
        appState.setAppointmentIdToUpdate(appointment.id),
        appState.setSelectedPage(SelectedPage.updateAppointment),
      },
      leading: Icon(
        size: 20,
        Icons.access_time_filled,
        color: const Color(0xFF2D72F6),
      ),
      minTileHeight: 100,
      title: Container(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    appointment.cpf,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${appointment.date.split("-").last}/${appointment.date.split("-")[1]}/${appointment.date.split("-").first}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  appointment.time,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            IconButton(
              disabledColor: Colors.grey,
              iconSize: 35,
              onPressed:
                  appointment.cancelled
                      ? null
                      : () async => {
                        await cancelAppointmentById(appointment.id),
                        await appState.setAppointmentsMapByDoctorId(
                          appState.loggedUser!.id,
                        ),
                      },
              icon: Icon(
                size: 25,
                Icons.delete_outline_rounded,
                color: appointment.cancelled ? Colors.grey : Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<AppointmentData> appointments = appState.appointmentDataList;

    if (appointments.isEmpty) {
      return EmptyState(title: "Nada para mostrar aqui");
    }

    return Column(
      children: [
        CustomTitle(title: "Pesquisar Consulta"),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(10, 35, 10, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SearchableList(
              searchFieldWidth: double.maxFinite,
              maxLength: 11,
              initialList: appointments,
              itemBuilder: (appointment) => _buildTile(appointment, context),
              textInputType: TextInputType.number,
              searchTextController: _controller,
              keyboardAction: TextInputAction.go,
              displaySearchIcon: false,
              inputDecoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "Digite o CPF (apenas números)",
                filled: true  ,
                fillColor: const Color(0xFFEEEEEE),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0),
                  gapPadding: 5
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              filter:
                  (cpf) =>
                      appointments
                          .where(
                            (appointment) => appointment.cpf.contains(
                              _cpfFormatter.maskText(cpf),
                            ),
                          ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
