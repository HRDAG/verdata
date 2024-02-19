## Submission comments
This is a new submission to CRAN.

## Test environments

- Locally on macOS Sonoma with R version 4.3.2
- Windows Server 2022, R-devel, 64 bit (via `rhub`)
- Ubuntu Linux 20.04.1 LTS, R-release, GCC (via `rhub`)
- Fedora Linux, R-devel, clang, gfortran (via `rhub`)
- win-builder

## R CMD check results

There were no errors or warnings, but there were four notes distinct notes across R-hub's three test environments.

```
── verdata 0.9.1: NOTE

  Build ID:   verdata_0.9.1.tar.gz-3523114f10754322855eb5612c23e39c
  Platform:   Windows Server 2022, R-devel, 64 bit
  Submitted:  2h 5m 56.3s ago
  Build time: 6m 57s

❯ checking CRAN incoming feasibility ... [12s] NOTE
  Maintainer: 'Maria Gargiulo <mariag@hrdag.org>'

  New submission

❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖
```

This package is a new submission to CRAN. The `NULL` directory and the `lastMiKTeXException` appear to be known R-hub issues and can likely be ignored. See [R-hub issue #503](https://github.com/r-hub/rhub/issues/503) for information about the `NULL` directory issue and [R-hub issue #560](https://github.com/r-hub/rhub/issues/560) for more information about the `lastMiKTeXException` issue.

```
── verdata 0.9.1: NOTE

  Build ID:   verdata_0.9.1.tar.gz-ae460def69ec4f80b806d1e1ebc90325
  Platform:   Ubuntu Linux 20.04.1 LTS, R-release, GCC
  Submitted:  2h 5m 56.3s ago
  Build time: 2h 2m 17.6s

❯ checking CRAN incoming feasibility ... [7s/37s] NOTE
  Maintainer: ‘Maria Gargiulo <mariag@hrdag.org>’

  New submission

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
```

This package is a new submission to CRAN. The `no comand 'tidy' found` issue appears to be a known R-hub issue and can likely be ignored. [R-hub issue #548](https://github.com/r-hub/rhub/issues/548) has more information.

```
── verdata 0.9.1: NOTE

  Build ID:   verdata_0.9.1.tar.gz-f4477c10431f403f8b0338f5159bdc5f
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  2h 5m 56.3s ago
  Build time: 1h 48m 45.4s

❯ checking CRAN incoming feasibility ... [8s/44s] NOTE
  Maintainer: ‘Maria Gargiulo <mariag@hrdag.org>’

  New submission

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
```

This package is a new submission to CRAN. The `no comand 'tidy' found` issue appears to be a known R-hub issue and can likely be ignored. [R-hub issue #548](https://github.com/r-hub/rhub/issues/548) has more information.

win-builder had no errors or messages, but had one note.

```
* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Maria Gargiulo <mariag@hrdag.org>'

New submission
```

This package is a new submission to CRAN.

<!-- done. -->
