import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../bloc/portfolio_bloc.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return SectionWrapper(
          sectionId: 'contact',
          title: 'Contact',
          subtitle: 'Get In Touch',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(context, state),
          tabletChild: _buildLayout(context, state),
          smallLaptopChild: _buildLayout(context, state),
          desktopChild: _buildLayout(context, state),
          largeDesktopChild: _buildLayout(context, state),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, PortfolioState state) {
    final contentWidth = ResponsiveHelper.getContentWidth(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final profile = state.profile;

    if (state.isLoading && profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (profile == null) {
      return Center(
        child: Text(
          'No profile data available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final contactInfo = profile.contactInfo;

    return Container(
      width: contentWidth,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildContactForm(context, state)),
                    const SizedBox(width: 48),
                    Expanded(child: _buildContactInfo(context, contactInfo)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo(context, contactInfo),
                    const SizedBox(height: 32),
                    _buildContactForm(context, state),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, PortfolioState state) {
    if (state.isContactFormSubmitted) return _buildSuccessMessage();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send a Message',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.message),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a message'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isContactFormSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PortfolioBloc>().add(
                                  SubmitContactForm(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    message: _messageController.text,
                                  ),
                                );
                          }
                        },
                  icon: state.isContactFormSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    state.isContactFormSubmitting
                        ? 'Sending...'
                        : 'Send Message',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 600.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildSuccessMessage() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary, size: 64),
            const SizedBox(height: 16),
            Text('Message Sent!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Thank you for reaching out. I\'ll get back to you as soon as possible.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
                context.read<PortfolioBloc>().add(LoadPortfolioData());
              },
              child: Text('Send Another Message',
                  style: Theme.of(context).textTheme.labelMedium),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildContactInfo(BuildContext context, ContactInfoModel contactInfo) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Information',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: contactInfo.email ?? '',
              onTap: () async {
                final url = Uri.parse('mailto:${contactInfo.email ?? ''}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Medium', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialIcon(
                    FontAwesomeIcons.linkedin, contactInfo.linkedIn),
                _buildSocialIcon(FontAwesomeIcons.github, contactInfo.github),
                _buildSocialIcon(FontAwesomeIcons.twitter, contactInfo.twitter),
              ],
            ),
            const SizedBox(height: 24),
            if (contactInfo.calendlyLink.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(contactInfo.calendlyLink);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text('Schedule a Meeting',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 600.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: FaIcon(icon, color: Theme.of(context).colorScheme.primary),
      iconSize: 30,
      onPressed: () async {
        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
    );
  }
}
