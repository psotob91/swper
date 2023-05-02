#' SWPER Verification Function
#'
#' This function checks that the variables in a given data frame are correctly coded to construct the SWPER index score. Users can specify which columns to use and which codes correspond to each response option.
#'
#' @name swper_verify
#' @title SWPER Verification Function
#'
#' @param df A data frame with the variables to be verified.
#' @param cols A vector with the names or indices of the columns to be verified.
#'
#' @return A data frame with the results of the verification, including the variable name, item name, valid codes, invalid values, and missing values for each specified column.
#' @importFrom dplyr select
#' @export
#'

swper_verify <- function(df, cols) {
  valid_codes_per_variable <- list(
    c(-1, 0, 1), # x1
    c(-1, 0, 1), # x2
    c(-1, 0, 1), # x3
    c(-1, 0, 1), # x4
    c(-1, 0, 1), # x5
    c(0, 1, 2), # x6
    "years", # x7
    "years", # x8
    "years", # x9
    "years", # x10
    "years", # x11
    c(-1, 1), # x12
    c(-1, 1), # x13
    c(-1, 1) # x14
  )

  # Seleccionamos las columnas del data frame
  df_filtrado <- df |>
    dplyr::select({{ cols }})

  # Verificamos si los valores en las columnas están dentro de los códigos válidos específicos
  verification_results <- lapply(seq_along(df_filtrado), function(i) {
    col <- df_filtrado[[i]]
    valid_codes <- valid_codes_per_variable[[i]]

    if (is.character(valid_codes) && valid_codes == "years") {
      valid_range <- 15:49
      invalid_values <- col[!col %in% valid_range]
      missing_values <- setdiff(valid_range, unique(col))
    } else {
      invalid_values <- col[!col %in% valid_codes]
      missing_values <- setdiff(valid_codes, unique(col))
    }

    col_name <- colnames(df_filtrado)[i]
    result <- list(
      variable = col_name,
      item = col_name, # Deberías cambiar esto por el nombre del ítem que corresponda a cada variable
      valid_codes = paste(valid_codes, collapse = ", "),
      invalid_values = if (length(unique(invalid_values)) == 0) "No invalid values" else paste("The following values are invalid:", paste(unique(invalid_values), collapse = ", ")),
      missing_values = paste(missing_values, collapse = ", ")
    )
    return(result)
  })

  # Unimos los resultados en un data.frame
  verification_df <- do.call(rbind, verification_results)
  verification_df <- as.data.frame(verification_df, stringsAsFactors = FALSE)
  return(verification_df)
}
