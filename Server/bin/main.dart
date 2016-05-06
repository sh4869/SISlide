import 'dart:io';

WebSocket ws;

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 9500).then((server) {
    server.listen((HttpRequest request) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then((socket) {
          ws = socket;
          handleWebSocket(ws);
        });
      } else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        handleHttpRequest(request);
      }
    });
  });
}

void handleWebSocket(WebSocket socket) {
  print('Client connected!');
  socket.listen((String s) {
    print('Client sent: $s');
    socket.add('echo: $s');
  }, onDone: () {
    print('Client disconnected');
  });
}

void handleHttpRequest(HttpRequest request) {
  if (ws != null) {
    ws.add("right");
  }
  request.response.reasonPhrase = "Connect!";
  request.response.close();
}
