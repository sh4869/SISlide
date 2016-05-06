import 'dart:io';
import 'package:route/server.dart';

WebSocket ws;

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 9500).then((server) {
    print("Server Start");
    var router = new Router(server)
      ..serve("/ws").listen((HttpRequest request) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then((socket) {
            ws = socket;
            handleWebSocket(ws);
          });
        }
      })
      ..serve("/right").listen(handleRightRequest)
      ..serve("/left").listen(handleLeftRequest);
  });
}

void handleWebSocket(WebSocket socket) {
  print('Client connected!');
  socket.listen((String s) {});
}

void handleRightRequest(HttpRequest request) {
  print("Right Request");
  ws?.add("right");
  request.response.reasonPhrase = "Connect Right";
  request.response.close();
}

void handleLeftRequest(HttpRequest request) {
  print("Left Request");
  ws?.add("left");
  request.response.reasonPhrase = "Connect Left";
  request.response.close();
}
