#' @name swper_score
#' @title Calculate the Survey-based Women emPowERment index (SWPER)
#' @description This function calculates the SWPER index for each combination of indices and standardization regions.
#'
#' @param df A data frame containing the input data.
#' @param cols A vector of column names used for calculating the SWPER index.
#' @param indices A character vector indicating which indices to calculate (default: "all").
#'   - "score_av": Attitude to Violence index.
#'   - "score_si": Social Independence index.
#'   - "score_dm": Decision Making index.
#' @param standardization A character vector indicating the regions for standardization (default: "raw").
#'   - "raw": No standardization applied.
#'   - Other values represent different standardization regions.
#'
#' @return A data frame containing the SWPER index for each combination of indices and standardization region. The data frame may have the following columns:
#' - swper_score_av_raw: The raw SWPER index for the "av" index (Attitude to Violence) without standardization.
#' - swper_score_av_glob: The global standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_sa: The South Asia standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_eap: The East Asia & the Pacific standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_euca: The Europe & Central Asia standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_mena: The Middle East & North Africa standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_wca: The West & Central Africa standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_eas: The Eastern & Southern Africa standardized SWPER index for the "av" index (Attitude to Violence).
#' - swper_score_av_lac: The Latin America & Caribbean standardized SWPER index for the "av" index (Attitude to Violence).
#' Similar columns will be present for the "si" (Social Independence) and "dm" (Decision Making) indices, with the respective suffixes.
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom tidyr expand_grid
#' @importFrom tibble tibble
#' @importFrom purrr pmap
#' @importFrom rlang :=
#' @examples
#' # Load sample data
#' data(sample_data)
#' @export
#'
swper_score <- function(df, cols, indices = "all", standardization = "raw") {
  valid_indices <- paste0("score_", c("av", "si", "dm"))

  if (identical(indices, "all")) {
    indices <- valid_indices
  } else if (!all(indices %in% valid_indices)) {
    stop("Invalid index specified. Please use 'all' or a vector containing any combination of 'score_av', 'score_si', and 'score_dm'.")
  }

  index_weights <- list(
    score_av = c(
      0.508, 0.508, 0.526, 0.538, 0.588, 0.083, 0.016, -0.006,
      -0.010, 0.001, 0.002, 0.001, -0.017, 0.002
    ),
    score_si = c(
      -0.012, -0.026, 0.001, 0.001, -0.015, 0.422, 0.081, 0.133,
      0.139, 0.031, 0.054, -0.004, -0.022, -0.034
    ),
    score_dm = c(
      -0.003, -0.040, 0.007, 0.028, -0.020, 0.121, 0.022, -0.012,
      -0.016, 0.013, 0.001, 0.599, 0.601, 0.619
    )
  )

  constants <- list(
    score_av = -1.202,
    score_si = -5.661,
    score_dm = -0.168
  )

  standardization_values <- list(
    glob = list(
      mean = c(0.000, 0.000, 0.000), # Global
      sd = c(1.811, 1.526, 1.502)
    ),
    sa = list(
      mean = c(-0.138, -0.121, -0.097), # South Asia
      sd = c(1.804, 1.452, 1.546)
    ),
    eap = list(
      mean = c(0.238, 0.757, 0.792), # East Asia & the Pacific
      sd = c(1.563, 1.550, 0.950)
    ),
    euca = list(
      mean = c(0.256, 1.286, 0.619), # Europe & Central Asia
      sd = c(1.701, 1.169, 1.296)
    ),
    mena = list(
      mean = c(-0.167, 0.371, 0.014), # Middle East & North Africa
      sd = c(1.923, 1.549, 1.449)
    ),
    wca = list(
      mean = c(-0.601, -0.683, -0.913), # West & Central Africa
      sd = c(2.030, 1.346, 1.562)
    ),
    eas = list(
      mean = c(0.094, -0.142, 0.246), # Eastern & Southern Africa
      sd = c(1.745, 1.350, 1.283)
    ),
    lac = list(
      mean = c(1.084, 0.460, 0.674), # Latin America & Caribbean
      sd = c(0.852, 1.546, 1.049)
    ),
    raw = list(
      mean = c(0, 0, 0),
      sd = c(1, 1, 1)
    )
  )

  df_filtered <- df |>
    dplyr::select({{ cols }})

  # Create all combinations of indices and regions
  combinations <- tidyr::expand_grid(index = indices, region = standardization)

  result <- combinations |> purrr::pmap(function(index, region) {
    raw_index <- constants[[index]] + rowSums(df_filtered * index_weights[[index]])

    if (!is.null(region)) {
      standardized_result <- (raw_index - standardization_values[[region]]$mean[match(index, indices)]) /
        standardization_values[[region]]$sd[match(index, indices)]
      return(tibble::tibble(!!paste0("swper_", index, "_", region) := standardized_result))
    } else {
      return(tibble::tibble(!!paste0("swper_", index) := raw_index))
    }
  })

  result <- dplyr::bind_cols(result)
  return(result)
}
