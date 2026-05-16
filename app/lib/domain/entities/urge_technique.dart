/// Urge technique entity
/// Represents one of the 11 neuroscience-backed urge interruption techniques
class UrgeTechnique {
  final String id;
  final String name;
  final String nameEn;
  final String neuralMechanism;  // one-line science explanation
  final String instruction;       // step-by-step guide
  final int durationSeconds;
  final String keyMechanism;
  final String icon;  // emoji or icon name
  final bool isRecommended;

  const UrgeTechnique({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.neuralMechanism,
    required this.instruction,
    required this.durationSeconds,
    required this.keyMechanism,
    required this.icon,
    this.isRecommended = false,
  });

  /// All 11 techniques defined in PRD
  static const List<UrgeTechnique> all = [
    UrgeTechnique(
      id: 'T1',
      name: '冷水洗30秒脸',
      nameEn: 'Cold Water Face Wash',
      neuralMechanism: '冷水激活哺乳动物潜水反射，5秒内接管皮质决策区',
      instruction: 'Step 1: 打开冷水龙头到最大\nStep 2: 将脸浸入冷水，停留30秒\nStep 3: 完成后来回走动，深呼吸3次',
      durationSeconds: 30,
      keyMechanism: '迷走神经激活',
      icon: '💧',
      isRecommended: true,
    ),
    UrgeTechnique(
      id: 'T2',
      name: '20个深蹲打断它',
      nameEn: 'Burst Exercise',
      neuralMechanism: '肾上腺素飙升清空多巴胺库存，给爬行脑一个物理出口',
      instruction: 'Step 1: 双脚与肩同宽站立\nStep 2: 快速下蹲，起身，重复20次\nStep 3: 如条件允许，原地冲刺15秒',
      durationSeconds: 45,
      keyMechanism: '肾上腺素-多巴胺拮抗',
      icon: '🏋️',
    ),
    UrgeTechnique(
      id: 'T3',
      name: '强薄荷味觉打断',
      nameEn: 'Strong Mint Sensory Override',
      neuralMechanism: '强烈感官刺激强制重启注意力锚点',
      instruction: 'Step 1: 含一口强薄荷糖或用薄荷牙膏\nStep 2: 感受强烈的清凉感充满口腔\nStep 3: 这种感觉会覆盖渴求信号',
      durationSeconds: 10,
      keyMechanism: '三叉神经强烈激活',
      icon: '🌿',
    ),
    UrgeTechnique(
      id: 'T4',
      name: '90秒呼吸重启',
      nameEn: '90-sec Breathing Reset',
      neuralMechanism: '延长呼气激活副交感神经，消退渴求高峰',
      instruction: 'Step 1: 深吸气4秒\nStep 2: 屏息2秒\nStep 3: 缓慢呼气15秒\nStep 4: 重复上述6轮（共90秒）',
      durationSeconds: 90,
      keyMechanism: '副交感神经激活',
      icon: '🌬️',
    ),
    UrgeTechnique(
      id: 'T5',
      name: '感官接地54321',
      nameEn: 'Sensory Grounding 5-4-3-2-1',
      neuralMechanism: '强制重启前额叶，覆盖自动化奖赏回路',
      instruction: '说出5件你能看见的东西\n说出4件你能触摸的东西\n说出3件你能听见的声音\n说出2件你能闻到的气味\n说出1件你能尝到的味道',
      durationSeconds: 60,
      keyMechanism: '前额叶重启',
      icon: '🧘',
    ),
    UrgeTechnique(
      id: 'T6',
      name: '冷热交替',
      nameEn: 'Cold-Hot Alternating',
      neuralMechanism: '血管收缩扩张节律激活副交感交替',
      instruction: 'Step 1: 冷水冲洗30秒\nStep 2: 切换热水30秒\nStep 3: 再冷水30秒结束',
      durationSeconds: 90,
      keyMechanism: '血管舒缩振荡',
      icon: '🚿',
    ),
    UrgeTechnique(
      id: 'T7',
      name: '冰敷后颈',
      nameEn: 'Ice Pack Neck Application',
      neuralMechanism: '脊髓背根神经冷受体强烈激活，产生镇静效应',
      instruction: 'Step 1: 用冰袋或冰水瓶\nStep 2: 敷在后颈中部\nStep 3: 30秒，间隔10秒，共3次',
      durationSeconds: 120,
      keyMechanism: '冷受体下行抑制',
      icon: '🧊',
    ),
    UrgeTechnique(
      id: 'T8',
      name: '屏息冲刺',
      nameEn: 'Breath-Hold Sprint',
      neuralMechanism: '短暂缺氧触发应急保护，清空多巴胺池',
      instruction: 'Step 1: 深吸一口气\nStep 2: 原地全力冲刺20米\nStep 3: 深呼吸3次\nStep 4: 重复一次',
      durationSeconds: 60,
      keyMechanism: '缺氧-再氧化神经递质重置',
      icon: '⚡',
    ),
    UrgeTechnique(
      id: 'T9',
      name: '冷水浸泡手腕',
      nameEn: 'Cold Water Wrist Soak',
      neuralMechanism: '尺侧腕部冷受体密集，激活迷走神经',
      instruction: 'Step 1: 准备一盆冷水（可加冰块）\nStep 2: 将两侧手腕浸入水中\nStep 3: 保持60秒',
      durationSeconds: 60,
      keyMechanism: '局部冷刺激迷走神经',
      icon: '👐',
    ),
    UrgeTechnique(
      id: 'T10',
      name: '强震感换场',
      nameEn: 'Strong Vibration Switch',
      neuralMechanism: '强烈触觉激活脊髓门控，覆盖奖赏回路信号',
      instruction: 'Step 1: 用力捏大腿外侧3次（疼痛阈值以下）\n或：使用握力球/减压玩具\nStep 2: 感受强烈的触觉存在感',
      durationSeconds: 10,
      keyMechanism: '脊髓上行门控',
      icon: '🔴',
    ),
    UrgeTechnique(
      id: 'T11',
      name: '冷水洗脸+自我对话',
      nameEn: 'Cold Wash + Self-Dialogue',
      neuralMechanism: '冷激活+认知解离协同，双重打断',
      instruction: 'Step 1: 冷水洗完脸后\nStep 2: 对着镜子说：\n"这只是多巴胺在作祟，\n90秒后我会更好"\nStep 3: 感受冷水带来的清醒感',
      durationSeconds: 45,
      keyMechanism: '冷激活+认知解离',
      icon: '🪞',
    ),
  ];

  static UrgeTechnique? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}