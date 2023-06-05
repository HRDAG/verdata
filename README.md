
# ⚠️Under construction. Data not yet available. ⚠️

<div class="columns">

<div class="column" width="40%">

<img src="man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` está pensado como una herramienta para el uso y análisis de los datos de Conflicto armado en
Colombia resultantes del proyecto conjunto [JEP-CEV-HRDAG](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf).
Los datos de este proyecto que han sido publicados corresponden a 100 réplicas, producto del proceso de
imputación estadística de campos faltantes (ver sección 4 del [informe metódologico del proyecto](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).

<div class="column" width="60%">


</div>

</div>

## Installation

You can install the development version from GitHub with:

```r
install.packages("devtools")
devtools::install_github("HRDAG/verdata")
```

# verdata (Español)

Este paquete está pensado como una herramienta para el uso y análisis de los datos de Conflicto armado en
Colombia resultantes del proyecto conjunto [JEP-CEV-HRDAG](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf).
Los datos de este proyecto que han sido publicados corresponden a 100 réplicas, producto del proceso de
imputación estadística de campos faltantes (ver sección 4 del [informe metódologico del proyecto](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).

Para el uso de este paquete es necesario haber descargado los datos previamente de alguno de los sitios en los
que se encuentran publicados. Esta librería ofrece al público 8 funciones para el tratamiento de los datos:

1. La función `confirm_files` permite autenticar que los archivos descargados correspondan exactamente a los
archivos originalmente publicados.

2. Además, la función `read_replicates` permite autenticar el contenido de los archivos, así como importar el
número deseado de réplicas a R.

3. Para sus análisis en violaciones a Derechos Humanos, la Comisión de la Verdad especificó [diferentes períodos
y condiciones](https://www.comisiondelaverdad.co/hasta-la-guerra-tiene-limites). En caso de querer replicar los resultados
del Informe Final de la CEV, es necesario aplicar estos
mismos filtros a los datos. El uso de la función `filter_standard_cev` es opcional y permite filtrar los datos del
mismo modo que la cev lo hizo, dependiendo de la violación a Derechos Humanos a analizar.

4. La función `summary_observed` ofrece un conteo del número observado de víctimas -totales o agrupadas por diferentes
variables- antes de la imputación estadística de campos faltantes. El número que se obtiene es la media entre las
diferentes réplicas.

5. La función `combine_replicates` usa la aproximación normal usando las reglas de total expectativa y varianza para combinar las réplicas, lo que permite obtener un intervalo de la imputación. Ver sección 18.2 de [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) para más información.

6. el uso de la función `prop_obs_rep` es opcional y permite obtener las proporciones de los datos para las variables por
las que se agrupó.

7. La función `mse` permite hacer estimaciones del subregistro, usando el modelo de [LCMCR](https://onlinelibrary.wiley.com/doi/10.1111/biom.12502) (ver sección 6 del [informe metódologico del proyecto](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).
Para usar esta función es necesario haber definido variables de estratificación, es decir, agrupación, para hacer la estimación
y haber hecho la estratificación (ver ejemplo y sección 8.4.2 del [informe metódologico del proyecto](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).
Además, considerando que la estimación requiere de tiempo y recursos computacionales, en caso de querer hacer uso de las
estimaciones ya calculadas por el equipo, se requiere haberlas descragado a su máquina local. Esta función requiere como input
los datos ya estratificados y el directorio en el que se encuentran las estimaciones publicadas -en caso de querer hacer uso
de estas. Tenga presente que al proveer un directorio la función asume las mismas especificaciones para el modelo usadas en el
proyecto. Si usted quiere usar otras especificaciones, no debe suministrar un directorio a las estimaciones.

8. Por último, la función `combine_estimates` permite combinar los resultados de la estimación, lo que, una vez más, dará como
resultado un intervalo (que incluye la media). Usa la aproximación normal usando las reglas de total expectativa y varianza. Ver sección 18.2 de [*Bayesian Data Analysis*](http://www.stat.columbia.edu/~gelman/book/) para más información.

# verdata (English)

This package is designed as a tool for the use and analysis of data on the armed conflict in Colombia resulting from the
joint project JEP-CEV-HRDAG. The data from this project that has been published corresponds to 100 replicates, which are
the result of a statistical imputation process of missing fields (see section 4 of the [methodological report of the project](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).

To use this package, it is necessary to have previously downloaded the data from one of the sites where they are published.
This library offers 8 functions to handle the data:

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
