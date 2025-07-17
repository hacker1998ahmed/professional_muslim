import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 1.0;

  // Getters
  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  // Initialize audio service
  Future<void> initialize() async {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  // Play audio from assets
  Future<void> playAsset(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  // Play audio from file
  Future<void> playFile(String filePath) async {
    try {
      await _audioPlayer.play(DeviceFileSource(filePath));
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing audio file: $e');
    }
  }

  // Play audio from URL
  Future<void> playUrl(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing audio URL: $e');
    }
  }

  // Pause audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  // Resume audio
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  // Stop audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  // Seek to position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  // Get current position
  Future<Duration?> getCurrentPosition() async {
    try {
      return await _audioPlayer.getCurrentPosition();
    } catch (e) {
      debugPrint('Error getting position: $e');
      return null;
    }
  }

  // Get duration
  Future<Duration?> getDuration() async {
    try {
      return await _audioPlayer.getDuration();
    } catch (e) {
      debugPrint('Error getting duration: $e');
      return null;
    }
  }

  // Set playback rate
  Future<void> setPlaybackRate(double rate) async {
    try {
      await _audioPlayer.setPlaybackRate(rate);
    } catch (e) {
      debugPrint('Error setting playback rate: $e');
    }
  }

  // Dispose audio player
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
  }

  // Audio presets for different types
  
  // Play Adhan
  Future<void> playAdhan({String? customPath}) async {
    final path = customPath ?? 'audio/adhan.mp3';
    await setVolume(1.0);
    await playAsset(path);
  }

  // Play notification sound
  Future<void> playNotification() async {
    await setVolume(0.7);
    await playAsset('audio/notification.mp3');
  }

  // Play tasbih sound
  Future<void> playTasbihSound() async {
    await setVolume(0.5);
    await playAsset('audio/tasbih.mp3');
    // Add haptic feedback
    HapticFeedback.lightImpact();
  }

  // Play button click sound
  Future<void> playClickSound() async {
    await setVolume(0.3);
    await playAsset('audio/click.mp3');
    HapticFeedback.selectionClick();
  }

  // Play success sound
  Future<void> playSuccessSound() async {
    await setVolume(0.6);
    await playAsset('audio/success.mp3');
    HapticFeedback.mediumImpact();
  }

  // Play error sound
  Future<void> playErrorSound() async {
    await setVolume(0.6);
    await playAsset('audio/error.mp3');
    HapticFeedback.heavyImpact();
  }

  // Play Quran recitation
  Future<void> playQuranRecitation(String surahNumber, String ayahNumber) async {
    final path = 'audio/quran/surah_${surahNumber}_ayah_$ayahNumber.mp3';
    await setVolume(0.8);
    await playAsset(path);
  }

  // Play background nasheed
  Future<void> playNasheed(String nasheedPath) async {
    await setVolume(0.4);
    await playAsset(nasheedPath);
  }

  // Audio effects
  
  // Fade in
  Future<void> fadeIn({Duration duration = const Duration(seconds: 2)}) async {
    const steps = 20;
    const stepDuration = Duration(milliseconds: 100);
    
    for (int i = 0; i <= steps; i++) {
      final volume = (i / steps) * _volume;
      await _audioPlayer.setVolume(volume);
      await Future.delayed(stepDuration);
    }
  }

  // Fade out
  Future<void> fadeOut({Duration duration = const Duration(seconds: 2)}) async {
    const steps = 20;
    const stepDuration = Duration(milliseconds: 100);
    final currentVolume = _volume;
    
    for (int i = steps; i >= 0; i--) {
      final volume = (i / steps) * currentVolume;
      await _audioPlayer.setVolume(volume);
      await Future.delayed(stepDuration);
    }
    
    await stop();
    await setVolume(currentVolume); // Restore original volume
  }

  // Check if audio file exists
  Future<bool> audioExists(String assetPath) async {
    try {
      await rootBundle.load('assets/$assetPath');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get audio info
  Future<Map<String, dynamic>?> getAudioInfo(String assetPath) async {
    try {
      await playAsset(assetPath);
      final duration = await getDuration();
      await stop();
      
      return {
        'duration': duration,
        'path': assetPath,
        'exists': true,
      };
    } catch (e) {
      return {
        'duration': null,
        'path': assetPath,
        'exists': false,
        'error': e.toString(),
      };
    }
  }

  // Audio queue management
  final List<String> _audioQueue = [];
  int _currentIndex = 0;

  // Add to queue
  void addToQueue(String audioPath) {
    _audioQueue.add(audioPath);
  }

  // Play next in queue
  Future<void> playNext() async {
    if (_currentIndex < _audioQueue.length - 1) {
      _currentIndex++;
      await playAsset(_audioQueue[_currentIndex]);
    }
  }

  // Play previous in queue
  Future<void> playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playAsset(_audioQueue[_currentIndex]);
    }
  }

  // Clear queue
  void clearQueue() {
    _audioQueue.clear();
    _currentIndex = 0;
  }

  // Shuffle queue
  void shuffleQueue() {
    _audioQueue.shuffle();
    _currentIndex = 0;
  }

  // Get queue info
  Map<String, dynamic> getQueueInfo() {
    return {
      'queue': _audioQueue,
      'currentIndex': _currentIndex,
      'hasNext': _currentIndex < _audioQueue.length - 1,
      'hasPrevious': _currentIndex > 0,
    };
  }
}
