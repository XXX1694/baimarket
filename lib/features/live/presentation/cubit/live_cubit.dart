import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/live_logger.dart';
import '../../../../core/services/live_socket_service.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/live_stream_info.dart';

part 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  LiveCubit({
    LiveSocketService? service,
    LiveLogger? logger,
    Duration pollInterval = const Duration(seconds: 15),
  })  : _log = logger ?? const LiveLogger(),
        _service = service ?? LiveSocketService(logger: logger),
        _pollInterval = pollInterval,
        super(const LiveState.initial()) {
    _bindStreams();
    _startPolling();
  }

  final LiveSocketService _service;
  final LiveLogger _log;
  final Duration _pollInterval;

  final List<StreamSubscription<dynamic>> _subs = [];
  Timer? _poller;

  static const _maxChatBuffer = 100;

  void _bindStreams() {
    _subs.addAll([
      _service.connection.listen((connected) {
        emit(state.copyWith(isConnected: connected));
      }),
      _service.streamStarted.listen((info) {
        emit(state.copyWith(isStreamActive: true, streamInfo: info));
      }),
      _service.streamStopped.listen((_) {
        emit(state.copyWith(
          isStreamActive: false,
          clearStreamInfo: true,
          chatMessages: const [],
          viewerCount: 0,
          messageCount: 0,
        ));
      }),
      _service.viewerCount.listen((v) {
        emit(state.copyWith(viewerCount: v));
      }),
      _service.messageCount.listen((v) {
        emit(state.copyWith(messageCount: v));
      }),
      _service.chatHistory.listen((history) {
        emit(state.copyWith(chatMessages: history));
      }),
      _service.newMessage.listen((msg) {
        final list = [...state.chatMessages, msg];
        final trimmed = list.length > _maxChatBuffer
            ? list.sublist(list.length - _maxChatBuffer)
            : list;
        emit(state.copyWith(chatMessages: trimmed));
      }),
      _service.messageDeleted.listen((id) {
        final updated = state.chatMessages
            .map((m) => m.id == id ? m.copyWith(isDeleted: true) : m)
            .toList();
        emit(state.copyWith(chatMessages: updated));
      }),
      _service.socketError.listen((message) {
        emit(state.copyWith(lastError: message));
      }),
    ]);
  }

  void _startPolling() {
    _poller?.cancel();
    _log.poll('start polling every ${_pollInterval.inSeconds}s');
    _poller = Timer.periodic(_pollInterval, (_) => _onPollTick());
  }

  Future<void> _onPollTick() async {
    final connected = _service.isConnected;
    final active = state.isStreamActive;
    _log.poll(
      'tick',
      'connected=$connected, isStreamActive=$active, '
          'viewers=${state.viewerCount}',
    );
    if (!connected) {
      _log.poll('socket dead → reconnecting');
      final ok = await _service.connect();
      if (!ok) _log.poll('reconnect failed (no token?)');
      return;
    }
    if (!active) {
      // Просим бэк прислать текущий streamStarted, если стрим идёт.
      _service.requestStreamStatus();
    }
  }

  /// Поднимает соединение. Безопасно вызывать многократно.
  Future<void> connect() async {
    _log.info('connect() called');
    await _service.connect();
  }

  void sendMessage(String text) => _service.sendMessage(text);

  Future<void> disconnect() => _service.disconnect();

  /// Дёрнуть руками поллинг-тик (для pull-to-refresh).
  Future<void> refreshNow() => _onPollTick();

  @override
  Future<void> close() async {
    _log.info('cubit close()');
    _poller?.cancel();
    for (final s in _subs) {
      await s.cancel();
    }
    _service.dispose();
    return super.close();
  }
}
