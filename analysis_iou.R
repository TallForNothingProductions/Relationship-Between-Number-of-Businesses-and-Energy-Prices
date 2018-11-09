#Copyright Nile Dixon, Tall For Nothing Productions
library(rjson)

#Select Generated JSON file
result <- fromJSON(file = file.choose())

#Change JSON file to Data Frame
result <- as.data.frame(result)

#Remove all data points with prices that are 0.0
result <- result[result$minimum_price > 0,]

#Generate basic plot of number of companies and average 
#price per kilowatt hour
plot(result$number_companies, result$average_price)

#Generate basic plot of number of companies and minimum 
#price per kilowatt hour
plot(result$number_companies, result$minimum_price)

#Linear Regression on the relationship between number of companies and 
#price of energy per kilowatt hour
relationship <- lm(result$average_price ~ result$number_companies)
summary(relationship)

#Normalize for States
normalize_for_states <- lm(result$average_price ~ result$number_companies + 
                             result$state)
summary(normalize_for_states)

#Remove outliers
result <- result[result$minimum_price < 0.2,]

#Linear Regression Again
relationship_wo_outliers <- lm(result$average_price ~ result$number_companies)
summary(relationship_wo_outliers)