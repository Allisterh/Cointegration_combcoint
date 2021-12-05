
<!-- README.md is generated from README.Rmd. Please edit that file -->

# combcoint

<!-- badges: start -->

[![R-CMD-check](https://github.com/jens-klenke/combcoint/workflows/R-CMD-check/badge.svg)](https://github.com/jens-klenke/combcoint/actions)
<!-- badges: end -->

## Overview

`combcoint` is package which provides, among other things, the
*Combining non-cointegration tests* of Bayer and Hanck. The following
cointegration tests are implemented:

-   `bayerhanck()` to perform the *Combining non-cointegration test*
    which is implemented in two different versions, see the help file,
    with the command `?bayerhnack()` for more information
-   `boswijk()` to perform the Boswijk cointegration test
-   `banerjee()` to perform the banerjee cointregration test

## Installation

<!--
You can install the released version of combcoint from [CRAN](https://CRAN.R-project.org) with:


```r
install.packages("combcoint")
```
-->

The development version can be downloaded from
[GitHub](https://github.com/jens-klenke/combcoint) with:

``` r
# install.packages("devtools")
devtools::install_github("jens-klenke/combcoint")
```

## Usage

First install the package as described above

``` r
library(combcoint)

combcoint::bayerhanck(sp ~ ibm + ko, data = ibmspko)
```

## Reference

Bayer, C. and Hanck, C. (2013). Combining non-cointegration tests.
*Journal of Time Series Analysis*, 34(1), 83 – 95.
<https://doi.org/10.1111/j.1467-9892.2012.00814.x>

Boswijk, H. P. (1994), Testing for an unstable root in conditional and
structural error correction models, *Journal of Econometrics* 63(1),
37-60.
<https://www.sciencedirect.com/science/article/abs/pii/0304407693015609>

Johansen, S. (1988), Statistical analysis of cointegration vectors,
*Journal of Economic Dynamics and Control* 12(2-3), 231-254.
<https://www.sciencedirect.com/science/article/abs/pii/0165188988900413>

Banerjee, A., Dolado, J. J. and Mestre, R. (1998), Error-correction
Mechanism Tests for Cointegration in a Single-equation Framework,
*Journal of Times Series Analysis* 19(3), 267-283.
<https://doi.org/10.1111/1467-9892.00091>

Engle, R. and Granger, C. (1987), Co-integration and Error Correction:
Representation, Estimation, and Testing, *Econometrica* 55(2), 251-76.
<https://doi.org/10.2307/1913236>
