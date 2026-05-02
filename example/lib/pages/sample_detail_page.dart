import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../demo/demo_theme.dart';

/// Detail screen: description, styled code block, primary [Let's try] + optional extras.
class SampleDetailPage extends StatelessWidget {
  const SampleDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.code,
    required this.onTry,
    this.tryLabel = "Let's try  🎉",
    this.extraActions = const <SampleExtraAction>[],
  });

  final String title;
  final String subtitle;
  final String description;
  final String code;
  final VoidCallback onTry;
  final String tryLabel;
  final List<SampleExtraAction> extraActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDeep,
      appBar: AppBar(
        backgroundColor: kBgDeep,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white70,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // ── Header card ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kAccentViolet.withValues(alpha: 0.12),
                  kBgCard,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccentViolet.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAccentViolet.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: kAccentViolet,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFCCCCEE),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Code block ───────────────────────────────────────────────────
          const _CodeLabel(),
          const SizedBox(height: 8),
          _CodeBlock(code: code),
          const SizedBox(height: 28),

          // ── Primary CTA ──────────────────────────────────────────────────
          _GradientButton(label: tryLabel, onPressed: onTry),
          for (final a in extraActions) ...[
            const SizedBox(height: 12),
            _SecondaryButton(label: a.label, onPressed: a.onPressed),
          ],
        ],
      ),
    );
  }
}

// ── Code components ───────────────────────────────────────────────────────────

class _CodeLabel extends StatelessWidget {
  const _CodeLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: kAccentViolet,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Sample code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CodeBlock extends StatefulWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgCodeBlock,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
            child: Row(
              children: [
                _trafficDot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _trafficDot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _trafficDot(const Color(0xFF28C940)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kAccentViolet.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'dart',
                    style: TextStyle(
                      color: kAccentViolet,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _copied
                      ? const Row(
                          key: ValueKey('done'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_rounded, size: 13, color: kAccentTeal),
                            SizedBox(width: 4),
                            Text(
                              'Copied',
                              style: TextStyle(color: kAccentTeal, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : GestureDetector(
                          key: const ValueKey('copy'),
                          onTap: _copy,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy_rounded, size: 13, color: kTextMuted),
                              SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: TextStyle(color: kTextMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          // Code body
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.55,
                color: Color(0xFFD4D4FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trafficDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Buttons ───────────────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            ),
          ),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kAccentViolet.withValues(alpha: 0.4)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: kAccentViolet,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary action on a detail page (e.g. second dialog variant).
class SampleExtraAction {
  const SampleExtraAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}
