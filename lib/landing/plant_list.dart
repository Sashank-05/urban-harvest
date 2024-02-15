List<Map<String, String>> plantList = [
  {'category': 'Flowers','name': 'Rose', 'img': '/images/flowers/rose.png'},
  {'category': 'Flowers','name': 'Marigold', 'img': '/images/flowers/marigold.png'},
  {'category': 'Flowers', 'name': 'Hibiscus', 'img': '/images/flowers/hibiscus.png'},
  {'category':'Flowers','name': 'Jasmine', 'img': '/images/flowers/jasmine.png'},
  {'category':'Flowers','name':'Sunflower','img':'/images/flowers/sunflower.png'},
  {'category':'Vegetables','name':'Cabbage','img':'/images/vegetables/cabbage.png'},
  {'category':'Vegetables','name':'Cauliflower','img':'/images/vegetables/cauliflower.png'},
  {'category':'Vegetables','name':'Chilli','img':'/images/vegetables/chilli.png'},
  {'category':'Vegetables','name':'Green Beans','img':'/images/vegetables/green-beans.png'},
  {'category':'Vegetables','name':'Tomato','img':'/images/vegetables/tomatoes.png'},
  {'category':'Greens','name':'Aloevera','img':'/images/greens/aloevera.png'},
  {'category':'Greens','name':'Coriander','img':'/images/greens/coriander.png'},
  {'category':'Greens','name':'Mint','img':'/images/greens/mint.png'},
  {'category':'Greens','name':'Curry Leaves','img':'/images/greens/tropical-leaves.png'},
];

Map<String, String> imageDict = {
  'Rose': 'images/flowers/rose.png',
  'Marigold': 'images/flowers/marigold.png',
  'Hibiscus':'images/flowers/hibiscus.png',
  'Jasmine':'images/flowers/jasmine.png',
  'Sunflower':'images/flowers/sunflower.png',
  'Cabbage':'images/vegetables/cabbage.png',
  'Cauliflower':'images/vegetables/cauliflower.png',
  'Chilli':'images/vegetables/chilli.png',
  'Green Beans':'images/vegetables/green-beans.png',
  'Tomato':'images/vegetables/tomato.png',
  'Aloevera':'images/greens/aloevera.png',
  'Coriander':'images/greens/coriander.png',
  'Mint':'images/greens/mint.png',
  'Curry Leaves':'images/greens/tropical-leaves.png',
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