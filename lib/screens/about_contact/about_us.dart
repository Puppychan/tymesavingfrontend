import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero image or banner
            Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Ensures it spans the full width
              height: MediaQuery.of(context).size.height *
                  0.2, // 30% of screen height
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://drive.google.com/uc?export=view&id=1cXnNS5h14Mg8MKMCd3aHbXjkzD6kSiCF'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Mission Statement or Tagline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLabel("Our Mission", context),
                  const SizedBox(height: 10),
                  Text(
                    "Our mission is to enhance financial literacy among Vietnamese Gen Y and Gen Z through an innovative, user-friendly budget management app. We aim to bridge the financial knowledge gap by offering collaborative tools for effective money management, fostering positive financial habits, and integrating with popular digital payment platforms. By empowering young adults aged 18-42 with practical financial skills, we strive to contribute to their financial well-being and success in the digital economy.",
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.7, letterSpacing: 1.02),
                    textAlign: TextAlign.center,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Divider for sections
            const Divider(thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 20),
            // Supervisor Section
            _buildLabel("RMIT Supervisor", context),
            _buildTeamMemberCard(
              context,
              'https://drive.google.com/uc?export=view&id=1j8BYbqBzCDZRgpScfYnOpdgDywZUIQMf',
              'Anna Felipe',
              'RMIT Supervisor',
              'Full-time lecturer, offering coordinator, and program advisor at RMIT University',
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 20),
            _buildLabel("TymeX Supervisors", context),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTeamMemberCard(
                      context,
                      'https://drive.google.com/uc?export=view&id=1cTk-48jLV8xrQsqM1CAni5tEcHIM7sUL',
                      'Mr. Vuong Tran',
                      'TymeX Supervisor',
                      'Mobile Tech Lead',
                    ),
                    _buildTeamMemberCard(
                      context,
                      'https://ca.slack-edge.com/T05N3DA83HS-U072X8UFLDB-g82ba8e5573d-512',
                      'Mr. Tung Nguyen',
                      'TymeX Supervisor',
                      'UI/UX Advisor',
                    ),
                    _buildTeamMemberCard(
                      context,
                      'https://drive.google.com/uc?export=view&id=1EGFt1PwhTPx0dWEB6hssFPvv03Io_Iy8',
                      'Mr. Lanh Tran',
                      'TymeX Supervisor',
                      'Android Developer',
                    ),
                    _buildTeamMemberCard(
                      context,
                      'https://drive.google.com/uc?export=view&id=17rB-Cd3uJsrJ8KPXUZTdKGLeaRzEAN-P',
                      'Mr. Long Nguyen',
                      'TymeX Supervisor',
                      'Mobile Engineer',
                    ),
                    _buildTeamMemberCard(
                      context,
                      'https://drive.google.com/uc?export=view&id=162RjtbQLSdKT-crv-3HW0xX3KjagwW4v',
                      'Ms. Thuy Nguyen',
                      'TymeX Supervisor',
                      'DevOps Engineer',
                    ),
                  ]),
            ),
            // Team Section
            const SizedBox(height: 20),
            const Divider(thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 20),
            _buildLabel("Meet our Team", context),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTeamMemberCard(
                    context,
                    'https://drive.google.com/uc?export=view&id=1-veQV1CAnJmBKOm91Q6JW117axEzRnmV',
                    'Nhung Tran',
                    'Project Team Leader, Frontend & UI/UX',
                    'Software Engineering.',
                  ),
                  _buildTeamMemberCard(
                    context,
                    'https://drive.google.com/uc?export=view&id=1Jx91cgkQNN4mcwHqnnQJvwFIHIdpL2yV',
                    'Duong Giang',
                    'Project Frontend & UI/UX - Main Contact Point',
                    'Information Technology.',
                  ),
                  _buildTeamMemberCard(
                    context,
                    'https://drive.google.com/uc?export=view&id=12rAfSJhf3sUdQDNZdxYIcJ4tv7FOWZOb',
                    'Thong Vo',
                    'Project Frontend & UI/UX',
                    'Information Technology.',
                  ),
                  _buildTeamMemberCard(
                    context,
                    'https://drive.google.com/uc?export=view&id=18wfpepyhElFLO7YeGBNyegaVwxlb0uf2',
                    'Khanh Tran',
                    'Project Backend & Database',
                    'Software Engineering.',
                  ),
                  _buildTeamMemberCard(
                    context,
                    'https://drive.google.com/uc?export=view&id=1ci4hB6C8JvOxyVV0jTPzuyALBv3GLUzr',
                    'Anh Ngo',
                    'Project Backend & Database',
                    'Information Technology.',
                  ),
                  // Add more team members as needed
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, String imagePath,
      String name, String role, String bio) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.63,
      child: Card(
        color: colorScheme.background,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: isDark ? colorScheme.tertiary : colorScheme.divider, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            children: [
              // Team member image
              CustomCircleImage(
                imagePath: imagePath,
                radius: 50,
              ),
              const SizedBox(height: 7),
              // Team member info
              Text(
                name,
                style: textTheme.titleMedium,
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Text(
                role,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 10),
              Text(
                bio,
                style:
                    textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
