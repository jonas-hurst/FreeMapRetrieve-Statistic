# Statistical Calculation used in FreeMapRetrieve publication

R scripts for all statistical calculations in the FreeMapRetrieve paper.
Also creates and saves all graphs used in the paper.

## Publication

For more details on this project, please refer to:\
*Hurst, J., Degbelo, A. and Kray, C. (2024) ‘FreeMapRetrieve: freehand gestures for retrieve operations in large-screen map environments’, in Proceedings of the 27th AGILE Conference on Geographic Information Science (AGILE 2024). Glasgow, Scotland, United Kingdom.*


## Files

Before running any of the scripts, create a directory called `graphs` inside the FreeMapRetrieve-Statistic directory.

Data is imported and pre-processed in `get_data.R` file. This file is then imported in all the `.Rmd` files, which do the actual statistic calculations. It is not necessary to run this file on its own. It it is executed automatically when running the .Rmd files

* Figure 4: created in `evaluation_slips.Rmd`
* Figure 5: created in `evaluation_time.Rmd`
* Figure 6: created in `demographic.Rmd`
* Figure 7: created in `exploration.Rmd`

It is recommended to use knitr to create PDF reports from each `.Rmd` file. The reports include all statistical results, as well as all the graphs. The graphs itself are stored as .png files inside the `graphs` directory.

