import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'show_model.dart';

void main() => runApp(const PartStudioApp());

class PartStudioApp extends StatelessWidget {
  const PartStudioApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'P-A-R-T Studio', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: const Color(0xFF4F7E70), useMaterial3: true),
    home: const StudioHome(),
  );
}

class StudioHome extends StatefulWidget {
  const StudioHome({super.key});
  @override State<StudioHome> createState() => _StudioHomeState();
}
class _StudioHomeState extends State<StudioHome> {
  PartShow show = PartShow.demo();
  int selectedTab=0, selectedSlot=0, playhead=0;
  final Set<int> rehearsed={};
  final List<String> eventLog=[];
  List<ShowCue> get cues=>[for(final act in show.acts) for(final scene in act.scenes) ...scene.cues];

  void identify() {
    final slot=show.slots[selectedSlot];
    setState(()=>eventLog.insert(0,'SIMULATED identify: ${slot.label} (${slot.id}); no radio command sent.'));
    notice('Simulated: ${slot.label} — flash/beep. No hardware connected.');
  }
  void rehearse() {
    if(cues.isEmpty) return;
    final i=playhead;
    setState(() {
      rehearsed.add(i);
      eventLog.insert(0,'SIMULATED cue ${i+1}: ${cues[i].name}; ${cues[i].slotNumbers.length} logical receivers.');
      if(playhead<cues.length-1) playhead++;
    });
    notice('Rehearsal only: ${cues[i].name}');
  }
  void reset() => setState(() {
    playhead=0;rehearsed.clear();
    eventLog.insert(0,'Rehearsal playhead reset. Physical devices remain disarmed.');
  });
  void notice(String s)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s)));
  Future<void> exportShow() async {
    await Clipboard.setData(ClipboardData(text:show.exportJson()));
    if(mounted) notice('JSON show copied to clipboard (no pairing credentials).');
  }
  Future<void> importShow() async {
    final controller=TextEditingController();
    final raw=await showDialog<String>(context:context,builder:(ctx)=>AlertDialog(
      title:const Text('Import show JSON'),content:SizedBox(width:480,child:TextField(controller:controller,maxLines:9,
      decoration:const InputDecoration(hintText:'Paste previously exported show JSON'))),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancel')),
        FilledButton(onPressed:()=>Navigator.pop(ctx,controller.text),child:const Text('Import'))]));
    controller.dispose();
    if(raw==null) return;
    try {
      final imported=PartShow.importJson(raw);
      if(imported.slots.isEmpty) throw const FormatException('Show needs at least one slot');
      setState((){show=imported;selectedSlot=0;playhead=0;rehearsed.clear();eventLog.clear();});
      notice('Show imported. Devices must be freshly identified and verified.');
    } catch(e) {notice('Could not import: $e');}
  }

  @override Widget build(BuildContext context) {
    final tabs=[_layout(),_cueList(),_rehearsal()];
    return Scaffold(
      appBar: AppBar(title:const Text('P-A-R-T Studio'),actions:[
        IconButton(tooltip:'Copy show JSON',onPressed:exportShow,icon:const Icon(Icons.ios_share)),
        IconButton(tooltip:'Import show JSON',onPressed:importShow,icon:const Icon(Icons.file_open)),
      ]),
      body:SafeArea(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:1000),
        child:Column(children:[
          Container(width:double.infinity,color:Theme.of(context).colorScheme.surfaceContainer,
            padding:const EdgeInsets.all(12),child:const Text('OFFLINE REHEARSAL • NO LIVE DEVICES OR HEATER OUTPUT',textAlign:TextAlign.center)),
          Padding(padding:const EdgeInsets.all(12),child:TextField(
            controller:TextEditingController(text:show.name),
            decoration:const InputDecoration(labelText:'Production name',border:OutlineInputBorder()),
            onSubmitted:(v)=>setState(()=>show.name=v.trim().isEmpty?show.name:v.trim()),
          )),
          Expanded(child:tabs[selectedTab]),
        ])))),
      bottomNavigationBar:NavigationBar(selectedIndex:selectedTab,onDestinationSelected:(i)=>setState(()=>selectedTab=i),
        destinations:const [NavigationDestination(icon:Icon(Icons.map),label:'Room'),
          NavigationDestination(icon:Icon(Icons.list_alt),label:'Cues'),
          NavigationDestination(icon:Icon(Icons.play_circle),label:'Rehearsal')]),
    );
  }

  Widget _layout()=>ListView(padding:const EdgeInsets.all(16),children:[
    Text('Room: ${show.widthFeet.toStringAsFixed(0)} × ${show.depthFeet.toStringAsFixed(0)} ft',
      style:Theme.of(context).textTheme.titleMedium),
    const SizedBox(height:10),
    AspectRatio(aspectRatio:1.5,child:LayoutBuilder(builder:(ctx,b)=>Stack(children:[
      Container(decoration:BoxDecoration(border:Border.all(color:Colors.grey),borderRadius:BorderRadius.circular(12))),
      ...show.slots.asMap().entries.map((entry){
        final i=entry.key,s=entry.value;
        return Positioned(left:s.x*(b.maxWidth-48),top:s.y*(b.maxHeight-48),
          child:Semantics(button:true,label:'Select ${s.label}',
            child:ChoiceChip(selected:selectedSlot==i,label:Text('${i+1}'),
            onSelected:(_)=>setState(()=>selectedSlot=i))));
      }),
    ]))),
    const SizedBox(height:12),
    Text('Selected: ${show.slots[selectedSlot].label}',style:Theme.of(context).textTheme.titleMedium),
    const SizedBox(height:8),
    Wrap(spacing:8,children:[
      FilledButton.icon(onPressed:identify,icon:const Icon(Icons.sensors),label:const Text('Test identify')),
      OutlinedButton.icon(onPressed:()=>setState((){
        final n=show.slots.length+1;
        show.slots.add(BalloonSlot('slot-$n','Balloon $n',0.5,0.5));
        selectedSlot=n-1;
      }),icon:const Icon(Icons.add),label:const Text('Add slot')),
    ]),
    const SizedBox(height:12),
    const Text('Select a numbered position. Identification is simulated; no radio or physical output exists.'),
  ]);

  Widget _cueList()=>ListView(padding:const EdgeInsets.all(14),children:[
    for(final act in show.acts) ExpansionTile(title:Text(act.name),initiallyExpanded:true,
      children:[for(final scene in act.scenes) ExpansionTile(title:Text(scene.name),initiallyExpanded:true,
        children:[for(final cue in scene.cues) ListTile(
          leading:const Icon(Icons.theater_comedy_outlined),title:Text(cue.name),
          subtitle:Text('Slots: ${cue.slotNumbers.join(", ")} · step interval ${cue.delayMs} ms'),
        )])]),
    const SizedBox(height:16),
    const Text('Act/scene/cue structure is editable in exported JSON in this first milestone. Visual editing follows.'),
  ]);

  Widget _rehearsal()=>ListView(padding:const EdgeInsets.all(16),children:[
    Text('Cue ${cues.isEmpty?0:playhead+1} of ${cues.length}',style:Theme.of(context).textTheme.titleMedium),
    const SizedBox(height:10),
    if(cues.isNotEmpty) Card(child:ListTile(title:Text(cues[playhead].name),
      subtitle:Text('${cues[playhead].slotNumbers.length} simulated device slots'),
      trailing:Icon(rehearsed.contains(playhead)?Icons.check_circle:Icons.radio_button_unchecked))),
    const SizedBox(height:12),
    Wrap(spacing:10,runSpacing:8,children:[
      FilledButton.icon(onPressed:cues.isEmpty?null:rehearse,icon:const Icon(Icons.play_arrow),label:const Text('Simulate GO')),
      OutlinedButton.icon(onPressed:reset,icon:const Icon(Icons.restart_alt),label:const Text('Reset to beginning')),
      OutlinedButton(onPressed:cues.isEmpty?null:()=>setState(()=>playhead=(playhead+1)%cues.length),child:const Text('Next cue')),
    ]),
    const SizedBox(height:14),const Text('Rehearsal log',style:TextStyle(fontWeight:FontWeight.bold)),
    for(final e in eventLog) ListTile(dense:true,leading:const Icon(Icons.history),title:Text(e)),
    if(eventLog.isEmpty) const Text('No simulated cues yet.'),
  ]);
}
