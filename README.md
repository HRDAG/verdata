Click [here](https://github.com/HRDAG/verdata/blob/main/inst/docs/README-en.md) for instructions in English.

<!-- badges: start -->
[![DOI](https://joss.theoj.org/papers/10.21105/joss.05844/status.svg)](https://doi.org/10.21105/joss.05844)
[![Codecov test coverage](https://codecov.io/gh/HRDAG/verdata/graph/badge.svg)](https://app.codecov.io/gh/HRDAG/verdata)
<!-- badges: end -->

<div class="columns">

<div class="column" width="40%">

<img src="man/figures/verdata_HEX_v2_249x288_transp.png" align="right" width="200" />

</div>

# verdata

`verdata` es un paquete de `R` que está pensado como una herramienta para el uso y análisis de los datos de conflicto armado en Colombia. Estos datos derivan del [proyecto conjunto JEP-CEV-HRDAG](https://hrdag.org/CEV-JEP/20250306-methodological-report-ES.pdf), los cuales, a través del paquete, pueden ser analizados utilizando tres conjuntos de funciones: En primer lugar, las personas interesadas pueden utilizar `verdata` para verificar que están utilizando los datos originalmente publicados, es decir, permite autenticar tanto los archivos como su contenido. Segundo, pueden usar `verdata` para replicar los principales resultados del proyecto conjunto JEP-CEV-HRDAG. Finalmente, para el tercer conjunto, pueden utilizar `verdata` para diseñar sus propios análisis estadísticos de patrones de violencia que abordan los dos tipos de datos faltantes presentes en el proyecto (campos faltantes y registros faltantes).

Dos versions de los datos sobre las cuatro violaciones a los derechos humanos que se trabajaron en el proyecto: desaparición, homicidio, secuestro y reclutamiento existen. La primera versión, (v1) corresponde a los datos usados para el análisis del informe metodológico del proyecto conjunto JEP-CEV-HRDAG. Se puede usar esta versión de los datos para replicar los hallazgos del Informe Metodológico. Después de la publicación de la primera versión de los datos, una entidad estatal con acceso legítimo a los datos originales descubrió algunos problemas con los datos publicados. La entidad encontró algunas instancias de la inclusión de víctimas indirectas en una de las fuentes analizadas en el proyecto. La segunda versión de los datos (v2) corrige estos errores y es adecuado para nuevos análisis del conflicto colombiano. Más información está disponible [aquí](https://hrdag.org/colombia/).

### Descargar datos para replicar los análisis del informe metodológico (v1)

Descargar datos del Departamento Administrativo Nacional de Estadística (DANE): [https://microdatos.dane.gov.co/index.php/catalog/795/get-microdata](https://microdatos.dane.gov.co/index.php/catalog/795/get-microdata)

Descargar datos del Human Rights Data Analysis Group (HRDAG) con IPFS:

- Desaparición [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/desaparicion-v1.parquet.zip)
- Reclutamiento [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/reclutamiento-v1.parquet.zip)
- Homicidio [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/homicidio-v1.parquet.zip)
- Secuestro [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v1.csv.zip) [[parquet]](https://bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy.ipfs.w3s.link/ipfs/bafybeicfjzjsl72ntzvne5apc4mubhtvsb7pd2qgvtqhuzbjznm7bxkuzy/secuestro-v1.parquet.zip)

### Descargar datos para diseñar nuevos análisis del conflicto colombiano (v2)

Descargar datos del Human Rights Data Analysis Group (HRDAG) con IPFS:

- Desaparición [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/desaparicion-v2.parquet.zip)
- Reclutamiento [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/reclutamiento-v2.parquet.zip)
- Homicidio [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/homicidio-v2.parquet.zip)
- Secuestro [[csv]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v2.csv.zip) [[parquet]](https://bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm.ipfs.w3s.link/ipfs/bafybeicb22gzaugj6jlrg47542oh7i2alzqbxwijedx7jfrstwgaxkxonm/secuestro-v2.parquet.zip)

Ambas versiones de los datos corresponden a 100 réplicas para cada violación, los cuales fueron producto del proceso de imputación estadística múltiple de campos faltantes (ver sección 4 del [informe metodológico del proyecto](https://hrdag.org/CEV-JEP/20250306-methodological-report-ES.pdf)). Además, el repositorio [`verdata-examples`](https://github.com/HRDAG/verdata-examples) contiene ejemplos que ilustran cómo usar correctamente estos datos (réplicas) a través del paquete previamente mencionado.

<div class="column" width="60%">

</div>

</div>

## Instalación

Se puede instalar `verdata` directamente de [CRAN](https://cran.r-project.org/) con:

```r
install.packages("verdata")
```

También se puede instalar la versión en desarrollo de `verdata` desde GitHub así:

```r
if (!require("devtools")) {install.packages("devtools")}
devtools::install_github("HRDAG/verdata")
```
`verdata` requiere algunos paquetes como dependencia. Para esto es recomendable la instalación del [GNU Scientific Library](https://www.gnu.org/software/gsl/). Es posible que necesite instalar esta librería en su computadora por separado antes de instalar `verdata`.

## Diccionario de datos

`verdata` presenta dos data frames que contienen información relacionada con el diccionario de datos de las réplicas. En `diccionario_replicas` encontrará la definición de cada una de las variables que se encuentran allí y, en `diccionario_vars_adicional`, encontrará nuevas variables que fueron usadas en algunos análisis estadísticos durante la construcción del informe final de la CEV.

## Uso

Para el uso de este paquete es necesario haber descargado previamente los datos de alguno de los sitios en los que se encuentran publicados. Este paquete ofrece al público 8 funciones para el tratamiento de los datos, divididas así:

### Verificación y lectura de datos en `R`:

* La función `confirm_files` permite autenticar que los archivos descargados correspondan exactamente a los archivos originalmente publicados. Esta función acepta archivos en cualquiera de los dos formatos publicados (`parquet` o `csv`).

* Además, la función `read_replicates` permite autenticar el contenido de los archivos, así como importar el número deseado de réplicas a `R`. Esta función acepta archivos en cualquiera de los dos formatos publicados (`parquet` o `csv`).

### Transformación de datos:

* Para sus análisis en violaciones a derechos humanos, la Comisión de la Verdad especificó [diferentes períodos y condiciones](https://www.comisiondelaverdad.co/hasta-la-guerra-tiene-limites). En caso de querer replicar los resultados del Informe Final de la CEV, es necesario aplicar estos mismos filtros a los datos. El uso de la función `filter_standard_cev` es opcional y permite filtrar los datos del mismo modo que la CEV lo hizo, dependiendo de la violación a derechos humanos a analizar.

### Datos observados:

* La función `summary_observed` ofrece un conteo del número observado de víctimas -totales o agrupadas por diferentes variables- antes de la imputación estadística de campos faltantes. El número que se obtiene es la media entre las diferentes réplicas.

### Datos imputados:

* La función `combine_replicates` usa la aproximación normal usando las reglas de total expectativa y varianza para combinar las réplicas, lo que permite obtener un intervalo de la imputación. Ver sección 18.2 de [*Bayesian Data Analysis*](https://sites.stat.columbia.edu/gelman/book/) para más información.

### Datos estimados:

* La función `estimates_exist` permite validar si la estimación de los estratos de interés ya existen, y se encuentran en los archivos de estimaciones precalculadas publicados, que deben haber sido previamente descargados del [sitio de la Comisión](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3). Esta función requiere los datos estratificados y el directorio en el que se encuentran las estimaciones precalculadas y devolverá un valor lógico que indica si la estimación existe o no, y la ruta en la que se encuentra, en caso de que exista. En caso de que usted quiera replicar los resultados de la Comisión de la Verdad, los objetos de datos `estratificacion` (en español) y `stratification` (en inglés) especifican qué estratificaciones se usaron para cada estimación presente en el [informe metodológico del proyecto](https://hrdag.org/wp-content/uploads/2022/08/20220818-fase4-informe-corrected.pdf).

* La función `mse` permite hacer estimaciones del subregistro, usando el modelo de [LCMCR](https://onlinelibrary.wiley.com/doi/10.1111/biom.12502) (ver sección 6 del [informe metodológico del proyecto](https://hrdag.org/wp-content/uploads/2022/08/20220818-fase4-informe-corrected.pdf)).
Para usar esta función es necesario haber definido variables de estratificación, es decir, agrupación, para hacer la estimación
y haber hecho la estratificación (ver ejemplo y sección 8.4.2 del [informe metodológico del proyecto](https://hrdag.org/wp-content/uploads/2022/08/20220818-fase4-informe-corrected.pdf)).
Además, considerando que la estimación requiere de tiempo y recursos computacionales, en caso de querer hacer uso de las
estimaciones ya calculadas por el equipo, es necesario haberlas descargado del [sitio de la Comisión](https://www.comisiondelaverdad.co/analitica-de-datos-informacion-y-recursos#c3) a su máquina local. Esta función requiere como insumo
los datos ya estratificados y el directorio en el que se encuentran las estimaciones publicadas -en caso de querer hacer uso
de estas-. Tenga presente que al proveer un directorio la función asume las mismas especificaciones para el modelo usadas en el
proyecto. Si usted quiere usar otras especificaciones, no debe suministrar un directorio a las estimaciones.

* Por último, la función `combine_estimates` permite combinar los resultados de la estimación, lo que, una vez más, dará como
resultado un intervalo (que incluye la media). Usa la aproximación normal usando las reglas de total expectativa y varianza. Ver sección 18.2 de [*Bayesian Data Analysis*](https://sites.stat.columbia.edu/gelman/book/) para más información.

## Agradecimientos
Agradecemos a [Micaela Morales](https://github.com/mmazul) por su atenta prueba beta.

## Contribuir al paquete
Contribuciones y sugerencias siempre son bienvenidas. Si tiene un problema, pregunta o duda sobre `verdata` puede abrir un issue en GitHub. Si quiere contribuir nueva funcionalidad puede abrir un pull request.
