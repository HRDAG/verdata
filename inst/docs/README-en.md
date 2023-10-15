Haga clic [aquí](https://github.com/HRDAG/verdata/blob/main/README.md) para instrucciones en español.

[![R-CMD-check](https://github.com/HRDAG/verdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/HRDAG/verdata/actions/workflows/R-CMD-check.yaml)

<div class="columns">

<div class="column" width="40%">

<img src="../../man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` is an `R` package designed as a tool for the use and analysis of data about the armed conflict in Colombia resulting from the [joint JEP-CEV-HRDAG project](https://hrdag.org/wp-content/uploads/2022/08/20220818-fase4-informe-corrected.pdf). Data about disappearance, homicide, recruitment of children and adolescents, and kidnapping can be downloaded from the [National Administrative Department of Statistics' website](https://microdatos.dane.gov.co/index.php/catalog/795). The data about each of the four human rights violations correspond to 100 replicates, which are the result of a statistical imputation process of missing fields (see Section 4 of the [methodological report of the project](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)). The repository [`verdata-examples`](https://github.com/HRDAG/verdata-examples) contains examples that illustrate how to correctly use the data and this package. These examples are currently only available in Spanish, but we are working on translating them to English.

<div class="column" width="60%">

</div>

</div>

## Installation

You can install the development version of `verdata` from GitHub with:

```r
install.packages("devtools")
devtools::install_github("HRDAG/verdata")
```

`verdata` requires the package [`LCMCR`](https://cran.r-project.org/web/packages/LCMCR/index.html) as a dependency. Installing `LCMCR` requires installing the [GNU Scientific Library](https://www.gnu.org/software/gsl/). It's possible that you will need to install this library separately before installing `verdata`.

## Data dictionary

In the subdirectory `inst/docs` you can find the data dictionary for the replicate files. This dictionary includes the definition of each one of the variables in the replicate files, as well as information about additional variables that were constructed for the final report of the Colombian Truth Commission. The dicionary is currently only available in Spanish, but we are working on translating it to English.

## Usage

To use this package, it is necessary to have previously downloaded the data from one of the sites where they are published. This package offers 8 functions to handle the data divided into 5 categories:

### Verifying and reading the data into `R`

* The `confirm_files` function allows you to authenticate the downloaded, making sure that your files exactly correspond to the files originally published. This function accepts files in either of the two published formats (`parquet` or `csv`).

* Additionally, the `read_replicates` function allows you to authenticate the content of the files, as well as import the desired number of replicates into `R`. This function accepts files in either of the two published formats (`parquet` or `csv`).

### Data transformations

* For its analysis of Human Rights violations, the Truth Commission specified [different periods and conditions](https://www.comisiondelaverdad.co/hasta-la-guerra-tiene-limites). If you want to replicate the results of the CEV's Final Report, you need to apply these same filters to the data. The use of the `filter_standard_cev` function is optional and allows you to filter the data in the same way that the Truth Commission did, depending on the human rights violation you're analyzing.

### Observed data

* The `summary_observed` function offers a count of the observed number of victims - total or grouped by different variables before the statistical imputation of missing fields. The number obtained is the mean between the different replicates.

### Imputed data

* The `combine_replicates` function uses the Normal approximation using the laws of total expectation and variance to combine the replicates, yielding a 95% confidence interval and a point estimate of the mean number of documented victims taking the imputation uncertainty into consideration. See Section 18.2 of [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) for more information.

### Estimates

* The `estimates_exist` function allows you to see whether your strata of interest already exist in the pre-calculated estimation files that you downloaded from the [Truth Commission website](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3) onto your local machine. This function requires the stratified data and the directory where you've saved the pre-calculated estimates as inputs and returns a data frame with a logical value for whether the estimate exists and a path to the file containing the estimation results if the estimates exists. If you would like to replicate the Truth Commission's results, the data objects `estratificacion` (in Spanish) and `stratification` (in English) specify the stratifications used for each of estimates presented in the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf).

* The `mse` function allows you to make estimates of underreporting using [LCMCR](https://onlinelibrary.wiley.com/doi/10.1111/biom.12502) specification (see Section 6 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)). To use this function, you need to define stratification variables and apply the stratification (i.e., by grouping the data according to these variables). See the function's example and Section 8.4.2 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)). These estimates take time and computational resources to run. If you would like to make use of the estimates already calculated by our team, you'll need to download the estimates from the [Truth Commission website](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3) onto your local machine. You can make use of the pre-calculated estimates by specifying the path to the `estimates_dir` argument.  Keep in mind that by providing a directory, the function assumes the same specifications for the model used in the project. If you want to use other specifications, don't provide a directory to the estimates.

* Finally, the `combine_estimates` function allows you to combine the results of the estimation, yielding an approximate 95% credibility interval and the point estimate of the mean of the total number of victims in a stratum of interest including both the uncertainty from the missing data imputation and from the multiple systems estimation model. The function uses the Normal approximation using the laws of total expectation and total variance. See Section 18.2 of [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) for more information.

## Thank yous
We thank [Micaela Morales](https://github.com/mmazul) for her thoughtful beta testing of the package.
