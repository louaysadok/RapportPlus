import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

/// PDF Generator - 100% local using pdf package
/// Professional French typography, A4, margins 2.5cm

class PdfReportGenerator {
  Future<File> generate({
    required String studentName,
    required String institution,
    required String company,
    required String period,
    required List<ReportChapter> chapters,
    List<String> imagePaths = const [],
  }) async {
    final pdf = pw.Document(
      title: 'Rapport de Stage - $studentName',
      author: studentName,
      creator: 'Rapport+ v1.0.0',
    );

    final font = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    // ── Page de garde ──
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(2.5 * PdfPageFormat.cm),
        build: (ctx) => pw.Column(
          children: [
            pw.Text('MINISTÈRE DE L\'ENSEIGNEMENT SUPÉRIEUR\nET DE LA RECHERCHE SCIENTIFIQUE',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColor.fromHex('#0F2440'))),
            pw.SizedBox(height: 12),
            pw.Container(height: 2, width: 60, color: PdfColor.fromHex('#2EC4B6')),
            pw.SizedBox(height: 12),
            pw.Text(institution, textAlign: pw.TextAlign.center, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
            pw.Spacer(),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#0F2440'), width: 1.5), borderRadius: pw.BorderRadius.circular(6)),
              child: pw.Column(children: [
                pw.Text('RAPPORT DE STAGE', style: pw.TextStyle(font: fontBold, fontSize: 20, color: PdfColor.fromHex('#0F2440'))),
                pw.SizedBox(height: 6),
                pw.Text('Stage de Perfectionnement', style: pw.TextStyle(font: font, fontSize: 11, color: PdfColors.grey600)),
              ]),
            ),
            pw.SizedBox(height: 16),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: pw.BoxDecoration(color: PdfColor.fromHex('#0F2440'), borderRadius: pw.BorderRadius.circular(6)),
              child: pw.Text(chapters.isNotEmpty ? chapters[0].title.toUpperCase() : 'RAPPORT DE STAGE',
                  textAlign: pw.TextAlign.center, style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.white)),
            ),
            pw.Spacer(),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('Élaboré par:', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                pw.Text(studentName, style: pw.TextStyle(font: fontBold, fontSize: 11)),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text('Entreprise:', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                pw.Text(company, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                pw.Text(period, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
              ]),
            ]),
            pw.SizedBox(height: 20),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 8),
            pw.Text('Année Universitaire 2025 - 2026', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColor.fromHex('#0F2440'))),
          ],
        ),
      ),
    );

    // ── Sommaire (TOC) ──
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(2.5 * PdfPageFormat.cm),
        build: (ctx) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('SOMMAIRE', style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColor.fromHex('#0F2440'))),
          pw.Divider(color: PdfColor.fromHex('#2EC4B6'), thickness: 2),
          pw.SizedBox(height: 10),
          ...List.generate(chapters.length, (i) {
            final c = chapters[i];
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Row(children: [
                pw.Text('${i + 1}.', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                pw.SizedBox(width: 8),
                pw.Expanded(child: pw.Text(c.title, style: pw.TextStyle(font: font, fontSize: 10))),
                pw.Text('${i + 3}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
              ]),
            );
          }),
        ]),
      ),
    );

    // ── Chapters ──
    for (int i = 0; i < chapters.length; i++) {
      final c = chapters[i];
      if (!c.isVisible) continue;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(2.5 * PdfPageFormat.cm),
          header: (ctx) => ctx.pageNumber > 1
              ? pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text('Rapport de Stage - $studentName', style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500)),
                  pw.Text('${ctx.pageNumber}', style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500)),
                ])
              : pw.SizedBox(),
          footer: (ctx) => pw.Center(child: pw.Text('Page ${ctx.pageNumber} / ${ctx.pagesCount}', style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500))),
          build: (ctx) => [
            pw.Text('Chapitre ${i + 1}: ${c.title}', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColor.fromHex('#0F2440'))),
            pw.Container(height: 2, width: 40, color: PdfColor.fromHex('#2EC4B6')),
            pw.SizedBox(height: 12),
            pw.Text(c.content.isEmpty ? '[Contenu à compléter - L\'IA attend vos entrées journal pour générer ce chapitre]' : c.content,
                style: pw.TextStyle(font: font, fontSize: 10, lineSpacing: 4)),
            if (c.content.isEmpty)
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(color: PdfColor.fromHex('#FEF3C7'), borderRadius: pw.BorderRadius.circular(6)),
                child: pw.Text('💡 Astuce: Documentez plus d\'activités dans votre journal pour enrichir ce chapitre automatiquement.',
                    style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.orange800)),
              ),
          ],
        ),
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Rapport_Stage_${studentName.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}

class ReportChapter {
  final String title;
  final String content;
  final bool isVisible;
  ReportChapter({required this.title, required this.content, this.isVisible = true});
}
