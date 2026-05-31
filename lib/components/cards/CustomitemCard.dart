import 'package:flutter/material.dart';

class CustomItemCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final VoidCallback? onTap;

  const CustomItemCard({
    super.key,
    required this.imgUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),

      child: InkWell(
        onTap: onTap,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: imgUrl,
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                      
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Container(
                            color: Colors.grey,
                      
                            child: const Icon(
                              Icons.image,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,

                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        8,
                      ),

                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment
                                  .topCenter,

                          end:
                              Alignment
                                  .bottomCenter,

                          colors: [
                            Colors.transparent,

                            Colors.black
                                .withOpacity(
                              0.65,
                            ),
                          ],
                        ),
                      ),

                      child: Text(
                        title,

                        style:
                            const TextStyle(
                          color:
                              Colors.white,

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 14,
                        ),

                        maxLines: 2,

                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}