import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/config/app_config.dart';
import '../../core/widgets/support_dialog.dart';

/// MINIMAL SETTINGS — dark mode toggle wired, no purple shading
/// All AI controls live here

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  String _aiAutoCorrect = 'Demander';
  bool _aiTranslate = true;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final bg = isDark ? AppTheme.darkScaffold : AppTheme.paper;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final line = isDark ? AppTheme.darkLine : AppTheme.line;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.darkScaffold : Colors.white,
        foregroundColor: isDark ? Colors.white : AppTheme.ink,
        surfaceTintColor: Colors.transparent,
        title: const Text('Réglages'),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: line)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // Profile
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: isDark ? Colors.white : AppTheme.ink, shape: BoxShape.circle), child: Icon(Icons.person, color: isDark ? AppTheme.ink : Colors.white, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ahmed Ben Ali', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : AppTheme.ink)), Text('ISET Sousse · Génie Logiciel', style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted))])),
              IconButton(onPressed: _editProfile, icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? Colors.white : AppTheme.ink), style: IconButton.styleFrom(side: BorderSide(color: line), padding: const EdgeInsets.all(8))),
            ]),
          ),
          const SizedBox(height: 20),

          _SectionLabel('Mes stages', isDark: isDark),
          _Card(isDark: isDark, children: [
            _RowTile(title: 'Stage PFE — Génie Logiciel', subtitle: 'TELNET Holding · 15 sept – 15 nov 2026', trailing: _Pill('Actif', filled: true, isDark: isDark), onTap: () {}, isDark: isDark),
            _Divider(isDark: isDark),
            _RowTile(title: 'Stage Technicien', subtitle: 'STEG Sousse · 10 juin – 10 août 2025', trailing: _Pill('Archivé', isDark: isDark), onTap: () {}, isDark: isDark),
            _Divider(isDark: isDark),
            InkWell(onTap: () {}, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add, size: 16, color: isDark ? Colors.white : AppTheme.ink), const SizedBox(width: 6), Text('Nouveau stage', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white : AppTheme.ink))]))),
          ]),
          const SizedBox(height: 16),

          _SectionLabel('Intelligence artificielle', caption: 'Tout ce qui concerne l\'IA locale est ici', isDark: isDark),
          _Card(isDark: isDark, children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(Icons.smart_toy_outlined, size: 16, color: isDark ? Colors.white : AppTheme.ink), const SizedBox(width: 8), Text('Modèles locaux', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), const Spacer(), _Pill('Aucun installé', isDark: isDark)]),
                const SizedBox(height: 8),
                Text('Aucun modèle installé. L\'app fonctionne normalement sans IA.', style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted, height: 1.4)),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => context.go('/ai/models'), child: const Text('Gérer les modèles'))),
                const SizedBox(height: 8),
                Text('Qwen2.5-3B · 1.5B · TinyLlama · Whisper 39 Mo', style: TextStyle(fontSize: 10, color: isDark ? AppTheme.darkMuted2 : AppTheme.muted2)),
              ]),
            ),
            _Divider(isDark: isDark),
            _SwitchTile(title: 'Correction automatique', subtitle: 'Corriger le français à l\'enregistrement', value: _aiTranslate, onChanged: (v) => setState(() => _aiTranslate = v), isDark: isDark),
            _Divider(isDark: isDark),
            _PickerTile(title: 'Action IA', subtitle: _aiAutoCorrect, options: const ['Auto', 'Demander', 'Désactivé'], value: _aiAutoCorrect, onPicked: (v) => setState(() => _aiAutoCorrect = v), isDark: isDark),
            _Divider(isDark: isDark),
            _NavTile(icon: Icons.memory_outlined, title: 'Bibliothèque de modèles', subtitle: 'Télécharger, charger, supprimer', onTap: () => context.go('/ai/models'), isDark: isDark),
            _Divider(isDark: isDark),
            _NavTile(icon: Icons.mic_none, title: 'Transcription vocale', subtitle: 'Whisper / sherpa-onnx · hors-ligne', onTap: () => context.go('/ai/models'), isDark: isDark),
          ]),
          const SizedBox(height: 16),

          _SectionLabel('Rappels', isDark: isDark),
          _Card(isDark: isDark, children: [
            _SwitchTile(title: 'Rappel quotidien', subtitle: _reminderEnabled ? 'Tous les jours à ${_reminderTime.format(context)}' : 'Désactivé', value: _reminderEnabled, onChanged: (v) => setState(() => _reminderEnabled = v), isDark: isDark),
            if (_reminderEnabled) ...[
              _Divider(isDark: isDark),
              _NavTile(icon: Icons.schedule, title: 'Heure', subtitle: _reminderTime.format(context), onTap: () async { final p = await showTimePicker(context: context, initialTime: _reminderTime); if (p != null) setState(() => _reminderTime = p); }, isDark: isDark),
              _Divider(isDark: isDark),
              _NavTile(icon: Icons.calendar_today_outlined, title: 'Jours', subtitle: 'Lun – Ven', onTap: () {}, isDark: isDark),
            ],
          ]),
          const SizedBox(height: 16),

          _SectionLabel('Sauvegarde', isDark: isDark),
          _Card(isDark: isDark, children: [
            Padding(padding: const EdgeInsets.all(14), child: Row(children: [Icon(Icons.cloud_outlined, size: 16, color: isDark ? Colors.white : AppTheme.ink), const SizedBox(width: 8), Text('Google Drive', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), const Spacer(), _Pill('Non connecté', isDark: isDark)])),
            _Divider(isDark: isDark),
            Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Connecter'))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Sauvegarder')))])),
          ]),
          const SizedBox(height: 16),

          _SectionLabel('Apparence', isDark: isDark),
          _Card(isDark: isDark, children: [
            _SwitchTile(
              title: 'Mode sombre',
              subtitle: isDark ? 'Activé — noir pur, sans violet' : 'Désactivé — thème clair minimal',
              value: isDark,
              onChanged: (v) => ref.read(themeProvider.notifier).setMode(v ? ThemeMode.dark : ThemeMode.light),
              isDark: isDark,
            ),
            _Divider(isDark: isDark),
            _NavTile(icon: Icons.language_outlined, title: 'Langue', subtitle: 'Français', onTap: () {}, isDark: isDark),
          ]),
          const SizedBox(height: 16),

          _SectionLabel('Aide & support', isDark: isDark),
          _Card(isDark: isDark, children: [
            _NavTile(icon: Icons.help_outline, title: 'Contacter l\'administrateur', subtitle: '${AppConfig.adminName} · ${AppConfig.adminPhone}', onTap: () => SupportDialog.show(context), isDark: isDark),
            _Divider(isDark: isDark),
            _NavTile(icon: Icons.shield_outlined, title: 'Confidentialité', subtitle: 'Données locales · aucun envoi auto', onTap: () {}, isDark: isDark),
          ]),
          const SizedBox(height: 24),
          Center(child: Text('Rapport+ v${AppConfig.appVersion} · Minimal · Tunisie', style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted2 : AppTheme.muted2))),
        ],
      ),
    );
  }

  void _editProfile() {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: isDark ? AppTheme.darkCard : Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (_) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 32, height: 3, decoration: BoxDecoration(color: isDark ? AppTheme.darkLine : AppTheme.line, borderRadius: BorderRadius.circular(2))), const SizedBox(height: 12), Text('Modifier le profil', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppTheme.ink)), const SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: 'Nom complet', filled: true, fillColor: isDark ? AppTheme.darkScaffold : Colors.white)), const SizedBox(height: 10), TextField(decoration: InputDecoration(labelText: 'Établissement', filled: true, fillColor: isDark ? AppTheme.darkScaffold : Colors.white)), const SizedBox(height: 14), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Enregistrer'))), const SizedBox(height: 16)])));
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final String? caption;
  final bool isDark;
  const _SectionLabel(this.text, {this.caption, this.isDark = false});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppTheme.ink)), if (caption != null) Text(caption!, style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted))]));
}
class _Card extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _Card({required this.children, this.isDark = false});
  @override
  Widget build(BuildContext context) => Container(decoration: BoxDecoration(color: isDark ? AppTheme.darkCard : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppTheme.darkLine : AppTheme.line)), child: Column(children: children));
}
class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({this.isDark = false});
  @override
  Widget build(BuildContext context) => Divider(height: 1, thickness: 1, color: isDark ? AppTheme.darkLine : AppTheme.line);
}
class _Pill extends StatelessWidget {
  final String text;
  final bool filled;
  final bool isDark;
  const _Pill(this.text, {this.filled = false, this.isDark = false});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: filled ? (isDark ? Colors.white : AppTheme.ink) : (isDark ? AppTheme.darkScaffold : Colors.white), borderRadius: BorderRadius.circular(20), border: Border.all(color: filled ? (isDark ? Colors.white : AppTheme.ink) : (isDark ? AppTheme.darkLine : AppTheme.line))), child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: filled ? (isDark ? AppTheme.ink : Colors.white) : (isDark ? AppTheme.darkMuted : AppTheme.muted))));
}
class _SwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  const _SwitchTile({required this.title, this.subtitle, required this.value, required this.onChanged, this.isDark = false});
  @override
  Widget build(BuildContext context) => ListTile(title: Text(title, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted)) : null, trailing: Switch(value: value, onChanged: onChanged), contentPadding: const EdgeInsets.symmetric(horizontal: 14));
}
class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDark;
  const _NavTile({required this.icon, required this.title, this.subtitle, required this.onTap, this.isDark = false});
  @override
  Widget build(BuildContext context) => ListTile(leading: Icon(icon, size: 18, color: isDark ? Colors.white : AppTheme.ink), title: Text(title, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted)) : null, trailing: Icon(Icons.chevron_right, size: 16, color: isDark ? AppTheme.darkMuted : AppTheme.muted), onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 14));
}
class _RowTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final bool isDark;
  const _RowTile({required this.title, required this.subtitle, required this.trailing, required this.onTap, this.isDark = false});
  @override
  Widget build(BuildContext context) => ListTile(title: Text(title, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted)), trailing: trailing, onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 14));
}
class _PickerTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String value;
  final ValueChanged<String> onPicked;
  final bool isDark;
  const _PickerTile({required this.title, required this.subtitle, required this.options, required this.value, required this.onPicked, this.isDark = false});
  @override
  Widget build(BuildContext context) => ListTile(title: Text(title, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkMuted : AppTheme.muted)), trailing: Icon(Icons.expand_more, size: 16, color: isDark ? AppTheme.darkMuted : AppTheme.muted), onTap: () => showModalBottomSheet(context: context, backgroundColor: isDark ? AppTheme.darkCard : Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (_) => ListView(children: options.map((o) => ListTile(title: Text(o, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppTheme.ink)), trailing: o == value ? Icon(Icons.check, size: 16, color: isDark ? Colors.white : AppTheme.ink) : null, onTap: () { Navigator.pop(context); onPicked(o); })).toList())), contentPadding: const EdgeInsets.symmetric(horizontal: 14));
}
