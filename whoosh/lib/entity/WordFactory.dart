
import 'dart:math';

class WordFactory {
  static List<String> wordBank = [
    'sushi',
    'edamame',
    'tuna',
    'salmon',
    'bun',
    'apple',
    'bread',
    'tofu',
    'pear',
    'melon',
    'carrot',
    'radish',
    'noodle',
    'bento',
    'gyoza',
    'tart',
    'cake',
    'spinach',
    'cabbage',
    'fries',
    'salad',
    'potato',
    'tomato',
    'cheese',
    'egg',
    'prata',
    'chicken',
    'lemon'
  ];

  static String getRandomWord() {
    final _random = new Random();

    return wordBank[_random.nextInt(wordBank.length)];
  }

  static String getRandomWordNotInList(List<String> words) {
    if (words.length >= wordBank.length) {
      return "";
    }
    String groupName = WordFactory.getRandomWord();
    while (words.contains(groupName)) {
      groupName = WordFactory.getRandomWord();
    }
    return groupName;
  }
}