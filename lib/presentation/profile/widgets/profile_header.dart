import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String image;
  final String firstName;
  final String lastName;
  final String username;
  final String role;

  const ProfileHeader({
    super.key,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(image),
          backgroundColor: theme.primaryColor.withOpacity(0.1),
        ),
        const SizedBox(height: 16),
        Text(
          '$firstName $lastName',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@$username',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
