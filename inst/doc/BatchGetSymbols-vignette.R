## ----example1-----------------------------------------------------------------
if (!require(BatchGetSymbols)) install.packages('BatchGetSymbols')

library(BatchGetSymbols)

# set dates
first.date <- Sys.Date() - 60
last.date <- Sys.Date()
freq.data <- 'daily'
# set tickers
tickers <- c('FB','MMM','PETR4.SA','abcdef')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()


## ----example2-----------------------------------------------------------------
print(l.out$df.control)


## ----plot.prices, fig.width=7, fig.height=2.5---------------------------------
library(ggplot2)
 
p <- ggplot(l.out$df.tickers, aes(x = ref.date, y = price.close))
p <- p + geom_line()
p <- p + facet_wrap(~ticker, scales = 'free_y') 
print(p)

## ----example3,eval=FALSE------------------------------------------------------
#  library(BatchGetSymbols)
#  
#  first.date <- Sys.Date()-365
#  last.date <- Sys.Date()
#  
#  df.SP500 <- GetSP500Stocks()
#  tickers <- df.SP500$Tickers
#  
#  l.out <- BatchGetSymbols(tickers = tickers,
#                           first.date = first.date,
#                           last.date = last.date)
#  
#  print(l.out$df.control)
#  print(l.out$df.tickers)
#  

