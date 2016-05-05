library md2slide.mdconverter;

import 'dart:html';
import 'package:markdown/markdown.dart';

class MDConverter {
  static List<HtmlElement> convertMarkdown(String markdwonSource) {
    List<HtmlElement> slideElement = new List<HtmlElement>();
    List<String> slideSource = markdwonSource.split('@@@');
    for (String source in slideSource) {
      print(markdownToHtml(source));
      DivElement div = new DivElement();
      div.innerHtml = markdownToHtml(source);
      div.style.fontSize = "3em";
      slideElement.add(div);
    }
    return slideElement;
  }
}
