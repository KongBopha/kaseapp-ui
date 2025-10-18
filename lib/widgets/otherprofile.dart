import 'package:flutter/material.dart';
import 'package:kaseapp_ui/models/user_model.dart';

class OtherProfileScreen extends StatelessWidget {
  final UserModel user;
  const OtherProfileScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(user.firstName ?? 'Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Avatar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      _getInitials(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role ?? 'User',
                      style: TextStyle(
                        color: _getRoleColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contact Information
            _buildSection(
              title: 'Contact Information',
              icon: Icons.contact_mail,
              children: [
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email ?? 'Not provided',
                ),
              ],
            ),

            // Vendor Information
            if (user.vendor != null) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Vendor Information',
                icon: Icons.business,
                children: [
                  _buildInfoTile(
                    icon: Icons.store,
                    label: 'Company Name',
                    value: user.vendor?.companyName ?? 'N/A',
                  ),
                  _buildInfoTile(
                    icon: Icons.category,
                    label: 'Vendor Type',
                    value: user.vendor?.vendorType ?? 'N/A',
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: user.vendor?.address ?? 'N/A',
                    maxLines: 2,
                  ),
                ],
              ),
            ],

            // Farm Information
            if (user.farm != null) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Farm Information',
                icon: Icons.agriculture,
                children: [
                  _buildInfoTile(
                    icon: Icons.landscape,
                    label: 'Farm Name',
                    value: user.farm?.name ?? 'N/A',
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: user.farm?.address ?? 'N/A',
                    maxLines: 2,
                  ),
                  _buildInfoTile(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: user.farm?.status as String? ?? 'N/A',
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    String initials = '';
    if (user.firstName != null && user.firstName!.isNotEmpty) {
      initials += user.firstName![0].toUpperCase();
    }
    if (user.lastName != null && user.lastName!.isNotEmpty) {
      initials += user.lastName![0].toUpperCase();
    }
    return initials.isEmpty ? '?' : initials;
  }

  Color _getRoleColor() {
    final role = user.role?.toLowerCase() ?? '';
    if (role.contains('admin')) return Colors.red[700]!;
    if (role.contains('vendor')) return Colors.orange[700]!;
    if (role.contains('farmer')) return Colors.green[700]!;
    return Colors.blue[700]!;
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}