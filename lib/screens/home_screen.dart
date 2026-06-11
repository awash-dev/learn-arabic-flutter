import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/storage.dart';
import 'login_screen.dart';

// ─── Page definitions ─────────────────────────────────────────────────────────
// Each entry maps a page number label to its image filename and audio filename.
// Names match exactly what is on disk inside assets/images/ and assets/audio/.

class _PageDef {
  final String label;   // display label in picker
  final String image;   // e.g. "assets/images/1.jpg"
  final String? audio;  // e.g. "assets/audio/arabic 1.m4a" — null if no audio

  const _PageDef({required this.label, required this.image, this.audio});
}

// Build the ordered page list.
// Images on disk: 1-18, 16+, 18+, 19-41 (no 39)
// Audio on disk:  arabic 1-41 (with 16+, 18+, no 8, no 39)
const List<_PageDef> _pages = [
  _PageDef(label: '1',   image: 'assets/images/1.jpg',   audio: 'assets/audio/arabic 1.m4a'),
  _PageDef(label: '2',   image: 'assets/images/2.jpg',   audio: 'assets/audio/arabic 2.m4a'),
  _PageDef(label: '3',   image: 'assets/images/3.jpg',   audio: 'assets/audio/arabic 3.m4a'),
  _PageDef(label: '4',   image: 'assets/images/4.jpg',   audio: 'assets/audio/arabic 4.m4a'),
  _PageDef(label: '5',   image: 'assets/images/5.jpg',   audio: 'assets/audio/arabic 5.m4a'),
  _PageDef(label: '6',   image: 'assets/images/6.jpg',   audio: 'assets/audio/arabic 6.m4a'),
  _PageDef(label: '7',   image: 'assets/images/7.jpg',   audio: 'assets/audio/arabic 7.m4a'),
  _PageDef(label: '8',   image: 'assets/images/8.jpg',   audio: null), // no audio 8
  _PageDef(label: '9',   image: 'assets/images/9.jpg',   audio: 'assets/audio/arabic 9.m4a'),
  _PageDef(label: '10',  image: 'assets/images/10.jpg',  audio: 'assets/audio/arabic 10.m4a'),
  _PageDef(label: '11',  image: 'assets/images/11.jpg',  audio: 'assets/audio/arabic 11.m4a'),
  _PageDef(label: '12',  image: 'assets/images/12.jpg',  audio: 'assets/audio/arabic 12.m4a'),
  _PageDef(label: '13',  image: 'assets/images/13.jpg',  audio: 'assets/audio/arabic 13.m4a'),
  _PageDef(label: '14',  image: 'assets/images/14.jpg',  audio: 'assets/audio/arabic 14.m4a'),
  _PageDef(label: '15',  image: 'assets/images/15.jpg',  audio: 'assets/audio/arabic 15.m4a'),
  _PageDef(label: '16',  image: 'assets/images/16.jpg',  audio: 'assets/audio/arabic 16.m4a'),
  _PageDef(label: '16+', image: 'assets/images/16+.jpg', audio: 'assets/audio/arabic 16+.m4a'),
  _PageDef(label: '17',  image: 'assets/images/17.jpg',  audio: 'assets/audio/arabic 17.m4a'),
  _PageDef(label: '18',  image: 'assets/images/18.jpg',  audio: 'assets/audio/arabic 18.m4a'),
  _PageDef(label: '18+', image: 'assets/images/18+.jpg', audio: 'assets/audio/arabic 18+.m4a'),
  _PageDef(label: '19',  image: 'assets/images/19.jpg',  audio: 'assets/audio/arabic 19.m4a'),
  _PageDef(label: '20',  image: 'assets/images/20.jpg',  audio: 'assets/audio/arabic 20.m4a'),
  _PageDef(label: '21',  image: 'assets/images/21.jpg',  audio: 'assets/audio/arabic 21.m4a'),
  _PageDef(label: '22',  image: 'assets/images/22.jpg',  audio: 'assets/audio/arabic 22.m4a'),
  _PageDef(label: '23',  image: 'assets/images/23.jpg',  audio: 'assets/audio/arabic 23.m4a'),
  _PageDef(label: '24',  image: 'assets/images/24.jpg',  audio: 'assets/audio/arabic 24.m4a'),
  _PageDef(label: '25',  image: 'assets/images/25.jpg',  audio: 'assets/audio/arabic 25.m4a'),
  _PageDef(label: '26',  image: 'assets/images/26.jpg',  audio: 'assets/audio/arabic 26.m4a'),
  _PageDef(label: '27',  image: 'assets/images/27.jpg',  audio: 'assets/audio/arabic 27.m4a'),
  _PageDef(label: '28',  image: 'assets/images/28.jpg',  audio: 'assets/audio/arabic 28.m4a'),
  _PageDef(label: '29',  image: 'assets/images/29.jpg',  audio: 'assets/audio/arabic 29.m4a'),
  _PageDef(label: '30',  image: 'assets/images/30.jpg',  audio: 'assets/audio/arabic 30.m4a'),
  _PageDef(label: '31',  image: 'assets/images/31.jpg',  audio: 'assets/audio/arabic 31.m4a'),
  _PageDef(label: '32',  image: 'assets/images/32.jpg',  audio: 'assets/audio/arabic 32.m4a'),
  _PageDef(label: '33',  image: 'assets/images/33.jpg',  audio: 'assets/audio/arabic 33.m4a'),
  _PageDef(label: '34',  image: 'assets/images/34.jpg',  audio: 'assets/audio/arabic 34.m4a'),
  _PageDef(label: '35',  image: 'assets/images/35.jpg',  audio: 'assets/audio/arabic 35.m4a'),
  _PageDef(label: '36',  image: 'assets/images/36.jpg',  audio: 'assets/audio/arabic 36.m4a'),
  _PageDef(label: '37',  image: 'assets/images/37.jpg',  audio: 'assets/audio/arabic 37.m4a'),
  _PageDef(label: '38',  image: 'assets/images/38.jpg',  audio: 'assets/audio/arabic 38.m4a'),
  // no image 39 and no audio 39 — skipped
  _PageDef(label: '40',  image: 'assets/images/40.jpg',  audio: 'assets/audio/arabic 40.m4a'),
  _PageDef(label: '41',  image: 'assets/images/41.jpg',  audio: 'assets/audio/arabic 41.m4a'),
];

final int _total = _pages.length;

// ─── HomeScreen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0; // index into _pages list
  final _player = AudioPlayer();
  bool _playing = false;
  bool _pickerVisible = false;
  bool _looping = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late PageController _pageController;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _player.durationStream.listen((dur) {
      if (mounted) setState(() => _duration = dur ?? Duration.zero);
    });
    _player.playingStream.listen((playing) {
      if (mounted) setState(() => _playing = playing);
    });
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _playing = false;
            _position = Duration.zero;
          });
        }
      }
    });

    // Load the first page that has audio
    await _loadAudioForPage(_pageIndex, autoPlay: false);
  }

  /// Load audio for the given page index. Returns silently if no audio.
  Future<void> _loadAudioForPage(int index, {bool autoPlay = false}) async {
    final audio = _pages[index].audio;
    if (audio == null) {
      // No audio for this page — reset player state
      await _player.stop();
      setState(() {
        _duration = Duration.zero;
        _position = Duration.zero;
        _playing = false;
      });
      return;
    }
    try {
      await _player.setAudioSource(AudioSource.asset(audio));
      await _player.seek(Duration.zero);
      if (autoPlay) await _player.play();
    } catch (e) {
      debugPrint('Audio load error for $audio: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _player.dispose();
    super.dispose();
  }

  /// Navigate to a specific page index.
  Future<void> _goTo(int index) async {
    if (index < 0 || index >= _total) return;
    final wasPlaying = _playing;
    await _player.stop();
    setState(() {
      _pageIndex = index;
      _pickerVisible = false;
      _position = Duration.zero;
      _duration = Duration.zero;
      _playing = false;
    });
    if (_pageController.hasClients &&
        (_pageController.page?.round() ?? 0) != index) {
      _pageController.jumpToPage(index);
    }
    await _loadAudioForPage(index, autoPlay: wasPlaying);
  }

  Future<void> _onPageSwiped(int index) async {
    if (index == _pageIndex) return;
    final wasPlaying = _playing;
    await _player.stop();
    setState(() {
      _pageIndex = index;
      _position = Duration.zero;
      _duration = Duration.zero;
      _playing = false;
    });
    await _loadAudioForPage(index, autoPlay: wasPlaying);
  }

  Future<void> _handlePlayPause() async {
    final audio = _pages[_pageIndex].audio;
    if (audio == null) return; // no audio for this page
    if (_playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _handleStop() async {
    await _player.pause();
    await _player.seek(Duration.zero);
    setState(() => _position = Duration.zero);
  }

  Future<void> _handleLoop() async {
    final next = !_looping;
    setState(() => _looping = next);
    await _player.setLoopMode(next ? LoopMode.one : LoopMode.off);
  }

  Future<void> _jumpBackward() async {
    final newPos = Duration(
        milliseconds: (_position.inMilliseconds - 10000)
            .clamp(0, _duration.inMilliseconds));
    await _player.seek(newPos);
  }

  Future<void> _jumpForward() async {
    final newPos = Duration(
        milliseconds: (_position.inMilliseconds + 10000)
            .clamp(0, _duration.inMilliseconds));
    await _player.seek(newPos);
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _handleLogout() async {
    await _player.stop();
    await Storage.clearLoggedIn();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final currentPage = _pages[_pageIndex];
    final hasAudio = currentPage.audio != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0a1912),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            // ── Page image with swipe ──────────────────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: _controlsVisible ? padding.top + 60 : 0,
              bottom: _controlsVisible ? padding.bottom + 182 : 0,
              left: _controlsVisible ? 18 : 0,
              right: _controlsVisible ? 18 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF6E8),
                  borderRadius:
                      BorderRadius.circular(_controlsVisible ? 16 : 0),
                  border: _controlsVisible
                      ? Border.all(color: const Color(0x38D4AF37), width: 1.2)
                      : null,
                  boxShadow: _controlsVisible
                      ? const [
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 14,
                              offset: Offset(0, 10))
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(_controlsVisible ? 16 : 0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _total,
                    reverse: true, // Arabic right-to-left reading
                    onPageChanged: _onPageSwiped,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => setState(
                            () => _controlsVisible = !_controlsVisible),
                        child: Image.asset(
                          _pages[index].image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFFAF6E8),
                            child: Center(
                              child: Text(
                                _pages[index].label,
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Top bar ───────────────────────────────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: _controlsVisible ? padding.top + 8 : -60.0,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _controlsVisible ? 1.0 : 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleBtn(Icons.logout, _handleLogout),
                    GestureDetector(
                      onTap: () => setState(() => _pickerVisible = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.list,
                                color: Color(0xFF0a1912), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${currentPage.label} / ${_pages.last.label}',
                              style: const TextStyle(
                                  color: Color(0xFF0a1912),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Player panel ──────────────────────────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _controlsVisible ? padding.bottom + 12 : -220.0,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _controlsVisible ? 1.0 : 0.0,
                child: _buildPlayerPanel(hasAudio: hasAudio),
              ),
            ),

            // ── Page picker modal ─────────────────────────────────────
            if (_pickerVisible) _buildPicker(padding),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xD00a1912),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x4DD4AF37)),
        ),
        child: Icon(icon, color: const Color(0xFFD4AF37), size: 22),
      ),
    );
  }

  Widget _buildPlayerPanel({required bool hasAudio}) {
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xF20a1912),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x38D4AF37), width: 1.2),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── No audio indicator ──
          if (!hasAudio)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volume_off_rounded,
                      color: Color(0x66D4AF37), size: 16),
                  SizedBox(width: 6),
                  Text('No audio for this page',
                      style:
                          TextStyle(color: Color(0x66D4AF37), fontSize: 12)),
                ],
              ),
            ),

          // ── Slider ──
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD4AF37),
              inactiveTrackColor: Colors.white12,
              thumbColor: const Color(0xFFD4AF37),
              overlayColor: const Color(0x22D4AF37),
              trackHeight: 3.5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: progress,
              onChanged: hasAudio
                  ? (v) {
                      final ms = (v * _duration.inMilliseconds).round();
                      _player.seek(Duration(milliseconds: ms));
                    }
                  : null,
            ),
          ),

          // ── Time row ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(_position),
                    style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                Text(_formatTime(_duration),
                    style: const TextStyle(
                        color: Color(0x99D4AF37),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Controls row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Loop
              _iconBtn(
                  icon: Icons.repeat,
                  onTap: hasAudio ? _handleLoop : () {},
                  active: _looping && hasAudio,
                  enabled: hasAudio),
              // -10s
              _labeledIconBtn(
                  icon: Icons.replay_10,
                  label: '-10s',
                  onTap: hasAudio ? _jumpBackward : () {},
                  enabled: hasAudio),
              // Prev
              IconButton(
                onPressed: _pageIndex > 0 ? () => _goTo(_pageIndex - 1) : null,
                icon: Icon(Icons.skip_previous_rounded,
                    color: _pageIndex > 0
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF3a4a40),
                    size: 28),
                padding: EdgeInsets.zero,
              ),
              // Play / Pause
              GestureDetector(
                onTap: hasAudio ? _handlePlayPause : null,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: hasAudio
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF2a3a30),
                    shape: BoxShape.circle,
                    boxShadow: hasAudio
                        ? const [
                            BoxShadow(
                                color: Color(0x73D4AF37),
                                blurRadius: 10,
                                offset: Offset(0, 4))
                          ]
                        : null,
                  ),
                  child: Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: hasAudio
                        ? const Color(0xFF0a1912)
                        : const Color(0xFF3a4a40),
                    size: 34,
                  ),
                ),
              ),
              // Next
              IconButton(
                onPressed:
                    _pageIndex < _total - 1 ? () => _goTo(_pageIndex + 1) : null,
                icon: Icon(Icons.skip_next_rounded,
                    color: _pageIndex < _total - 1
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF3a4a40),
                    size: 28),
                padding: EdgeInsets.zero,
              ),
              // +10s
              _labeledIconBtn(
                  icon: Icons.forward_10,
                  label: '+10s',
                  onTap: hasAudio ? _jumpForward : () {},
                  enabled: hasAudio),
              // Stop
              _iconBtn(
                  icon: Icons.stop_rounded,
                  onTap: hasAudio ? _handleStop : () {},
                  active: false,
                  enabled: hasAudio),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool active,
    bool enabled = true,
    double size = 22,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD4AF37) : Colors.white10,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active
              ? const Color(0xFF0a1912)
              : enabled
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF3a4a40),
          size: size,
        ),
      ),
    );
  }

  Widget _labeledIconBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: enabled
                ? const Color(0xFFD4AF37)
                : const Color(0xFF3a4a40),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                color: enabled
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF3a4a40),
                fontSize: 9,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(EdgeInsets padding) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _pickerVisible = false),
            child: Container(color: Colors.black54),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55),
              padding: EdgeInsets.fromLTRB(16, 12, 16, padding.bottom + 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0f2519),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: Color(0x33D4AF37), width: 1.5),
                  left: BorderSide(color: Color(0x33D4AF37), width: 1.5),
                  right: BorderSide(color: Color(0x33D4AF37), width: 1.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x59D4AF37),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Select Page',
                      style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: _total,
                      itemBuilder: (_, i) {
                        final active = i == _pageIndex;
                        final hasAud = _pages[i].audio != null;
                        return GestureDetector(
                          onTap: () => _goTo(i),
                          child: Container(
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFFD4AF37)
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? const Color(0xFFD4AF37)
                                    : Colors.white12,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  _pages[i].label,
                                  style: TextStyle(
                                    color: active
                                        ? const Color(0xFF0a1912)
                                        : const Color(0xFFD4AF37),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                // small dot at bottom-right if no audio
                                if (!hasAud)
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFF0a1912)
                                            : const Color(0xFF555555),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
