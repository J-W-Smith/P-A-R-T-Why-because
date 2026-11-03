import 'package:flutter_test/flutter_test.dart';
import 'package:part_studio/show_model.dart';

void main() {
  test('demo show survives export/import with acts and cues', () {
    final original=PartShow.demo();
    final roundTrip=PartShow.importJson(original.exportJson());
    expect(roundTrip.name,original.name);
    expect(roundTrip.slots.length,8);
    expect(roundTrip.acts.length,2);
    expect(roundTrip.acts.first.scenes.first.cues.first.name,'Center Pair');
  });
  test('reject incompatible schema', () {
    final contents=PartShow.demo().toJson();
    contents['schemaVersion']=99;
    expect(()=>PartShow.fromJson(contents),throwsFormatException);
  });
  test('reject positions outside venue', () {
    final contents=PartShow.demo().toJson();
    (contents['slots'] as List).first['x']=4.0;
    expect(()=>PartShow.fromJson(contents),throwsFormatException);
  });
  test('show format never includes physical arming or OAuth secrets', () {
    final json=PartShow.demo().exportJson().toLowerCase();
    expect(json.contains('token'),isFalse);
    expect(json.contains('armed'),isFalse);
    expect(json.contains('privatekey'),isFalse);
  });
}
