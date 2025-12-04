import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../services/models/product.dart';

Future<void> generateSaleReceipt(
  Map<Product, int> products,
  double total, {
  required String saleId,
  required String employee,
}) async {
  final pdf = pw.Document();
  final date = DateTime.now();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [

        // ===================== ENCABEZADO =====================
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue700,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'InventSmart',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'RECIBO DE VENTA',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ===================== DATOS EMPRESA =====================
        pw.Text('Sistema de Ventas InventSmart', style: pw.TextStyle(fontSize: 12)),
        pw.Text('RUC: 9999999999'),
        pw.Text('Dirección: Ambato - Ecuador'),
        pw.Text('Teléfono: 0999999999'),

        pw.Divider(),

        // ===================== DATOS VENTA =====================
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Venta N°: $saleId'),
                pw.Text('Empleado: $employee'),
              ],
            ),
            pw.Text('Fecha: ${date.day}/${date.month}/${date.year}'),
          ],
        ),

        pw.SizedBox(height: 20),

        // ===================== TABLA PRODUCTOS =====================
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {
            0: pw.FlexColumnWidth(4),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cellHeader('Producto'),
                _cellHeader('Cantidad'),
                _cellHeader('Precio'),
                _cellHeader('Total'),
              ],
            ),

            ...products.entries.map((e) {
              final p = e.key;
              final qty = e.value;
              final subtotal = p.precio * qty;

              return pw.TableRow(
                children: [
                  _cell(p.nombre),
                  _cell(qty.toString()),
                  _cell('\$${p.precio.toStringAsFixed(2)}'),
                  _cell('\$${subtotal.toStringAsFixed(2)}'),
                ],
              );
            }).toList(),
          ],
        ),

        pw.SizedBox(height: 20),

        // ===================== TOTAL =====================
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              width: 200,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 40),

        // ===================== FIRMAS =====================
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Text('_______________________'),
                pw.Text('Cliente'),
              ],
            ),
            pw.Column(
              children: [
                pw.Text('_______________________'),
                pw.Text('Empleado'),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        // ===================== PIE =====================
        pw.Center(
          child: pw.Text(
            'Gracias por su compra - InventSmart © ${date.year}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ),
      ],
    ),
  );

  final pdfBytes = await pdf.save();

  await Printing.sharePdf(
    bytes: pdfBytes,
    filename: 'recibo_venta_$saleId.pdf',
  );
}

////////////////////////////////////////////////////////
/// ✅ ESTAS DOS FUNCIONES EVITAN TU ERROR
////////////////////////////////////////////////////////

pw.Widget _cellHeader(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    ),
  );
}

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(text),
  );
}
