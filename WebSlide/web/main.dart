// Copyright (c) 2016, sh4869. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:presentation/presentation.dart';
import 'package:WebSlide/md2slide.dart';

String markdownSource = """
# プレプロ発表

### 情報工学科 AL16030 笠井信宏
@@@
## 目次
##### 1.制作物紹介
##### 2.自己紹介
@@@
## 1.制作物紹介
@@@
### もうお気づきかと思いますが、
@@@
## 制作物は
@@@
# これです。
@@@
# 制作物
## このスライド
@@@
## 技術的な話 1
このスライド自体はライブラリを利用

(僕が一から全部作ったわけではない)
@@@
## 技術的な話 2

操作コントローラーとしてAndroidアプリを作成
@@@
## 詳しいことは

新歓とか休憩の時に聞いてくださいヽ(^_^)ノ
""";

WebSocket ws;

int count = 1;
int maxCount;

void main() {
  List<List<num>> spi = [
    [1500, 0, 0, 0, 0, 0],
    [3000, 0, 0, 0, 0, 0],
    [4500, 0, 0, 0, 0, 0],
    [6000, 0, 0, 0, 0, 0],
    [7000, 0, 1000, 90, 0, 0],
    [6000, 0, 2000, 180, 0, 0],
    [6000, -300, 1800, 0, -90, 90],
    [6000, 0, 1200, 0, 0, 90],
    [7000, 500, 0, 30, 90, 90],
    [7000, 500, 500, -30, 180, -90]
  ];
  List<HtmlElement> elements = MDConverter.convertMarkdown(markdownSource);
  maxCount = elements.length;
  var presentation = new BasicSlideShow(querySelector("#render"));
  int x = 0;
  for (Element ele in elements) {
    presentation.addElementSlide(ele, 1.0, spi[x][0], spi[x][1], spi[x][2],
        spi[x][3], spi[x][4], spi[x][5]);
    x += 1;
  }

  presentation.start();
  ws = new WebSocket("ws://localhost:9500");

  ws.onMessage.listen((MessageEvent e) {
    if (e.data == "right") {
      presentation.next();
      updatePageCount(true);
    } else if (e.data == "left") {
      presentation.previous();
      updatePageCount(false);
    }
  });

  // Handle key events.
  document.onKeyDown.listen((KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.LEFT:
        presentation.previous();
        updatePageCount(false);
        break;
      case KeyCode.RIGHT:
        presentation.next();
        updatePageCount(true);
        break;
    }
    window.scrollTo(0, 0);
  });
}

void updatePageCount(bool up) {
  if (up) {
    if (maxCount == count) {
      count = 1;
    } else {
      count++;
    }
  } else {
    if (count == 1) {
      count = maxCount;
    } else {
      count--;
    }
  }
  querySelector("#count").text = count.toString();
}
