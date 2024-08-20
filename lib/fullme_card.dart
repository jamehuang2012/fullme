import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class fullme_card extends StatefulWidget {
  final List<String?> imageUrls;
  final String id;
  final String name;
  final String taskName;
  const fullme_card({
    required this.id,
    required this.name,
    required this.imageUrls,
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
          Column(
            children: widget.imageUrls!.map((imageUrl) {
              print(imageUrl);
              return Container(
                alignment: Alignment.center,
                child: Image.file(
                  File(imageUrl!),
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),

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
