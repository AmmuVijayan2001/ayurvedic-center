import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ayurvediccenter/Data/models/selected_treatment.dart';

class PdfService {
  Future<void> generatePdf({
    required Map<String, dynamic> data,
    required List<SelectedTreatment> selectedTreatments,
    required DateTime bookedOn,
  }) async {
    final pdf = pw.Document();

   
    final font = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();
    final fontMedium = await PdfGoogleFonts.poppinsMedium();

   
    final logoImage = await imageFromAssetBundle('assets/images/Group.png');
    final watermarkImage = await imageFromAssetBundle(
      'assets/images/Layer_1-2.png',
    );
    final signatureImage = await imageFromAssetBundle(
      'assets/images/Vector 1.png',
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              
              pw.Center(
                child: pw.Opacity(
                  opacity: 0.1,
                  child: pw.Image(watermarkImage, width: 300),
                ),
              ),

             
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(logoImage, width: 80, height: 80),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "KUMARAKOM",
                            style: pw.TextStyle(font: fontBold, fontSize: 12),
                          ),
                          pw.Text(
                            "Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563",
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            "e-mail: unknown@gmail.com",
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            "Mob: +91 9876543210 | +91 9786543210",
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            "GST No: 32AABCU9603R1ZW",
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 10),

                  
                  pw.Text(
                    "Patient Details",
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 13,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("Name", data['name']),
                          _buildDetailRow("Address", data['address']),
                          _buildDetailRow("WhatsApp Number", data['phone']),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            "Booked On",
                            "${bookedOn.day}/${bookedOn.month}/${bookedOn.year} | ${bookedOn.hour}:${bookedOn.minute.toString().padLeft(2, '0')} ${bookedOn.hour >= 12 ? 'pm' : 'am'}",
                          ),
                          _buildDetailRow(
                            "Treatment Date",
                            data['date_nd_time'].split('-')[0],
                          ),
                          _buildDetailRow(
                            "Treatment Time",
                            data['date_nd_time'].split('-')[1],
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 4,
                          child: pw.Text(
                            "Treatment",
                            style: pw.TextStyle(
                              font: fontBold,
                              color: PdfColors.green800,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            "Price",
                            style: pw.TextStyle(
                              font: fontBold,
                              color: PdfColors.green800,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            "Male",
                            style: pw.TextStyle(
                              font: fontBold,
                              color: PdfColors.green800,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            "Female",
                            style: pw.TextStyle(
                              font: fontBold,
                              color: PdfColors.green800,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            "Total",
                            style: pw.TextStyle(
                              font: fontBold,
                              color: PdfColors.green800,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(color: PdfColors.grey300),

                  ...selectedTreatments.map((item) {
                    final price =
                        double.tryParse(item.treatment.price ?? "") ?? 0;
                    final count = item.maleCount + item.femaleCount;
                    final total = price * count;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              item.treatment.name ?? "",
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "₹${price}",
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "${item.maleCount}",
                              style: const pw.TextStyle(fontSize: 11),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "${item.femaleCount}",
                              style: const pw.TextStyle(fontSize: 11),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "₹${total}",
                              style: const pw.TextStyle(fontSize: 11),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 10),

                  // Totals
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          _buildTotalRow(
                            "Total Amount",
                            "₹${data['total_amount']}",
                            isBold: true,
                          ),
                          _buildTotalRow(
                            "Discount",
                            "₹${data['discount_amount']}",
                          ),
                          _buildTotalRow(
                            "Advance",
                            "₹${data['advance_amount']}",
                          ),
                          _buildTotalRow(
                            "Balance",
                            "₹${data['balance_amount']}",
                            isBold: true,
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.Spacer(),

                 
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("Thank you for choosing us", style: pw.TextStyle(font: fontBold, color: PdfColors.green800, fontSize: 14)),
                          pw.SizedBox(height: 5),
                          pw.Text("Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey", 
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)
                          ),
                          pw.SizedBox(height: 10),
                          pw.Image(signatureImage, width: 60),
                        ]
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),
                  pw.Divider(color: PdfColors.grey300),
                  pw.Center(
                    child: pw.Text(
                      "\"Booking amount is non-refundable, and it's important to arrive on the allotted time for your treatment\"",
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey500,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
            ),
          ),
          pw.Text(
            ":  $value",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(width: 30),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
