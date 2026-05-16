import 'package:flutter/material.dart';

class UrgeTechnique {
  final String id;
  final String name;
  final String nameEn;
  final String neuralMechanism;
  final String instruction;
  final int durationSeconds;
  final String keyMechanism;
  final IconData icon;
  final Color iconColor;
  final bool isRecommended;
  final int displayPriority;
  final int recommendedUrgeLevel; // 1-10, best for this urge level
  final int minUrgeLevel;         // minimum urge level suitable
  final int maxUrgeLevel;         // maximum urge level suitable

  const UrgeTechnique({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.neuralMechanism,
    required this.instruction,
    required this.durationSeconds,
    required this.keyMechanism,
    required this.icon,
    this.iconColor = const Color(0xFF0077B6),
    this.isRecommended = false,
    this.displayPriority = 99,
    this.recommendedUrgeLevel = 5,
    this.minUrgeLevel = 1,
    this.maxUrgeLevel = 10,
  });

  static List<UrgeTechnique> getSortedForUrgeLevel(int urgeLevel) {
    final all = List<UrgeTechnique>.from(allTechniques);
    all.sort((a, b) {
      // First priority: techniques specifically recommended for this urge level
      final aScore = _getUrgencyScore(a, urgeLevel);
      final bScore = _getUrgencyScore(b, urgeLevel);
      if (aScore != bScore) return bScore.compareTo(aScore);
      // Second priority: display order
      return a.displayPriority.compareTo(b.displayPriority);
    });
    return all;
  }

  static int _getUrgencyScore(UrgeTechnique tech, int urgeLevel) {
    int score = 100 - tech.displayPriority;
    if (urgeLevel >= tech.minUrgeLevel && urgeLevel <= tech.maxUrgeLevel) {
      score += 50;
      if (tech.recommendedUrgeLevel == urgeLevel) {
        score += 30;
      } else {
        final distance = (tech.recommendedUrgeLevel - urgeLevel).abs();
        score -= distance * 3;
      }
    } else {
      score -= 100;
    }
    return score;
  }

  static List<UrgeTechnique> get allTechniques => _allTechniques;
  static const List<UrgeTechnique> _allTechniques = [
    UrgeTechnique(
      id: 'T11',
      name: '冷水洗脸+自我对话',
      nameEn: 'Cold Wash + Self-Talk',
      neuralMechanism: '冷激活+认知解离协同，双重打断',
      instruction: 'Step 1: 冷水洗完脸后\nStep 2: 对着镜子说：\n"这只是神经习惯的回响，不是我的本质"\n"90秒后这个渴望会自然衰减"\n"我选择给前额叶一个机会"\nStep 3: 感受冷水带来的清醒感',
      durationSeconds: 45,
      keyMechanism: '冷激活+认知解离',
      icon: Icons.water_drop,
      iconColor: Color(0xFF00D4AA),
      isRecommended: true,
      displayPriority: 1,
      recommendedUrgeLevel: 7,
      minUrgeLevel: 5,
      maxUrgeLevel: 10,
    ),
    UrgeTechnique(
      id: 'T4',
      name: '90秒呼吸法',
      nameEn: '90-sec Breathing',
      neuralMechanism: '延长呼气激活副交感神经，消退渴求高峰',
      instruction: 'Step 1: 深吸气4秒\nStep 2: 屏息2秒\nStep 3: 缓慢呼气15秒\nStep 4: 重复上述6轮（共90秒）',
      durationSeconds: 90,
      keyMechanism: '副交感神经激活',
      icon: Icons.air,
      iconColor: Color(0xFF0077B6),
      isRecommended: true,
      displayPriority: 2,
      recommendedUrgeLevel: 6,
      minUrgeLevel: 3,
      maxUrgeLevel: 10,
    ),
    UrgeTechnique(
      id: 'T5',
      name: '感官接地54321',
      nameEn: '5-4-3-2-1 Grounding',
      neuralMechanism: '强制重启前额叶，覆盖自动化奖赏回路',
      instruction: '说出5件你能看见的东西\n说出4件你能触摸的东西\n说出3件你能听见的声音\n说出2件你能闻到的气味\n说出1件你能尝到的味道',
      durationSeconds: 60,
      keyMechanism: '前额叶重启',
      icon: Icons.visibility,
      iconColor: Color(0xFF5C6B73),
      isRecommended: true,
      displayPriority: 3,
      recommendedUrgeLevel: 5,
      minUrgeLevel: 2,
      maxUrgeLevel: 8,
    ),
    UrgeTechnique(
      id: 'T1',
      name: '冷水洗30秒脸',
      nameEn: 'Cold Water Face Wash',
      neuralMechanism: '冷水激活哺乳动物潜水反射，5秒内接管皮质决策区',
      instruction: 'Step 1: 打开冷水龙头到最大\nStep 2: 将脸浸入冷水，停留30秒\nStep 3: 完成后来回走动，深呼吸3次',
      durationSeconds: 30,
      keyMechanism: '迷走神经激活',
      icon: Icons.water,
      iconColor: Color(0xFF00B4D8),
      isRecommended: true,
      displayPriority: 4,
      recommendedUrgeLevel: 6,
      minUrgeLevel: 4,
      maxUrgeLevel: 10,
    ),
    UrgeTechnique(
      id: 'T2',
      name: '20个深蹲打断它',
      nameEn: 'Burst Exercise',
      neuralMechanism: '急性运动→前额叶激活→抑制性控制增强',
      instruction: 'Step 1: 双脚与肩同宽站立\nStep 2: 快速下蹲，起身，重复20次\nStep 3: 如条件允许，原地冲刺15秒',
      durationSeconds: 45,
      keyMechanism: '前额叶激活',
      icon: Icons.fitness_center,
      iconColor: Color(0xFFFF6B6B),
      displayPriority: 5,
      recommendedUrgeLevel: 4,
      minUrgeLevel: 2,
      maxUrgeLevel: 7,
    ),
    UrgeTechnique(
      id: 'T6',
      name: '冷热交替浴',
      nameEn: 'Cold-Hot Alternating',
      neuralMechanism: '血管收缩扩张节律激活副交感交替',
      instruction: 'Step 1: 冷水冲洗30秒\nStep 2: 切换热水30秒\nStep 3: 再冷水30秒结束',
      durationSeconds: 90,
      keyMechanism: '血管舒缩振荡',
      icon: Icons.thermostat,
      iconColor: Color(0xFF667EEA),
      displayPriority: 6,
      recommendedUrgeLevel: 7,
      minUrgeLevel: 5,
      maxUrgeLevel: 10,
    ),
    UrgeTechnique(
      id: 'T3',
      name: '强薄荷味觉打断',
      nameEn: 'Strong Mint',
      neuralMechanism: '强烈感官刺激强制重启注意力锚点',
      instruction: 'Step 1: 含一口强薄荷糖或用薄荷牙膏\nStep 2: 感受强烈的清凉感充满口腔\nStep 3: 这种感觉会覆盖渴求信号',
      durationSeconds: 10,
      keyMechanism: '三叉神经强烈激活',
      icon: Icons.spa,
      iconColor: Color(0xFF88D8B0),
      displayPriority: 7,
      recommendedUrgeLevel: 3,
      minUrgeLevel: 1,
      maxUrgeLevel: 5,
    ),
    UrgeTechnique(
      id: 'T9',
      name: '冷水浸泡手腕',
      nameEn: 'Cold Wrist Soak',
      neuralMechanism: '尺侧腕部冷受体密集，激活迷走神经',
      instruction: 'Step 1: 准备一盆冷水（可加冰块）\nStep 2: 将两侧手腕浸入水中\nStep 3: 保持60秒',
      durationSeconds: 60,
      keyMechanism: '局部冷刺激迷走神经',
      icon: Icons.pan_tool,
      iconColor: Color(0xFF00B4D8),
      displayPriority: 8,
      recommendedUrgeLevel: 5,
      minUrgeLevel: 3,
      maxUrgeLevel: 8,
    ),
    UrgeTechnique(
      id: 'T7',
      name: '冰敷后颈',
      nameEn: 'Ice Pack Neck',
      neuralMechanism: '脊髓背根神经冷受体强烈激活，产生镇静效应',
      instruction: 'Step 1: 用冰袋或冰水瓶\nStep 2: 敷在后颈中部\nStep 3: 30秒，间隔10秒，共3次',
      durationSeconds: 120,
      keyMechanism: '冷受体下行抑制',
      icon: Icons.ac_unit,
      iconColor: Color(0xFF5C6B73),
      displayPriority: 9,
      recommendedUrgeLevel: 6,
      minUrgeLevel: 4,
      maxUrgeLevel: 9,
    ),
    UrgeTechnique(
      id: 'T8',
      name: '屏息冲刺',
      nameEn: 'Breath-Hold Sprint',
      neuralMechanism: '短暂缺氧触发应急保护，清空多巴胺池',
      instruction: 'Step 1: 深吸一口气\nStep 2: 原地全力冲刺20米\nStep 3: 深呼吸3次\nStep 4: 重复一次',
      durationSeconds: 60,
      keyMechanism: '缺氧-再氧化神经递质重置',
      icon: Icons.directions_run,
      iconColor: Color(0xFFFF9800),
      displayPriority: 10,
      recommendedUrgeLevel: 8,
      minUrgeLevel: 6,
      maxUrgeLevel: 10,
    ),
    UrgeTechnique(
      id: 'T10',
      name: '强震感换场（实验性）',
      nameEn: 'Strong Vibration',
      neuralMechanism: '强烈触觉激活脊髓门控，覆盖奖赏回路信号（无RCT证据）',
      instruction: 'Step 1: 用力捏大腿外侧3次（疼痛阈值以下）\n或：使用握力球/减压玩具\nStep 2: 感受强烈的触觉存在感',
      durationSeconds: 10,
      keyMechanism: '脊髓上行门控',
      icon: Icons.vibration,
      iconColor: Color(0xFF9E9E9E),
      displayPriority: 11,
      recommendedUrgeLevel: 4,
      minUrgeLevel: 2,
      maxUrgeLevel: 7,
    ),
  ];

  static UrgeTechnique? getById(String id) {
    try {
      return _allTechniques.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}