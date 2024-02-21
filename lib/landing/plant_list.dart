import 'package:flutter/material.dart';
import './guides/aloevera-guide.dart';
import './guides/cabbage-guide.dart';
import './guides/cauliflower-guide.dart';
import './guides/chilli-guide.dart';
import './guides/coriander-guide.dart';
import './guides/green-beans-guide.dart';
import './guides/hibiscus-guide.dart';
import './guides/jasmine-guide.dart';
import './guides/marigold-guide.dart';
import './guides/mint-guide.dart';
import './guides/rose-guide.dart';
import './guides/sunflower-guide.dart';
import './guides/tomato-guide.dart';
import './guides/curry-leaves-guide.dart';


Map<String,Widget> guideDict = {
  'Rose': RoseGuide(),
  'Marigold': MarigoldGuide(),
  'Hibiscus': HibiscusGuide(),
  'Jasmine': JasmineGuide(),
  'Sunflower': SunflowerGuide(),
  'Cabbage': CabbageGuide(),
  'Cauliflower': CauliflowerGuide(),
  'Chilli': ChilliGuide(),
  'Green Beans': GreenBeansGuide(),
  'Tomato': TomatoGuide(),
  'Aloevera': AloeveraGuide(),
  'Coriander': CorianderGuide(),
  'Mint': MintGuide(),
  'Curry Leaves': CurryLeavesGuide(),
};

List<Map<String, String>> plantList = [
  {'category': 'Flowers','name': 'Rose', 'img': '/assets/img/landing/landing/flowers/rose.png'},
  {'category': 'Flowers','name': 'Marigold', 'img': '/assets/img/landing/landing/flowers/marigold.png'},
  {'category': 'Flowers', 'name': 'Hibiscus', 'img': '/assets/img/landing/landing/flowers/hibiscus.png'},
  {'category':'Flowers','name': 'Jasmine', 'img': '/assets/img/landing/landing/flowers/jasmine.png'},
  {'category':'Flowers','name':'Sunflower','img':'/assets/img/landing/landing/flowers/sunflower.png'},
  {'category':'Vegetables','name':'Cabbage','img':'/assets/img/landing/landing/vegetables/cabbage.png'},
  {'category':'Vegetables','name':'Cauliflower','img':'/assets/img/landing/landing/vegetables/cauliflower.png'},
  {'category':'Vegetables','name':'Chilli','img':'/assets/img/landing/landing/vegetables/chilli.png'},
  {'category':'Vegetables','name':'Green Beans','img':'/assets/img/landing/landing/vegetables/green-beans.png'},
  {'category':'Vegetables','name':'Tomato','img':'/assets/img/landing/landing/vegetables/tomato.png'},
  {'category':'Greens','name':'Aloevera','img':'/assets/img/landing/landing/greens/aloevera.png'},
  {'category':'Greens','name':'Coriander','img':'/assets/img/landing/landing/greens/coriander.png'},
  {'category':'Greens','name':'Mint','img':'/assets/img/landing/landing/greens/mint.png'},
  {'category':'Greens','name':'Curry Leaves','img':'/assets/img/landing/landing/greens/tropical-leaves.png'},
];

Map<String, String> imageDict = {
  'Rose': 'assets/img/landing/flowers/rose.png',
  'Marigold': 'assets/img/landing/flowers/marigold.png',
  'Hibiscus': 'assets/img/landing/flowers/hibiscus.png',
  'Jasmine': 'assets/img/landing/flowers/jasmine.png',
  'Sunflower': 'assets/img/landing/flowers/sunflower.png',
  'Cabbage': 'assets/img/landing/vegetables/cabbage.png',
  'Cauliflower': 'assets/img/landing/vegetables/cauliflower.png',
  'Chilli': 'assets/img/landing/vegetables/chilli.png',
  'Green Beans': 'assets/img/landing/vegetables/green-beans.png',
  'Tomato': 'assets/img/landing/vegetables/tomato.png',
  'Aloevera': 'assets/img/landing/greens/aloevera.png',
  'Coriander': 'assets/img/landing/greens/coriander.png',
  'Mint': 'assets/img/landing/greens/mint.png',
  'Curry Leaves': 'assets/img/landing/greens/tropical-leaves.png',
};

//this is what it is searching for
Map<String, List<String>> searchQueryResults(String searchQuery) {
  Map<String, List<String>> results = {
    'Flowers': [],
    'Vegetables': [],
    'Greens': [],
  };
  String lowerCaseQuery = searchQuery.toLowerCase();

  for (var plant in plantList) {
    if (plant['name']!.toLowerCase().contains(lowerCaseQuery)) {
      results[plant['category']]!.add(plant['name']!);
    }
  }

  // Remove keys with empty lists from the results map
  results.removeWhere((key, value) => value.isEmpty);

  return results;
}
