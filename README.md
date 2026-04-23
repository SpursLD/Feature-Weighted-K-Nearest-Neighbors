# Quantifying and predicting information loss in digital microstructure: An integrated experimental, simulation, and machine learning framework
## Abstract
 In polycrystalline digital microstructure analysis, limited resolution and data processing lead to microstructural information loss, which subsequently manifests as systematic distortions in geometric and topological structures. In this work, the quantification of such information loss is formulated as a statistical correction problem, and an integrated experimental–simulation–machine learning framework is developed.  Within this framework, a Feature Weighted K-Nearest Neighbors (FWKNN) algorithm is employed to predict resolution correction factors, and its effectiveness is validated on both electron backscatter diffraction (EBSD) and simulated datasets. The proposed approach enables the reconstruction of high-resolution microstructural statistics, including mean grain size and topological feature counts, from low-resolution processed data. The framework accurately predicts high-resolution microstructural statistics, with the coefficient of determination (_R2_) exceeding 0.95. Furthermore, by expressing grain size in pixel-based units, resolution-invariant descriptors are constructed, extending the applicability of the framework beyond EBSD to other digital microstructure characterization techniques.
 ## Dataset
1. High-resolution ground truth microstructures for different shape parameters are stored in the `ground_truth` folder. The `down_sampled.m` file can be used to downsample these to generate lower resolutions. 
2. Microstructures at various resolutions can be processed using the `delect_big_denoise.m` script with different size thresholds.
3. The `size_topology.m` script computes the geometric and topological structures of the microstructures.
4. `tpzuhe.m`: Combines statistical microstructure information into an Excel.
5. Training datasets with different size thresholds are located in the `training_dataset` folder, while test datasets are in the `test_dataset` folder.
  ## FWKNN
1. The FWKNN implementation is located in `FWKNN.py`, and `test.py` is used to evaluate the training performance.
2. The `Indicators.m` script is used to calculate R2and RCE.
3. The trained parameter files are located in the `models` folder.
The model's results on the test set are shown as the red points in the figure.
![Test Results](image/result.png)
 ## Grain track
 1. The `segnment_label.m` script segments the microstructures and generates label files.
 2. The `delect_big_denoise_label.m` script is used to process the label files.

