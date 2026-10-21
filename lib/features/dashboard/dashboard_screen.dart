import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/support_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app from Drift via Riverpod
    const activeInternship = 'Stage PFE - Génie Logiciel';
    const company = 'TELNET Holding - Tunis';
    const daysCompleted = 23;
    const totalDays = 60;
    const progress = 0.38;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text('Rapport+'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => SupportDialog.show(context),
            tooltip: 'Aide',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active internship card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.navy, AppTheme.navyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppTheme.turquoise, borderRadius: BorderRadius.circular(20)),
                        child: const Text('STAGE ACTIF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text('$daysCompleted / $totalDays jours', style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(activeInternship, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.business, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(company, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  ]),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.turquoise),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${(progress * 100).toInt()}% complété', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      Text('${totalDays - daysCompleted} jours restants', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Today's journal status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.edit_calendar_rounded, color: AppTheme.warning),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Journal du jour', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('Aujourd\'hui, 20 oct. - Pas encore rempli', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/journal/new'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40), padding: const EdgeInsets.symmetric(horizontal: 16)),
                    child: const Text('Remplir'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick stats row
            Row(
              children: [
                _StatCard(icon: Icons.book_outlined, label: 'Entrées', value: '23', color: AppTheme.blueSoft),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.description_outlined, label: 'Rapport', value: '42%', color: AppTheme.navy),
                const SizedBox(width: 10),
                _StatCard(icon: Icons.emoji_events_outlined, label: 'Soutenance', value: '6/15', color: AppTheme.turquoise),
              ],
            ),
            const SizedBox(height: 20),

            // Recent entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Entrées récentes', style: Theme.of(context).textTheme.titleMedium),
                TextButton(onPressed: () => context.go('/journal'), child: const Text('Voir tout')),
              ],
            ),
            _EntryTile(date: '19 oct. 2026', title: 'Observation atelier - maintenance préventive', preview: 'J\'ai observé le technicien pendant la maintenance préventive de la ligne 2...', type: 'Observé'),
            _EntryTile(date: '18 oct. 2026', title: 'Participation - inventaire stock', preview: 'J\'ai participé à l\'inventaire du stock avec l\'aide de Mme Salma...', type: 'Assisté'),
            _EntryTile(date: '17 oct. 2026', title: 'Réunion d\'équipe hebdomadaire', preview: 'On m\'a expliqué la nouvelle procédure qualité ISO 9001...', type: 'Expliqué'),

            const SizedBox(height: 16),
            // Report progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description, color: AppTheme.navy, size: 20),
                      const SizedBox(width: 8),
                      const Text('Rapport - Progression', style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      TextButton(onPressed: () => context.go('/report'), child: const Text('Ouvrir')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ProgressRow(label: 'Présentation entreprise', value: 0.7),
                  _ProgressRow(label: 'Activités réalisées', value: 0.5),
                  _ProgressRow(label: 'Compétences acquises', value: 0.3),
                  _ProgressRow(label: 'Conclusion', value: 0.1),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.warning),
                        SizedBox(width: 8),
                        Expanded(child: Text('Votre section "Présentation entreprise" manque d\'informations sur l\'organisation.', style: TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Jury prep
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderLight)),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.turquoise.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.record_voice_over, color: AppTheme.turquoise)),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Préparation soutenance', style: TextStyle(fontWeight: FontWeight.w600)), Text('6 questions pratiquées • 2 à réviser', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))])),
                  OutlinedButton(onPressed: () => context.go('/soutenance'), child: const Text('S\'entraîner')),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/journal/new'),
        backgroundColor: AppTheme.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle entrée'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.borderLight)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final String date;
  final String title;
  final String preview;
  final String type;
  const _EntryTile({required this.date, required this.title, required this.preview, required this.type});
  @override
  Widget build(BuildContext context) {
    Color typeColor = type == 'Observé' ? AppTheme.blueSoft : type == 'Assisté' ? AppTheme.turquoise : AppTheme.warning;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Column(children: [Text(date.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)), Text(date.split(' ').sublist(1).join(' '), style: const TextStyle(fontSize: 10, color: AppTheme.textMuted))]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: typeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: typeColor))),
                ]),
                const SizedBox(height: 2),
                Text(preview, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  const _ProgressRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          SizedBox(width: 80, child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: value, minHeight: 6, backgroundColor: AppTheme.borderLight, valueColor: AlwaysStoppedAnimation(value > 0.5 ? AppTheme.success : AppTheme.warning)))),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
