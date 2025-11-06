Haga clic [aquí](https://github.com/HRDAG/verdata/blob/main/README.md) para instrucciones en español.

 <!-- badges: start -->
[![DOI](https://joss.theoj.org/papers/10.21105/joss.05844/status.svg)](https://doi.org/10.21105/joss.05844)
  [![Codecov test coverage](https://codecov.io/gh/HRDAG/verdata/branch/main/graph/badge.svg)](https://app.codecov.io/gh/HRDAG/verdata?branch=main)
<!-- badges: end -->

<div class="columns">

<div class="column" width="40%">

<img src="../../man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` is an `R` package designed as a tool for the use and analysis of data about the armed conflict in Colombia resulting from the [JEP-CEV-HRDAG Joint Project](https://hrdag.org/CEV-JEP/20250306-methodological-report-EN.pdf) (note that this is a translation of the Spanish report available [here](https://hrdag.org/CEV-JEP/20250306-methodological-report-ES.pdf)). `verdata` has three main sets of features. First, researchers can use `verdata` to verify that they are using unaltered versions of the published data. Second, they can use `verdata` to replicate the main findings of the joint JEP-CEV-HRDAG project. Finally, they can use `verdata` to design their own statistical analyses of patterns of violence that address the two forms of missing data present in the documented data.

There are two versions of the data about the four human rights considered in the Joint Project: disappearance, homicide, kidnapping, and forced recruitment. The first version (v1) corresponds to the data used for the analyses in the Methodological Report of the JEP-CEV-HRDAG Joint Project. This version of the data can be used to replicae the findings of the Methodological Report. After the publication of the first version of the data a state entity with legitimate access to the original data discovered some problems with the published data. The entity found some instances of the inclusion of indirect victims in one of the sources analyzed in the project. The second version of the data (v2) corrects these errors and is appropriate for new analyses of the Colombian conflict. More information is available [here](https://hrdag.org/colombia/).

### Download data to replicate analyses conducted in the Methodological Report (v1)

Download data from the Departamento Administrativo Nacional de Estadística (DANE), the national statistics office in Colombia: [https://microdatos.dane.gov.co/index.php/catalog/795/get-microdata](https://microdatos.dane.gov.co/index.php/catalog/795/get-microdata)

Download data from the Human Rights Data Analysis Group (HRDAG) via IPFS:

- Disappearance [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/desaparicion-v1.parquet.zip)
- Forced recruitment [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/reclutamiento-v1.parquet.zip)
- Homicide [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/homicidio-v1.parquet.zip)
- Kidnapping [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/secuestro-v1.parquet.zip)

### Download data to design your own analyses of the armed conflict in Colombia (v2)

Download data from the Human Rights Data Analysis Group (HRDAG) via IPFS:

- Disappearance [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v2.parquet.zip)
- Forced recruitment [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v2.parquet.zip)
- Homicide [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v2.parquet.zip)
- Kidnapping [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v2.parquet.zip)

Both versions of the data are 100 replicate data files for each violation. These replicates were created using multiple imputation to address missing fields (see Section 4 of the [Methodological Report](https://hrdag.org/CEV-JEP/20250306-methodological-report-EN.pdf)). The repository [`verdata-examples`](https://github.com/HRDAG/verdata-examples) contains examples that illustrate how to correctly use the data and this package. These examples are currently only available in Spanish, but we are working on translating them to English.

In the data files, each row represents a unique victim. The column `match_group_id` contains the unique identifier for each victim. A person can be the victim of one violation or of two violations: homicide and disappearance, homicide and forced recruitment, or homicide and kidnapping. You can use the `match_group_id` column to identify victims of two violations using the files of interest. See Section 3.6.1 of the [Methodological Report](https://hrdag.org/CEV-JEP/20250306-methodological-report-EN.pdf) for more information about cases of multiple violations.

<div class="column" width="60%">

</div>

</div>

## Installation

You can install the stable version of `verdata` from [CRAN](https://cran.r-project.org/) with:

```r
install.packages("verdata")
```

You can install the development version of `verdata` from GitHub with:

```r
if (!require("devtools")) {install.packages("devtools")}
devtools::install_github("HRDAG/verdata")
```

One of the `verdata`'s dependencies requires the installation of the [GNU Scientific Library](https://www.gnu.org/software/gsl/). It's possible that you will need to install this library separately before installing `verdata`.

## Data dictionary

`verdata` has two data frames that contain information about the data dictionary for the replicate files. In `diccionario_replias`, you will find the definition of each of the variables contained within. In `diccionario_vars_adicional`, you will find additional variables that were constructed for the final report of the Colombian Truth Commission. These data dictionaries are currently only available in Spanish, but we are working on translating them to English.

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

* The `combine_replicates` function uses the Normal approximation using the laws of total expectation and variance to combine the replicates, yielding a 95% confidence interval and a point estimate of the mean number of documented victims taking the imputation uncertainty into consideration. See Section 18.2 of [*Bayesian Data Analysis*](https://sites.stat.columbia.edu/gelman/book/) for more information.

### Estimates

* The `estimates_exist` function allows you to see whether your strata of interest already exist in the pre-calculated estimation files that you downloaded from the [Truth Commission website](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3) onto your local machine. This function requires the stratified data and the directory where you've saved the pre-calculated estimates as inputs and returns a data frame with a logical value for whether the estimate exists and a path to the file containing the estimation results if the estimates exists. If you would like to replicate the Truth Commission's results, the data objects `estratificacion` (in Spanish) and `stratification` (in English) specify the stratifications used for each of estimates presented in the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf).

* The `mse` function allows you to make estimates of underreporting using [LCMCR](https://doi.org/10.1111/biom.12502) specification (see Section 6 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)). To use this function, you need to define stratification variables and apply the stratification (i.e., by grouping the data according to these variables). See the function's example and Section 8.4.2 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)). These estimates take time and computational resources to run. If you would like to make use of the estimates already calculated by our team, you'll need to download the estimates from the [Truth Commission website](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3) onto your local machine. You can make use of the pre-calculated estimates by specifying the path to the `estimates_dir` argument.  Keep in mind that by providing a directory, the function assumes the same specifications for the model used in the project. If you want to use other specifications, don't provide a directory to the estimates.

* Finally, the `combine_estimates` function allows you to combine the results of the estimation, yielding an approximate 95% credibility interval and the point estimate of the mean of the total number of victims in a stratum of interest including both the uncertainty from the missing data imputation and from the multiple systems estimation model. The function uses the Normal approximation using the laws of total expectation and total variance. See Section 18.2 of [*Bayesian Data Analysis*](https://sites.stat.columbia.edu/gelman/book/) for more information.

## Acknowledgments
We thank [Micaela Morales](https://github.com/mmazul) for her thoughtful beta testing of the package.

## Contribute to the package
Comments and suggestions are very welcome. If you have a problem, question, or issue with `verdata`, please open an issue on GitHub. If you would like to add new functionality to the package, please open a pull request. Continuous integration is setup to automatically run tests upon a pull request being opened. If you would like to run the existing tests locally prior to opening a pull request you can do so using `testthat::test_local()`.

## Citing the package

You can cite the package as:

> Gargiulo et al., (2024). verdata: An R package for analyzing data from the Truth Commission in Colombia. Journal of Open Source Software, 9(93), 5844, <https://doi.org/10.21105/joss.05844>.

BibTex entry:

```
@article{Gargiulo2024,
    doi = {10.21105/joss.05844},
    url = {https://doi.org/10.21105/joss.05844},
    year = {2024},
    publisher = {The Open Journal},
    volume = {9},
    number = {93},
    pages = {5844},
    author = {Maria Gargiulo and María Juliana Durán and Paula Andrea Amado and Patrick Ball},
    title = {verdata: An R package for analyzing data from the Truth Commission in Colombia},
    journal = {Journal of Open Source Software}
} 
```

<!-- done. -->
