This repository hosts the scripts and data for "Measuring changes in polarisation using Singular Value Decomposition of network graphs" by Sage Anastasi & Giulio Dalla Riva. The paper is available at https://arxiv.org/abs/2403.18191

Plots and data used in the paper are saved in "Plots" and "Results". Please be aware that running the scripts will overwrite these with new plots and data in your local version of the project.

Scripts used for generating and analysing data were written in Julia, and are saved in "Src". They use the manifest and project files provided in the main folder. If needed, packages may be installed by running Pkg.activate(“.”); Pkg.add(["list", "all", "packages", "here"]). 

The tweet data used for 00_Input_climate_Twitter_NZ_data, 01_climate_NZ_analysis, 04_COP, 11_Plot_Rsmpl_Results, and 13_Plot_COP_results is not available due to Twitter closing its Academic API. Previously, the terms of the Academic API had required us to only save the Tweet IDs, so that the network could be re-downloaded in the future without infringing on copyright by saving copies of the full tweet data. Since the closure of the Academic API, this is no longer possible. However, we provide our scripts so that the code can at least be inspected for flaws, even if it cannot be fully re-run. 

