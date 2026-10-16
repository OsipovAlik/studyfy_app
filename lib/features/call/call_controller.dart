import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/class_session.dart';

enum CallPhase { lobby, connecting, connected, ended }

/// Why the call ended, or why it never connected — covers both so one
/// outcome screen can show either.
enum CallEndReason {
  /// The user tapped Leave.
  left,

  /// Another device signed in as the same person joined this room.
  duplicate,

  /// The host removed this participant.
  removed,

  /// The room was closed (the server shut it down, or everyone left).
  roomClosed,

  /// The connection dropped and could not be resumed.
  lost,

  /// `404`: not a teacher or student of this class.
  forbidden,

  /// `503`: video is not switched on for this server.
  unavailable,

  /// Anything else that kept the call from connecting.
  error
  ;

  /// Reasons where trying again might work.
  bool get isRecoverable => switch (this) {
    CallEndReason.left ||
    CallEndReason.lost ||
    CallEndReason.unavailable ||
    CallEndReason.error => true,
    CallEndReason.duplicate ||
    CallEndReason.removed ||
    CallEndReason.roomClosed ||
    CallEndReason.forbidden => false,
  };
}

/// Owns the lobby preview, the LiveKit [Room] connection, and the call's
/// controls (mic, camera, leave) for one [session].
class CallController extends ChangeNotifier {
  CallController({
    required SessionsRepository repository,
    required this.session,
    required UserProfile user,
  }) : _repository = repository,
       _user = user;

  final SessionsRepository _repository;
  final ClassSession session;
  final UserProfile _user;

  CallPhase _phase = CallPhase.lobby;
  CallEndReason? _endReason;
  bool _micEnabled = true;
  bool _cameraEnabled = true;
  CameraPosition _cameraPosition = CameraPosition.front;
  LocalVideoTrack? _previewTrack;
  Room? _room;
  EventsListener<RoomEvent>? _roomListener;
  bool _preparingLobby = false;

  CallPhase get phase => _phase;
  CallEndReason? get endReason => _endReason;
  bool get micEnabled => _micEnabled;
  bool get cameraEnabled => _cameraEnabled;
  LocalVideoTrack? get previewTrack => _previewTrack;
  Room? get room => _room;
  bool get isTeacher => _user.role == UserRole.teacher;
  String get displayName =>
      _user.fullName.isEmpty ? _user.email : _user.fullName;

  /// Asks for camera/microphone permission and starts a preview. Safe to
  /// call more than once (e.g. re-entering the lobby after "Try again").
  Future<void> prepareLobby() async {
    if (_preparingLobby) return;
    _preparingLobby = true;
    _phase = CallPhase.lobby;
    _endReason = null;

    final micStatus = await Permission.microphone.request();
    _micEnabled = micStatus.isGranted;

    final cameraStatus = await Permission.camera.request();
    _cameraEnabled = cameraStatus.isGranted;
    if (_cameraEnabled) {
      try {
        _previewTrack = await LocalVideoTrack.createCameraTrack(
          CameraCaptureOptions(cameraPosition: _cameraPosition),
        );
      } on Exception catch (error) {
        debugPrint('Camera preview failed: $error');
        _cameraEnabled = false;
      }
    }
    _preparingLobby = false;
    notifyListeners();
  }

  Future<void> toggleMic() async {
    _micEnabled = !_micEnabled;
    notifyListeners();
    await _room?.localParticipant?.setMicrophoneEnabled(_micEnabled);
  }

  Future<void> toggleCamera() async {
    _cameraEnabled = !_cameraEnabled;
    final room = _room;
    if (room == null) {
      if (_cameraEnabled) {
        try {
          _previewTrack ??= await LocalVideoTrack.createCameraTrack(
            CameraCaptureOptions(cameraPosition: _cameraPosition),
          );
        } on Exception catch (error) {
          debugPrint('Camera preview failed: $error');
          _cameraEnabled = false;
        }
      } else {
        // Stopping (not just muting) releases the camera; drop the
        // reference too, so turning the camera back on creates a fresh
        // track instead of reusing — and failing to restart — this one.
        final track = _previewTrack;
        _previewTrack = null;
        await track?.stop();
        await track?.dispose();
      }
    } else {
      try {
        await room.localParticipant?.setCameraEnabled(
          _cameraEnabled,
          cameraCaptureOptions: CameraCaptureOptions(
            cameraPosition: _cameraPosition,
          ),
        );
      } on Exception catch (error) {
        debugPrint('setCameraEnabled failed: $error');
        _cameraEnabled = false;
      }
    }
    notifyListeners();
  }

  Future<void> switchCamera() async {
    // Nothing is capturing while the camera is hidden — the track was
    // stopped (lobby) or unpublished (in-call), so there's nothing to
    // restart with a new position. Just remember the choice for next
    // time the camera comes on.
    _cameraPosition = _cameraPosition.switched();
    if (!_cameraEnabled) {
      notifyListeners();
      return;
    }

    final room = _room;
    try {
      if (room != null) {
        // setCameraEnabled() only creates a track with these options for
        // a brand-new publication — for a camera that's already
        // published (true here) it just mutes/unmutes the existing
        // track, which restarts on the *same* camera it already had.
        // That looked like "switching" only because the local tile
        // force-mirrors regardless of which camera is active; the
        // picture itself never changed. setCameraPosition() is the
        // SDK's own call for this: it restarts the already-published
        // track with the new position.
        final publication = room.localParticipant?.getTrackPublicationBySource(
          TrackSource.camera,
        );
        final track = publication?.track;
        if (track is LocalVideoTrack) {
          await track.setCameraPosition(_cameraPosition);
        }
      } else if (_previewTrack != null) {
        // The lobby preview was never published, so it has no sender —
        // LocalVideoTrack.setCameraPosition() always throws
        // TrackCreateException('could not restart track') on it. Swap
        // in a freshly captured track instead.
        final old = _previewTrack;
        _previewTrack = null;
        await old?.stop();
        await old?.dispose();
        _previewTrack = await LocalVideoTrack.createCameraTrack(
          CameraCaptureOptions(cameraPosition: _cameraPosition),
        );
      }
    } on Exception catch (error) {
      debugPrint('switchCamera failed: $error');
      // Whichever branch this came from, the camera isn't capturing any
      // more: the lobby preview failed to recreate, or it was disabled
      // for the in-call re-publish and that re-publish itself failed.
      _cameraEnabled = false;
    }
    notifyListeners();
  }

  /// Fetches a join ticket and connects to the class's LiveKit room.
  Future<void> join() async {
    _phase = CallPhase.connecting;
    _endReason = null;
    notifyListeners();

    try {
      final ticket = await _repository.join(session.id);

      await _previewTrack?.stop();
      await _previewTrack?.dispose();
      _previewTrack = null;

      final room = Room(
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );
      _roomListener = room.createListener()
        ..on<RoomDisconnectedEvent>(_handleDisconnected);
      room.addListener(notifyListeners);
      await room.connect(ticket.url, ticket.token);
      _room = room;

      if (_cameraEnabled) {
        try {
          await room.localParticipant?.setCameraEnabled(
            true,
            cameraCaptureOptions: CameraCaptureOptions(
              cameraPosition: _cameraPosition,
            ),
          );
        } on Exception catch (error) {
          debugPrint('Could not publish video: $error');
          _cameraEnabled = false;
        }
      }
      if (_micEnabled) {
        await room.localParticipant?.setMicrophoneEnabled(true);
      }
      _phase = CallPhase.connected;
      notifyListeners();
    } on ApiException catch (error) {
      _phase = CallPhase.ended;
      _endReason = switch (error.statusCode) {
        404 => CallEndReason.forbidden,
        503 => CallEndReason.unavailable,
        _ => CallEndReason.error,
      };
      notifyListeners();
    } on Exception catch (error) {
      debugPrint('join() failed: $error');
      _phase = CallPhase.ended;
      _endReason = CallEndReason.error;
      notifyListeners();
    }
  }

  void _handleDisconnected(RoomDisconnectedEvent event) {
    _endReason = switch (event.reason) {
      DisconnectReason.clientInitiated => CallEndReason.left,
      DisconnectReason.duplicateIdentity => CallEndReason.duplicate,
      DisconnectReason.participantRemoved => CallEndReason.removed,
      DisconnectReason.roomDeleted ||
      DisconnectReason.roomClosed ||
      DisconnectReason.serverShutdown => CallEndReason.roomClosed,
      _ => CallEndReason.lost,
    };
    _phase = CallPhase.ended;
    notifyListeners();
  }

  Future<void> leave() async {
    if (_phase != CallPhase.connected) return;
    await _room?.disconnect();
    _phase = CallPhase.ended;
    _endReason ??= CallEndReason.left;
    notifyListeners();
  }

  /// Goes back to the lobby after a failed or ended call, to try again.
  Future<void> returnToLobby() => prepareLobby();

  @override
  void dispose() {
    unawaited(_roomListener?.dispose());
    final room = _room;
    if (room != null) {
      room.removeListener(notifyListeners);
      // Room has no dispose() of its own; disconnect() is what actually
      // tells the server and frees the camera/mic.
      unawaited(room.disconnect());
    }
    unawaited(_previewTrack?.dispose());
    super.dispose();
  }
}
