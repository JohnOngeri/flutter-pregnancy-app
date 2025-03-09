class TipsModel {
  final String id;
  final String text;
  final String imgPath;
  final String type;
  final String author;

  TipsModel({
    required this.id,
    required this.text,
    required this.imgPath,
    required this.author,
    required this.type,
  });
}

// Sample tips data
List<TipsModel> tipsList = [
  TipsModel(
    id: "1",
    text:
        "Eating a variety of colorful fruits and vegetables daily boosts your immune system and overall health.",
    imgPath: 'images/avocadoes.png',
    author: "Dr. Smith",
    type: "Food Tips",
  ),
  TipsModel(
    id: "2",
    text:
        "Regular exercise, hydration, and enough sleep are key to maintaining a healthy body and mind.",
    imgPath: 'images/health_tips.png',
    author: "Dr. Adams",
    type: "Health Tips",
  ),
  TipsModel(
    id: "3",
    text:
        "Practicing mindfulness, gratitude, and self-care can help reduce stress and improve mental well-being.",
    imgPath: 'images/psych_tips.png',
    author: "Dr. Williams",
    type: "Psychological Tips",
  ),
  TipsModel(
    id: "4",
    text:
        "Consistency is key! Engage in at least 30 minutes of physical activity daily for a strong and fit body.",
    imgPath: 'images/mental.png',
    author: "Coach Johnson",
    type: "Fitness Tips",
  ),
];
