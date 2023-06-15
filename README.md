
# ⚠️Under construction. Data not yet available. ⚠️

Click [here](https://github.com/HRDAG/verdata/blob/main/README-en.md) for instructions in English.

<div class="columns">

<div class="column" width="40%">

<img src="man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` es un paquete de `R` que está pensado como una herramienta para el uso y análisis de los datos de Conflicto armado en
Colombia resultantes del proyecto conjunto [JEP-CEV-HRDAG](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf).
Los datos de este proyecto que han sido publicados corresponden a 100 réplicas, producto del proceso de
imputación estadística de campos faltantes (ver sección 4 del [informe metódologico del proyecto](https://www.comisiondelaverdad.co/sites/default/files/descargables/2022-08/04_Anexo_Proyecto_JEP_CEV_HRDAG_08022022.pdf)).

<div class="column" width="60%">

</div>

</div>

## Instalación

Se puede instalar la versión la versión en desarrollo de `verdata` desde GitHub con lo siguiente:

```r
install.packages("devtools")
devtools::install_github("HRDAG/verdata")
```

`verdata` requiere el paquete [`LCMCR`](https://cran.r-project.org/web/packages/LCMCR/index.html) como dependencia. La instalación de `LCMCR` requiere la instalación del [GNU Scientific Library](https://www.gnu.org/software/gsl/). Es posible que necesite instalar esta librería en su computadora por separado antes de instalar `verdata`.

## Uso

Para el uso de este paquete es necesario haber descargado los datos previamente de alguno de los sitios en los
que se encuentran publicados. Este paquete ofrece al público 8 funciones para el tratamiento de los datos:

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
