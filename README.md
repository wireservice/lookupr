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

If you have a table with years and you want to add a column with the annual Consumer Price Index:

``` r
my_data_frame %>%
  lookup("year", "cpi")
```

If you're column name is different from `year`:

``` r
my_data_frame %>%
  lookup("my_year", "cpi", lookup_keys = "year")
```

For monthly CPI, with `year` and `month` columns:

``` r
my_data_frame %>%
  lookup(c("year", "month"), "cpi")
```
