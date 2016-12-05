.onAttach <- function(libname, pkgname) {

  citation.apa <- 'Perlin, M. (2016) BatchGetSymbols: Downloads and Organizes Financial Data for Multiple Tickers. CRAN Package, Available in https://CRAN.R-project.org/package=BatchGetSymbols.'

  citation.bibtex <- '@misc{perlin2016batchgetsymbols,
  title = {BatchGetSymbols: Downloads and Organizes Financial Data for Multiple Tickers},
  author = {Marcelo Perlin},
  year = {2016},
  journal = {CRAN Package},
  url = {https://CRAN.R-project.org/package=BatchGetSymbols}
}
}'
  my.message <- paste('\nThank you for using BatchGetSymbols! If applicable, please use the following citation',
                      'in your research report. Thanks!',
                      '\n\nAPA:\n',citation.apa,
                      '\n\nBIBTEX:\n',citation.bibtex )
  packageStartupMessage(my.message)
}
