import 'package:flutter/material.dart';
import 'tips_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailBody extends StatefulWidget {
  final TipsModel tipsModel;
  const DetailBody({super.key, required this.tipsModel});

  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _getYoutubeVideoId(widget.tipsModel.type),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/doctor.png'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tipsModel.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Increased font size
                          ),
                        ),
                        const Text(
                          "12 hours ago",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18, // Increased font size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Lorem ipsum paragraph with increased font size and spacing
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  _getLoremIpsumText(widget.tipsModel.type),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Youtube Player with spacing
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  height: 200,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  ),
                ),
              ),
              // Tip text with increased font size and spacing
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  widget.tipsModel.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate lorem ipsum text based on tip type
  String _getLoremIpsumText(String type) {
    switch (type) {
      case "Food Tips":
        return "During pregnancy, a balanced diet is crucial for both the mother and baby's health. Focus on nutrient-rich foods like fruits, vegetables, lean protein, and whole grains. Ensure adequate intake of folic acid, iron, calcium, and omega-3 fatty acids. Consult a healthcare professional for personalized dietary recommendations.";
      case "Health Tips":
        return "Regular prenatal checkups are essential to monitor the health of both mother and baby. Stay active with moderate-intensity exercises like walking or swimming, as approved by your doctor. Get enough sleep and manage stress through relaxation techniques. Avoid smoking, alcohol, and unnecessary medications.";
      case "Psychological Tips":
        return "Pregnancy can bring a mix of emotions. Practice mindfulness and relaxation techniques to manage stress and anxiety. Connect with your partner, family, or support groups to share your feelings. Seek professional help if you experience overwhelming emotions or mood swings.";
      case "Fitness Tips":
        return "Staying active during pregnancy can improve overall health and prepare your body for labor. Engage in low-impact exercises like walking, swimming, or prenatal yoga. Consult your doctor before starting any new exercise program. Listen to your body and avoid overexertion.";
      default:
        return "Maintaining a healthy lifestyle during pregnancy is vital for both mother and baby. Focus on a balanced diet, regular exercise, emotional well-being, and regular prenatal care. Consult your healthcare provider for personalized guidance and support.";
    }
  }

  // Get Youtube video ID based on tip type
  String _getYoutubeVideoId(String type) {
    switch (type) {
      case "Food Tips":
        return "ADqM3thoy2Y"; // Extracted video ID
      case "Health Tips":
        return "Ybyo5nRmr1Y";
      case "Psychological Tips":
        return "MwvctN3Uejg";
      case "Fitness Tips":
        return "lKx0sOz31C4";
      default:
        return "BcVOmKUhxnQ";
    }
  }

  String _getHeaderText(String type) {
    switch (type) {
      case "Food Tips":
        return "Eat healthy, live your best moments...";
      case "Health Tips":
        return "Your health is your greatest wealth!";
      case "Psychological Tips":
        return "A peaceful mind leads to a happy life.";
      case "Fitness Tips":
        return "Stay active, stay strong!";
      default:
        return "Live a balanced life!";
    }
  }
}
