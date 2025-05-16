import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../models/match_model.dart';
import 'dart:convert';

class AvailableMatchCard extends StatefulWidget {
  final MatchModel match;

  const AvailableMatchCard({super.key, required this.match});

  @override
  State<AvailableMatchCard> createState() => _AvailableMatchCardState();
}

class _AvailableMatchCardState extends State<AvailableMatchCard> {
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    final date = DateTime.parse(widget.match.dateText);
    formattedDate = DateFormat('EEEE, MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondary,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time
            Text(
              '${formattedDate} – ${widget.match.timeText}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),

            // Type & Availability
            Row(
              children: [
                const Icon(Icons.sports_tennis, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.match.matchLevel,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.wc, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.match.gender_allowed,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Players
            Row(
              children:
                  widget.match.players.map((player) {
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 44, // radius * 2 + padding
                            height: 44,

                            decoration:
                                player.avatarUrl != null
                                    ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 2,
                                      ),
                                    )
                                    : BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.primary,
                                        width: 1,
                                      ),
                                    ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  player.avatarUrl != null
                                      ? MemoryImage(
                                        base64Decode(
                                          player.avatarUrl!.split(',').last,
                                        ),
                                      )
                                      : null,
                              child:
                                  player.avatarUrl == null
                                      ? const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      )
                                      : null,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            player.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            player.rating.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 18),

            // Club & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT SECTION
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          '${imageBaseUrl}${widget.match.cover_image}',
                        ),
                        //  child: const Icon(Icons.add, color: Colors.blue),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.match.sportsCenterName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis, //
                            ),
                            Text(
                              widget.match.courtName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// RIGHT SECTION
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.match.joinedStatus == true
                            ? Colors.transparent
                            : colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      widget.match.joinedStatus == true
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Joined',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            '₦${NumberFormat('#,##0', 'en_NG').format(widget.match.sessionPrice)} – ${widget.match.sessionDuration}mins',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
