# Model contract and provenance

The binary `assets/model_unquant.tflite` and labels are unchanged from the original 2020 repository. FlatBuffer schema inspection and native interpreter validation agree:

- one float32 input `sequential_5_input`, `[1,224,224,3]`;
- one float32 output `sequential_7/dense_Dense4/Softmax`, `[1,2]`;
- output order: `0 Gato`, `1 Cachorro`;
- first operation PAD, followed by CONV_2D and DEPTHWISE_CONV_2D; no input normalization operator before these;
- description: `TOCO Converted.`.

RGB pixels are converted to unsigned 8-bit channels, oriented using EXIF, center-cropped and resized to 224 square, then normalized by `(pixel/127.5)-1`. This matches the [Teachable Machine MobileNet preprocessing convention](https://github.com/googlecreativelab/teachablemachine-community/blob/master/libraries/image/src/teachable-mobilenet.ts). It corrects the old helper's unsubstantiated mean=0/std=255 choice. Normalization cannot be inferred from a float tensor shape alone. Original training/export metadata are absent; we cannot prove that every training-stage operation matches or reproduce training accuracy.

The original lesson referenced Kaggle's cat-and-dog dataset, but the repository supplies no exact split, dataset snapshot, training seed or separate model/data license. The MIT code notice is preserved without asserting new third-party rights. Use the bundled model for this existing classroom example; establish provenance before downstream redistribution/retraining.

The two Wikimedia images are independently licensed demonstration inputs, not a test dataset establishing accuracy. On macOS arm64 the native smoke test returned:

- cat: Gato 0.9999918937683105, Cachorro 0.000008084193723334465;
- dog: Cachorro 1.0, Gato 3.8729909954021e-22.

A softmax score is relative to the two known classes. It is not calibration, dataset accuracy or proof that an image contains an animal. The UI rounds to one decimal place; 100.0% does not imply certainty. No threshold silently drops the second class. No simulated outputs are used in the running app; injected fake engines occur only in unit/widget tests.

Replacing this model requires updating its contract, normalization, labels and tests together. Quantized models and additional classes are deliberately rejected by this lesson's current contract.

Native libraries: tflite_flutter 0.12.1 includes the macOS universal runtime; code and runtime retain their Apache-2.0 notices. Current mobile scaffolding is not a claim of successful camera/device testing. The runtime is not supported on web.
