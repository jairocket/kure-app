import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/components/custom_form_input_container.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/components/custom_time_picker.dart';
import 'package:mobile/components/date_input.dart';


final _nomePacienteController = TextEditingController();
final _dataConsultaController = TextEditingController();
final _horaConsultaController = TextEditingController();

class AgendamentoConsultaPage extends StatefulWidget {
  const AgendamentoConsultaPage({super.key});

  @override
  State<StatefulWidget> createState() => _AgendamentoConsultaPageState();
}

// Variáveis que armazenam a data e hora escolhidas
DateTime? _dataConsulta;
TimeOfDay? _horaConsulta;
String? _nomePaciente;

class _AgendamentoConsultaPageState extends State<AgendamentoConsultaPage> {
  // Chave do formulário usada para validação
  final _formKey = GlobalKey<FormState>();

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
      builder: (BuildContext context) {
        return SizedBox(
          height: 350, // Ajuste a altura conforme necessário
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selecione um horário',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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
      _formKey.currentState!.reset();
      _nomePacienteController.clear();
      setState(() {
        _dataConsulta = null;
        _horaConsulta = null;
        _dataConsultaController.clear(); // Aqui limpa o campo visível
        _horaConsultaController.clear(); // Aqui também
      });
    } else {
      // Se algum campo estiver faltando, mostra alerta
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
    }
  }

  void _cancelarConsulta() {
    _formKey.currentState?.reset();
    _nomePacienteController.clear();
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
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: Duration(microseconds: 1500),
                      child: CustomFormTitle(title: "Nova consulta"),
                    ),

                    SizedBox(height: 30),
                    FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: CustomFormInputContainer(
                        inputFields: [
                          CustomTextInputField(
                            hintText: "Nome do paciente",
                            controller: _nomePacienteController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe o nome do paciente';
                              }

                              if (value.trim().length < 3) {
                                return 'O nome deve ter pelo menos 3 letras';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              value = _nomePaciente;
                            },
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                            ],
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
                            onSaved: (value) => setState(() {}),
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
                            onSaved: (value) {},
                          ),
                        ],
                      ),
                    ),

                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _agendarConsulta,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Color.fromRGBO(49, 39, 79, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Agendar Consulta',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _cancelarConsulta,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
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
