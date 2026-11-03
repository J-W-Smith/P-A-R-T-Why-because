import 'dart:convert';

/// Portable, logical show template; never contains credentials or hardware arm state.
class PartShow {
  PartShow({required this.name, required this.widthFeet, required this.depthFeet,
    required this.slots, required this.acts});
  String name;
  double widthFeet;
  double depthFeet;
  final List<BalloonSlot> slots;
  final List<ShowAct> acts;

  factory PartShow.demo() => PartShow(
    name: 'The Enchanted Ball', widthFeet: 40, depthFeet: 60,
    slots: List.generate(8, (i) => BalloonSlot('slot-${i + 1}', 'Balloon ${i + 1}', (i % 4 + 1) / 5, (i ~/ 4 + 1) / 3)),
    acts: [ShowAct('Act 1 — Arrival', [
      ShowScene('Opening Reveal', [ShowCue('Center Pair', [3, 4], 0), ShowCue('Wave', [1,2,3,4,5,6,7,8], 350)]),
      ShowScene('Celebration', [ShowCue('All Lights', [1,2,3,4,5,6,7,8], 0)]),
    ]), ShowAct('Act 2 — Finale', [ShowScene('Finale', [ShowCue('Final Chase', [8,7,6,5,4,3,2,1], 500)])])],
  );

  Map<String, dynamic> toJson() => {
    'schemaVersion': 1, 'name': name, 'widthFeet': widthFeet, 'depthFeet': depthFeet,
    'slots': slots.map((s) => s.toJson()).toList(),
    'acts': acts.map((a) => a.toJson()).toList(),
  };
  String exportJson() => const JsonEncoder.withIndent('  ').convert(toJson());
  factory PartShow.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) throw const FormatException('Unsupported show version');
    final slots = (json['slots'] as List).map((x) => BalloonSlot.fromJson(Map<String,dynamic>.from(x as Map))).toList();
    final acts = (json['acts'] as List).map((x) => ShowAct.fromJson(Map<String,dynamic>.from(x as Map))).toList();
    if (slots.length > 256 || acts.length > 100) throw const FormatException('Show exceeds safety limits');
    return PartShow(name: (json['name'] as String), widthFeet: (json['widthFeet'] as num).toDouble(),
      depthFeet: (json['depthFeet'] as num).toDouble(), slots: slots, acts: acts);
  }
  static PartShow importJson(String content) => PartShow.fromJson(Map<String,dynamic>.from(jsonDecode(content) as Map));
}

class BalloonSlot {
  BalloonSlot(this.id, this.label, this.x, this.y);
  final String id;
  String label;
  double x, y; // normalized position in venue layout
  Map<String,dynamic> toJson() => {'id':id,'label':label,'x':x,'y':y};
  factory BalloonSlot.fromJson(Map<String,dynamic> j) {
    final x=(j['x'] as num).toDouble(), y=(j['y'] as num).toDouble();
    if (x<0 || x>1 || y<0 || y>1) throw const FormatException('Invalid position');
    return BalloonSlot(j['id'] as String,j['label'] as String,x,y);
  }
}
class ShowCue {
  ShowCue(this.name, this.slotNumbers, this.delayMs);
  String name;
  final List<int> slotNumbers;
  int delayMs;
  Map<String,dynamic> toJson()=>{'name':name,'slots':slotNumbers,'delayMs':delayMs};
  factory ShowCue.fromJson(Map<String,dynamic> j) => ShowCue(j['name'] as String,List<int>.from(j['slots'] as List),j['delayMs'] as int);
}
class ShowScene {
  ShowScene(this.name,this.cues);
  String name;
  final List<ShowCue> cues;
  Map<String,dynamic> toJson()=>{'name':name,'cues':cues.map((c)=>c.toJson()).toList()};
  factory ShowScene.fromJson(Map<String,dynamic> j)=>ShowScene(j['name'] as String,(j['cues'] as List).map((c)=>ShowCue.fromJson(Map<String,dynamic>.from(c as Map))).toList());
}
class ShowAct {
  ShowAct(this.name,this.scenes);
  String name;
  final List<ShowScene> scenes;
  Map<String,dynamic> toJson()=>{'name':name,'scenes':scenes.map((s)=>s.toJson()).toList()};
  factory ShowAct.fromJson(Map<String,dynamic> j)=>ShowAct(j['name'] as String,(j['scenes'] as List).map((s)=>ShowScene.fromJson(Map<String,dynamic>.from(s as Map))).toList());
}
