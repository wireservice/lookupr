#' Generate a path to find a given lookup table.
#'
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @return A lookup table path.
make_table_path <- function(keys, value, version = NULL) {
  if (is.vector(keys)) {
    keys <- paste0(keys, collapse = "/")
  }

  path <- paste0(keys, "/", value)

  if (!is.null(version)) {
    path <- paste0(path, ".", version)
  }

  paste0(path, ".csv")
}

#' Generate a path to find a given lookup table's metadata.
#'
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @return A lookup table metadata path.
make_metadata_path <- function(keys, value, version = NULL) {
  path <- make_table_path(keys, value, version)

  paste0(path, ".yml")
}

#' Create a \code{lookup_source} object which handles fetching lookup tables.
#'
#' @param root Root url to the hosted lookup tables.
#' @return A source object.
lookup_source <- function(root = "http://wireservice.github.io/lookup") {
  structure(list(
    root = root
  ), class = "lookup_source")
}

#' Fetch remote metadata for a lookup table.
#'
#' @param x A \code{lookup_source} object.
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @return See \code{yaml.load}.
get_metadata <- function(x, keys, value, version = NULL) UseMethod("get_metadata")

get_metadata.lookup_source <- function(x, keys, value, version = NULL) {
  path <- make_metadata_path(keys, value, version)

  url <- paste0(x$root, "/", path)

  text <- paste0(readLines(url), collapse = "\n")

  yaml::yaml.load(text)
}

#' Convert agate column types to R types.
#'
#' @param c A column definition from lookup table metadata.
#' @return A column type suitable for use with \code{read_csv}.
map_column_type <- function(c) {
  if (c$type == "Text") {
    return("c")
  } else if (c$type == "Number") {
    return("n")
  } else if (c$type == "Date") {
    return("D")
  } else if (c$type == "DateTime") {
    return("T")
  }

  NULL
}

#' Fetch a lookup table from a remote url.
#'
#' @param x A \code{lookup_source} object.
#' @param keys A single lookup table key or a vector of keys.
#' @param value A lookup table value.
#' @param version A lookup table version identifier.
#' @return A \code{tbl}, or \code{NULL} if the table does not exist.
get_table <- function(x, keys, value, version = NULL) UseMethod("get_table")

get_table.lookup_source <- function(x, keys, value, version = NULL) {
  meta <- get_metadata(x, keys, value, version)
  col_types <- sapply(meta$columns, map_column_type)

  path <- make_table_path(keys, value, version)

  url <- paste0(x$root, "/", path)

  text <- paste0(readLines(url), collapse = "\n")

  readr::read_csv(text, col_types = paste0(col_types, collapse = ""))
}
