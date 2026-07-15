import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/session/constants.dart';

const _maxNameLength = 30;

class SessionForm extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final DateTime initialStartedAt;
  final String submitButtonText;
  final Future<void> Function(
    String name,
    String description,
    DateTime startedAt,
  )
  onSubmit;
  final Widget? additionalActions;

  const SessionForm({
    super.key,
    required this.initialName,
    required this.initialDescription,
    required this.initialStartedAt,
    required this.submitButtonText,
    required this.onSubmit,
    this.additionalActions,
  });

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startedAtController = TextEditingController();

  late DateTime _selectedStartedAt = widget.initialStartedAt;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
    _startedAtController.text = formatFullDateTime(_selectedStartedAt);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startedAtController.dispose();
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
                const Gap(16),
                _buildDescriptionInput(form),
                const Gap(16),
                _buildStartedAtInput(form),
              ],
            ),
          ),
          if (widget.additionalActions != null) ...[
            widget.additionalActions!,
            const Gap(16),
          ],
          _buildSubmitButton(form),
        ],
      ),
    );
  }

  Future<void> _selectStartedAt() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedStartedAt),
    );
    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedStartedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
    _startedAtController.text = formatFullDateTime(_selectedStartedAt);
  }

  Widget _buildNameInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _nameController,
      label: 'Session Name',
      prefixIcon: Icons.celebration,
      maxLength: _maxNameLength,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name cannot be empty.';
        }
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters long.';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _descriptionController,
      label: 'Description',
      maxLength: maxSessionDescriptionLength,
      minLines: 3,
      maxLines: 7,
    );
  }

  Widget _buildStartedAtInput(LoadingFormState form) {
    return TextFormField(
      controller: _startedAtController,
      readOnly: true,
      enabled: !form.isLoading,
      onTap: _selectStartedAt,
      decoration: const InputDecoration(
        labelText: 'Start Time',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select when the session starts.';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(LoadingFormState form) {
    return form.buildSubmitButton(
      text: widget.submitButtonText,
      margin: const EdgeInsets.only(bottom: 16),
      onSubmit: () => widget.onSubmit(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _selectedStartedAt,
      ),
    );
  }
}
