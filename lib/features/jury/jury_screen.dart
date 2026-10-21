import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class JuryScreen extends StatefulWidget {
  const JuryScreen({super.key});
  @override
  State<JuryScreen> createState() => _JuryScreenState();
}

class _JuryScreenState extends State<JuryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _mockIndex = 0;
  bool _showAnswer = false;
  String _userMockAnswer = '';
  int? _score;

  final List<Map<String, dynamic>> _questions = [
    {'q': 'Pouvez-vous présenter l\'entreprise dans laquelle vous avez effectué votre stage ?', 'cat': 'Entreprise', 'difficulty': 'Facile', 'status': 'new'},
    {'q': 'Quels étaient les objectifs de votre stage ?', 'cat': 'Objectifs', 'difficulty': 'Facile', 'status': 'learning'},
    {'q': 'Quelles activités avez-vous réalisées ?', 'cat': 'Activités', 'difficulty': 'Moyen', 'status': 'learning'},
    {'q': 'Quelles compétences avez-vous acquises ?', 'cat': 'Compétences', 'difficulty': 'Moyen', 'status': 'mastered'},
    {'q': 'Quelles difficultés avez-vous rencontrées ?', 'cat': 'Difficultés', 'difficulty': 'Moyen', 'status': 'new'},
    {'q': 'Comment avez-vous surmonté ces difficultés ?', 'cat': 'Solutions', 'difficulty': 'Difficile', 'status': 'new'},
    {'q': 'Qu\'avez-vous appris de cette expérience ?', 'cat': 'Bilan', 'difficulty': 'Moyen', 'status': 'new'},
    {'q': 'Quelles technologies avez-vous utilisées ?', 'cat': 'Technique', 'difficulty': 'Moyen', 'status': 'new'},
  ];

  final List<Map<String, String>> _mockQa = [
    {'q': 'Pouvez-vous présenter l\'entreprise ?', 'a': 'J\'ai effectué mon stage chez TELNET Holding, un groupe tunisien spécialisé en ingénierie. J\'ai travaillé au département R&D...'},
    {'q': 'Quelles activités avez-vous réalisées ?', 'a': 'J\'ai participé au développement d\'un module de gestion et j\'ai observé l\'équipe lors des tests d\'intégration...'},
    {'q': 'Quelles difficultés avez-vous rencontrées ?', 'a': 'J\'ai eu des difficultés avec la prise en main du framework, que j\'ai surmontées grâce à l\'aide de mon encadrant...'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text('Préparation soutenance'),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.turquoise,
          tabs: const [
            Tab(text: 'Questions'),
            Tab(text: 'Simulation'),
            Tab(text: 'Flashcards'),
            Tab(text: 'Progrès'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildQuestionsTab(),
          _buildMockTab(),
          _buildFlashcardsTab(),
          _buildProgressTab(),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBFDBFE))),
          child: const Row(children: [Icon(Icons.info_outline, size: 18, color: AppTheme.blueSoft), SizedBox(width: 8), Expanded(child: Text('Questions générées à partir de vos entrées réelles. Aucune question n\'est inventée.', style: TextStyle(fontSize: 12)))]),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: ['Toutes', 'Entreprise', 'Activités', 'Technique', 'Bilan'].map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(c, style: const TextStyle(fontSize: 12)), onSelected: (_) {}, backgroundColor: Colors.white)) ).toList()),
        ),
        const SizedBox(height: 12),
        ..._questions.map((q) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: _catColor(q['cat']).withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(q['cat'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _catColor(q['cat'])))),
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.borderLight)), child: Text(q['difficulty'], style: const TextStyle(fontSize: 10))),
                  const Spacer(),
                  Icon(_statusIcon(q['status']), size: 16, color: _statusColor(q['status'])),
                ]),
                const SizedBox(height: 8),
                Text(q['q'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [
                  TextButton(onPressed: () => _showSuggestedAnswer(q['q']), child: const Text('Voir réponse suggérée', style: TextStyle(fontSize: 12))),
                  const Spacer(),
                  OutlinedButton(onPressed: () {}, child: const Text('S\'entraîner', style: TextStyle(fontSize: 12))),
                ]),
              ]),
            )),
      ],
    );
  }

  Widget _buildMockTab() {
    final current = _mockQa[_mockIndex % _mockQa.length];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(children: [
            Text('Question ${_mockIndex + 1} / ${_mockQa.length}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('${((_mockIndex + 1) / _mockQa.length * 100).toInt()}%', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_mockIndex + 1) / _mockQa.length, backgroundColor: AppTheme.borderLight, valueColor: const AlwaysStoppedAnimation(AppTheme.navy), minHeight: 6)),
          const SizedBox(height: 20),

          // Question card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const Icon(Icons.record_voice_over, color: Colors.white, size: 28),
              const SizedBox(height: 12),
              Text(current['q']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: const Text('L\'IA vous écoute...', style: TextStyle(color: Colors.white70, fontSize: 12))),
            ]),
          ),
          const SizedBox(height: 16),

          // Answer input
          const Text('Votre réponse:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            onChanged: (v) => _userMockAnswer = v,
            decoration: InputDecoration(
              hintText: 'Tapez ou dictez votre réponse...',
              suffixIcon: IconButton(icon: const Icon(Icons.mic, color: AppTheme.navy), onPressed: () {}),
            ),
          ),
          const SizedBox(height: 12),
          if (_score == null)
            ElevatedButton(
              onPressed: () {
                if (_userMockAnswer.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez saisir une réponse')));
                  return;
                }
                setState(() => _score = 7);
              },
              child: const Text('Soumettre pour évaluation'),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text('$_score/10', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.success))),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Bonne réponse ! Structure claire.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                ]),
                const SizedBox(height: 10),
                const Text('Feedback:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const Text('• Bonne pertinence par rapport à la question\n• Ajoutez un exemple concret de votre expérience\n• Utilisez des connecteurs logiques', style: TextStyle(fontSize: 12, height: 1.5, color: AppTheme.textMuted)),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)), child: Text('Exemple amélioré: ${current['a']}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic))),
              ]),
            ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: _score == null ? null : () => setState(() { _mockIndex++; _score = null; _userMockAnswer = ''; _showAnswer = false; }), child: const Text('Question suivante →'))),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: () => setState(() => _showAnswer = !_showAnswer), child: Text(_showAnswer ? 'Masquer' : 'Voir réponse')),
          ]),
          if (_showAnswer) ...[
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)), child: Text(current['a']!, style: const TextStyle(fontSize: 13, height: 1.5))),
          ],
        ],
      ),
    );
  }

  Widget _buildFlashcardsTab() {
    final cards = [
      {'q': 'Qu\'est-ce que la maintenance préventive ?', 'a': 'Ensemble d\'actions planifiées pour éviter les pannes', 'status': 'learning'},
      {'q': 'Citez 2 outils utilisés', 'a': 'Multimètre, oscilloscope', 'status': 'new'},
      {'q': 'Quelle norme qualité ?', 'a': 'ISO 9001:2015', 'status': 'mastered'},
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [const Text('Flashcards', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)), const Spacer(), Text('${cards.length} cartes', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))]),
        const SizedBox(height: 12),
        ...cards.map((c) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.borderLight)),
              child: ExpansionTile(
                title: Text(c['q']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                subtitle: Text('Statut: ${c['status']}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(8)), child: Text(c['a']!, style: const TextStyle(fontSize: 13))),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('À réviser', style: TextStyle(fontSize: 12)))),
                        const SizedBox(width: 8),
                        Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success), child: const Text('Maîtrisé', style: TextStyle(fontSize: 12)))),
                      ]),
                    ]),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildProgressTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Expanded(child: _ProgressStat(value: '8', label: 'Questions\npratiquées', color: AppTheme.navy)),
          const SizedBox(width: 10),
          Expanded(child: _ProgressStat(value: '6.5/10', label: 'Score\nmoyen', color: AppTheme.success)),
          const SizedBox(width: 10),
          Expanded(child: _ProgressStat(value: '3', label: 'À\nréviser', color: AppTheme.warning)),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Points forts', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _SkillRow(label: 'Présentation entreprise', score: 0.9),
            _SkillRow(label: 'Activités réalisées', score: 0.7),
            const SizedBox(height: 8),
            const Text('À améliorer', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _SkillRow(label: 'Difficultés & solutions', score: 0.3),
            _SkillRow(label: 'Bilan personnel', score: 0.4),
          ]),
        ),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.emoji_events, color: AppTheme.blueSoft, size: 20), SizedBox(width: 10), Expanded(child: Text('Continuez ! Vous progressez bien. Révisez les sujets faibles avant la soutenance.', style: TextStyle(fontSize: 12)))])),
      ],
    );
  }

  void _showSuggestedAnswer(String question) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.navy)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(10)), child: const Text('Réponse suggérée basée sur vos entrées réelles:\n\n"J\'ai effectué mon stage au sein du département R&D. Mes objectifs étaient de développer un module de gestion et de comprendre la méthodologie Agile. J\'ai observé l\'équipe pendant les phases de test..."', style: TextStyle(fontSize: 13, height: 1.5))),
          const SizedBox(height: 8),
          Text('Source: journal 16-20 oct. • Généré en français clair (B2)', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ]),
      ),
    );
  }

  Color _catColor(String cat) => switch (cat) {
        'Entreprise' => AppTheme.navy,
        'Technique' => AppTheme.blueSoft,
        'Bilan' => AppTheme.turquoise,
        _ => AppTheme.warning,
      };
  IconData _statusIcon(String s) => switch (s) {
        'mastered' => Icons.check_circle,
        'learning' => Icons.access_time,
        _ => Icons.circle_outlined,
      };
  Color _statusColor(String s) => switch (s) {
        'mastered' => AppTheme.success,
        'learning' => AppTheme.warning,
        _ => Colors.grey,
      };
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _ProgressStat({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)), child: Column(children: [Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: color)), const SizedBox(height: 4), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted))]));
}

class _SkillRow extends StatelessWidget {
  final String label;
  final double score;
  const _SkillRow({required this.label, required this.score});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          SizedBox(width: 80, child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: score, minHeight: 6, backgroundColor: AppTheme.borderLight, valueColor: AlwaysStoppedAnimation(score > 0.6 ? AppTheme.success : AppTheme.warning)))),
          const SizedBox(width: 8),
          Text('${(score * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
        ]),
      );
}
