// Copyright (c) 2016, sh4869. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:presentation/presentation.dart';
import 'package:WebSlide/md2slide.dart';

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
    [7000,500,0,30,90,90],
    [7000,500,500,-30,180,-90]
  ];
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
  List<HtmlElement> elements = MDConverter.convertMarkdown(markdownSource);
  int maxCount = elements.length;
  var presentation = new BasicSlideShow(querySelector("#render"));
  int x = 0;
  for (Element ele in elements) {
    presentation.addElementSlide(ele, 1.0, spi[x][0], spi[x][1], spi[x][2],
        spi[x][3], spi[x][4], spi[x][5]);
    x += 1;
  }
  /*
  presentation.addHtmlSlide("面白い", 1.0, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
  presentation.addHtmlSlide("良い", 1.0, 0.0, 0.0, -3000.0, 0.0, 0.0, 0.0);
  presentation.addHtmlSlide("最高", 1.0, 0, 0.0, 0.0, 0.0, 90.0, 0.0);
  presentation.addHtmlSlide("優勝", 1.0, 1500.0, 0.0, 0.0, 90.0, 0.0, 0.0);
  presentation.addHtmlSlide("尊い…", 1.0, 0.0, -200.0, 2000.0, 90.0, 90.0, 90.0);
  */
  presentation.start();

  // Handle key events.
  int count = 1;
  document.onKeyDown.listen((KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.LEFT:
        presentation.previous();
        if (count == 1) {
          count = maxCount;
        } else {
          count--;
        }
        break;
      case KeyCode.RIGHT:
        presentation.next();
        if (maxCount == count) {
          count = 1;
        } else {
          count++;
        }
        break;
    }
    querySelector("#count").text = count.toString();
    window.scrollTo(0, 0);
  });
}
