import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  // GlobalKey para manejar el estado del Form y ejecutar validaciones
  final _formKey = GlobalKey<FormState>();

  // Controlador para capturar el texto del TextFormField
  final _comentarioController = TextEditingController();

  // Estado para RadioListTile — calificación del 1 al 5
  int? _calificacion;

  // Estado para CheckboxListTile — características seleccionadas
  bool _atencionCliente = false;
  bool _tiempoRespuesta = false;
  bool _facilidadUso = false;
  bool _precioCalidad = false;

  // Estado para mostrar el mensaje de éxito
  bool _enviado = false;

  @override
  void dispose() {
    // Liberar el controlador cuando el widget se destruye
    _comentarioController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    // validate() recorre todos los validators del Form y retorna true si todos pasan
    if (_formKey.currentState!.validate()) {
      setState(() => _enviado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Encuesta enviada exitosamente!'),
          backgroundColor: Color(0xFF0F6E56),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _resetFormulario() {
    _formKey.currentState!.reset();
    _comentarioController.clear();
    setState(() {
      _calificacion = null;
      _atencionCliente = false;
      _tiempoRespuesta = false;
      _facilidadUso = false;
      _precioCalidad = false;
      _enviado = false;
    });
  }

  // Widget reutilizable: fila de estrellas para visualizar la calificación
  Widget _buildEstrellas(int cantidad) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < cantidad ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFBA7517),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        // El GlobalKey conecta este Form con _formKey para poder llamar validate()
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado ───────────────────────────────────────────────
            _SectionHeader(
              title: 'Encuesta de Satisfacción',
              subtitle: 'RadioListTile + CheckboxListTile + TextFormField',
              color: const Color(0xFF185FA5),
            ),
            const SizedBox(height: 20),

            // ── SECCIÓN 1: RadioListTile ─────────────────────────────────
            // RadioListTile: cada opción es excluyente (solo una puede estar activa)
            // groupValue: el valor actualmente seleccionado en el grupo
            // value: el valor que representa esta opción específica
            // onChanged: callback que actualiza el groupValue al presionar
            const _WidgetLabel(
              label: 'Calificación del servicio *',
              widget: 'RadioListTile',
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _calificacion == null
                      ? Colors.grey.shade300
                      : const Color(0xFF185FA5),
                  width: 0.8,
                ),
              ),
              child: Column(
                children: List.generate(5, (i) {
                  final valor = i + 1;
                  return RadioListTile<int>(
                    title: Row(
                      children: [
                        Text(
                          '$valor — ${_etiquetaCalificacion(valor)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        _buildEstrellas(valor),
                      ],
                    ),
                    value: valor,
                    groupValue: _calificacion,
                    activeColor: const Color(0xFF185FA5),
                    onChanged: (val) => setState(() => _calificacion = val),
                  );
                }),
              ),
            ),
            // Validación manual del RadioListTile (los RadioListTile no tienen validator propio)
            if (_calificacion == null && _enviado == false)
              const SizedBox.shrink()
            else if (_calificacion == null)
              const Padding(
                padding: EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  'Selecciona una calificación',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),

            // ── SECCIÓN 2: CheckboxListTile ───────────────────────────────
            // CheckboxListTile: cada opción es independiente (múltiple selección)
            // Diferencia vs Checkbox: incluye título, subtítulo y toda la fila es tappable
            // value: estado booleano del checkbox
            // onChanged: callback que recibe el nuevo valor booleano
            const _WidgetLabel(
              label: 'Características que te gustaron',
              widget: 'CheckboxListTile',
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Atención al cliente',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Trato amable y profesional',
                        style: TextStyle(fontSize: 12)),
                    value: _atencionCliente,
                    activeColor: const Color(0xFF0F6E56),
                    onChanged: (val) =>
                        setState(() => _atencionCliente = val!),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    title: const Text('Tiempo de respuesta',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Respuestas rápidas y oportunas',
                        style: TextStyle(fontSize: 12)),
                    value: _tiempoRespuesta,
                    activeColor: const Color(0xFF0F6E56),
                    onChanged: (val) =>
                        setState(() => _tiempoRespuesta = val!),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    title: const Text('Facilidad de uso',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Interfaz intuitiva y clara',
                        style: TextStyle(fontSize: 12)),
                    value: _facilidadUso,
                    activeColor: const Color(0xFF0F6E56),
                    onChanged: (val) => setState(() => _facilidadUso = val!),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    title: const Text('Precio / calidad',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Relación justa entre costo y servicio',
                        style: TextStyle(fontSize: 12)),
                    value: _precioCalidad,
                    activeColor: const Color(0xFF0F6E56),
                    onChanged: (val) => setState(() => _precioCalidad = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── SECCIÓN 3: TextFormField ──────────────────────────────────
            // TextFormField: campo de texto integrado con Form y FormState
            // Diferencia vs TextField: tiene validator, onSaved y se conecta
            // automáticamente al GlobalKey del Form padre
            const _WidgetLabel(
              label: 'Comentarios adicionales *',
              widget: 'TextFormField',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _comentarioController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe tu opinión sobre el servicio...',
                alignLabelWithHint: true,
              ),
              // validator: se ejecuta automáticamente al llamar _formKey.currentState!.validate()
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un comentario';
                }
                if (value.trim().length < 10) {
                  return 'El comentario debe tener al menos 10 caracteres';
                }
                return null; // null = sin error
              },
            ),
            const SizedBox(height: 24),

            // ── Botón de envío ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Validar que haya calificación (RadioListTile manual)
                  if (_calificacion == null) {
                    setState(() => _enviado = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecciona una calificación del 1 al 5'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  _enviarFormulario();
                },
                icon: const Icon(Icons.send),
                label: const Text('Enviar encuesta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185FA5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // ── Resultado ────────────────────────────────────────────────
            if (_enviado && _calificacion != null) ...[
              const SizedBox(height: 20),
              _ResultCard(
                title: 'Encuesta registrada',
                color: const Color(0xFF0F6E56),
                icon: Icons.check_circle,
                children: [
                  _ResultRow(
                      label: 'Calificación',
                      value: '$_calificacion / 5 ${_etiquetaCalificacion(_calificacion!)}'),
                  _ResultRow(
                    label: 'Características',
                    value: _getCaracteristicasSeleccionadas(),
                  ),
                  _ResultRow(
                    label: 'Comentario',
                    value: _comentarioController.text.trim(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _resetFormulario,
                icon: const Icon(Icons.refresh),
                label: const Text('Nueva encuesta'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _etiquetaCalificacion(int val) {
    switch (val) {
      case 1:
        return 'Muy malo';
      case 2:
        return 'Malo';
      case 3:
        return 'Regular';
      case 4:
        return 'Bueno';
      case 5:
        return 'Excelente';
      default:
        return '';
    }
  }

  String _getCaracteristicasSeleccionadas() {
    final seleccionadas = <String>[];
    if (_atencionCliente) seleccionadas.add('Atención al cliente');
    if (_tiempoRespuesta) seleccionadas.add('Tiempo de respuesta');
    if (_facilidadUso) seleccionadas.add('Facilidad de uso');
    if (_precioCalidad) seleccionadas.add('Precio / calidad');
    return seleccionadas.isEmpty ? 'Ninguna' : seleccionadas.join(', ');
  }
}
