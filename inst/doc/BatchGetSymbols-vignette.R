## ----example1------------------------------------------------------------
library(BatchGetSymbols, quietly = T)

first.date <- Sys.Date()-15
last.date <- Sys.Date()

tickers <- c('FB','NYSE:MMM','abcdef')

l.out <- BatchGetSymbols(tickers = tickers,
                         first.date = first.date,
                         last.date = last.date)


## ----example2------------------------------------------------------------
print(l.out$df.control)


## ----plot.prices, fig.width=7, fig.height=2.5----------------------------
library(ggplot2)
 
p <- ggplot(l.out$df.tickers, aes(x = ref.date, y = price.close, color = ticker))
p <-  p + geom_line()
print(p)

## ----example3,eval=FALSE-------------------------------------------------
#  library(BatchGetSymbols)
#  
#  first.date <- Sys.Date()-365
#  last.date <- Sys.Date()
#  
#  df.SP500 <- GetSP500Stocks()
#  tickers <- df.SP500$tickers
#  
#  l.out <- BatchGetSymbols(tickers = tickers,
#                           first.date = first.date,
#                           last.date = last.date)
#  
#  print(l.out$df.control)
#  print(l.out$df.tickers)
#  

