import 'dart:async';

/// Hardware-independent protocol contract.
///
/// The V1 API intentionally has NO effect activation method.
/// Bluetooth implementations must preserve this restriction until independent
/// safety engineering and product design review.
enum NodeHealth { online, offline, unknown }
class NodeStatus {
  const NodeStatus(this.id,this.label,this.health,{this.batteryPercent});
  final String id,label;
  final NodeHealth health;
  final int? batteryPercent;
}
abstract class GatewayTransport {
  Future<void> connect();
  Future<void> disconnect();
  Future<List<NodeStatus>> discover();
  /// Hardware-safe request to blink/beep. Cannot enable a thermal output.
  Future<bool> identify(String immutableNodeId);
  Future<void> close();
}

/// Deterministic offline simulation used by the app before BLE integration.
class SimulatedGateway implements GatewayTransport {
  SimulatedGateway(this._nodes);
  final List<NodeStatus> _nodes;
  bool _connected=false;
  final List<String> identifyLog=[];
  bool get connected=>_connected;
  @override Future<void> connect() async { _connected=true; }
  @override Future<void> disconnect() async { _connected=false; }
  @override Future<List<NodeStatus>> discover() async {
    if(!_connected) throw StateError('Gateway disconnected');
    return List.unmodifiable(_nodes);
  }
  @override Future<bool> identify(String immutableNodeId) async {
    if(!_connected) throw StateError('Gateway disconnected');
    final found=_nodes.any((n)=>n.id==immutableNodeId&&n.health==NodeHealth.online);
    if(found) identifyLog.add(immutableNodeId);
    return found;
  }
  @override Future<void> close() => disconnect();
}
