import 'dart:math';

class RandomFact {
  List<String> mess = [
    'Bamboo is the fastest-growing woody plant in the world. It can grow up to 35 inches in a single day.',
    'Tomato juice is the official state beverage of Ohio, honoring the part A. W. Livingston of Reynoldsburg, Ohio, played in popularizing the tomato in the late 1800s.',
    'Vanilla flavoring comes from the pod of an orchid, Vanilla planifolia. Though the pods are called vanilla beans, they are not actually in the legume family like green beans.',
    'Saffron, used as a flavoring in Mediterranean cooking, is harvested from the stigmas of a type of fall-blooming crocus, Crocus sativus.',
    'The first potatoes were cultivated in Peru about 7,000 years ago.',
    'The average strawberry has 200 seeds. It is the only fruit that bears its seeds on the outside.',
    'There are over 300,000 identified plant species and the list is growing all the time!',
    'Oak trees don’t produce acorns until they are 50 years old!'
  ];

  late String did;

  RandomFact() {
    shuffleMess();
  }

  String shuffleMess() {
    mess.shuffle();
    did = mess.first;
    return(did);

  }
}


