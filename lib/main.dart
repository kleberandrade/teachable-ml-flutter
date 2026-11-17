import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import 'classifier.dart';
import 'controller.dart';
import 'domain/classification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.controller, this.pickImage});
  final ClassificationController? controller;
  final Future<Uint8List?> Function()? pickImage;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Gato ou cachorro?',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff165c49)),
      scaffoldBackgroundColor: const Color(0xfff4f5ef),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        bodyLarge: TextStyle(fontSize: 17, height: 1.5),
      ),
    ),
    home: HomePage(controller: controller, pickImage: pickImage),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.controller, this.pickImage});
  final ClassificationController? controller;
  final Future<Uint8List?> Function()? pickImage;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final state =
      widget.controller ?? ClassificationController(LocalClassifier());
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _initialize();
  }

  Future<void> _initialize() async {
    await state.initialize();
    if (!mounted || kIsWeb || !Platform.isAndroid || !state.ready) return;
    // Android can destroy the activity while its system picker is open.
    await state.choose(() async {
      final response = await ImagePicker().retrieveLostData();
      if (response.exception != null) throw response.exception!;
      final files = response.files;
      if (files == null || files.isEmpty) return null;
      final file = files.first;
      if (await file.length() > maxImageBytes) {
        throw const FormatException('Escolha uma imagem de até 12 MB.');
      }
      return file.readAsBytes();
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) state.dispose();
    super.dispose();
  }

  Future<Uint8List?> _pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      requestFullMetadata: false,
    );
    if (file == null) return null;
    if (await file.length() > maxImageBytes) {
      throw const FormatException('Escolha uma imagem de até 12 MB.');
    }
    return file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1056),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.pets,
                        color: Color(0xff165c49),
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'TEACHABLE LAB',
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(letterSpacing: 2),
                      ),
                      const Spacer(),
                      const Tooltip(
                        message: 'Inferência no próprio dispositivo',
                        child: Icon(Icons.privacy_tip_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  Text(
                    'Gato ou cachorro?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Uma imagem, duas possibilidades. Explore como um modelo aprende a reconhecer animais.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final panels = [_imagePanel(), _resultPanel()];
                      if (constraints.maxWidth < 720) {
                        return Column(
                          children: [
                            panels[0],
                            const SizedBox(height: 20),
                            panels[1],
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: panels[0]),
                          const SizedBox(width: 24),
                          Expanded(flex: 5, child: panels[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'APRENDA EXPERIMENTANDO',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use uma foto nítida, com um animal no centro. O modelo só conhece duas classes: até uma foto de uma cadeira receberá um resultado. O score não mede acurácia.',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _imagePanel() => Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '01  /  SUA IMAGEM',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ColoredBox(
                color: const Color(0xffe9eee7),
                child: state.image == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 56,
                            color: Color(0xff165c49),
                          ),
                          SizedBox(height: 16),
                          Text('Sua imagem aparece aqui'),
                          SizedBox(height: 6),
                          Text('JPEG, PNG ou WebP • até 12 MB'),
                        ],
                      )
                    : Image.memory(
                        state.image!,
                        fit: BoxFit.contain,
                        semanticLabel: 'Imagem selecionada para classificação',
                        errorBuilder: (_, _, _) => const Center(
                          child: Text('Não foi possível exibir esta imagem.'),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: state.ready && !state.busy
                ? () => state.choose(
                    widget.pickImage ?? () => _pick(ImageSource.gallery),
                  )
                : null,
            icon: const Icon(Icons.folder_open),
            label: const Text('Escolher imagem'),
          ),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final sample in [
                ('cat', 'Testar gato'),
                ('dog', 'Testar cachorro'),
              ])
                TextButton(
                  onPressed: state.ready && !state.busy
                      ? () => state.choose(
                          () async => (await rootBundle.load(
                            'assets/samples/${sample.$1}.jpg',
                          )).buffer.asUint8List(),
                        )
                      : null,
                  child: Text(sample.$2),
                ),
            ],
          ),
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
            OutlinedButton.icon(
              onPressed: state.ready && !state.busy
                  ? () => state.choose(() => _pick(ImageSource.camera))
                  : null,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Usar câmera'),
            ),
          TextButton.icon(
            onPressed: state.ready ? state.reset : null,
            icon: const Icon(Icons.restart_alt),
            label: Text(state.busy ? 'Cancelar análise' : 'Recomeçar'),
          ),
        ],
      ),
    ),
  );

  Widget _resultPanel() => Card(
    elevation: 0,
    color: const Color(0xffe2ede5),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '02  /  O QUE O MODELO VÊ',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(height: 24),
          Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.busy) ...[
                  const LinearProgressIndicator(semanticsLabel: 'Processando'),
                  const SizedBox(height: 18),
                  Text(
                    state.ready
                        ? 'Analisando sua imagem…'
                        : 'Carregando o modelo…',
                  ),
                ] else if (state.error case final error?) ...[
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  Text(error),
                  const SizedBox(height: 12),
                  if (!state.ready)
                    FilledButton(
                      onPressed: state.initialize,
                      child: const Text('Tentar novamente'),
                    ),
                ] else if (state.predictions.isEmpty) ...[
                  const Icon(
                    Icons.auto_awesome_outlined,
                    size: 40,
                    color: Color(0xff165c49),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vamos descobrir?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Escolha uma imagem para comparar os scores de gato e cachorro.',
                  ),
                ] else ...[
                  Text(
                    state.predictions.first.label,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Classe com maior score'),
                  const SizedBox(height: 24),
                  ...state.predictions.map(_score),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.lock_outline, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Suas fotos ficam neste dispositivo.')),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _score(Prediction result) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      children: [
        Row(
          children: [
            Text(result.label),
            const Spacer(),
            Text(
              '${(result.score * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: result.score,
          minHeight: 10,
          borderRadius: BorderRadius.circular(8),
          semanticsLabel: result.label,
          semanticsValue:
              '${(result.score * 100).toStringAsFixed(1)} por cento',
        ),
      ],
    ),
  );
}
