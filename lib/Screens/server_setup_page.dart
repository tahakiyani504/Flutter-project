import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerSetupPage extends StatefulWidget {
  const ServerSetupPage({super.key});

  @override
  State<ServerSetupPage> createState() => _ServerSetupPageState();
}

class _ServerSetupPageState extends State<ServerSetupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // ============================================================
  // REPLACE THIS URL LATER WITH YOUR REAL SERVER DOWNLOAD LINK
  // ============================================================
  static const String serverDownloadUrl =
      'https://yourwebsite.com/download/server';

  static const String serverWebsiteUrl =
      'https://yourwebsite.com';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(
          'Unable to open the link.',
          isError: true,
        );
      }
    } catch (e) {
      if (mounted) {
        _showMessage(
          'Unable to open the link.',
          isError: true,
        );
      }
    }
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline
                  : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _glassContainer({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueAccent.withOpacity(0.12),
            Colors.white.withOpacity(0.035),
          ],
        ),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.blueAccent.withOpacity(0.12),
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.18),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.blueAccent,
            size: 23,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.55),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step({
    required int number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.14),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.30),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: Colors.white.withOpacity(0.56),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.white.withOpacity(0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expandableCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.025),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 5,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blueAccent.withOpacity(0.10),
            ),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 21,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ),
          iconColor: Colors.blueAccent,
          collapsedIconColor: Colors.white54,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050816),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'PC Server Setup',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  8,
                  18,
                  30,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 650,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // HEADER
                        // ==================================================
                        _glassContainer(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent
                                          .withOpacity(0.30),
                                      Colors.blue
                                          .withOpacity(0.08),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.blueAccent
                                        .withOpacity(0.22),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent
                                          .withOpacity(0.16),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.computer_rounded,
                                  size: 38,
                                  color: Colors.blueAccent,
                                ),
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                'Connect Your PC',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Install the PC Controller Server on your '
                                    'Windows computer to control it from this app.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.white.withOpacity(0.55),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // SERVER STATUS
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.orange.withOpacity(0.07),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.18),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.orangeAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Server setup required',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Not Connected',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white
                                            .withOpacity(0.45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // DOWNLOAD BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    _openUrl(serverDownloadUrl);
                                  },
                                  icon: const Icon(
                                    Icons.download_rounded,
                                  ),
                                  label: const Text(
                                    'Download Windows Server',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                    Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(17),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // INSTALLATION
                        // ==================================================
                        _sectionTitle(
                          icon: Icons.install_desktop_rounded,
                          title: 'Get Started',
                          subtitle:
                          'Follow these simple steps to prepare your PC.',
                        ),

                        _expandableCard(
                          icon: Icons.download_rounded,
                          title: 'How to Install Server',
                          subtitle: 'Installation guide',
                          content: Column(
                            children: [
                              _step(
                                number: 1,
                                title: 'Download the Server',
                                description:
                                'Tap "Download Windows Server" and '
                                    'download the latest Windows installer.',
                              ),
                              _step(
                                number: 2,
                                title: 'Run the Installer',
                                description:
                                'Open the downloaded .exe file and '
                                    'follow the Windows installation steps.',
                              ),
                              _step(
                                number: 3,
                                title: 'Allow Windows Firewall',
                                description:
                                'When Windows asks for network access, '
                                    'allow the PC Controller Server through '
                                    'the firewall.',
                              ),
                              _step(
                                number: 4,
                                title: 'Start the Server',
                                description:
                                'Launch the PC Controller Server after '
                                    'installation. The server will wait for '
                                    'your mobile connection.',
                              ),
                              _step(
                                number: 5,
                                title: 'Connect Your Phone',
                                description:
                                'Keep your phone and PC connected to '
                                    'the same Wi-Fi network and use Auto '
                                    'Detect or enter the PC IP manually.',
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // HOW IT WORKS
                        // ==================================================
                        _expandableCard(
                          icon: Icons.account_tree_rounded,
                          title: 'How Does It Work?',
                          subtitle: 'Simple client-server connection',
                          content: Column(
                            children: [
                              const SizedBox(height: 4),

                              _bullet(
                                icon: Icons.phone_android_rounded,
                                text:
                                'Your Flutter mobile app acts as the '
                                    'controller.',
                              ),

                              _bullet(
                                icon: Icons.wifi_rounded,
                                text:
                                'Commands are sent through your local '
                                    'Wi-Fi network.',
                              ),

                              _bullet(
                                icon: Icons.computer_rounded,
                                text:
                                'The Windows Server receives those '
                                    'commands on your PC.',
                              ),

                              _bullet(
                                icon: Icons.mouse_rounded,
                                text:
                                'The server controls mouse and keyboard '
                                    'input.',
                              ),

                              _bullet(
                                icon: Icons.music_note_rounded,
                                text:
                                'Media and volume commands are handled '
                                    'by the PC server.',
                              ),

                              _bullet(
                                icon:
                                Icons.power_settings_new_rounded,
                                text:
                                'Power commands can restart, sleep or '
                                    'shut down the PC.',
                              ),

                              const SizedBox(height: 5),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  color: Colors.blueAccent
                                      .withOpacity(0.07),
                                  border: Border.all(
                                    color: Colors.blueAccent
                                        .withOpacity(0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      size: 19,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'For the current version, your '
                                            'phone and PC should be on the '
                                            'same local Wi-Fi network.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.4,
                                          color: Colors.white
                                              .withOpacity(0.58),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // TROUBLESHOOTING
                        // ==================================================
                        _expandableCard(
                          icon: Icons.build_circle_outlined,
                          title: 'Troubleshooting',
                          subtitle: 'Having connection problems?',
                          content: Column(
                            children: [
                              _bullet(
                                icon: Icons.wifi_rounded,
                                text:
                                'Make sure your phone and PC are on '
                                    'the same Wi-Fi network.',
                              ),
                              _bullet(
                                icon: Icons.play_circle_outline_rounded,
                                text:
                                'Make sure the PC Controller Server '
                                    'is running.',
                              ),
                              _bullet(
                                icon: Icons.security_rounded,
                                text:
                                'Check that Windows Firewall is not '
                                    'blocking the server.',
                              ),
                              _bullet(
                                icon: Icons.search_rounded,
                                text:
                                'Try Auto Detect from the connection '
                                    'screen.',
                              ),
                              _bullet(
                                icon: Icons.edit_rounded,
                                text:
                                'If Auto Detect does not find the PC, '
                                    'use the PC IP address manually.',
                              ),
                              _bullet(
                                icon: Icons.restart_alt_rounded,
                                text:
                                'Restart the server if it is not '
                                    'responding.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // WEBSITE / HELP
                        // ==================================================
                        _glassContainer(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(13),
                                      color: Colors.blueAccent
                                          .withOpacity(0.10),
                                    ),
                                    child: const Icon(
                                      Icons.help_outline_rounded,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Need More Help?',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Visit the official PC Controller '
                                              'server page.',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _openUrl(serverWebsiteUrl);
                                  },
                                  icon: const Icon(
                                    Icons.open_in_new_rounded,
                                    size: 19,
                                  ),
                                  label: const Text(
                                    'Open Server Website',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                    Colors.blueAccent,
                                    side: BorderSide(
                                      color: Colors.blueAccent
                                          .withOpacity(0.30),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ==================================================
                        // VERSION
                        // ==================================================
                        Center(
                          child: Text(
                            'PC Controller Server • v1.0.0',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.28),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}