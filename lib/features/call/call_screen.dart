import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/call/call_controller.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The video-class screen: a lobby to check camera/mic, then the call
/// itself, pushed full screen over the tab bar.
class CallScreen extends StatefulWidget {
  const CallScreen({required this.session, super.key});

  final ClassSession session;

  static Future<void> open(BuildContext context, ClassSession session) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CallScreen(session: session),
      ),
    );
  }

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final CallController _controller = CallController(
    repository: context.read<SessionsRepository>(),
    session: widget.session,
    user: context.read<AuthController>().user!,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_controller.prepareLobby());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: const _CallScaffold(),
    );
  }
}

class _CallScaffold extends StatelessWidget {
  const _CallScaffold();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CallController>();
    return Scaffold(
      backgroundColor: AppColors.deepAbyss,
      body: SafeArea(
        child: switch (controller.phase) {
          CallPhase.lobby => const _LobbyView(),
          CallPhase.connecting => const _ConnectingView(),
          CallPhase.connected => const _ConnectedView(),
          CallPhase.ended => const _EndedView(),
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          ),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

class _LobbyView extends StatelessWidget {
  const _LobbyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<CallController>();
    final session = controller.session;

    return Column(
      children: [
        const _TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: _CameraPreview(controller: controller),
                  ),
                ),
                const SizedBox(height: 16),
                _LobbyControls(controller: controller),
                const SizedBox(height: 28),
                Text(
                  l10n.callLobbyTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.callLobbySubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  session.type == SessionType.group ? l10n.callGroupSession : l10n.callIndividualSession,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.indigo300,
                  ),
                ),
                Text(
                  l10n.callWeekly(
                    session.dayOfWeek.label(l10n),
                    session.startTime,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.callJoinAs(controller.displayName),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                if (controller.isTeacher) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.callHostNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  l10n.callOneDeviceNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => unawaited(controller.join()),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.indigo600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: Text(l10n.callJoinNow),
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({required this.controller});

  final CallController controller;

  @override
  Widget build(BuildContext context) {
    final track = controller.previewTrack;
    if (controller.cameraEnabled && track != null) {
      return VideoTrackRenderer(track, fit: VideoViewFit.cover);
    }
    return ColoredBox(
      color: AppColors.indigo950,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InitialsAvatar(name: controller.displayName),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).callCameraOff,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _LobbyControls extends StatelessWidget {
  const _LobbyControls({required this.controller});

  final CallController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundButton(
          icon: controller.micEnabled ? CupertinoIcons.mic_fill : CupertinoIcons.mic_slash_fill,
          active: controller.micEnabled,
          tooltip: controller.micEnabled ? l10n.callTurnOffMic : l10n.callTurnOnMic,
          onPressed: () => unawaited(controller.toggleMic()),
        ),
        const SizedBox(width: 16),
        _RoundButton(
          icon: controller.cameraEnabled ? CupertinoIcons.video_camera_solid : CupertinoIcons.video_camera,
          active: controller.cameraEnabled,
          tooltip: controller.cameraEnabled ? l10n.callTurnOffCamera : l10n.callTurnOnCamera,
          onPressed: () => unawaited(controller.toggleCamera()),
        ),
        const SizedBox(width: 16),
        _RoundButton(
          icon: CupertinoIcons.switch_camera,
          active: true,
          tooltip: l10n.callSwitchCamera,
          onPressed: controller.cameraEnabled ? () => unawaited(controller.switchCamera()) : null,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.active,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final bool active;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? Colors.white12 : AppColors.red500.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(
          icon,
          color: onPressed == null ? Colors.white38 : Colors.white,
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.indigo600,
      child: Text(
        initial,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}

class _ConnectingView extends StatelessWidget {
  const _ConnectingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const _TopBar(),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: Colors.white70),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(
            l10n.callJoining,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class _ConnectedView extends StatelessWidget {
  const _ConnectedView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CallController>();
    final room = controller.room;
    final local = room?.localParticipant;
    final remotes = room?.remoteParticipants.values.toList() ?? const [];
    final participants = <Participant>[?local, ...remotes];
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        _TopBar(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: AppColors.red500,
                  shape: BoxShape.circle,
                ),
              ),
              Text(l10n.callLive, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 12),
              const Icon(
                CupertinoIcons.person_2_fill,
                size: 15,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                '${participants.length}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: participants.length <= 1
                ? _AloneState(hasLocal: local != null)
                : _ParticipantGrid(
                    participants: participants,
                    localIdentity: local?.identity,
                  ),
          ),
        ),
        _CallControls(controller: controller),
      ],
    );
  }
}

class _AloneState extends StatelessWidget {
  const _AloneState({required this.hasLocal});

  final bool hasLocal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<CallController>();
    final local = controller.room?.localParticipant;
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: local != null
                ? _ParticipantTile(
                    participant: local,
                    isLocal: true,
                    displayName: controller.displayName,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.callAloneTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.callAloneDescription,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }
}

class _ParticipantGrid extends StatelessWidget {
  const _ParticipantGrid({
    required this.participants,
    required this.localIdentity,
  });

  final List<Participant> participants;
  final String? localIdentity;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CallController>();
    final count = participants.length;
    final crossAxisCount = count <= 2 ? 1 : (count <= 4 ? 2 : 3);

    return GridView.builder(
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: crossAxisCount == 1 ? 16 / 10 : 1,
      ),
      itemBuilder: (context, index) {
        final participant = participants[index];
        final isLocal = participant.identity == localIdentity;
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _ParticipantTile(
            participant: participant,
            isLocal: isLocal,
            displayName: isLocal ? controller.displayName : participant.name,
          ),
        );
      },
    );
  }
}

class _ParticipantTile extends StatefulWidget {
  const _ParticipantTile({
    required this.participant,
    required this.isLocal,
    required this.displayName,
  });

  final Participant participant;
  final bool isLocal;
  final String displayName;

  @override
  State<_ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<_ParticipantTile> {
  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_onChange);
  }

  @override
  void didUpdateWidget(covariant _ParticipantTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participant != widget.participant) {
      oldWidget.participant.removeListener(_onChange);
      widget.participant.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final participant = widget.participant;
    final cameraPub = participant.getTrackPublicationBySource(
      TrackSource.camera,
    );
    final track = cameraPub?.track;
    final videoTrack = track is VideoTrack ? track : null;
    final showVideo = videoTrack != null && !(cameraPub?.muted ?? true);
    final micPub = participant.getTrackPublicationBySource(
      TrackSource.microphone,
    );
    final isMuted = micPub?.muted ?? true;
    final name = widget.displayName.isEmpty ? participant.identity : widget.displayName;
    final isHost = widget.isLocal && context.read<CallController>().isTeacher;

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.indigo950),
        if (showVideo)
          VideoTrackRenderer(
            videoTrack,
            fit: VideoViewFit.cover,
            // auto mirrors only the front camera (selfie-style); forcing
            // it on for every local tile meant the back camera stayed
            // mirrored too, which is backwards.
          )
        else
          Center(child: _InitialsAvatar(name: name)),
        Positioned(
          left: 8,
          bottom: 8,
          right: 8,
          child: Row(
            children: [
              if (isMuted)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    CupertinoIcons.mic_slash_fill,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isHost ? '$name · ${l10n.callHost}' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CallControls extends StatelessWidget {
  const _CallControls({required this.controller});

  final CallController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RoundButton(
            icon: controller.micEnabled ? CupertinoIcons.mic_fill : CupertinoIcons.mic_slash_fill,
            active: controller.micEnabled,
            tooltip: controller.micEnabled ? l10n.callTurnOffMic : l10n.callTurnOnMic,
            onPressed: () => unawaited(controller.toggleMic()),
          ),
          const SizedBox(width: 14),
          _RoundButton(
            icon: controller.cameraEnabled ? CupertinoIcons.video_camera_solid : CupertinoIcons.video_camera,
            active: controller.cameraEnabled,
            tooltip: controller.cameraEnabled ? l10n.callTurnOffCamera : l10n.callTurnOnCamera,
            onPressed: () => unawaited(controller.toggleCamera()),
          ),
          const SizedBox(width: 14),
          _RoundButton(
            icon: CupertinoIcons.switch_camera,
            active: true,
            tooltip: l10n.callSwitchCamera,
            onPressed: controller.cameraEnabled ? () => unawaited(controller.switchCamera()) : null,
          ),
          const SizedBox(width: 14),
          Material(
            color: AppColors.red500,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: l10n.callLeave,
              onPressed: () => unawaited(controller.leave()),
              icon: const Icon(
                CupertinoIcons.phone_down_fill,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndedView extends StatelessWidget {
  const _EndedView();

  ({IconData icon, String title, String description}) _outcome(
    CallEndReason reason,
    AppLocalizations l10n,
  ) => switch (reason) {
    CallEndReason.left => (
      icon: CupertinoIcons.phone_down_fill,
      title: l10n.callLeftTitle,
      description: l10n.callLeftDescription,
    ),
    CallEndReason.duplicate => (
      icon: CupertinoIcons.exclamationmark_circle,
      title: l10n.callDuplicateTitle,
      description: l10n.callDuplicateDescription,
    ),
    CallEndReason.removed => (
      icon: CupertinoIcons.xmark_circle,
      title: l10n.callRemovedTitle,
      description: l10n.callRemovedDescription,
    ),
    CallEndReason.roomClosed => (
      icon: CupertinoIcons.xmark_circle,
      title: l10n.callEndedTitle,
      description: l10n.callEndedDescription,
    ),
    CallEndReason.lost => (
      icon: CupertinoIcons.wifi_slash,
      title: l10n.callLostTitle,
      description: l10n.callLostDescription,
    ),
    CallEndReason.forbidden => (
      icon: CupertinoIcons.lock_fill,
      title: l10n.callForbiddenTitle,
      description: l10n.callForbiddenDescription,
    ),
    CallEndReason.unavailable => (
      icon: CupertinoIcons.video_camera,
      title: l10n.callUnavailableTitle,
      description: l10n.callUnavailableDescription,
    ),
    CallEndReason.error => (
      icon: CupertinoIcons.exclamationmark_triangle,
      title: l10n.callErrorTitle,
      description: l10n.callErrorDescription,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<CallController>();
    final reason = controller.endReason ?? CallEndReason.left;
    final outcome = _outcome(reason, l10n);

    return Column(
      children: [
        const _TopBar(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(outcome.icon, size: 52, color: Colors.white70),
                  const SizedBox(height: 18),
                  Text(
                    outcome.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    outcome.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  if (reason.isRecoverable) ...[
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: () => unawaited(controller.returnToLobby()),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.indigo600,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        reason == CallEndReason.left ? l10n.callRejoin : l10n.callTryAgain,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
