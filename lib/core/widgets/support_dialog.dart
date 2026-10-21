import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

/// Help & Support Dialog - Contains EXACT admin message as specified.
/// This widget is the single point of display. Contact info from AppConfig only.
class SupportDialog extends StatelessWidget {
  const SupportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const SupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.navy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.support_agent_rounded, color: AppTheme.navy, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Aide & Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.navy)),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppConfig.supportMessage,
                      style: const TextStyle(fontSize: 13.5, height: 1.5, color: AppTheme.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ContactRow(
              icon: Icons.person_outline,
              label: 'Administrateur',
              value: AppConfig.adminName,
            ),
            const SizedBox(height: 8),
            _ContactRow(
              icon: Icons.phone_outlined,
              label: 'WhatsApp',
              value: AppConfig.adminPhone,
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copier le numéro',
                onPressed: () async {
                  await Clipboard.setData(const ClipboardData(text: AppConfig.adminPhoneRaw));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Numéro copié dans le presse-papiers')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fermer', style: TextStyle(color: AppTheme.textMuted)),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(AppConfig.whatsappUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('WhatsApp non disponible. Numéro: ${AppConfig.adminPhone}')),
                );
              }
            }
          },
          icon: const Icon(Icons.chat_bubble_outline, size: 18),
          label: const Text('Ouvrir WhatsApp'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  const _ContactRow({required this.icon, required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.navy),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Helper to show error + support option
class ErrorWithSupportDialog extends StatelessWidget {
  final String errorTitle;
  final String errorDetails;
  const ErrorWithSupportDialog({super.key, required this.errorTitle, required this.errorDetails});

  static Future<void> show(BuildContext context, {required String title, required String details}) {
    return showDialog(
      context: context,
      builder: (_) => ErrorWithSupportDialog(errorTitle: title, errorDetails: details),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.error_outline, color: AppTheme.error),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(errorTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      ]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(errorDetails, style: const TextStyle(fontSize: 13.5, height: 1.5)),
          const SizedBox(height: 16),
          const Text('Besoin d\'aide ?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
            SupportDialog.show(context);
          },
          child: const Text('Contacter le support'),
        ),
      ],
    );
  }
}
