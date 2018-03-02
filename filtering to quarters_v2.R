setwd("D:/R/DSG")
MyData <- read.csv(file="toySet.csv", header=TRUE, sep=",")

pkgs <- c('magrittr','dplyr','tidyr', 'ggplot2','sparklyr')
invisible(lapply(pkgs, require, character.only = TRUE))

## working on the entire data at once 
## adding quarters and getting the summaries for each quarter 

MyData$quarter[MyData$month>= 0 & MyData$month <4] <- 1
MyData$quarter[MyData$month> 3 & MyData$month <7] <- 2
MyData$quarter[MyData$month> 6 & MyData$month <10] <- 3
MyData$quarter[MyData$month> 9 & MyData$month <13] <- 4

MyData$year_Q <- paste0(MyData$year," ","Q",MyData$quarter)

MyData %>%
  group_by(companies,year_Q) %>%     
      summarise(lines = n(), mean_cost = mean(cost), total_cost = sum(cost)) %>%
         arrange(companies,year_Q) -> costs_by_comp_q  

##lines plot - not so nice
#ggplot(data=costs_by_comp_q, aes(x=year_Q, y=mean_cost, group=companies)) + geom_line()


##display heatmaps before clustering
# quarter mean costs
ggplot(costs_by_comp_q, aes(x = year_Q, y = companies, fill = mean_cost)) + geom_tile() + scale_fill_gradient(low = "lightgrey",high = "darkblue")

#quarter total costs
ggplot(costs_by_comp_q, aes(x = year_Q, y = companies, fill = total_cost)) + geom_tile() + scale_fill_gradient(low = "lightgrey",high = "darkblue")
