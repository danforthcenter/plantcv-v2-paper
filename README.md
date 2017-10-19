# PlantCV v2 Image and Data Analysis Scripts

PlantCV image and data analysis scripts used in Gehan MA, Fahlgren N, Abbasi A, Berry JC, Callen ST, Chavez L, Doust AN,
Feldman MJ, Gilbert KB, Hodge JG, Hoyer JS, Lin A, Liu S, Lizárraga C, Lorence A, Miller M, Platon E, Tessman M, Sax T. 
(2017) PlantCV v2.0: Image analysis software for high-throughput plant phenotyping. PeerJ Preprints 5:e3225v1 
https://doi.org/10.7287/peerj.preprints.3225v1

## PlantCV release

The PlantCV release used for the above manuscript was v2.0 and can be cloned directly by:

```bash
git clone --branch v2.0 https://github.com/danforthcenter/plantcv.git
```

Alternatively, an archived version of the v2.0 release can be downloaded from 
[Zenodo](https://doi.org/10.5281/zenodo.854674).

Documentation for PlantCV v2.0 can be found at http://plantcv.readthedocs.io/en/v2.0/.

## Contents

The SQLite database schema for PlantCV v2.0 can be found in the file `database_schema.sql`.

Image analysis Python scripts and Jupyter notebooks for Figures 2, 3 and 5 can be found in the folder 
`image-analysis-scripts`.

An R script for comparing the results of PlantCV using image thresholding or the naive Bayes methods for segmentation
(Figure 5) can be found in the folder `analysis_scripts`.
