import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../components/molecules/my_widget_animator.dart';
import 'controllers/profile.controller.dart';
import 'widgets/logout_button.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_item.dart';
import 'widgets/profile_info_section.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(Get.find());

    return CustomLayout(
      extendBodyBehindAppBar: true,
      extendBody: true,

      // appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SafeArea(
        child: GetBuilder<ProfileController>(
          init: controller,
          id: 'profile',
          key: const Key('profile'),
          builder: (controller) {
            return MyWidgetsAnimator(
              status: controller.profileStatus.value,
              successWidget: () {
                final user = controller.profile.value;
                if (user == null) return const SizedBox();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ProfileHeader(
                        image: user.image,
                        firstName: user.firstName,
                        lastName: user.lastName,
                        username: user.username,
                        role: user.role,
                      ),
                      ProfileInfoSection(
                        title: 'Personal Information',
                        items: [
                          ProfileInfoItem(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email,
                          ),
                          ProfileInfoItem(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: user.phone,
                          ),
                          ProfileInfoItem(
                            icon: Icons.cake_outlined,
                            label: 'Birth Date',
                            value: user.birthDate,
                          ),
                          ProfileInfoItem(
                            icon: Icons.bloodtype_outlined,
                            label: 'Blood Group',
                            value: user.bloodGroup,
                            iconColor: Colors.red,
                          ),
                        ],
                      ),
                      ProfileInfoSection(
                        title: 'Work Information',
                        items: [
                          ProfileInfoItem(
                            icon: Icons.business_outlined,
                            label: 'Company',
                            value: user.company?.name ?? '-',
                          ),
                          ProfileInfoItem(
                            icon: Icons.work_outline,
                            label: 'Department',
                            value: user.company?.department ?? '-',
                          ),
                          ProfileInfoItem(
                            icon: Icons.badge_outlined,
                            label: 'Job Title',
                            value: user.company?.title ?? '-',
                          ),
                        ],
                      ),
                      ProfileInfoSection(
                        title: 'Physical Attributes',
                        items: [
                          ProfileInfoItem(
                            icon: Icons.height,
                            label: 'Height',
                            value: '${user.height} cm',
                          ),
                          ProfileInfoItem(
                            icon: Icons.monitor_weight_outlined,
                            label: 'Weight',
                            value: '${user.weight} kg',
                          ),
                          ProfileInfoItem(
                            icon: Icons.visibility_outlined,
                            label: 'Eye Color',
                            value: user.eyeColor,
                          ),
                        ],
                      ),
                      LogoutButton(onPressed: controller.logout),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
