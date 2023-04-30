#' @name swper_score
#' @title Calculate Survey-based Women emPowERment index (SWPER)
#' @description This function calculates the SWPER score for a given dataset and set of indices, and returns the result as a data frame.
#'
#' @param df The dataset to use.
#' @param cols The columns of the dataset to use.
#' @param indices The indices to use in the SWPER index calculation.
#' @param estandarizacion The region of standardization to use.
#'
#' @return A data frame containing the SWPER index for each combination of indices and standardization region.
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom tidyr expand_grid
#' @importFrom tibble tibble
#' @importFrom purrr pmap
#' @importFrom rlang :=
#' @export
#'

swper_score <- function(df, cols, indices, estandarizacion = NULL) {
  pesos_indices <- list(
    score_av = c(0.508, 0.508, 0.526, 0.538, 0.588, 0.083, 0.016, -0.006,
                 -0.010, 0.001, 0.002, 0.001, -0.017, 0.002),

    score_si = c(-0.012, -0.026, 0.001, 0.001, -0.015, 0.422, 0.081, 0.133,
                 0.139, 0.031, 0.054, -0.004, -0.022, -0.034),

    score_dm = c(-0.003, -0.040, 0.007, 0.028, -0.020, 0.121, 0.022, -0.012,
                 -0.016, 0.013, 0.001, 0.599, 0.601, 0.619)
  )

  estandarizacion_valores <- list(
    global = list(mean = c(0.000, 0.000, 0.000),
                  sd = c(1.811, 1.526, 1.502)),
    south_asia = list(mean = c(-0.138, -0.121, -0.097),
                      sd = c(1.804, 1.452, 1.546)),
    east_asia_pac = list(mean = c(0.238, 0.757, 0.792),
                         sd = c(1.563, 1.550, 0.950)),
    eu_cent_asia = list(mean = c(0.256, 1.286, 0.619),
                        sd = c(1.701, 1.169, 1.296)),
    mid_east_nor_afr = list(mean = c(-0.167, 0.371, 0.014),
                            sd = c(1.923, 1.549, 1.449)),
    west_cent_afr = list(mean = c(-0.601, -0.683, -0.913),
                         sd = c(2.030, 1.346, 1.562)),
    east_south_afr = list(mean = c(0.094, -0.142, 0.246),
                          sd = c(1.745, 1.350, 1.283)),
    lat_ame_carib = list(mean = c(1.084, 0.460, 0.674),
                         sd = c(0.852, 1.546, 1.049))
  )

  df_filtrado <- df |>
    dplyr::select({{cols}})

  # Creamos todas las combinaciones de índices y regiones
  combinaciones <- tidyr::expand_grid(index = indices, region = estandarizacion)

  resultado <- combinaciones |> purrr::pmap(function(index, region) {

    indice_bruto <- rowSums(df_filtrado * pesos_indices[[index]])

    if (!is.null(region)) {
      resultado_estandarizado <- (indice_bruto - estandarizacion_valores[[region]]$mean[match(index, indices)]) /
        estandarizacion_valores[[region]]$sd[match(index, indices)]
      return(tibble::tibble(!!paste0("swper_", index, "_", region) := resultado_estandarizado))
    } else {
      return(tibble::tibble(!!paste0("swper_", index) := indice_bruto))
    }
  })

  resultado <- dplyr::bind_cols(resultado)
  return(resultado)
}
