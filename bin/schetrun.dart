import 'package:pdf2b/schet.dart';

void main() async {
  await generateInvoice(
    invoiceNumber: '1730574869',
    invoiceDate: '02 ноября 2024г.',
    supplier: 'ИП Зинштейн Харитон Владимирович',
    supplierINN: '911000073763',
    buyer: 'ООО "ДИЗО"',
    buyerINN: '6317091400',
    contractNumber: '39431',
    contractDate: '14.02.2023',
    items: [
      {
        'name':
            'Услуга интернет, за три месяца (июль, август, сентябрь); Логин (ID): dizo (31539)',
        'quantity': '1',
        'unit': '30 сут.',
        'price': '2 000,00',
        'total': '2 000,00',
      },
    ],
    totalAmount: '2 000,00',
    totalAmountWords: 'две тысячи рублей 00 копеек',
  );
}
