#' Fetch a lookup table and join it to your data.
#'
#' This function works with \href{https://CRAN.R-project.org/package=magrittr}{magrittr} pipes.
#'
#' @export
#' @param data A \code{data.frame} to join to.
#' @param keys A key column or vector of key columns to join on.
#' @param value A lookup table value.
#' @param lookup_keys A single lookup table key or a vector of keys, if different from \code{keys}.
#' @param version A lookup table version identifier.
#' @param source A \code{\link{lookup_source}} or \code{NULL} to use the default.
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
lookup <- function(data, keys, value, lookup_keys = NULL, version = NULL, source = NULL) {
  if (is.null(source)) {
    source <- lookup_source()
  }

  if (is.null(lookup_keys)) {
    lookup_keys <- keys
  }

  lookup_data <- get_table(source, lookup_keys, value, version)

  merge(
    data,
    lookup_data,
    by.x = keys,
    by.y = lookup_keys,
    all.x = TRUE
  )
}

#' Fetch the CPI lookup table and use it to inflation-adjust columns in a dataset.
#'
#' This function works with \href{https://CRAN.R-project.org/package=magrittr}{magrittr} pipes.
#'
#' @export
#' @param data A \code{data.frame} to join to.
#' @param values A single column name to be adjusteed or a vector of column names.
#' @param year The name of a column containing data years.
#' @param base The base year to adjust data to.
#' @param replace_columns If \code{TRUE}, the original, unadjusted columns will be replaced.
#' @param source A \code{\link{lookup_source}} or \code{NULL} to use the default.
#'
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
lookup_cpi <- function(data, values, year = "year", base = "2016", replace_columns = TRUE, source = NULL) {
  if (is.null(source)) {
    source <- lookup_source()
  }

  cpi_data <- get_table(source, "year", "cpi")

  base_value = cpi_data[cpi_data$year == base,]$cpi

  merged <- merge(
    data,
    cpi_data,
    by.x = year,
    by.y = "year",
    all.x = TRUE
  )

  for (value in values) {
    col_name <- value

    if (!replace_columns) {
      col_name = paste0(col_name, "_", base)
    }

    merged[[col_name]] <- merged[[value]] * (merged$cpi / base_value)
  }

  merged$cpi <- NULL

  merged
}

#' Fetch a lookup table and return it.
#'
#' @export
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @param source A \code{\link{lookup_source}} or \code{NULL} to use the default.
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
from_lookup <- function(keys, value, version = NULL, source = NULL) {
  if (is.null(source)) {
    source <- lookup_source()
  }

  get_table(source, keys, value, version)
}

