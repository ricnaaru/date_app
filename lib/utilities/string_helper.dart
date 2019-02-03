import 'package:flutter/material.dart';

class StringHelper {
  static String formatString(String string, Map<String, String> parameters) {
    String result = string;

    parameters.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    return result;
  }

  static List<TextSpan> parseStringToTextSpan(String fullString, List<String> findString) {
    String stringWithSmallestIndex =
    _findWordWithSmallestIndex(fullString, findString, startFindFrom: 0);
    int index = fullString.indexOf(stringWithSmallestIndex);
    int startCropFrom = 0;
    List<TextSpan> textSpans = [];

    while (index != -1) {
      String croppedString = fullString.substring(startCropFrom, index);
      startCropFrom = index + stringWithSmallestIndex.length;

      textSpans.add(TextSpan(text: croppedString));
      textSpans.add(TextSpan(text: stringWithSmallestIndex));

      index++;

      if (index > fullString.length) break;

      stringWithSmallestIndex =
          _findWordWithSmallestIndex(fullString, findString, startFindFrom: index);

      index = fullString.indexOf(stringWithSmallestIndex, index);
    }

    String croppedString = fullString.substring(startCropFrom, fullString.length);
    textSpans.add(TextSpan(text: croppedString));

    return textSpans;
  }

  static String _findWordWithSmallestIndex(String fullString, List<String> findString,
      {int startFindFrom}) {
    int tempSmallestIndex;
    int tempIndex;
    String wordWithSmallestIndex;
    int i = 0;

    while (i < findString.length) {
      tempIndex = fullString.indexOf(findString[i], startFindFrom);
      if (tempIndex == -1) {
        i++;
        continue;
      }
      wordWithSmallestIndex = tempSmallestIndex == null
          ? findString[i]
          : tempSmallestIndex < tempIndex ? wordWithSmallestIndex : findString[i];
      tempSmallestIndex = tempSmallestIndex == null
          ? tempIndex
          : tempSmallestIndex < tempIndex ? tempSmallestIndex : tempIndex;
      i++;
    }
    return wordWithSmallestIndex ?? findString[0];
  }
}