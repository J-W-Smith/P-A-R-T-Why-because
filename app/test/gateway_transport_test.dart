import 'package:flutter_test/flutter_test.dart';
import 'package:part_studio/gateway_transport.dart';

void main() {
  test('offline-safe gateway rejects requests before connection',() async {
    final gateway=SimulatedGateway([const NodeStatus('node-1','Balloon 1',NodeHealth.online)]);
    await expectLater(gateway.identify('node-1'),throwsStateError);
    await expectLater(gateway.discover(),throwsStateError);
  });
  test('identify succeeds only for discovered online immutable IDs',() async {
    final gateway=SimulatedGateway([
      const NodeStatus('node-1','Balloon 1',NodeHealth.online,batteryPercent:90),
      const NodeStatus('node-2','Balloon 2',NodeHealth.offline),
    ]);
    await gateway.connect();
    expect((await gateway.discover()).length,2);
    expect(await gateway.identify('node-1'),isTrue);
    expect(await gateway.identify('node-2'),isFalse);
    expect(await gateway.identify('spoof'),isFalse);
    expect(gateway.identifyLog,['node-1']);
    await gateway.disconnect();
    await expectLater(gateway.identify('node-1'),throwsStateError);
  });
}
