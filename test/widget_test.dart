import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_store_app/core/utils/validators.dart';
import 'package:pet_store_app/data/model/category_model.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/data/model/pet_upload_image_response_model.dart';
import 'package:pet_store_app/data/model/tag_model.dart';
import 'package:pet_store_app/domain/entity/user_entity.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';
import 'package:pet_store_app/domain/repository/user_repository.dart';
import 'package:pet_store_app/domain/use_cases/add_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/create_user_use_case.dart';
import 'package:pet_store_app/domain/use_cases/get_pets_by_status_use_case.dart';
import 'package:pet_store_app/domain/use_cases/login_use_case.dart';
import 'package:pet_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:pet_store_app/presentation/bloc/login/login_event.dart'
    as login_events;
import 'package:pet_store_app/presentation/bloc/login/login_state.dart';
import 'package:pet_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:pet_store_app/presentation/bloc/register/register_event.dart'
    as register_events;
import 'package:pet_store_app/presentation/bloc/register/register_state.dart';
import 'package:pet_store_app/presentation/screen/onboarding_screen.dart';

class _FakePetRepository implements PetRepository {
  _FakePetRepository({List<PetModel>? initialPets}) : _pets = initialPets ?? [];

  final List<PetModel> _pets;

  @override
  Future<PetUploadImageResponseModel> uploadImage(
    int petId,
    String? metadata,
    File file,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<PetModel> addPet(PetModel pet) async {
    _pets.add(pet);
    return pet;
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async => pet;

  @override
  Future<List<PetModel>> getPetsByStatus(List<String> status) async {
    return _pets.where((pet) => status.contains(pet.status)).toList();
  }

  @override
  Future<PetModel> getPetById(int petId) async {
    return _pets.firstWhere((pet) => pet.id == petId);
  }

  @override
  Future<void> updatePetWithForm(
    int petId,
    String? name,
    String? status,
  ) async {}

  @override
  Future<void> deletePet(int petId, {String? apiKey}) async {}
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<void> createUser(UserEntity user) async {}

  @override
  Future<UserEntity> getUserByUsername(String username) async =>
      throw UnimplementedError();

  @override
  Future<UserEntity> login(String username, String password) async =>
      throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<void> updateUser(String username, UserEntity user) async {}
}

void main() {
  group('AppValidators', () {
    test('rejects invalid email and empty required fields', () {
      expect(
        AppValidators.validateRequired('', fieldName: 'email'),
        'Please enter email',
      );
      expect(
        AppValidators.validateEmail('invalid-email'),
        'Please enter a valid email',
      );
      expect(AppValidators.validateEmail('user@example.com'), isNull);
    });

    test('validates password and phone format', () {
      expect(
        AppValidators.validatePassword('123'),
        'Password must be at least 6 characters',
      );
      expect(AppValidators.validatePassword('password123'), isNull);
      expect(
        AppValidators.validatePhone('12345'),
        'Please enter a valid phone number',
      );
      expect(AppValidators.validatePhone('+1234567890'), isNull);
    });
  });

  group('Pet store use cases', () {
    test('GetPetsByStatusUseCase filters by status', () async {
      final pet = PetModel(
        id: 1,
        category: CategoryModel(id: 1, name: 'Dog'),
        name: 'Buddy',
        photoUrls: ['https://example.com/buddy.png'],
        tags: [const TagModel(id: 1, name: 'friendly')],
        status: 'available',
      );
      final repository = _FakePetRepository(initialPets: [pet]);
      final useCase = GetPetsByStatusUseCase(repository);

      final result = await useCase(['available']);

      expect(result, hasLength(1));
      expect(result.first.name, 'Buddy');
      expect(result.first.status, 'available');
    });

    test('AddPetUseCase delegates to repository', () async {
      final repository = _FakePetRepository();
      final useCase = AddPetUseCase(repository);
      final pet = PetModel(
        id: 7,
        category: CategoryModel(id: 2, name: 'Cat'),
        name: 'Milo',
        photoUrls: ['https://example.com/milo.png'],
        tags: [const TagModel(id: 2, name: 'playful')],
        status: 'pending',
      );

      final savedPet = await useCase(pet);

      expect(savedPet.id, 7);
      expect(savedPet.name, 'Milo');
      expect(savedPet.status, 'pending');
    });
  });

  group('Authentication BLoCs', () {
    test(
      'registration validation failure retains fields while editing',
      () async {
        final bloc = RegisterBloc(CreateUserUseCase(_FakeUserRepository()));

        Future<RegisterState> send(register_events.RegisterEvent event) {
          final nextState = bloc.stream.first;
          bloc.add(event);
          return nextState;
        }

        await send(register_events.UsernameChanged('mira'));
        await send(register_events.FirstNameChanged('Mira'));
        await send(register_events.LastNameChanged('Lee'));
        await send(register_events.EmailChanged('invalid-email'));
        await send(register_events.PasswordChanged('secret123'));
        await send(register_events.PhoneChanged('+1234567890'));

        final failureFuture = bloc.stream.first;
        bloc.add(register_events.SubmitRegisterEvent());
        final failure = await failureFuture as RegisterFailure;

        expect(failure.username, 'mira');
        expect(failure.firstName, 'Mira');
        expect(failure.lastName, 'Lee');
        expect(failure.email, 'invalid-email');
        expect(failure.password, 'secret123');
        expect(failure.phone, '+1234567890');

        final editedFuture = bloc.stream.first;
        bloc.add(register_events.EmailChanged('mira@example.com'));
        final editedState = await editedFuture;

        expect(editedState, isA<RegisterInitial>());
        expect(editedState.username, 'mira');
        expect(editedState.firstName, 'Mira');
        expect(editedState.lastName, 'Lee');
        expect(editedState.email, 'mira@example.com');
        expect(editedState.password, 'secret123');
        expect(editedState.phone, '+1234567890');

        await bloc.close();
      },
    );

    test('login field changes leave the failure state', () async {
      final bloc = LoginBloc(loginUseCase: LoginUseCase(_FakeUserRepository()));

      Future<LoginState> send(login_events.LoginEvent event) {
        final nextState = bloc.stream.first;
        bloc.add(event);
        return nextState;
      }

      await send(login_events.UsernameChanged('mira'));
      await send(login_events.PasswordChanged('short'));
      final failure = await send(login_events.SubmitLoginEvent());
      expect(failure, isA<LoginFailure>());

      final editedState = await send(login_events.PasswordChanged('secret123'));

      expect(editedState, isA<LoginInitial>());
      expect(editedState.username, 'mira');
      expect(editedState.password, 'secret123');

      await bloc.close();
    });
  });

  group('OnboardingScreen', () {
    testWidgets('shows final log in prompt and get started action', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    });
  });
}
