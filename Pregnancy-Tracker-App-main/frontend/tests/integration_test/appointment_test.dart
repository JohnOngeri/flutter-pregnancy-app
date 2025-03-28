import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/application/appointment/bloc/appointment_bloc.dart';
import 'package:frontend/domain/appointment/appointment_repository_interface.dart';
import 'package:frontend/presentation/appointments/appointment_page.dart';
import 'package:frontend/presentation/appointments/components/add_appointmentpage.dart';
import 'package:frontend/presentation/appointments/components/appointments_body.dart';
import 'package:frontend/presentation/appointments/components/edit_appointment_dialog.dart';
import 'package:mockito/mockito.dart';

class MockAppointmentRepositoryInterface extends Mock
    implements AppointmentRepositoryInterface {}

void main() {
  group('Integration Test', () {
    late AppointmentBloc appointmentBloc;
    late AppointmentRepositoryInterface appointmentRepository;

    setUp(() {
      appointmentRepository = MockAppointmentRepositoryInterface();
      appointmentBloc = AppointmentBloc(
          appointmentRepositoryInterface: appointmentRepository);
    });

    testWidgets('AddAppointmentPage integration test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AddAppointmentPage(),
        ),
      );

      // Find the form fields for entering appointment details
      final titleField = find.byKey(Key('appointmentTitleField'));
      final bodyField = find.byKey(Key('appointmentBodyField'));
      final dateField = find.byKey(Key('appointmentDateField'));
      final timeField = find.byKey(Key('appointmentTimeField'));
      final saveButton = find.byKey(Key('saveAppointmentButton'));

      // Ensure the fields are present
      expect(titleField, findsOneWidget);
      expect(bodyField, findsOneWidget);
      expect(dateField, findsOneWidget);
      expect(timeField, findsOneWidget);
      expect(saveButton, findsOneWidget);

      // Simulate user input
      await tester.enterText(titleField, 'New Appointment');
      await tester.enterText(bodyField, 'Appointment Details');
      await tester.enterText(dateField, '2023-06-02');
      await tester.enterText(timeField, '14:30');
      await tester.tap(saveButton);

      // Trigger a frame to ensure all changes are applied
      await tester.pumpAndSettle();

      // Verify that the appointment was saved, which might trigger a navigation or a success message
      expect(find.text('Appointment saved successfully!'),
          findsOneWidget); // Replace with expected behavior
    });

    testWidgets('AppointmentsPage integration test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentsPage(),
        ),
      );

      // Ensure the app displays the appointment list and necessary buttons
      final appointmentList = find.byType(ListView);
      final addAppointmentButton = find.byIcon(Icons.add);

      // Verify that the appointment list is present
      expect(appointmentList, findsOneWidget);
      expect(addAppointmentButton, findsOneWidget);

      // Simulate user clicking on the "Add Appointment" button
      await tester.tap(addAppointmentButton);
      await tester.pumpAndSettle();

      // Verify that it navigates to the AddAppointmentPage
      expect(find.byType(AddAppointmentPage), findsOneWidget);
    });

    testWidgets('EditAppointmentDialog integration test',
        (WidgetTester tester) async {
      final appointmentId = 'testAppointmentId';
      final initialTitle = 'Initial Title';
      final initialBody = 'Initial Body';
      final initialDate = '2023-06-02';
      final initialTime = '14:30';

      await tester.pumpWidget(
        MaterialApp(
          home: EditAppointmentDialog(
            initialTitle: initialTitle,
            initialBody: initialBody,
            initialDate: initialDate,
            initialTime: initialTime,
            appointmentId: appointmentId,
          ),
        ),
      );

      // Find and interact with the fields to update appointment details
      final titleField = find.byKey(Key('editAppointmentTitleField'));
      final bodyField = find.byKey(Key('editAppointmentBodyField'));
      final dateField = find.byKey(Key('editAppointmentDateField'));
      final timeField = find.byKey(Key('editAppointmentTimeField'));
      final saveButton = find.byKey(Key('saveEditedAppointmentButton'));

      // Ensure the fields are present
      expect(titleField, findsOneWidget);
      expect(bodyField, findsOneWidget);
      expect(dateField, findsOneWidget);
      expect(timeField, findsOneWidget);
      expect(saveButton, findsOneWidget);

      // Modify the appointment details and save
      await tester.enterText(titleField, 'Updated Title');
      await tester.enterText(bodyField, 'Updated Body');
      await tester.enterText(dateField, '2023-06-03');
      await tester.enterText(timeField, '15:00');
      await tester.tap(saveButton);

      // Trigger a frame to apply changes
      await tester.pumpAndSettle();

      // Verify that the appointment was updated, which might trigger a success message or navigation
      expect(find.text('Appointment updated successfully!'),
          findsOneWidget); // Replace with expected behavior
    });

    testWidgets('AppointmentsBody integration test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppointmentsBody(),
          ),
        ),
      );

      // Verify that the body displays the correct information, like appointment list
      final appointmentList = find.byType(ListView);

      // Ensure the list is present
      expect(appointmentList, findsOneWidget);

      // Verify that each appointment item is rendered correctly (e.g., by title)
      // You can mock the list of appointments and check for specific text
      expect(find.text('Test Appointment'),
          findsOneWidget); // Replace with actual mock data
    });
  });
}
