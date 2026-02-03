import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/leaderboard/constants.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_icon_picker.dart';

class LeaderboardForm extends StatefulWidget {
  final String initialName;
  final LeaderboardIcon initialIcon;
  final String submitButtonText;
  final bool isEditing;
  final Future<void> Function(String name, LeaderboardIcon icon) onSubmit;

  const LeaderboardForm({
    super.key,
    required this.initialName,
    required this.initialIcon,
    required this.submitButtonText,
    required this.onSubmit,
    required this.isEditing,
  });

  @override
  State<LeaderboardForm> createState() => _LeaderboardFormState();
}

class _LeaderboardFormState extends State<LeaderboardForm> {
  final _nameController = TextEditingController();

  late LeaderboardIcon _selectedIcon = widget.initialIcon;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildNameInput(form),
                if (!widget.isEditing) ...[
                  const Gap(24),
                  LeaderboardIconPicker(
                    selectedIcon: _selectedIcon,
                    onIconSelected: (icon) =>
                        setState(() => _selectedIcon = icon),
                  ),
                ],
              ],
            ),
          ),
          _buildSubmitButton(form),
        ],
      ),
    );
  }

  Widget _buildNameInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _nameController,
      label: 'Leaderboard Name',
      prefixIcon: _selectedIcon.icon,
      maxLength: maxLeaderboardNameLength,
      isLastField: true,
      validator: _validateName,
    );
  }

  Widget _buildSubmitButton(LoadingFormState form) {
    return form.buildSubmitButton(
      text: widget.submitButtonText,
      margin: const EdgeInsets.only(bottom: 16),
      onSubmit: () =>
          widget.onSubmit(_nameController.text.trim(), _selectedIcon),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty.';
    }
    if (value.trim().length < minLeaderboardNameLength) {
      return 'Name must be at least $minLeaderboardNameLength characters long.';
    }
    return null;
  }
}
