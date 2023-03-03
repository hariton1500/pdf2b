import 'dart:io';
//import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf2b/pdfdata.dart';

class MyText extends pw.Text {
  //final Uint8List fontData = File('open-sans.ttf').readAsBytesSync();
  static final ttf = pw.Font.ttf(File('open-sans.ttf').readAsBytesSync().buffer.asByteData());
  MyText(String text) : super(text, style: pw.TextStyle(font: ttf));  
}

pw.Document doDoc(PdfData pdfData) {
  final pdf = pw.Document();
  
  pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (pw.Context context) => pw.Center(
    child: pw.Column(
      children: [
        MyText('Акт No ${pdfData.number} от ${pdfData.date}'),
        pw.Divider(thickness: 2),
        pw.Row(children: [
          MyText('Поставщик: '),
          MyText('${pdfData.from}, ${pdfData.fromReqs}')
        ]),
        pw.Wrap(children: [
          MyText('Покупатель: '),
          MyText('${pdfData.to}, ${pdfData.toReqs}')
        ]),
        pw.Row(children: [
          MyText('Основание: '),
          MyText('Договор оказания телематических услуг связи No ${pdfData.dogovor}')
        ]),
        pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
        MyText('Исполнитель выполнил следующие работы (услуги):'),
        pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
        pw.Table(border: pw.TableBorder.all(), children: [
          pw.TableRow(children: [
            MyText('No'),
            MyText('Наименование товара, работ, услуг'),
            MyText('Количество'),
            MyText('Ед. изм.'),
            MyText('Цена'),
            MyText('Сумма')
          ]),
          pw.TableRow(children: [
            MyText('1'),
            MyText('${pdfData.serviceName}; ID: ${pdfData.toNumber}'),
            MyText('1'),
            MyText('30 сут.'),
            MyText('${pdfData.price} руб.'),
            MyText('${pdfData.summ} руб.')
          ]),
        ]),
        pw.Row(children: [
          MyText('Итого: '),
          MyText('${pdfData.summ} руб.')
        ], mainAxisAlignment: pw.MainAxisAlignment.end),
        pw.Row(children: [
          MyText('В том числе НДС: '),
          MyText('0.00 руб.')
        ], mainAxisAlignment: pw.MainAxisAlignment.end),
        pw.Row(children: [
          MyText('Всего к оплате: '),
          MyText('${pdfData.summ} руб.')
        ], mainAxisAlignment: pw.MainAxisAlignment.end),
        pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
        MyText('Всего наименований 1, на сумму ${pdfData.summ} руб.'),
        MyText(pdfData.byChars()),
        pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
        MyText('Вышеперечисленные работы (услуги) выполнены полностью и в срок. Заказчик претензий по объему, качеству и срокам оказания услуг претензий не имеет.'),
        pw.Divider(thickness: 2),
        pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(children: [
              MyText('ИСПОЛНИТЕЛЬ'),
              pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
              MyText(pdfData.from),
              pw.Stack(children: [
                MyText('Руководитель _________________'),
                //pw.Positioned(child: pw.Image(image))
              ]),
              MyText('МП')
            ]),
            pw.Wrap(
              //runAlignment: WrapAlignment.start,
              direction: pw.Axis.vertical,
              children: [
              MyText('ЗАКАЗЧИК'),
              pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
              MyText(pdfData.to),
              MyText('Руководитель _________________'),
              MyText('МП')
            ]),
        ])
      ]
    )
  )));
  return pdf;
}

run(List<String> args) async {
  final inputFile = File('input.csv');
  if (inputFile.existsSync()) {
    if (args.contains('-akt')) {
      print('creating pdf file with Akt');
      print('parsing input file');
      List<String> lines = inputFile.readAsLinesSync();
      for (var i = 1; i < lines.length; i++) {
        List<String> fields = lines[i].split(';');
        print('parsing line: $fields');
        PdfData data = PdfData();
        data.date = fields[2];
        data.number = fields[1];
        data.to = fields[8];
        data.summ = int.tryParse(fields[12]) ?? 0;
        data.from = 'ИП Зинштейн Х. В.';
        var pdf = doDoc(data);
        final outFile = File('akt_${data.number}.pdf');
        await outFile.writeAsBytes(await pdf.save());
      }
    }
    if (args.contains('-bill')) {
      
    }
  } else {
    print('Input csv file "input.csv" is not found');
  }
  //final file = File("example.pdf");
  //await file.writeAsBytes(await pdf.save());
}
