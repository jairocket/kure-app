import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/components/custom_form_input_container.dart';
import 'package:mobile/components/custom_form_title.dart';
import 'package:mobile/components/custom_text_input_field.dart';
import 'package:mobile/services/cep_service.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  final _cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _numeroFormatter = FilteringTextInputFormatter.digitsOnly;

  Future<void> _buscarEndereco() async {
    final cep = _cepController.text;
    final data = await CepService.getAddressByCep(cep);

    if (data != null) {
      setState(() {
        _logradouroController.text = data['logradouro'] ?? '';
        _bairroController.text = data['bairro'] ?? '';
        _cidadeController.text = data['localidade'] ?? '';
        _estadoController.text = data['uf'] ?? '';
      });
    } else {
      _mostrarSnackBar("CEP inválido ou não encontrado.");
    }
  }

  void _mostrarSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CustomFormTitle(title: "Cadastro do Endereço"),
                    const SizedBox(height: 30),
                    CustomFormInputContainer(
                      inputFields: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextInputField(
                                hintText: "CEP:",
                                controller: _cepController,
                                inputFormatters: [_cepFormatter],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.length != 9) {
                                    return "Informe um CEP válido";
                                  }
                                  return null;
                                },
                                onSaved: (_) {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _buscarEndereco,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D72F6),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Buscar"),
                              ),
                            ),
                          ],
                        ),
                        CustomTextInputField(
                          hintText: "Endereço:",
                          controller: _logradouroController,
                          inputFormatters: [],
                          validator: (_) => null,
                          onSaved: (_) {},
                          readOnly: true,
                        ),
                        CustomTextInputField(
                          hintText: "Bairro:",
                          controller: _bairroController,
                          inputFormatters: [],
                          validator: (_) => null,
                          onSaved: (_) {},
                          readOnly: true,
                        ),
                        CustomTextInputField(
                          hintText: "Cidade:",
                          controller: _cidadeController,
                          inputFormatters: [],
                          validator: (_) => null,
                          onSaved: (_) {},
                          readOnly: true,
                        ),
                        CustomTextInputField(
                          hintText: "Complemento:",
                          controller: _complementoController,
                          inputFormatters: [],
                          validator: (_) => null,
                          onSaved: (_) {},
                        ),
                        CustomTextInputField(
                          hintText: "Nº:",
                          controller: _numeroController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_numeroFormatter],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Informe o número";
                            }
                            return null;
                          },
                          onSaved: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _mostrarSnackBar("Endereço salvo com sucesso!");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D72F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Salvar",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
