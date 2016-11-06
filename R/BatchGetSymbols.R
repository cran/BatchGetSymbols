#' Function to download financial data from a list of tickers
#'
#' This function is designed to make batch downloads of financial data using \code{\link[quantmod]{getSymbols}}.
#' Based on a set of tickers and a time period, the function will download the data for each ticker and return a report of the process, along with the actual data in the long dataframe format.
#' The main advantage of the function is that it automatically recognizes the source of the dataset from the ticker and structures the resulting data from different sources in the long format.
#'
#' @section Warning:
#'
#' Do notice that adjusted prices are not available from google finance. When using this source, the function will output NA values for this columns.
#'
#' @param tickers A vector of tickers. If not sure wheter the ticker is available, check the websites of google and yahoo finance
#' @param first.date The first date to download data (date class)
#' @param last.date The last date to download data (date class)
#' @param bench.ticker The ticker of the benchmark asset used to compared dates. My suggestion is to use the main stock index of the market from where the data is coming from (default = ^GSPC (SP500, US market))
#' @param thresh.bad.data A percentage threshold for defining bad data. The dates of the benchmark ticker are compared to each asset. If the percentage of non-missing dates
#'  with respect to the benchmark ticker is lower than thresh.bad.data, the function will ignore the asset (default = 0.9)
#'
#' @return A list with the following items: \describe{
#' \item{df.control }{A dataframe containing the results of the download process for each asset}
#' \item{df.tickers}{A dataframe with the financial data for all valid tickers} }
#' @export
#'
#' @seealso \link[quantmod]{getSymbols}
#'
#' @examples
#' tickers <- c('FB','NYSE:MMM')
#'
#' first.date <- Sys.Date()-30
#' last.date <- Sys.Date()
#'
#' l.out <- BatchGetSymbols(tickers = tickers,
#'                          first.date = first.date,
#'                         last.date = last.date)
#'
#' print(l.out$df.control)
#' print(l.out$df.tickers)
BatchGetSymbols <- function(tickers,
                            bench.ticker = '^GSPC',
                            first.date,
                            last.date,
                            thresh.bad.data = 0.9) {
  # check for internet

  test.internet <- curl::has_internet()

  if (!test.internet) {
    stop('No internet connection found...')
  }

  # check date class
  if (class(first.date) != 'Date') {
    stop('ERROR: Input first.date should be of class Date')
  }

  if (class(last.date) != 'Date') {
    stop('ERROR: Input first.date should be of class Date')
  }

  if (last.date<=first.date){
    stop('The last.date is lower (less recent) or equal to first.date. Check your dates!')
  }


  # check tickers
  if (!is.null(tickers)){
    tickers <- as.character(tickers)

    if (class(tickers)!='character'){
      stop('The input tickers should be a character object.')
    }
  }

  # check threshold
  if ( (thresh.bad.data<0)|(thresh.bad.data>1)){
    stop('Input thresh.bad.data should be a proportion between 0 and 1')
  }


  # build tickers.src (google tickers have : in their name)
  tickers.src <- ifelse(stringr::str_detect(tickers,':'),'google','yahoo')

  # fix for dates with google finance data
  # details: http://stackoverflow.com/questions/20472376/quantmod-empty-dates-in-getsymbols-from-google

  if(any(tickers.src=='google')){
    suppressWarnings({
      invisible(Sys.setlocale("LC_MESSAGES", "C"))
      invisible(Sys.setlocale("LC_TIME", "C"))
    })
  }


  # first screen msgs

  cat('\nRunning BatchGetSymbols for:')
  cat('\n   tickers =', paste0(tickers, collapse = ', '))
  cat('\n   Downloading data for benchmark ticker')

  # detect if bench.src is google or yahoo (google tickers have : in their name)
  bench.src <- ifelse(stringr::str_detect(bench.ticker,':'),'google','yahoo')

  df.bench <- myGetSymbols(ticker = bench.ticker,
                           src = bench.src,
                           first.date = first.date,
                           last.date = last.date)

  df.tickers <- data.frame()
  df.control <- data.frame()
  for (i.ticker in seq_along(tickers))
  {
    src.now <- tickers.src[i.ticker]
    ticker.now <- tickers[i.ticker]

    cat(paste0('\nDownloading Data for ', ticker.now, ' from ', src.now, ' (',i.ticker,'|',length(tickers),')'))

    out <- myGetSymbols(ticker = ticker.now,src = src.now,first.date = first.date, last.date = last.date)

    # control for ERROr in download
    if (is.character(out)){
      download.status = 'NOT OK'
      total.obs = 0
      perc.benchmark.dates = 0
      threshold.decision = 'OUT'

      out <- data.frame()
      cat(' - Error in download..')

    } else {
      download.status = 'OK'
      total.obs = nrow(out)
      perc.benchmark.dates = sum(out$ref.date %in% df.bench$ref.date)/length(df.bench$ref.date)

      if (perc.benchmark.dates>=thresh.bad.data){
        threshold.decision = 'KEEP'
      } else {
        threshold.decision = 'OUT'
      }

      cat(paste0(' - ', sample(c('OK!','Got it!','Nice!','Good stuff!','Good job!','Well done!'),1)))

      df.tickers <- rbind(df.tickers,out)


    }


    df.control <- rbind(df.control, data.frame(ticker=ticker.now,
                                               src = src.now,
                                               download.status,
                                               total.obs,
                                               perc.benchmark.dates,
                                               threshold.decision))
  }

  # remove tickers with bad data
  tickers.to.keep <- df.control$ticker[df.control$threshold.decision=='KEEP']
  idx <- df.tickers$ticker %in% tickers.to.keep
  df.tickers <- df.tickers[idx, ]

  my.l <- list(df.control = df.control,
               df.tickers = df.tickers)
  return(my.l)
}