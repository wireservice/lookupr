#' Fetch a lookup table and join it to the give \code{data.frame}.
#'
#' This method works with \code{%>%} pipes.
#'
#' @export
#' @param data A \code{data.frame} to join to.
#' @param keys A key column or vector of key columns to join on.
#' @param value A lookup table value.
#' @param lookup_keys A single lookup table key or a vector of keys, if different from \code{keys}.
#' @param version A lookup table version identifier.
#' @param source A \code{lookup_source} or \code{NULL} to use the default.
#' @param require_match If \code{TRUE}, values without a match in the lookup table will raise an error.
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
lookup <- function(data, keys, value, lookup_keys = NULL, version = NULL, source = NULL, require_match = NULL) {
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

#' Fetch a lookup table and return it.
#'
#' @export
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @param source A \code{lookup_source} or \code{NULL} to use the default.
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
from_lookup <- function(keys, value, version = NULL, source = NULL) {
  if (is.null(source)) {
    source <- lookup_source()
  }

  get_table(source, keys, value, version)
}

