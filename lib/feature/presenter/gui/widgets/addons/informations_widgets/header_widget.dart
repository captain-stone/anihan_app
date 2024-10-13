import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String name;

  final String isApproved;

  final List<Widget> accessRoles;

  final Function() onPressSell;

  const HeaderWidget(this.name,
      {required this.isApproved,
      required this.accessRoles,
      required this.onPressSell,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
      decoration: BoxDecoration(
        // color: Colors.red,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildProfileSection(context),
    );
  }

  Row _buildProfileSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32.0,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.white, size: 36.0),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileNameWithIcon(context),
              _buildMemberSinceText(context),
              _buildUserBadge(),
            ],
          ),
        ),
        // const SizedBox(width: 8.0),
        accessRoles.length > 1
            ? Container()
            : isApproved == Approval.pendingApproval.name
                ? _buildSellButton("Seller approval")
                : _buildSellButton("Sell Your Own"),
      ],
    );
  }

  Row _buildProfileNameWithIcon(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        // const SizedBox(width: 6.0),
        IconButton(
          icon: const Icon(
            Icons.card_giftcard,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            AutoRouter.of(context).replace(const MyInformationFarmerRoute());
          },
        ),
      ],
    );
  }

  Text _buildMemberSinceText(BuildContext context) {
    return Text(
      'Member since 04/17/24',
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.white, fontSize: 12),
    );
  }

  Row _buildUserBadge() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: accessRoles);
  }

  ElevatedButton _buildSellButton(String label) {
    return ElevatedButton(
      onPressed: isApproved == Approval.pendingApproval.name
          ? null
          : isApproved == Approval.approved.name
              ? null
              : onPressSell,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Colors.white),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4.0), // Space between icon and text

          const Icon(
            Icons.sell,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(height: 4.0), // Space between icon and text
          Text(
            // softWrap: true,
            // textAlign: TextAlign.center,
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(height: 4.0), // Space between icon and text
        ],
      ),
    );
  }
}
