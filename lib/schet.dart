import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

Future<void> generateInvoice({
  required String invoiceNumber,
  required String invoiceDate,
  required String supplier,
  required String supplierINN,
  required String buyer,
  required String buyerINN,
  required String contractNumber,
  required String contractDate,
  required List<Map<String, dynamic>> items, // Список товаров или услуг
  required String totalAmount,
  required String totalAmountWords,
}) async {
  final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(
              File('open-sans.ttf').readAsBytesSync().buffer.asByteData())));
  //pw.Font.ttf(File('open-sans.ttf').readAsBytesSync().buffer.asByteData());
  /*
  pdf.theme!.copyWith(
      defaultTextStyle: pw.TextStyle(
          font: pw.Font.ttf(
              File('open-sans.ttf').readAsBytesSync().buffer.asByteData())));*/

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Счет на оплату № $invoiceNumber от $invoiceDate'),
            pw.SizedBox(height: 20),
            pw.Text('Поставщик: $supplier, ИНН: $supplierINN'),
            pw.Text('Покупатель: $buyer, ИНН: $buyerINN'),
            pw.Text('Основание: договор № $contractNumber от $contractDate'),
            pw.SizedBox(height: 20),

            // Таблица с услугами/товарами
            pw.Table.fromTextArray(
              headers: [
                '№',
                'Наименование товара, работ, услуг',
                'Кол-во',
                'Ед. изм.',
                'Цена',
                'Сумма'
              ],
              data: [
                for (var i = 0; i < items.length; i++)
                  [
                    (i + 1).toString(),
                    items[i]['name'],
                    items[i]['quantity'],
                    items[i]['unit'],
                    '${items[i]['price']} руб.',
                    '${items[i]['total']} руб.',
                  ],
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Text('Итого: $totalAmount руб.'),
            pw.Text('В том числе НДС: 0.00 руб.'),
            pw.Text('Всего к оплате: $totalAmount руб.'),
            pw.Text('Сумма прописью: $totalAmountWords'),
            pw.SizedBox(height: 20),
            pw.Text('Руководитель Зинштейн Х. В.'),
          ],
        );
      },
    ),
  );

  final output = File("schet.pdf");
  await output.writeAsBytes(await pdf.save());
}
