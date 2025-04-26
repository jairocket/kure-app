import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/components/custom_time_picker.dart';
import 'package:mobile/components/date_input.dart';

class AgendamentoConsultaPage extends StatefulWidget {
  const AgendamentoConsultaPage({super.key});

  @override
  State<StatefulWidget> createState() => _AgendamentoConsultaPageState();
}

final _patientNameController = TextEditingController();
final _dataConsultaController = TextEditingController();
final _horaConsultaController = TextEditingController();
// Variáveis que armazenam a data e hora escolhidas
DateTime? _dataConsulta;
TimeOfDay? _horaConsulta;
String? _nomePaciente;

class _AgendamentoConsultaPageState extends State<AgendamentoConsultaPage> {
  // Chave do formulário usada para validação
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Função que abre o seletor de data
  Future<void> _selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    initializeDateFormatting("pt_BR", null);

    if (data != null) {
      setState(() {
        _dataConsulta = data;

        // Atualiza o campo visível com o valor formatado
        _dataConsultaController.text =
            "${data.day.toString().padLeft(2, '0')}/"
            "${data.month.toString().padLeft(2, '0')}/"
            "${data.year}";
      });
    }
  }

  void _selecionarHora() {
    final List<TimeOfDay> horariosDisponiveis = List.generate(
      20, // 08:00 até 17:30 = 20 intervalos de 30min
      (index) => TimeOfDay(hour: 8 + (index ~/ 2), minute: (index % 2) * 30),
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
          height:
              MediaQuery.of(context).size.height *
              0.95, // Ajuste a altura conforme necessário
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
                        backgroundColor: const Color.fromRGBO(49, 39, 79, 1),
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
              SizedBox(
                height: 20,
              ), // Adicionando um espaçamento entre a lista e a borda inferior
            ],
          ),
        );
      },
    );
  }

  // Função que valida e realiza o agendamento
  void _agendarConsulta() {
    final isValid =
        _formKey.currentState!.validate(); // Valida os campos do formulário
    final dataSelecionada = _dataConsulta != null;
    final horaSelecionada = _horaConsulta != null;

    if (isValid && dataSelecionada && horaSelecionada) {
      // Se tudo estiver preenchido corretamente, mostra mensagem de sucesso
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Consulta agendada com sucesso!')));

      // Limpa os campos após o agendamento
      _cleanInputData();
    } else {
      // Se algum campo estiver faltando, mostra alerta
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
    }
  }

  void _cleanInputData() {
    _formKey.currentState?.reset();
    _patientNameController.clear();
    _dataConsultaController.clear();
    _horaConsultaController.clear();

    setState(() {
      _dataConsulta = null;
      _horaConsulta = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Campos do agendamento apagados.')));
  }

  // Monta a interface visual da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                    CustomFormTitle(title: "Agendar Consulta"),
                    SizedBox(height: 30),
                    CustomTextInputField(
                      hintText: "Nome do paciente",
                      controller: _patientNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-ZÀ-ÿ\s]"),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Informe o nome do paciente";
                        }
                        return null;
                      },
                      onSaved:
                          (value) => setState(() {
                            if (value != null) {
                              _nomePaciente = value;
                            }
                          }),
                    ),
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),
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
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _agendarConsulta,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
