import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class CilindroScreen extends StatefulWidget {
  const CilindroScreen({super.key});

  @override
  State<CilindroScreen> createState() => _CilindroScreenState();
}

class _CilindroScreenState extends State<CilindroScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar radio y altura del TextFormField
  final _radioController = TextEditingController();
  final _alturaController = TextEditingController();

  // Resultados del cálculo (null = aún no calculado)
  double? _areaLateral;
  double? _areaTotal;
  double? _volumen;

  @override
  void dispose() {
    _radioController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcular() {
    // validate() recorre todos los TextFormField dentro del Form
    if (_formKey.currentState!.validate()) {
      final r = double.parse(_radioController.text.trim());
      final h = double.parse(_alturaController.text.trim());

      setState(() {
        // Área lateral: A = 2π·r·h
        _areaLateral = 2 * pi * r * h;

        // Área total: A = 2π·r·(r + h)
        _areaTotal = 2 * pi * r * (r + h);

        // Volumen: V = π·r²·h
        _volumen = pi * pow(r, 2) * h;
      });
    }
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _radioController.clear();
    _alturaController.clear();
    setState(() {
      _areaLateral = null;
      _areaTotal = null;
      _volumen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado ───────────────────────────────────────────────
            _SectionHeader(
              title: 'Área y Volumen del Cilindro',
              subtitle: 'TextFormField + ElevatedButton + validaciones',
              color: const Color(0xFF854F0B),
            ),
            const SizedBox(height: 20),

            // ── Fórmulas de referencia ────────────────────────────────────
            Card(
              elevation: 0,
              color: const Color(0xFFFAEEDA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFFAC775), width: 0.8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fórmulas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF633806),
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    _FormulaRow(
                        formula: 'A lateral', expresion: '= 2π · r · h'),
                    _FormulaRow(
                        formula: 'A total', expresion: '= 2π · r · (r + h)'),
                    _FormulaRow(formula: 'Volumen', expresion: '= π · r² · h'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Campo: Radio ─────────────────────────────────────────────
            // TextFormField con validator: valida que el valor sea numérico y positivo
            const _WidgetLabel(
              label: 'Radio (r) en centímetros *',
              widget: 'TextFormField',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _radioController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Ej: 5.0',
                suffixText: 'cm',
                prefixIcon: Icon(Icons.straighten),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El radio es obligatorio';
                }
                final numero = double.tryParse(value.trim());
                if (numero == null) {
                  return 'Ingresa un número válido';
                }
                if (numero <= 0) {
                  return 'El radio debe ser mayor que 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Campo: Altura ─────────────────────────────────────────────
            const _WidgetLabel(
              label: 'Altura (h) en centímetros *',
              widget: 'TextFormField',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _alturaController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Ej: 10.0',
                suffixText: 'cm',
                prefixIcon: Icon(Icons.height),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La altura es obligatoria';
                }
                final numero = double.tryParse(value.trim());
                if (numero == null) {
                  return 'Ingresa un número válido';
                }
                if (numero <= 0) {
                  return 'La altura debe ser mayor que 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Botones ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: _calcular,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF854F0B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _limpiar,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.clear),
                  ),
                ),
              ],
            ),

            // ── Resultados ───────────────────────────────────────────────
            if (_areaLateral != null) ...[
              const SizedBox(height: 24),
              _ResultCard(
                title: 'Resultados del cilindro',
                color: const Color(0xFF854F0B),
                icon: Icons.science,
                children: [
                  _ResultRow(
                    label: 'Radio (r)',
                    value:
                        '${double.parse(_radioController.text).toStringAsFixed(2)} cm',
                  ),
                  _ResultRow(
                    label: 'Altura (h)',
                    value:
                        '${double.parse(_alturaController.text).toStringAsFixed(2)} cm',
                  ),
                  const Divider(),
                  _ResultRow(
                    label: 'Área lateral',
                    value: '${_areaLateral!.toStringAsFixed(4)} cm²',
                  ),
                  _ResultRow(
                    label: 'Área total',
                    value: '${_areaTotal!.toStringAsFixed(4)} cm²',
                  ),
                  _ResultRow(
                    label: 'Volumen',
                    value: '${_volumen!.toStringAsFixed(4)} cm³',
                    destacado: true,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FormulaRow extends StatelessWidget {
  final String formula;
  final String expresion;

  const _FormulaRow({required this.formula, required this.expresion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              formula,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF633806),
              ),
            ),
          ),
          Text(
            expresion,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF854F0B),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
