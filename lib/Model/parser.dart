import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body?.text ?? "").documentElement!.text;
  return HtmlUnescape().convert(parsedString);
}
