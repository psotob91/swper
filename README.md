
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swper

<!-- badges: start -->
<!-- badges: end -->

The `swper` package provides functions for creating the **Survey-based
Women’s Empowerment Index (SWPER)**. The SWPER is a validated index for
measuring women’s empowerment across three domains: social independence,
decision-making, and attitude to violence. The external validity and
predictive value of the SWPER have been demonstrated in terms of
coverage of maternal and child interventions and use of modern
contraception ([Singh et
al. 2020](https://doi.org/10.7189%2Fjogh.10.020434)).

This package includes functions to create all indices (for each domain,
standardized for each region or globally). There are also functions to
categorize scores according to the cut-off points suggested in the
article. Functions are included to check that variables are correctly
coded to construct the score, as well as to impute hotdeck the variable
“woman’s age at first birth” according to the methodology developed
originally to create the index.

## Installation

You can install the `swper` package from GitHub using the `devtools`
package:

``` r
# Install devtools if you haven't already
install.packages("devtools")
```

``` r
# install.packages("devtools")
devtools::install_github("psotob91/swper")
```

## Functions

The swper package includes the following functions:

- `swper_score`: Calculates the SWPER index scores based on a data frame
  with the necessary variables. Users can specify which columns to use,
  the indices to compute, and whether to standardize the scores for a
  specific region or globally.

- `swper_categorize`: Categorizes the SWPER index scores into low,
  medium, and high categories based on suggested cut-off points.

- `swper_verify`: Checks that the variables are correctly coded to
  construct the SWPER index score. Users can specify which columns to
  use and which codes correspond to each response option.

- `swper_impute`: Imputes missing values for the “woman’s age at first
  birth” variable using hot deck imputation, as done in the original
  validation article.

For detailed information on each function, see the package
documentation.

## References

The initial development and validation of the SWPER index was conducted
for African populations in the following study:

> Ewerling, F., Lynch, J. W., Victora, C. G., van Eerdewijk, A.,
> Tyszler, M., & Barros, A. J. D. (2017). **The SWPER index for women’s
> empowerment in Africa: development and validation of an index based on
> survey data.** The Lancet Global Health, 5(9), e916-e923.
> <https://doi.org/10.1016/S2214-109X(17)30292-9>

Subsequently, a global adaptation and validation of the SWPER was
conducted:

> Singh, K., Bloom, S., Tsui, A., and Brodish, P. (2020). **The external
> validity and predictive value of the SWPER: a survey-based women’s
> empowerment index validated with maternal and child health indicators
> in low- and middle-income countries.** Journal of Global Health,
> 10(2), 020434. <https://doi.org/10.7189/jogh.10.020434>

Please note that the SWPER index created by the `swper` package is based
on the measures of women’s empowerment validated in the last article.

## Contributing

If you encounter any issues or have suggestions for new features, please
create an issue on the [GitHub
repository](https://github.com/psotob91/swper/issues). Pull requests are
also welcome.

## License

This package is licensed under the MIT license. See the
[LICENSE](https://github.com/psotob91/swper/blob/main/LICENSE.md) file
for more information.
