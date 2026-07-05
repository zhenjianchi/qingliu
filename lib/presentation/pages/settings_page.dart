import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// V3.0 Settings Page (iOS-style)
/// 参考: doc/design/20260705/HTML/mobile-settings.html
///
/// - Account card (avatar + name + streak)
/// - Notifications (3 toggles)
/// - Privacy (3 rows)
/// - Appearance (theme, language)
/// - About (4 links)
/// - Sign out + version footer
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _morningReminder = true;
  bool _eveningReminder = true;
  bool _riskReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection(
                      label: '账户',
                      child: _accountCard(),
                    ),
                    _buildSection(
                      label: '通知',
                      child: _card([
                        _toggleRow(
                          title: '早晨承诺提醒',
                          sub: '每天 08:00 · "新的一天开始了"',
                          value: _morningReminder,
                          onChanged: (v) => setState(() => _morningReminder = v),
                        ),
                        _divider(),
                        _toggleRow(
                          title: '夜间回顾',
                          sub: '每天 22:00 · "睡前花 2 分钟看看今天"',
                          value: _eveningReminder,
                          onChanged: (v) => setState(() => _eveningReminder = v),
                        ),
                        _divider(),
                        _toggleRow(
                          title: '高风险时段',
                          sub: '根据你历史数据动态学习',
                          value: _riskReminder,
                          onChanged: (v) => setState(() => _riskReminder = v),
                        ),
                      ]),
                    ),
                    _buildSection(
                      label: '隐私',
                      child: _card([
                        _valueRow(
                          title: 'AI 对话本地处理',
                          sub: '对话内容不上云，不留存',
                          value: '已开启',
                        ),
                        _divider(),
                        _valueRow(
                          title: '数据所有权',
                          sub: '所有记录都保存在你的设备上',
                          value: '本地',
                        ),
                        _divider(),
                        _dangerRow(
                          title: '删除所有数据',
                          sub: '不可恢复 · 保留 0 天的清白',
                          onTap: _confirmDelete,
                        ),
                      ]),
                    ),
                    _buildSection(
                      label: '外观',
                      child: _card([
                        _valueRow(
                          title: '主题',
                          sub: '温暖陪伴 · 沙色基底',
                          value: '温暖陪伴',
                        ),
                        _divider(),
                        _valueRow(
                          title: '语言',
                          sub: '跟随系统设置',
                          value: '简体中文',
                        ),
                      ]),
                    ),
                    _buildSection(
                      label: '关于',
                      child: _card([
                        _arrowRow(title: '神经科学来源', onTap: () {}),
                        _divider(),
                        _arrowRow(title: '非临床免责声明', onTap: () {}),
                        _divider(),
                        _arrowRow(title: '隐私政策', onTap: () {}),
                        _divider(),
                        _arrowRow(title: '开源许可', onTap: () {}),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: _signOut,
                        borderRadius: BorderRadius.circular(kBorderRadiusPill),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(kColorSurface),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusPill),
                            border: Border.all(color: const Color(kColorBorder)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '退出登录',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(kColorTextPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'v1.0.0 · build 2026.05.16 · 清流',
                      textAlign: TextAlign.center,
                      style: AppTheme.monoLabel(
                        color: const Color(kColorTextMeta),
                        fontSize: 10,
                      ).copyWith(letterSpacing: 0.08),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Color(kColorTextPrimary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '设置',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(kColorTextPrimary),
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              label.toUpperCase(),
              style: AppTheme.monoLabel(
                color: const Color(kColorTextHint),
                fontSize: 11,
              ).copyWith(letterSpacing: 0.12),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _card(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(kColorSurface),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: const Color(kColorBorder)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color(kColorBorderSoft),
      ),
    );
  }

  Widget _accountCard() {
    return _card([
      Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFC96442), Color(0xFFD57A4F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '宇',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '小宇',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(kColorTextPrimary),
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '第 23 天 · 你还在。这就够了。',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(kColorTextHint),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _toggleRow({
    required String title,
    required String sub,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(kColorTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(kColorTextHint),
                    ),
                  ),
                ],
              ),
            ),
            _toggle(value: value),
          ],
        ),
      ),
    );
  }

  Widget _valueRow({
    required String title,
    required String sub,
    required String value,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(kColorTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(kColorTextHint),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(kColorTextSecondary),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: Color(kColorTextHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dangerRow({
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(kColorDanger),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(kColorTextHint),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: Color(kColorTextHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowRow({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(kColorTextPrimary),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: Color(kColorTextHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle({required bool value}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value
            ? const Color(kColorSuccess)
            : const Color(kColorBorder),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(kColorBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        title: Text(
          '删除所有数据？',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '这一步不可恢复。你的 23 天累计和所有记录都会消失。',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(kColorTextSecondary),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: GoogleFonts.inter(color: const Color(kColorTextSecondary)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '保留操作',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(kColorDanger),
            ),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(kColorBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        title: Text(
          '退出登录？',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '你随时可以回来。你的记录还在。',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(kColorTextSecondary),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: GoogleFonts.inter(color: const Color(kColorTextSecondary)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(kColorPrimary),
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}