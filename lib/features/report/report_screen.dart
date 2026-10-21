import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<Map<String, dynamic>> _chapters = [
    {'title': 'Page de garde', 'status': 'approved', 'progress': 1.0, 'missing': ''},
    {'title': 'Remerciements', 'status': 'approved', 'progress': 1.0, 'missing': ''},
    {'title': 'Sommaire', 'status': 'auto', 'progress': 1.0, 'missing': ''},
    {'title': 'Introduction générale', 'status': 'draft', 'progress': 0.4, 'missing': 'Objectifs non détaillés'},
    {'title': 'Présentation de l\'entreprise', 'status': 'needs_info', 'progress': 0.3, 'missing': 'Activité principale manquante'},
    {'title': 'Organisation et fonctionnement', 'status': 'draft', 'progress': 0.2, 'missing': 'Organigramme manquant'},
    {'title': 'Service d\'accueil', 'status': 'draft', 'progress': 0.5, 'missing': ''},
    {'title': 'Objectifs du stage', 'status': 'approved', 'progress': 1.0, 'missing': ''},
    {'title': 'Activités réalisées', 'status': 'ai_generated', 'progress': 0.7, 'missing': ''},
    {'title': 'Activités observées', 'status': 'ai_generated', 'progress': 0.6, 'missing': ''},
    {'title': 'Matériel, outils et logiciels', 'status': 'draft', 'progress': 0.4, 'missing': 'Captures d\'écran à ajouter'},
    {'title': 'Compétences acquises', 'status': 'draft', 'progress': 0.5, 'missing': ''},
    {'title': 'Difficultés rencontrées', 'status': 'draft', 'progress': 0.3, 'missing': ''},
    {'title': 'Solutions apportées', 'status': 'draft', 'progress': 0.3, 'missing': ''},
    {'title': 'Hygiène et sécurité', 'status': 'hidden', 'progress': 0.0, 'missing': ''},
    {'title': 'Bilan personnel', 'status': 'draft', 'progress': 0.2, 'missing': 'À compléter en fin de stage'},
    {'title': 'Conclusion générale', 'status': 'draft', 'progress': 0.3, 'missing': ''},
    {'title': 'Annexes', 'status': 'draft', 'progress': 0.5, 'missing': ''},
  ];

  @override
  Widget build(BuildContext context) {
    final overallProgress = _chapters.where((c) => c['status'] != 'hidden').map((c) => c['progress'] as double).reduce((a, b) => a + b) / _chapters.where((c) => c['status'] != 'hidden').length;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text('Rapport de stage'),
        actions: [
          IconButton(icon: const Icon(Icons.visibility_outlined), tooltip: 'Aperçu', onPressed: () => context.go('/report/preview')),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(children: [
                    const Expanded(child: Text('Progression globale', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                    Text('${(overallProgress * 100).toInt()}%', style: const TextStyle(color: AppTheme.turquoise, fontWeight: FontWeight.w700, fontSize: 18)),
                  ]),
                  const SizedBox(height: 10),
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: overallProgress, minHeight: 8, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation(AppTheme.turquoise))),
                  const SizedBox(height: 10),
                  Row(children: [
                    _Dot(color: AppTheme.success, label: 'Approuvé'),
                    const SizedBox(width: 10),
                    _Dot(color: AppTheme.blueSoft, label: 'Généré IA'),
                    const SizedBox(width: 10),
                    _Dot(color: AppTheme.warning, label: 'À compléter'),
                    const Spacer(),
                    TextButton(onPressed: () => context.go('/report/preview'), child: const Text('Aperçu →', style: TextStyle(color: Colors.white))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Missing info banner (progressive)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFDE68A))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, color: AppTheme.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Revue de complétude', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('${_chapters.where((c) => c['missing'] != '').length} sections nécessitent votre attention. Répondez aux questions pour améliorer votre rapport.', style: const TextStyle(fontSize: 12, height: 1.4)),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Chapters list
            Text('Chapitres du rapport', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Basé sur vos entrées réelles - L\'IA n\'invente rien', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 10),

            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _chapters.length,
              onReorder: (oldI, newI) {
                setState(() {
                  if (newI > oldI) newI--;
                  final item = _chapters.removeAt(oldI);
                  _chapters.insert(newI, item);
                });
              },
              itemBuilder: (context, i) {
                final c = _chapters[i];
                final isHidden = c['status'] == 'hidden';
                return _ChapterTile(
                  key: ValueKey(c['title']),
                  index: i + 1,
                  title: c['title'],
                  status: c['status'],
                  progress: c['progress'],
                  missing: c['missing'],
                  isHidden: isHidden,
                  onTap: () => _openChapterEditor(c),
                  onToggleVisibility: () => setState(() => c['status'] = isHidden ? 'draft' : 'hidden'),
                );
              },
            ),
            const SizedBox(height: 16),

            // Add custom chapter
            OutlinedButton.icon(
              onPressed: () => _addCustomChapter(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter un chapitre personnalisé'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
            const SizedBox(height: 16),

            // Export
            ElevatedButton.icon(
              onPressed: () => _showExportDialog(),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Exporter le rapport'),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _showExportDialog(isPdf: true), icon: const Icon(Icons.picture_as_pdf, size: 18), label: const Text('PDF'))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: () => _showExportDialog(isPdf: false), icon: const Icon(Icons.description, size: 18), label: const Text('DOCX'))),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _openChapterEditor(Map<String, dynamic> chapter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(chapter['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.navy)),
              if (chapter['missing'] != '') ...[
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.warning_amber, size: 16, color: AppTheme.warning), const SizedBox(width: 8), Expanded(child: Text(chapter['missing'], style: const TextStyle(fontSize: 12)))])),
              ],
              const SizedBox(height: 16),
              // Missing info questions
              if (chapter['title'] == 'Présentation de l\'entreprise') ...[
                const Text('Questions pour compléter:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                _QuestionField(question: 'Quelle est l\'activité principale de l\'entreprise ?'),
                _QuestionField(question: 'Combien de départements possède-t-elle ?'),
                _QuestionField(question: 'Dans quel département avez-vous travaillé ?'),
                _QuestionField(question: 'Qui vous a supervisé ?'),
              ],
              const SizedBox(height: 16),
              const Text('Contenu du chapitre', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Contenu généré par l\'IA à partir de vos entrées réelles...\n\nVous pouvez modifier librement. L\'original est conservé.',
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                ),
              ),
              const SizedBox(height: 8),
              Text('Source: 3 entrées journal (14-19 oct.) • Généré par IA locale', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Régénérer (IA)'))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Approuver'))),
              ]),
              const SizedBox(height: 8),
              TextButton(onPressed: () {}, child: const Text('Voir les entrées sources →', style: TextStyle(color: AppTheme.blueSoft))),
            ],
          ),
        ),
      ),
    );
  }

  void _addCustomChapter() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouveau chapitre'),
        content: const TextField(decoration: InputDecoration(labelText: 'Titre du chapitre', hintText: 'Ex: Analyse du marché')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Ajouter'))],
      ),
    );
  }

  void _showExportDialog({bool isPdf = true}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Exporter en ${isPdf ? 'PDF' : 'DOCX'}'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Votre rapport sera généré localement avec:', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          const SizedBox(height: 8),
          _ExportBullet('Page de garde personnalisée'),
          _ExportBullet('Table des matières avec numéros'),
          _ExportBullet('Images et légendes'),
          _ExportBullet('Mise en page professionnelle'),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)), child: const Text('Police: Inter/Poppins • Marges: 2.5cm • A4 • Numérotation automatique', style: TextStyle(fontSize: 11))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () { Navigator.pop(context); context.go('/report/preview'); }, child: Text('Générer ${isPdf ? 'PDF' : 'DOCX'}')),
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final int index;
  final String title;
  final String status;
  final double progress;
  final String missing;
  final bool isHidden;
  final VoidCallback onTap;
  final VoidCallback onToggleVisibility;
  const _ChapterTile({super.key, required this.index, required this.title, required this.status, required this.progress, required this.missing, required this.isHidden, required this.onTap, required this.onToggleVisibility});

  @override
  Widget build(BuildContext context) {
    Color statusColor = switch (status) {
      'approved' => AppTheme.success,
      'ai_generated' => AppTheme.blueSoft,
      'needs_info' => AppTheme.error,
      'hidden' => Colors.grey,
      _ => AppTheme.warning,
    };
    String statusLabel = switch (status) {
      'approved' => 'Approuvé',
      'ai_generated' => 'Généré IA',
      'needs_info' => 'Infos manquantes',
      'hidden' => 'Masqué',
      _ => 'Brouillon',
    };

    return Opacity(
      opacity: isHidden ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
        child: ListTile(
          leading: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('$index', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.navy)))),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, decoration: isHidden ? TextDecoration.lineThrough : null)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),
            Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor))), if (missing.isNotEmpty) ...[const SizedBox(width: 6), Expanded(child: Text(missing, style: const TextStyle(fontSize: 11, color: AppTheme.error), maxLines: 1, overflow: TextOverflow.ellipsis))]]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: AppTheme.borderLight, valueColor: AlwaysStoppedAnimation(statusColor))),
          ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, size: 18, color: Colors.grey[600]), onPressed: onToggleVisibility, tooltip: isHidden ? 'Afficher' : 'Masquer'),
            const Icon(Icons.drag_handle, size: 18, color: AppTheme.textMuted),
          ]),
          onTap: isHidden ? null : onTap,
        ),
      ),
    );
  }
}

class _QuestionField extends StatelessWidget {
  final String question;
  const _QuestionField({required this.question});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(question, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        const TextField(decoration: InputDecoration(hintText: 'Votre réponse...', isDense: true), maxLines: 2),
      ]),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))]);
}

class _ExportBullet extends StatelessWidget {
  final String text;
  const _ExportBullet(this.text);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [const Icon(Icons.check_circle, size: 14, color: AppTheme.success), const SizedBox(width: 6), Text(text, style: const TextStyle(fontSize: 12))])),
}
