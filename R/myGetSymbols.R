#' An improved version of function \code{\link[quantmod]{getSymbols}} from quantmod
#'
#' This is a helper function to \code{\link{BatchGetSymbols}} and it should normally not be called directly. The purpose of this function is to download financial data based on a ticker and a time period.
#' The main difference from \code{\link[quantmod]{getSymbols}} is that it imports the data as a dataframe with proper named columns,
#' making it easy to aggregate the resulting dataframe with data from other tickers.
#'
#' @param ticker A single ticker to download data
#' @param src The source of the data ('google' or'yahoo')
#' @inheritParams BatchGetSymbols
#'
#' @return A dataframe with the financial data
#'
#' @export
#' @seealso \link[quantmod]{getSymbols} for the base function
#'
#' @examples
#' ticker <- 'FB'
#'
#' first.date <- Sys.Date()-30
#' last.date <- Sys.Date()
#'
#' \dontrun{
#' df.ticker <- myGetSymbols(ticker,
#'                           first.date = first.date,
#'                           last.date = last.date)
#' }
myGetSymbols <- function(ticker,
                         src = 'yahoo',
                         first.date,
                         last.date){

  # empty df
  temp.df <- data.frame()

  # get data with GetSymbols
  suppressMessages({
    suppressWarnings({
      try(temp.df <- quantmod::getSymbols(Symbols = ticker,
                                src = src,
                                from = first.date,
                                to = last.date,
                                auto.assign = F),
          silent = T)
    }) })

  # sleep for a bit (dont abuse yahoo or google!)
  Sys.sleep(0.5)

  if (nrow(temp.df) ==0) return('Error in download')

  temp.df <- as.data.frame(temp.df)

  # adjust df for difference of columns from yahoo and google
  if (src=='google'){

    colnames(temp.df) <- c('price.open','price.high','price.low','price.close','volume')
    temp.df$price.adjusted <- NA

  } else {

    colnames(temp.df) <- c('price.open','price.high','price.low','price.close','volume','price.adjusted')
  }

  # get a nice column for dates and tickers
  temp.df$ref.date <- as.Date(rownames(temp.df))
  temp.df$ticker <- ticker

  # remove rownames
  rownames(temp.df) <- NULL

  return(temp.df)


}
