import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.aboutApp,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            16.height,
            _buildAppInfo(),
            16.height,
            _buildLinksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              color: appColorPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              Assets.assetsAppLogo,
              fit: BoxFit.contain,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          16.height,
          Text(
            'Version 1.6.2',
            style: secondaryTextStyle(size: 16),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    ).paddingAll(16);
  }

  Widget _buildAppInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About EG Physio',
            style: boldTextStyle(size: 20),
          ),
          16.height,
          Text(
            'EG Physio is a comprehensive physiotherapy management solution designed to streamline clinic operations, patient care, and treatment management.',
            style: secondaryTextStyle(size: 16),
          ),
          16.height,
          _buildFeatureItem(
            icon: Icons.medical_services,
            title: 'Clinic Management',
            description: 'Efficiently manage your physiotherapy clinic operations and staff',
          ),
          16.height,
          _buildFeatureItem(
            icon: Icons.people,
            title: 'Patient Care',
            description: 'Enhanced patient experience and treatment management',
          ),
          16.height,
          _buildFeatureItem(
            icon: Icons.schedule,
            title: 'Appointment Scheduling',
            description: 'Streamlined appointment booking and session management',
          ),
          16.height,
          _buildFeatureItem(
            icon: Icons.fitness_center,
            title: 'Treatment Plans',
            description: 'Comprehensive treatment planning and progress tracking',
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: boxDecorationDefault(
            color: appColorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: appColorPrimary,
            size: 24,
          ),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: boldTextStyle(size: 16),
              ),
              4.height,
              Text(
                description,
                style: secondaryTextStyle(size: 14),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildLinksSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: boxDecorationDefault(
        color: isDarkMode.value ? cardDarkColor : white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode.value ? null : defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Links',
            style: boldTextStyle(size: 20),
          ),
          16.height,
          ...aboutPages.map((page) {
            if (page.name.isEmpty || page.url.isEmpty) {
              return const SizedBox();
            }
            return SettingItemWidget(
              title: page.name,
              onTap: () {
                commonLaunchUrl(
                  page.url.trim(),
                  launchMode: LaunchMode.externalApplication,
                );
              },
              titleTextStyle: primaryTextStyle(),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
          }).toList(),
        ],
      ),
    ).paddingAll(16);
  }
}
