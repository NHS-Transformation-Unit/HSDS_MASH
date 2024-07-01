<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

<br/>
<br/>
<br/>

# Horizon Scanning, Demand Signalling (HSDS): MASH Pathway Analysis and Modelling Repository
This repository contains the codebase for undertaking all analysis and modelling of the MASH pathway.

<br/>

## Table of Contents

- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Contributors](#contributors)
- [License](#license)

## Repository Structure
The current structure of the repository is detailed below:

``` plaintext

├───README.md
├───LICENSE
├───.gitignore
├───.Rproj
├───data
    ├───raw
      └───ncdr_extracts
    └───reference
├───documentation
    ├───project_documentation
    └───guidance
├───images
└───src
    ├───config
    ├───outputs
    ├───requirements
    ├───results
      ├───charts
      └───tables
    └───scripts
      ├───analysis
      ├───etl
        └───ncdr_extracts
      ├───processing
      └───visualisation
    
```

- `README.md`: This file containing an overview and instructions for using the repository.
- `LICENSE`: License information for the repository.
- `.gitignore`: Specifies the files and folders that are ignored (not tracked) in the repository.
- `.Rproj`: The RStudio project file.
- `data`: Directory for data files used in the analysis
  - `raw`: Raw data files that are extracted from the National Commissioning Data Repository (NCDR).
  - `reference`: Any reference files such as geospatial datasets or data dictionary files used in the analysis.
- `documentation`: Additional documentation that is helpful for understanding and replicating analysis and modelling.
- `images`: Directory containing any logos and other images used in creating outputs for the repository.
- `src`: All source code used for any analysis and modelling. This is comprised of the following:
  - `config`: Directory contains configuration files for outputs such as css and ggplot themes.
  - `outputs`: Contains the output files used to render the analysis or modelling such as `.qmd` or `.rmd`
  - `requirements`: Contains information on requirements for the repository. Scripts for required R packages and loading these into the environment.
  - `results`: Outputs of analysis or modelling such as specific charts and tables to be rendered in the `outputs`.
  - `scripts`: Directory containing the code used within the analysis and modelling. This is further broken down into:
    1. `analysis`: Scripts for analysing MASH datasets.
    2. `etl`: Scripts for loading datasets into environment.
    3. `processing`: Scripts for processing and cleaning loaded datasets.
    4. `visualisation`: Scripts for creating visualisations and functions for analysis.
    
<br/>

## Getting Started
This analysis has been undertaken in R and RStudio. You will need to have these installed to replicate the analysis or use an alternative IDE. The R packages that are required for replicating analysis and modelling are documented within the `requirements` directory.

The repository can be cloned locally using:

```

git clone https://github.com/NHS-Transformation-Unit/HSDS_MASH.git

```

<br/>

## Contributors
This repository has been created and developed by:

- [Andy Wilson](https://github.com/ASW-Analyst)

<br/>

## License
This project is licensed under the **GPL-3.0 license** - see the `LICENSE` file for details.