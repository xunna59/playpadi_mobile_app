import '../../../core/capitalization_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../controllers/match_controller.dart';
import '../../../core/activity_overlay.dart';
import '../../../core/constants.dart';
import '../../../models/match_model.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_routes.dart';

class MatchDetailsScreen extends StatefulWidget {
  final MatchModel match;
  const MatchDetailsScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  final MatchController matchController = MatchController();

  String _formatPrice(double p) =>
      '₦${NumberFormat("#,##0", "en_NG").format(p)}';
  String formattedDate = '';
  late final int bookingId;

  @override
  void initState() {
    super.initState();
    final date = DateTime.parse(widget.match.dateText);
    formattedDate = DateFormat('EEEE, MMMM d, y').format(date);
    bookingId = widget.match.id;
  }

  Future<void> _onJoinBooking() async {
    // Build up your payload
    final payload = {'bookind_id': bookingId};

    LoadingOverlay.show(context);
    try {
      final matches = await matchController.joinPublicMatch(payload);

      Navigator.pop(context, true);
      // Navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Match Joined Successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green, // ← here
        ),
      );
    } catch (e) {
      // Handle errors (network, format, server, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking failed: $e',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _onLeaveBooking() async {
    final payload = {'bookingId': bookingId};

    LoadingOverlay.show(context);
    try {
      final response = await matchController.leavePublicBooking(payload);

      Navigator.pop(context, true);

      final refundEligible = response['refund'] == true;
      final refundAmount = num.parse(
        response['refundAmount'].toString(),
      ).toStringAsFixed(2);
      final refundNote = response['refundNote'] ?? 'You left the match.';

      final successMessage =
          refundEligible
              ? 'Left match successfully. \n$refundNote Amount: ₦$refundAmount'
              : 'Left match successfully.\n$refundNote';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successMessage,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not leave booking: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      // We remove the normal AppBar and use a SliverAppBar below
      body: CustomScrollView(
        slivers: [
          // ─────────────────────────────────────────────────────────────
          // 1) SLIVER APP BAR WITH FIXED COVER IMAGE
          SliverAppBar(
            pinned: true, // so back/share stay visible
            expandedHeight: 240, // height of your cover image
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          'PlayPadi Upcoming ${widget.match.matchLevel} Game visit https://playpadi.com to Join Match',
                    ),
                  );
                },
              ),
            ],

            // The image sits behind the toolbar
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '${imageBaseUrl}${widget.match.cover_image}',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ─────────────────────────────────────────────────────────────
          // 2) SCROLLABLE CONTENT
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // INFO CARD
                Card(
                  color: cs.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: cs.primary),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.match.matchLevel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formattedDate} - ${widget.match.timeText}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _infoColumn(
                                'Gender',
                                widget.match.gender_allowed.capitalizeFirst(),
                              ),
                            ),
                            Expanded(
                              child: _infoColumn(
                                'Game',
                                widget.match.matchLevel,
                              ),
                            ),
                            Expanded(
                              child: _infoColumn(
                                'Price',
                                _formatPrice(
                                  widget.match.sessionPrice /
                                      widget.match.totalPlayers,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // STATUS ROW
                Row(
                  children: [
                    // Open Match: just icon + text, tappable
                    InkWell(
                      onTap: () {
                        // your handler
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.lock_open),
                          SizedBox(width: 4),
                          Text("Open Match"),
                        ],
                      ),
                    ),

                    Spacer(),
                    // Court booked: just icon + text
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 4),
                        Text("Court Available"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // COMPETITIVE CARD
                // Card(
                //   color: cs.secondary,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   margin: EdgeInsets.zero,
                //   elevation: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.all(12),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: const [
                //         Text(
                //           "Competitive",
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //         SizedBox(height: 4),
                //         Text(
                //           "The result of this match will count towards the level.",
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 12),

                // COMPETITIVE LIST TILE
                // Card(
                //   color: cs.secondary,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   margin: EdgeInsets.zero,
                //   elevation: 1,
                //   child: ListTile(
                //     leading: CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         match.players.isNotEmpty
                //             ? match.players.first.avatarUrl ?? ''
                //             : 'https://via.placeholder.com/150',
                //       ),
                //     ),
                //     title: const Text(
                //       "Competitive",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     subtitle: const Text(
                //       "The result of this match will count towards the level.",
                //     ),
                //     trailing: const Icon(Icons.chevron_right),
                //   ),
                // ),

                // const SizedBox(height: 16),

                // PLAYERS ROW
                const Text(
                  "Players",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // actual players
                    for (var p in widget.match.players)
                      Expanded(
                        child: _playerColumn(p.name, p.avatarUrl, p.rating),
                      ),
                    // placeholders
                    for (
                      var i = 0;
                      i <
                          widget.match.totalPlayers -
                              widget.match.players.length;
                      i++
                    )
                      Expanded(child: _availableColumn()),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  "Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // COURT INFO CARD
                Card(
                  color: cs.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.zero,
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("Sports Center"),
                        subtitle: Text(widget.match.sportsCenterName),
                      ),

                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("Court"),
                        subtitle: Text(widget.match.courtName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_month_outlined),
                        title: const Text("Session Duration"),
                        subtitle: Text('${widget.match.sessionDuration} mins'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.match.joinedStatus == true
                              ? Colors.redAccent
                              : cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    onPressed: () async {
                      if (widget.match.joinedStatus == true) {
                        // Ask for confirmation before cancelling
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: cs.secondary,
                                title: const Text('Cancel Booking?'),
                                content: const Text(
                                  'Are you sure you want to cancel this booking?\nRefunds depend on how early you cancel.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: cs.primary,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text('Yes, Cancel'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          _onLeaveBooking();
                        }

                        return;
                      }

                      // Not joined yet — proceed with payment
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.paymentConfirmationScreen,
                        arguments: {
                          'purpose': 'Join Open Match',
                          'amount':
                              widget.match.sessionPrice /
                              widget.match.totalPlayers,
                        },
                      );

                      if (result == true) {
                        _onJoinBooking(); // Perform the booking join
                      }
                    },

                    child:
                        widget.match.joinedStatus == true
                            ? Text(
                              'Cancel Booking',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              'Book Place - ${_formatPrice(widget.match.sessionPrice / widget.match.totalPlayers)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                // add more slivers or list items here...
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _playerColumn(String name, String? avatarUrl, double rating) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor:
              avatarUrl != null ? Colors.transparent : colorScheme.primary,
          backgroundImage:
              avatarUrl != null
                  // ? MemoryImage(base64Decode(avatarUrl.split(',').last))
                  ? NetworkImage('${display_picture}${avatarUrl}')
                  : null,
          child:
              avatarUrl == null
                  ? const Icon(Icons.add, color: Colors.black)
                  : null,
        ),
        const SizedBox(height: 4),
        Text(name),
        Text(
          rating.toStringAsFixed(2),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _availableColumn() {
    return Column(
      children: const [
        CircleAvatar(radius: 30, child: Icon(Icons.add, color: Colors.red)),
        SizedBox(height: 4),
        Text("Available", style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
