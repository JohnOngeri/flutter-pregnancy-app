import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/tip/bloc/tip_bloc.dart';
import '../../../application/tip/bloc/tip_event.dart';
import '../../../infrastructure/tip/tip_api.dart';
import '../../../infrastructure/tip/tip_repository.dart';
import '../../core/constants/assets.dart';
import 'tips_model.dart';
import 'detail_body.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.tipsModel, required this.type});
  final TipsModel tipsModel;
  final String type;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: detailAppBar(size, context, widget.type),
      body: DetailBody(
        tipsModel: widget.tipsModel,
      ),
    );
  }

  PreferredSize detailAppBar(Size size, BuildContext context, String type) {
    String imagePath;
    switch (type) {
      case 'Food Tips':
        imagePath = 'assets/images/avocadoes.png';
        break;
      case 'Health Tips':
        imagePath = 'assets/images/health.png';
        break;
      case 'Psychological Tips':
        imagePath = 'assets/images/mental.png';
        break;
      case 'Fitness Tips':
        imagePath = 'assets/images/fitness.png';
        break;
      default:
        imagePath = 'assets/images/mental.png';
    }

    return PreferredSize(
      preferredSize: Size(size.width, 150), // Adjust the height as needed
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
