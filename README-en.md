
# ⚠️Under construction. Data not yet available. ⚠️

Haga clic [aquí](https://github.com/HRDAG/verdata/blob/main/README.md) para instrucciones en español.

<div class="columns">

<div class="column" width="40%">

<img src="man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` is an `R` package designed as a tool for the use and analysis of data about the armed conflict in Colombia resulting from the joint JEP-CEV-HRDAG project. The data from this project that has been published corresponds to 100 replicates, which are
the result of a statistical imputation process of missing fields (see section 4 of the [methodological report of the project](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).

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

## Usage

To use this package, it is necessary to have previously downloaded the data from one of the sites where they are published. This package offers 8 functions to handle the data:

1. The `confirm_files` function allows you to authenticate the downloaded, making sure that your files exactly correspond to
the files originally published.

2. In addition, the `read_replicates` function allows you to authenticate the content of the files, as well as import the
desired number of replicates into R.

3. For its analysis of Human Rights violations, the Truth Commission specified [different periods and conditions](https://www.comisiondelaverdad.co/hasta-la-guerra-tiene-limites). If you want
to replicate the results of the CEV's Final Report, it is necessary to apply these same filters to the data. The use of the `filter_standard_cev` function is optional and allows you to filter the data in the same way that the CEV did, depending on
the Human Rights violation to be analyzed.

4. The `summary_observed` function offers a count of the observed number of victims - total or grouped by different variables -
before the statistical imputation of missing fields. The number obtained is the mean between the different replicates.

5. The `combine_replicates` function uses the Normal approximation using the laws of total expectation and variance to combine the replicates, which allows you to obtain an interval of the imputation. See Section 18.2 of [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) for more information.

6. The use of the `prop_obs_rep` function is optional and allows you to obtain the proportions of the data for the variables
by which it was grouped.

7. The `mse` function allows you to make estimates of underreporting using [LCMCR](https://onlinelibrary.wiley.com/doi/10.1111/biom.12502) specification (see section 6 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).
To use this function, it is necessary to have defined stratification variables, that is, grouping, to calculate the estimation,
and to have done the stratification (see example and section 8.4.2 of the [methodological report](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).
Additionally, considering that the estimation requires time and computational resources, in case you want to make use of the
estimates already calculated by the team, it is necessary to have downloaded them to your local machine. This function requires
as input the already stratified data and the directory where the published estimates are located - in case you want to make use
of these. Keep in mind that by providing a directory, the function assumes the same specifications for the model used in the
project. If you want to use other specifications, don't provide a directory to the estimates.

8. Finally, the `combine_estimates` function allows you to combine the results of the estimation, which once again will result in
an interval (including the mean). The function uses the Normal approximation using the laws of total expectation and total variance. See Section 18.2 of [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) for more information.
