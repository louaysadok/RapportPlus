import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/config/app_config.dart';
import '../../core/widgets/support_dialog.dart';
import '../../database/database.dart';
import '../../main.dart';

class SettingsFirstLaunchScreen extends ConsumerStatefulWidget {
  const SettingsFirstLaunchScreen({super.key});
  @override
  ConsumerState<SettingsFirstLaunchScreen> createState() => _SettingsFirstLaunchScreenState();
}

class _SettingsFirstLaunchScreenState extends ConsumerState<SettingsFirstLaunchScreen> {
  bool _driveConnected = false;
  bool _isConnecting = false;
  final _nameCtrl = TextEditingController();
  final _institutionCtrl = TextEditingController();
  final _specializationCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Logo / Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.navy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text('Bienvenue sur Rapport+ !',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text('Configurons votre application avant de commencer.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Google Drive Section (prominent at top as per spec) ──
              _SectionCard(
                title: 'Sauvegarde Google Drive',
                subtitle: 'Optionnel - Vous pouvez passer cette étape',
                icon: Icons.cloud_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppTheme.blueSoft, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Vos données restent stockées localement. La sauvegarde Drive est chiffrée et optionnelle. Vous gardez le contrôle total.',
                              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Voulez-vous connecter votre compte Google Drive pour sauvegarder vos données de stage ?',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('Données sauvegardées: profil, stages, journal, rapport, médias (références). Aucune donnée n\'est envoyée sans votre permission.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5)),
                    const SizedBox(height: 16),
                    if (_driveConnected)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(child: Text('Connecté - Sauvegarde activée', style: TextStyle(fontWeight: FontWeight.w600))),
                            TextButton(
                              onPressed: () => setState(() => _driveConnected = false),
                              child: const Text('Déconnecter'),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isConnecting
                                  ? null
                                  : () async {
                                      setState(() => _isConnecting = true);
                                      // Real: GoogleSignIn().signIn() + drive scope
                                      await Future.delayed(const Duration(milliseconds: 900));
                                      if (mounted) setState(() {
                                        _isConnecting = false;
                                        _driveConnected = true;
                                      });
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Google Drive connecté (simulation - configurer OAuth dans Google Cloud Console)')),
                                        );
                                      }
                                    },
                              icon: _isConnecting
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.cloud_done_outlined, size: 18),
                              label: Text(_isConnecting ? 'Connexion...' : 'Connecter Google Drive'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Configuration Drive ignorée - vous pourrez l\'activer plus tard dans Paramètres')),
                                );
                              },
                              child: const Text('Passer pour l\'instant'),
                            ),
                          ),
                        ],
                      ),
                    if (!_driveConnected) ...[
                      const SizedBox(height: 8),
                      Text('Statut: Non connecté • L\'app fonctionne normalement sans Drive',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text('Permissions demandées: drive.file (vos fichiers RapportPlus uniquement) + drive.appdata (données app). Aucun accès à vos autres fichiers.',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                    if (_driveConnected) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.backup, size: 16), label: const Text('Sauvegarder maintenant'))),
                          const SizedBox(width: 8),
                          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.restore, size: 16), label: const Text('Restaurer'))),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Profile Quick Setup ──
              _SectionCard(
                title: 'Votre profil',
                subtitle: 'Vous pourrez compléter plus tard',
                icon: Icons.person_outline,
                child: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nom complet', hintText: 'Ex: Ahmed Ben Ali', prefixIcon: Icon(Icons.badge_outlined)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _institutionCtrl,
                      decoration: const InputDecoration(labelText: 'Établissement', hintText: 'Ex: ENIT, ISET Sousse...', prefixIcon: Icon(Icons.school_outlined)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _specializationCtrl,
                      decoration: const InputDecoration(labelText: 'Filière / Spécialité', hintText: 'Ex: Génie Mécanique, Informatique...', prefixIcon: Icon(Icons.workspace_premium_outlined)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _companyCtrl,
                      decoration: const InputDecoration(labelText: 'Entreprise de stage (optionnel)', hintText: 'Ex: STEG, Orange Tunisie...', prefixIcon: Icon(Icons.business_outlined)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Continue button
              ElevatedButton(
                onPressed: () async {
                  final db = ref.read(databaseProvider);
                  // Save profile if provided
                  if (_nameCtrl.text.trim().isNotEmpty) {
                    await db.setSetting('user_name', _nameCtrl.text.trim());
                  }
                  await db.completeFirstLaunch();
                  if (context.mounted) context.go('/dashboard');
                },
                child: const Text('Continuer vers le tableau de bord →'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () => SupportDialog.show(context),
                  icon: const Icon(Icons.help_outline, size: 16),
                  label: const Text('Aide & Support'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('Vos données sont stockées localement sur votre appareil.',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.subtitle, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppTheme.navy, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.navy)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
