import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:typed_data';
import 'dart:async';

class WebSocketMessage {
  final int errorCode;
  final int cmd;
  final int length;
  final Uint8List data;

  WebSocketMessage({
    required this.errorCode,
    required this.cmd,
    required this.length,
    required this.data,
  });
}

class WebSocketNotifier extends ChangeNotifier {
  late WebSocketChannel _channel;
  final List<WebSocketMessage> _messages = [];
  List<WebSocketMessage> get messages => _messages;

  late StreamSubscription _subscription;
  bool _isReconnecting = false;

  WebSocketNotifier() {
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://wap-v101-gtmservice.rosetts.com/ws/fruit?session_id=6671446771c1d0000b0137e3'),
      // Uri.parse('ws://127.0.0.1:8080'),
    );

    _subscription = _channel.stream.listen(
      (message) {
        if (message is List<int>) {
          Uint8List data = Uint8List.fromList(message);
          WebSocketMessage parsedMessage = _parseMessage(data);
          if (parsedMessage.errorCode == 0) {
            _messages.add(parsedMessage);
          } else {
            print("error code: ${parsedMessage.errorCode}");
          }
        }
        notifyListeners();
      },
      onDone: _onDone,
      onError: _onError,
    );
  }

  void _onDone() {
    print("onDone");
    if (!_isReconnecting) {
      _reconnect();
    }
  }

  void _onError(error) {
    print("onError");
    if (!_isReconnecting) {
      _reconnect();
    }
  }

  void _reconnect() {
    _isReconnecting = true;
    Future.delayed(Duration(seconds: 5), () {
      _isReconnecting = false;
      _connect();
    });
  }

  void sendMessage(Uint8List data, int errorCode, int cmd) {
    ByteData header = ByteData(6);
    header.setUint16(0, errorCode, Endian.big);
    header.setUint16(2, cmd, Endian.big);
    header.setUint16(4, data.length, Endian.big);

    Uint8List messageBytes = Uint8List(header.lengthInBytes + data.length);
    messageBytes.setRange(0, header.lengthInBytes, header.buffer.asUint8List());
    messageBytes.setRange(header.lengthInBytes, messageBytes.length, data);
    print("send message: $messageBytes");
    _channel.sink.add(messageBytes);
  }

  WebSocketMessage _parseMessage(Uint8List data) {
    if (data.length < 6) {
      throw Exception('Invalid data length');
    }

    ByteData byteData = ByteData.sublistView(data);
    int errorCode = byteData.getUint16(0, Endian.big);
    int cmd = byteData.getUint16(2, Endian.big);
    int length = byteData.getUint16(4, Endian.big);

    return WebSocketMessage(
      errorCode: errorCode,
      cmd: cmd,
      length: length,
      data: data.sublist(6),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _channel.sink.close(status.goingAway);
    super.dispose();
  }
}

final webSocketProvider = ChangeNotifierProvider<WebSocketNotifier>((ref) {
  return WebSocketNotifier();
});
