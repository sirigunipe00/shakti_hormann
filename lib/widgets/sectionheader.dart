import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.assetIcon,
  });

  final String title;
  final String assetIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(assetIcon),
            ),
            const DottedLine(
              direction: Axis.vertical,
              dashGapLength: 3,
              dashColor: Color(0xFF2957A4),
              lineThickness: 2,
              lineLength: 20,
            ),
          ],
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
