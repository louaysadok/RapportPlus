import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        title: const Text('Aperçu du rapport'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                // Page de garde preview
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      // Institution header
                      const Text('MINISTÈRE DE L\'ENSEIGNEMENT SUPÉRIEUR\nET DE LA RECHERCHE SCIENTIFIQUE',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.navy, letterSpacing: 0.5)),
                      const SizedBox(height: 12),
                      Container(height: 2, width: 60, color: AppTheme.turquoise),
                      const SizedBox(height: 12),
                      const Text('Institut Supérieur des Études Technologiques de Sousse', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.navy, width: 1.5), borderRadius: BorderRadius.circular(8)),
                        child: const Column(children: [
                          Text('RAPPORT DE STAGE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.navy, letterSpacing: 1.2)),
                          SizedBox(height: 8),
                          Text('Stage de Perfectionnement / PFE', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(6)),
                        child: const Text('DÉVELOPPEMENT D\'UNE APPLICATION MOBILE\nPOUR LA GESTION DES STAGES',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Élaboré par:', style: TextStyle(fontSize: 10, color: Colors.grey[600])), const Text('Nom Prénom', style: TextStyle(fontWeight: FontWeight.w700)), Text('Génie Logiciel - L3', style: TextStyle(fontSize: 11, color: Colors.grey[600]))])),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('Encadré par:', style: TextStyle(fontSize: 10, color: Colors.grey[600])), const Text('M. Encadrant', style: TextStyle(fontWeight: FontWeight.w700)), Text('TELNET Holding', style: TextStyle(fontSize: 11, color: Colors.grey[600]))])),
                      ]),
                      const SizedBox(height: 20),
                      Container(height: 1, color: AppTheme.borderLight),
                      const SizedBox(height: 12),
                      const Text('Année Universitaire 2025 - 2026', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.navy)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sommaire preview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('SOMMAIRE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.navy)),
                    const Divider(),
                    ...[
                      'Remerciements ............................................................ 2',
                      'Introduction générale ............................................... 3',
                      'Chapitre 1: Présentation de l\'entreprise ................ 4',
                      'Chapitre 2: Activités réalisées ................................. 7',
                      'Chapitre 3: Compétences acquises ......................... 10',
                      'Conclusion générale ............................................. 12',
                      'Annexes ................................................................... 13',
                    ].map((l) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(l, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')))),
                    const SizedBox(height: 8),
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)), child: const Text('Table des matières générée automatiquement avec numérotation', style: TextStyle(fontSize: 11, color: AppTheme.blueSoft))),
                  ]),
                ),
                const SizedBox(height: 16),

                // Content page preview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Chapitre 1: Présentation de l\'entreprise', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy)),
                    const SizedBox(height: 4),
                    Container(height: 2, width: 40, color: AppTheme.turquoise),
                    const SizedBox(height: 12),
                    const Text('1.1  Présentation générale', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    const Text('TELNET Holding est un groupe tunisien fondé en 1994, spécialisé dans l\'ingénierie et le conseil en technologie. Le groupe opère dans plusieurs domaines dont les télécommunications, l\'aéronautique et les systèmes embarqués. J\'ai effectué mon stage au sein du département Recherche & Développement, situé à Tunis.', style: TextStyle(fontSize: 12, height: 1.6, color: AppTheme.textDark)),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderLight)),
                      child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_outlined, color: AppTheme.textMuted), SizedBox(height: 4), Text('Figure 1: Organigramme de l\'entreprise', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)), Text('(Image avec légende)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted))])),
                    ),
                    const SizedBox(height: 10),
                    const Text('1.2  Activités observées', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    const Text('Durant mon stage, j\'ai observé l\'équipe pendant la phase de conception d\'un module de gestion. Cette observation m\'a permis de comprendre la méthodologie Agile utilisée au sein de l\'entreprise.', style: TextStyle(fontSize: 12, height: 1.6)),
                    const SizedBox(height: 12),
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF86EFAC))), child: const Row(children: [Icon(Icons.verified, size: 14, color: AppTheme.success), SizedBox(width: 6), Expanded(child: Text('Vérification FactGuard: "J\'ai observé" préservé (source: journal 19 oct.)', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600)))])),
                  ]),
                ),
                const SizedBox(height: 16),

                // Export actions
                Row(children: [
                  Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf, size: 18), label: const Text('Exporter PDF'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navy))),
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.description, size: 18), label: const Text('Exporter DOCX'), style: OutlinedButton.styleFrom(backgroundColor: Colors.white))),
                ]),
                const SizedBox(height: 8),
                Text('Génération 100% locale • Aucune donnée envoyée', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
