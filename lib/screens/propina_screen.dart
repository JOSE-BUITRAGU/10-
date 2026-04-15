import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class PropinaScreen extends StatefulWidget {
  const PropinaScreen({super.key});

  @override
  State<PropinaScreen> createState() => _PropinaScreenState();
}

class _PropinaScreenState extends State<PropinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cuentaController = TextEditingController();

  // Estado del RadioListTile: porcentaje de propina seleccionado
  // null = ninguno seleccionado aún
  int? _porcentajePropina;

  // Resultados
  double? _montoPropina;
  double? _totalFinal;

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
  }

  void _calcularPropina() {
    // Primero validar el TextFormField mediante el Form
    if (!_formKey.currentState!.validate()) return;

    // Validar selección de RadioListTile manualmente
    if (_porcentajePropina == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un porcentaje de propina'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalCuenta = double.parse(_cuentaController.text.trim());

    setState(() {
      // Fórmula: Propina = Total cuenta × (porcentaje / 100)
      _montoPropina = totalCuenta * (_porcentajePropina! / 100);

      // Total final = Total cuenta + Propina
      _totalFinal = totalCuenta + _montoPropina!;
    });
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _cuentaController.clear();
    setState(() {
      _porcentajePropina = null;
      _montoPropina = null;
      _totalFinal = null;
    });
  }

  // Formatea números como moneda colombiana
  String _formatCOP(double value) {
    return '\$${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
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
              title: 'Calculadora de Propina',
              subtitle: 'TextFormField + RadioListTile + Fórmula',
              color: const Color(0xFF0F6E56),
            ),
            const SizedBox(height: 20),

            // ── Fórmula de referencia ─────────────────────────────────────
            Card(
              elevation: 0,
              color: const Color(0xFFE1F5EE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF5DCAA5), width: 0.8),
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
                        color: Color(0xFF085041),
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Propina  = Total × (porcentaje ÷ 100)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F6E56),
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total final = Total cuenta + Propina',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F6E56),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Campo: Total de la cuenta ─────────────────────────────────
            const _WidgetLabel(
              label: 'Total de la cuenta *',
              widget: 'TextFormField',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cuentaController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Ej: 85000',
                prefixText: '\$ ',
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (_) {
                // Limpiar resultados si el usuario modifica el campo
                if (_montoPropina != null) {
                  setState(() {
                    _montoPropina = null;
                    _totalFinal = null;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el total de la cuenta';
                }
                final numero = double.tryParse(value.trim());
                if (numero == null) {
                  return 'Ingresa un número válido';
                }
                if (numero <= 0) {
                  return 'El monto debe ser mayor que \$0';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ── RadioListTile: porcentaje de propina ──────────────────────
            // RadioListTile<int>: el tipo genérico define el tipo de value/groupValue
            // Cada opción tiene su propio value; groupValue comparte el estado
            // Al presionar, onChanged actualiza _porcentajePropina → se reconstruye el widget
            const _WidgetLabel(
              label: 'Porcentaje de propina *',
              widget: 'RadioListTile<int>',
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _porcentajePropina != null
                      ? const Color(0xFF0F6E56)
                      : Colors.grey.shade300,
                  width: 0.8,
                ),
              ),
              child: Column(
                children: [
                  // Opción 10%
                  RadioListTile<int>(
                    title: const Text('10% — Propina estándar',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Para servicios normales',
                        style: TextStyle(fontSize: 12)),
                    value: 10,
                    groupValue: _porcentajePropina,
                    activeColor: const Color(0xFF0F6E56),
                    secondary: const _PorcentajeBadge(pct: '10%'),
                    onChanged: (val) {
                      setState(() {
                        _porcentajePropina = val;
                        _montoPropina = null;
                        _totalFinal = null;
                      });
                    },
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),

                  // Opción 15%
                  RadioListTile<int>(
                    title: const Text('15% — Propina recomendada',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Para buen servicio',
                        style: TextStyle(fontSize: 12)),
                    value: 15,
                    groupValue: _porcentajePropina,
                    activeColor: const Color(0xFF0F6E56),
                    secondary: const _PorcentajeBadge(pct: '15%'),
                    onChanged: (val) {
                      setState(() {
                        _porcentajePropina = val;
                        _montoPropina = null;
                        _totalFinal = null;
                      });
                    },
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),

                  // Opción 20%
                  RadioListTile<int>(
                    title: const Text('20% — Propina excelente',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Para servicio excepcional',
                        style: TextStyle(fontSize: 12)),
                    value: 20,
                    groupValue: _porcentajePropina,
                    activeColor: const Color(0xFF0F6E56),
                    secondary: const _PorcentajeBadge(pct: '20%'),
                    onChanged: (val) {
                      setState(() {
                        _porcentajePropina = val;
                        _montoPropina = null;
                        _totalFinal = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Botones ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: _calcularPropina,
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Calcular propina'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F6E56),
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
            if (_montoPropina != null) ...[
              const SizedBox(height: 24),
              _ResultCard(
                title: 'Resumen de pago',
                color: const Color(0xFF0F6E56),
                icon: Icons.receipt_long,
                children: [
                  _ResultRow(
                    label: 'Total cuenta',
                    value: _formatCOP(
                        double.parse(_cuentaController.text.trim())),
                  ),
                  _ResultRow(
                    label: 'Porcentaje elegido',
                    value: '$_porcentajePropina%',
                  ),
                  const Divider(),
                  _ResultRow(
                    label: 'Propina',
                    value: '+ ${_formatCOP(_montoPropina!)}',
                  ),
                  _ResultRow(
                    label: 'Total a pagar',
                    value: _formatCOP(_totalFinal!),
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

// Widget auxiliar: badge con el porcentaje para el secondary del RadioListTile
class _PorcentajeBadge extends StatelessWidget {
  final String pct;
  const _PorcentajeBadge({required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5EE),
        borderRadius: BorderRadius.circular(6),
        border: const Border.fromBorderSide(
          BorderSide(color: Color(0xFF5DCAA5), width: 0.8),
        ),
      ),
      child: Text(
        pct,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF085041),
        ),
      ),
    );
  }
}
