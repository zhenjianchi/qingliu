import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// V3.0 AI Support Page
/// 参考: doc/design/20260705/HTML/mobile-ios.html (Screen 05)
///
/// - Header: back + "清流 · 即时支持" + privacy
/// - Privacy badge (本地处理 · 不留存 · 不替代专业咨询)
/// - Chat-style conversation (with avatars)
/// - Recommended technique card
/// - Quick reply chips
/// - Input bar at bottom
class AiSupportPage extends StatefulWidget {
  const AiSupportPage({super.key});

  @override
  State<AiSupportPage> createState() => _AiSupportPageState();
}

class _AiSupportPageState extends State<AiSupportPage> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      fromAi: true,
      text: '嗨，我在这里。无论这一刻是深夜还是刚刚到家、累得像被掏空 —— 都先别急着给自己下定义。',
    ),
    _ChatMessage(
      fromAi: true,
      text: '你愿意告诉我，是工作的那种累，还是一种空？两种我都陪得了。',
    ),
    _ChatMessage(
      fromAi: false,
      text: '工作。一整天都被打断，回家没力气做任何决定。',
    ),
    _ChatMessage(
      fromAi: true,
      text: '嗯，听到你了。"决策疲劳"是真东西 —— 不是矫情，是大脑真的电量不足。我陪你做一件小事，让身体先慢一拍：',
    ),
  ];

  void _sendMessage() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(fromAi: false, text: text));
      _ctrl.clear();
    });
    // Simulate AI reply
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          fromAi: true,
          text: '收到。听起来你需要先让神经慢一拍。',
        ));
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildPrivacyBadge(),
            const SizedBox(height: 16),
            Expanded(child: _buildChatList()),
            const SizedBox(height: 8),
            _buildQuickReplies(),
            const SizedBox(height: 12),
            _buildInputBar(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          _iconBtn(
            Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '现在',
                  style: AppTheme.monoLabel(
                    color: const Color(kColorTextHint),
                    fontSize: 11,
                  ).copyWith(letterSpacing: 0.12),
                ),
                const SizedBox(height: 2),
                Text(
                  '清流 · 即时支持',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorTextPrimary),
                  ),
                ),
              ],
            ),
          ),
          _iconBtn(Icons.lock_outline, onTap: () {}),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(kColorTextPrimary)),
        ),
      ),
    );
  }

  Widget _buildPrivacyBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(kColorSuccess).withAlpha(26),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(kColorSuccess),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '本地处理 · 不留存 · 不替代专业咨询',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(kColorSuccess),
                letterSpacing: 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.separated(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _messages.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i == _messages.length) {
          return _buildRecommendation();
        }
        return _buildMessage(_messages[i]);
      },
    );
  }

  Widget _buildMessage(_ChatMessage msg) {
    final isAi = msg.fromAi;
    return Row(
      mainAxisAlignment:
          isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isAi) ...[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(kColorSurface),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(kColorBorderSoft)),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.bolt,
              size: 16,
              color: Color(kColorTextPrimary),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isAi
                  ? const Color(kColorSurface)
                  : const Color(kColorPrimary).withAlpha(31),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isAi ? 4 : 16),
                bottomRight: Radius.circular(isAi ? 16 : 4),
              ),
              border: isAi
                  ? Border.all(color: const Color(kColorBorderSoft))
                  : null,
            ),
            child: Text(
              msg.text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(kColorTextPrimary),
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendation() {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(kColorSurface),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: const Color(kColorBorderSoft)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(kColorWarning).withAlpha(31),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '为你推荐',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(kColorWarning),
                    ),
                  ),
                ),
                Text(
                  '立刻开始 →',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'T4 · 90 秒呼吸法',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(kColorTextPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '用一次完整的 90 秒让副交感神经先接管。',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(kColorTextHint),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _quickChip('换一种'),
          _quickChip('我想先聊一会'),
          _quickChip('记下这次'),
        ],
      ),
    );
  }

  Widget _quickChip(String label) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(kColorSurface),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(kColorBorderSoft)),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(kColorTextPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(kColorBorderSoft),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(kColorTextPrimary),
                ),
                decoration: InputDecoration(
                  hintText: '告诉我此刻的样子…',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(kColorTextHint),
                  ),
                  filled: true,
                  fillColor: const Color(kColorSurface),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide: const BorderSide(color: Color(kColorBorder)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide: const BorderSide(color: Color(kColorBorder)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide:
                        const BorderSide(color: Color(kColorPrimary), width: 2),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(kColorPrimary),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.send,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final bool fromAi;
  final String text;

  _ChatMessage({required this.fromAi, required this.text});
}