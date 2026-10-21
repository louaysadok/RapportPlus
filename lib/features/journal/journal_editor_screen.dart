import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/fact_guard.dart';
import '../../services/ai/speech_service.dart';

class JournalEditorScreen extends StatefulWidget {
  final int? entryId;
  const JournalEditorScreen({super.key, this.entryId});
  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final _contentCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  bool _isDraft = false;
  bool _isRecording = false;
  String _activityType = 'unknown';
  final SpeechService _speech = SpeechService();

  final List<Map<String, String>> _questions = [
    {'q': 'Qu\'avez-vous fait aujourd\'hui ?', 'hint': 'Décrivez vos activités principales'},
    {'q': 'Avez-vous participé à des activités ?', 'hint': 'Avec qui ? Quel rôle ?'},
    {'q': 'Qu\'avez-vous observé ?', 'hint': 'Démonstrations, procédures...'},
    {'q': 'Qu\'avez-vous appris ?', 'hint': 'Nouvelles compétences, connaissances'},
    {'q': 'Quels outils / logiciels avez-vous utilisés ?', 'hint': 'Machines, équipements, logiciels'},
    {'q': 'Avez-vous rencontré des difficultés ?', 'hint': 'Problèmes et solutions'},
    {'q': 'Avez-vous suivi des procédures de sécurité ?', 'hint': 'Équipements, consignes'},
    {'q': 'Que souhaitez-vous apprendre demain ?', 'hint': 'Objectifs pour la suite'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entryId != null) {
      _titleCtrl.text = 'Maintenance préventive ligne 2';
      _contentCtrl.text = 'J\'ai observé le technicien pendant la maintenance préventive de la ligne 2. Il a vérifié les capteurs de température et remplacé le filtre à air. On m\'a expliqué l\'importance du calendrier de maintenance.';
    }
    _contentCtrl.addListener(_detectType);
  }

  void _detectType() {
    setState(() => _activityType = FactGuard.detectActivityType(_contentCtrl.text).name);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entryId != null;
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/journal')),
        title: Text(isEditing ? 'Modifier l\'entrée' : 'Nouvelle entrée'),
        actions: [
          if (_isDraft) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: const Text('Brouillon', style: TextStyle(fontSize: 12, color: AppTheme.warning))),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'draft', child: Text('Enregistrer comme brouillon')),
              const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
            ],
            onSelected: (v) {
              if (v == 'delete') _confirmDelete();
              if (v == 'draft') setState(() => _isDraft = true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
                child: Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.calendar_today, size: 18, color: AppTheme.navy)),
                  const SizedBox(width: 10),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Date', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)), Text('Lundi 20 octobre 2026', style: TextStyle(fontWeight: FontWeight.w600))]),
                  const Spacer(),
                  const Icon(Icons.expand_more, color: AppTheme.textMuted),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Activity type indicator (FactGuard)
            if (_contentCtrl.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _activityType == 'observed' ? const Color(0xFFEFF6FF) : _activityType == 'performed' ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _activityType == 'observed' ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0)),
                ),
                child: Row(children: [
                  Icon(_activityType == 'observed' ? Icons.visibility_outlined : _activityType == 'performed' ? Icons.build_outlined : Icons.help_outline, size: 16, color: AppTheme.navy),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_factMessage(_activityType), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                ]),
              ),
            if (_contentCtrl.text.isNotEmpty) const SizedBox(height: 12),

            // Title
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Titre (optionnel)', hintText: 'Ex: Maintenance atelier...'),
            ),
            const SizedBox(height: 12),

            // Main content
            TextField(
              controller: _contentCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Que s\'est-il passé aujourd\'hui ? *',
                hintText: 'Écrivez librement ou répondez aux questions ci-dessous...\n\nEx: J\'ai observé un mécanicien pendant la réparation d\'une machine.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${_contentCtrl.text.split(' ').where((w) => w.isNotEmpty).length} mots', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const Spacer(),
                // Voice button
                InkWell(
                  onTap: () async {
                    if (_isRecording) {
                      final path = await _speech.stopRecording();
                      setState(() => _isRecording = false);
                      if (path != null && mounted) _showTranscriptionDialog(path);
                    } else {
                      await _speech.startRecording();
                      setState(() => _isRecording = true);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: _isRecording ? AppTheme.error : AppTheme.navy, borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_isRecording ? Icons.stop : Icons.mic, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(_isRecording ? 'Arrêter' : 'Dicter', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {},
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.borderLight)), child: const Row(children: [Icon(Icons.auto_fix_high, size: 16, color: AppTheme.blueSoft), SizedBox(width: 6), Text('IA Corriger', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.blueSoft))])),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Attachments
            const Text('Pièces jointes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _AttachButton(icon: Icons.photo_camera_outlined, label: 'Photo', onTap: () {}),
                const SizedBox(width: 8),
                _AttachButton(icon: Icons.videocam_outlined, label: 'Vidéo', onTap: () {}),
                const SizedBox(width: 8),
                _AttachButton(icon: Icons.attach_file, label: 'Document', onTap: () {}),
                const SizedBox(width: 8),
                _AttachButton(icon: Icons.mic_none, label: 'Audio', onTap: () {}),
              ]),
            ),
            const SizedBox(height: 16),

            // Adaptive questionnaire (optional)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.quiz_outlined, size: 18, color: AppTheme.navy), const SizedBox(width: 8), const Text('Questions guidées (optionnel)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)), const Spacer(), Text('Répondez ou écrivez librement', style: TextStyle(fontSize: 11, color: Colors.grey[500]))]),
                  const SizedBox(height: 12),
                  ..._questions.map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(q['q']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          TextField(decoration: InputDecoration(hintText: q['hint'], isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), maxLines: 2),
                        ]),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save buttons
            ElevatedButton(
              onPressed: () {
                // Validate fact guard
                if (_contentCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez saisir le contenu de votre journée')));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Entrée mise à jour' : 'Entrée enregistrée - IA va organiser en français clair')));
                context.go('/journal');
              },
              child: Text(isEditing ? 'Mettre à jour' : 'Enregistrer l\'entrée'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => setState(() => _isDraft = true),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: const Text('Enregistrer comme brouillon'),
            ),
            const SizedBox(height: 16),
            Center(child: Text('Vos notes originales sont toujours conservées. L\'IA génère une version corrigée séparément.', style: TextStyle(fontSize: 11, color: Colors.grey[500]), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }

  String _factMessage(String type) {
    switch (type) {
      case 'observed':
        return 'Détecté: Activité OBSERVÉE → Sera rédigé "J\'ai observé..." (jamais "J\'ai effectué")';
      case 'performed':
        return 'Détecté: Activité RÉALISÉE → Sera rédigé "J\'ai effectué..."';
      case 'assisted':
        return 'Détecté: Activité ASSISTÉE → Sera rédigé "J\'ai participé avec l\'aide de..."';
      case 'explained':
        return 'Détecté: Activité EXPLIQUÉE → Sera rédigé "On m\'a expliqué..."';
      default:
        return 'L\'IA préservera fidèlement le type d\'activité (observé vs réalisé)';
    }
  }

  void _showTranscriptionDialog(String path) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Transcription'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)), child: const Text('⚠️ Vérifiez attentivement la transcription avant d\'enregistrer. Ne sauvegardez jamais une transcription incorrecte.', style: TextStyle(fontSize: 12))),
          const SizedBox(height: 12),
          const TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Transcription apparaîtra ici... Vous pouvez la corriger.')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirmer et insérer')),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer l\'entrée ?'),
        content: const Text('Cette action est irréversible. Voulez-vous vraiment supprimer cette entrée ?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), ElevatedButton(onPressed: () { Navigator.pop(context); context.go('/journal'); }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error), child: const Text('Supprimer'))],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AttachButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
        child: Column(children: [Icon(icon, size: 20, color: AppTheme.navy), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 11))]),
      ),
    );
  }
}
