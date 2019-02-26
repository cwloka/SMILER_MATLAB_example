# SMILER Example: Noise effects explored in MATLAB

This is an example application which showcases the use of SMILER through the MATLAB environment. Note that although this example is designed to showcase an interesting and non-standard exploration of the properties of saliency algorithms, it is nevertheless a toy example with only a very small number of test images. Any conclusions or judgements about algorithm performance are therefore tentative at best.

This example was written by Calden Wloka, and most recently tested under SMILER version 1.0.0

## Running instructions

This readme assumes that the user has already successfully downloaded and configured SMILER, as well as has access to the MATLAB programming environment. If SMILER is not set up on your system, instructions and content can be found on the [GitHub repository](https://github.com/TsotsosLab/SMILER).

To execute SMILER wrapped models in MATLAB, it is necessary for SMILER to be set up on your MATLAB path. A quick way to check if SMILER is currently available is to run the command:
`which iSMILER`
which will return:
`'iSMILER' not found`
if SMILER is not set up, and a path to your local copy of the `iSMILER` function if everything has already been set up.

Once SMILER is available on the MATLAB path, navigate the working directory to the `code` directory of this example. The example script is contained in `noise_example.m`, which may be run directly to produce the output graphs or examined and stepped through to see an example of SMILER user in MATLAB.

## Experiment description

This experiment examines the effects of noise on singleton target detection by saliency models in psychophysical search arrays. It uses two target images: a search array with simple elements consisting of a dot target and plus distractors (circle_plus.png) and a search array with more complex elements consisting of human silhouettes in upright or flipped orientations (person_flip.png). For more background on why we feel psychophysical experimentation is an underexplored but important area of saliency modeling research, see the following paper:

Neil D.B. Bruce, Calden Wloka, Nick Frosst, Shafin Rahman, and John Tsotsos (2015) On computational modeling of visual saliency: Examining what’s right, and what’s left. Vision Research 116:95-112 [Link](https://www.sciencedirect.com/science/article/pii/S0042698915000267)

Each test image is tested under one of two noise conditions with varying intensity: point-noise and Gaussian smoothing. Model performance is evaluated by taking the ratio between the maximum saliency value within the (dilated) target mask and the maximum saliency value within the (dilated) distractor masks.

## Experiment file descriptions

This example organizes files into two subfolders: `images` and `code`.

The `images` folder contains `stimuli` which provides the input images for the experiment, `distmap` which provides the binary distractor masks, and `targmap` which provides the binary target masks. If map logging is turned on, this folder will also contain a `output` folder after the experiment is run which contains example output of the different saliency algorithms, as well as the corresponding noise-degraded images.

The `code` folder contains all the MATLAB files necessary to conduct the experiment.
