import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});
  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  String _filter = 'Tous';
  final _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _entries = [
    {'date': '20 oct 2026', 'title': 'Mise à jour système - observation', 'content': 'J\'ai observé l\'ingénieur système pendant la mise à jour des serveurs...', 'type': 'Observé', 'hasAudio': false, 'hasPhoto': true, 'words': 85},
    {'date': '19 oct 2026', 'title': 'Maintenance préventive ligne 2', 'content': 'J\'ai observé le technicien pendant la maintenance préventive. Il a vérifié les capteurs et remplacé le filtre.', 'type': 'Observé', 'hasAudio': true, 'hasPhoto': true, 'words': 142},
    {'date': '18 oct 2026', 'title': 'Inventaire stock - participation', 'content': 'J\'ai participé à l\'inventaire du stock avec Mme Salma. Nous avons compté et rangé les composants électroniques.', 'type': 'Assisté', 'hasAudio': false, 'hasPhoto': false, 'words': 98},
    {'date': '17 oct 2026', 'title': 'Réunion qualité ISO 9001', 'content': 'On m\'a expliqué la procédure qualité et les nouvelles normes ISO à respecter dans l\'atelier.', 'type': 'Expliqué', 'hasAudio': false, 'hasPhoto': false, 'words': 110},
    {'date': '16 oct 2026', 'title': 'Test logiciel module RH', 'content': 'J\'ai effectué des tests unitaires sur le module de gestion des congés. J\'ai détecté 2 bugs mineurs.', 'type': 'Réalisé', 'hasAudio': false, 'hasPhoto': true, 'words': 76},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'Tous' ? _entries : _entries.where((e) => e['type'] == _filter).toList();

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text('Journal de stage'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search + filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Rechercher dans le journal...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Tous', 'Réalisé', 'Assisté', 'Observé', 'Expliqué'].map((f) {
                      final selected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppTheme.textDark)),
                          selected: selected,
                          selectedColor: AppTheme.navy,
                          backgroundColor: Colors.white,
                          onSelected: (v) => setState(() => _filter = f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Calendar strip
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 14,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final isToday = i == 6;
                return Container(
                  width: 48,
                  decoration: BoxDecoration(
                    color: isToday ? AppTheme.navy : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isToday ? AppTheme.navy : AppTheme.borderLight),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(['L', 'M', 'M', 'J', 'V', 'S', 'D'][i % 7], style: TextStyle(fontSize: 11, color: isToday ? Colors.white70 : AppTheme.textMuted)),
                      Text('${14 + i}', style: TextStyle(fontWeight: FontWeight.w700, color: isToday ? Colors.white : AppTheme.textDark)),
                      if ([2, 6, 9].contains(i)) Container(margin: const EdgeInsets.only(top: 2), width: 6, height: 6, decoration: BoxDecoration(color: isToday ? AppTheme.turquoise : AppTheme.blueSoft, shape: BoxShape.circle)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('Aucune entrée pour "$_filter"', style: const TextStyle(color: AppTheme.textMuted)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final e = filtered[i];
                      return _JournalCard(entry: e, onTap: () => context.go('/journal/${i + 1}'));
                    },
                  ),
          ),
        ],
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

class _JournalCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onTap;
  const _JournalCard({required this.entry, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final typeColor = {
      'Réalisé': AppTheme.success,
      'Assisté': AppTheme.turquoise,
      'Observé': AppTheme.blueSoft,
      'Expliqué': AppTheme.warning,
    }[entry['type']] ?? AppTheme.textMuted;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.borderLight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: typeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(entry['type'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: typeColor)),
                ),
                const SizedBox(width: 8),
                Text(entry['date'], style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const Spacer(),
                if (entry['hasAudio']) const Icon(Icons.mic, size: 14, color: AppTheme.textMuted),
                if (entry['hasPhoto']) const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.photo, size: 14, color: AppTheme.textMuted)),
                const SizedBox(width: 8),
                Text('${entry['words']} mots', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
            const SizedBox(height: 8),
            Text(entry['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark)),
            const SizedBox(height: 4),
            Text(entry['content'], style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
