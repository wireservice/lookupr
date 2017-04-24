# lookup

Lookup pulls common lookup tables from the [lookup](https://github.com/wireservice/lookup) repository and joins them to your data.

This is a port of Python's [https://agate-lookup.readthedocs.io](agate-lookup).

This version does not do caching. If you don't want to redownload lookup tables, save a local copy of your results.

## Install

From Github:

``` r
install.packages("devtools")
devtools::install_github("wireservice/lookupr")
```

## Usage

Load libraries:

``` r
library(dplyr)
library(lookupr)
```

Lookup the consumer price index for yearly data:

``` r
data <- data.frame(year = c("2004", "2005", "2006", "2007"))

data %>%
  lookup("year", "cpi")
```

```
  year     cpi
1 2004 188.908
2 2005 195.267
3 2006 201.558
4 2007 207.344
```

If you're column name is different from `year`:

``` r
data <- data.frame(anum = c("2004", "2005", "2006", "2007"))

data %>%
  lookup("anum", "cpi", lookup_keys = "year")
```

```
  anum     cpi
1 2004 188.908
2 2005 195.267
3 2006 201.558
4 2007 207.344
```

Monthly CPI:

``` r
data <- data.frame(
  year = c("2004", "2004", "2005", "2005"),
  month = c("11", "12", "1", "2")
)

data %>%
  lookup(c("year", "month"), "cpi")
```

```
  year month   cpi
1 2004    11 191.7
2 2004    12 191.7
3 2005     1 191.6
4 2005     2 192.4
```