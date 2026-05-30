import 'package:flutter/material.dart';

class SourceCard extends StatelessWidget {
  final imageSource;
  final String title;
  final String subtitle;
  final Function()? onTap;
  // final b
  const SourceCard({super.key,required this.imageSource,required this.title,required this.subtitle,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
  margin: EdgeInsets.zero,
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [

          /// NOVEL IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageSource,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 42,
                  height: 42,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.broken_image,
                    size: 18,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [

                    Icon(
                      Icons.language,
                      size: 12,
                      color: Colors.grey[400],
                    ),

                    const SizedBox(width: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// PIN ICON
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.push_pin_outlined,
              size: 20,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    ),
  ),
);

  }
  }