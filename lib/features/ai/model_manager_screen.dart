import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/config/app_config.dart';

class ModelManagerScreen extends StatefulWidget {
  const ModelManagerScreen({super.key});
  @override
  State<ModelManagerScreen> createState() => _ModelManagerScreenState();
}

class _ModelManagerScreenState extends State<ModelManagerScreen> {
  String? _downloadingId;
  double _progress = 0;
  String? _installedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(title: const Text('Modèles IA locaux')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBFDBFE))),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.info_outline, size: 16, color: AppTheme.blueSoft), SizedBox(width: 8), Text('IA 100% locale', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))]),
              SizedBox(height: 4),
              Text('Les modèles tournent directement sur votre téléphone via llama.cpp. Aucune donnée n\'est envoyée. Le téléchargement se fait une seule fois (Wi-Fi recommandé).', style: TextStyle(fontSize: 12, height: 1.4)),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
            child: Row(children: [
              const Icon(Icons.phone_android, size: 18, color: AppTheme.navy),
              const SizedBox(width: 8),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Votre appareil', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)), Text('RAM: ~1.9 Go • Stockage libre: ~6 Go', style: TextStyle(fontSize: 11, color: AppTheme.textMuted))])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(20)), child: const Text('Mémoire limitée', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.warning))),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('Modèles disponibles', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.navy)),
          const SizedBox(height: 8),
          ...AppConfig.availableModels.map((m) => _ModelCard(
                model: m,
                isInstalled: _installedId == m.id,
                isDownloading: _downloadingId == m.id,
                progress: _progress,
                onDownload: () async {
                  setState(() { _downloadingId = m.id; _progress = 0; });
                  for (int i = 0; i <= 100; i += 5) {
                    await Future.delayed(const Duration(milliseconds: 80));
                    if (mounted) setState(() => _progress = i / 100);
                  }
                  if (mounted) setState(() { _downloadingId = null; _installedId = m.id; });
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${m.name} installé')));
                },
                onDelete: () => setState(() => _installedId = null),
                onLoad: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modèle chargé - prêt à l\'emploi'))),
              )),
          const SizedBox(height: 16),
          const Text('Transcription vocale (Whisper)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.navy)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.turquoise.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mic, color: AppTheme.turquoise, size: 18)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Whisper Small (39 Mo)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)), Text('Français, Anglais, Arabe • Offline', style: TextStyle(fontSize: 11, color: AppTheme.textMuted))]))]),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Télécharger', style: TextStyle(fontSize: 12))))]),
              const SizedBox(height: 6),
              Text('Alternative via sherpa-onnx pour une meilleure prise en charge de l\'arabe dialectal tunisien (Derja). Qualité variable selon l\'accent.', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12)),
            child: const Text('💡 Recommandation pour votre appareil (1.9 Go RAM): Installez TinyLlama 1.1B pour commencer. Passez à Qwen2.5 1.5B si vous avez 3 Go+ RAM.', style: TextStyle(fontSize: 12, height: 1.4)),
          ),
          const SizedBox(height: 16),
          const Text('Licences', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          ...AppConfig.availableModels.map((m) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• ${m.name}: ${m.license}', style: TextStyle(fontSize: 11, color: Colors.grey[600])))),
          const Text('• whisper.cpp: MIT • sherpa-onnx: Apache 2.0 • llama.cpp: MIT', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final AIModelConfig model;
  final bool isInstalled;
  final bool isDownloading;
  final double progress;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final VoidCallback onLoad;
  const _ModelCard({required this.model, required this.isInstalled, required this.isDownloading, required this.progress, required this.onDownload, required this.onDelete, required this.onLoad});

  @override
  Widget build(BuildContext context) {
    final ramOk = model.ramRequiredMb <= 1900;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isInstalled ? AppTheme.success.withOpacity(0.3) : AppTheme.borderLight, width: isInstalled ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.smart_toy, size: 20, color: AppTheme.navy)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(model.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text(model.description, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted))])),
            if (isInstalled) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.success, borderRadius: BorderRadius.circular(20)), child: const Text('Installé', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 4, children: [
            _Chip(icon: Icons.storage, label: '${model.sizeMb} Mo'),
            _Chip(icon: Icons.memory, label: '${model.ramRequiredMb} Mo RAM', color: ramOk ? null : AppTheme.error),
            _Chip(icon: Icons.text_fields, label: '${model.contextLength} tokens'),
          ]),
          if (!ramOk) ...[
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.warning_amber, size: 14, color: AppTheme.error), const SizedBox(width: 6), Expanded(child: Text('RAM insuffisante pour cet appareil (${model.ramRequiredMb} Mo requis)', style: const TextStyle(fontSize: 11, color: AppTheme.error)))])),
          ],
          const SizedBox(height: 10),
          if (isDownloading) ...[
            ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress, minHeight: 6)),
            const SizedBox(height: 6),
            Text('${(progress * 100).toInt()}% • ${(model.sizeMb * progress).toInt()} / ${model.sizeMb} Mo', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ] else if (isInstalled) ...[
            Row(children: [
              Expanded(child: ElevatedButton.icon(onPressed: onLoad, icon: const Icon(Icons.play_arrow, size: 16), label: const Text('Charger', style: TextStyle(fontSize: 13)))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 16), label: const Text('Supprimer', style: TextStyle(fontSize: 13)))),
            ]),
          ] else ...[
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: onDownload, icon: const Icon(Icons.download, size: 16), label: Text('Télécharger (${model.sizeMb} Mo)', style: const TextStyle(fontSize: 13)))),
            const SizedBox(height: 4),
            Text('Source: Hugging Face • Quantization: ${model.id.contains('q4') ? 'Q4_K_M' : 'Q4_0'}', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _Chip({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.borderLight)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color ?? AppTheme.textMuted), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 11, color: color ?? AppTheme.textDark))]));
}
