class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.description = '',
  });

  String title;
  String description;

  String imagePath;

  static List<Category> ImageList = <Category>[
    Category(
      imagePath: 'assets/design_course/interFace3.png',
      title: 'Image 0',
      description: 'scene',
    ),
    Category(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Image 1',
      description: 'ocr',
    ),
    Category(
      imagePath: 'assets/design_course/interFace3.png',
      title: 'Image 2',
      description: 'faces',
    ),
    Category(
      imagePath: 'assets/design_course/interFace4.png',
      title: 'Image 3',
      description: 'ocr',
    ),
  ];
}
