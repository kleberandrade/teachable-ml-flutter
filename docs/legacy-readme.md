# Flutter Image Classification

[![Language: Dart](https://img.shields.io/badge/Language-Dart-0175C2)](https://github.com/kleberandrade/teachable-ml-flutter/blob/master/pubspec.yaml)
[![Framework: Flutter](https://img.shields.io/badge/Framework-Flutter-02569B)](https://github.com/kleberandrade/teachable-ml-flutter/blob/master/pubspec.yaml)

Flutter classroom example of image classification using a Teachable Machine model.

## Getting started

- Select a Flutter release whose bundled Dart SDK satisfies the manifest constraint, then run the commands below from the repository root.

```sh
flutter pub get
flutter run
```

- If the app depends on Firebase or another external service, configure your own service project using the dependencies and original notes; credentials are not supplied by this guide.

## Recorded requirements

- Dart SDK constraint from [`pubspec.yaml`](https://github.com/kleberandrade/teachable-ml-flutter/blob/master/pubspec.yaml): `>=2.1.0 <3.0.0`.

## Repository map

- [lib](https://github.com/kleberandrade/teachable-ml-flutter/tree/master/lib)
- [test](https://github.com/kleberandrade/teachable-ml-flutter/tree/master/test)
- [android](https://github.com/kleberandrade/teachable-ml-flutter/tree/master/android)
- [ios](https://github.com/kleberandrade/teachable-ml-flutter/tree/master/ios)

## Validation status

This update documents the tracked source and project metadata. It does not certify a successful build, device test or compatibility with a current toolchain. Follow any project-specific validation instructions in the original material.

## License and attribution

No standalone repository-wide license file was identified in this review. Preserve the original credits and any component-specific licenses; this documentation update grants no additional rights.

---

## Original project material

# Classificação de Imagens

Aplicativo para classificar imagens (gatos e cachorros) criado na disciplina de Programação Mobile, por Kleber de Oliveira Andrade.

Tutorial de criação deste app [clique aqui](https://medium.com/@kleberandrade/criando-um-aplicativo-em-flutter-para-classificar-imagens-gato-e-cachorro-com-teachable-machine-be35c604c780).

## Arquitetura

<p align="center">
    <img src="https://miro.medium.com/max/1400/1*Zp_hJKpmWOaMNZEgcPkKOQ.png" width="740" />
</p>

## Screenshots

<p align="center">
    <img src="https://cdn-images-1.medium.com/max/1200/1*tYVH6LoV6R68_UNNMdNnpg.jpeg" width="250"/>
    <img src="https://cdn-images-1.medium.com/max/1200/1*wD1SiK6deupsFWL2dSktsA.jpeg" width="250"/>
    <img src="https://cdn-images-1.medium.com/max/1200/1*AOk1Iu8XXfVVG0c1qfgHmw.jpeg" width="250"/>
</p>

## Como clonar e importar

*   Faça um fork do projeto (precisa ter uma conta no github)
*   Abra o terminal do Visual Studio Code
*   Acesse a pasta onde deseja salvar o aplicativo e digite: git clone *link_do_projeto_no_seu_github* **teachable_ml**
*   Clique em File -> Open e abra o projeto (pasta)
*   Não se esqueça de abrir o arquivo *pubspec.yaml* e salvar (CTRL + S) o arquivo para que os plugins sejam baixados 

## Desafio para aula

*   [ ] Defina pelo menos três tipos de objetos que deseja reconhecer e prepare sua base de dados; Quanto mais imagens dos objetos melhor, mas cuidado com as outras informações das imagens (objetos, pessoas e etc);
*   [ ] Crie um projeto novo no Teachable Machine, crie suas classes e faça upload das imagens; Treine, faça download do seu modelo e adicione ao projeto;
*   [ ] Quando clicar para tirar fotos, eu gostaria de poder escolher entre câmera ou galeria de imagens. Estude mais a fundo o plugin [ImagePicker](https://pub.dev/packages/image_picker) ([exemplo de uso](https://heartbeat.fritz.ai/using-the-camera-gallery-in-flutter-apps-2f9e8e0e5899));
*   [ ] Altere o tema do seu aplicativo - já fizemos isso várias vezes; Teste seu aplicativo para ver se ele reconhece os objetos;
*   [ ] Escrever um relatório explicando de no máximo 2 páginas, explicando o resultado da sua classificação de imagens;

## Licença

    Copyright 2020 Kleber de Oliveira Andrade
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
