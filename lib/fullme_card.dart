import 'package:flutter/material.dart';


class fullme_card extends StatefulWidget {
  final String imageUrl;
  final String id;
  final String name;
  final String taskName;
  const fullme_card({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.taskName,
    Key? key,
  }):  super(key: key);

  @override
  State<fullme_card> createState() => _fullmeCardState();
}

class _fullmeCardState extends State<fullme_card> {

  Widget _buildCardContent(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '登录名: ${widget.id} - 中文名: ${widget.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh,color: Colors.blueAccent,),
                onPressed: () {
                  // Handle settings button press
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '任务: ${widget.taskName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),

            ],
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            child:  Image.asset(
              'assets/images/b2evo-1.jpg', // Replace with your image asset path
              //  height: 50,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            alignment: Alignment.center,
            child:  Image.asset(
              'assets/images/b2evo-2.jpg', // Replace with your image asset path
              //  height: 50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: _buildCardContent(context),
    );
  }
}
