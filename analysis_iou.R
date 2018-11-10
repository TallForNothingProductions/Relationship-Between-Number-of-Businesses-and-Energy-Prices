#Copyright Nile Dixon, Tall For Nothing Productions
library(rjson)

#Select Generated JSON file
result <- fromJSON(file = file.choose())

#Change JSON file to Data Frame
result <- as.data.frame(result)

#Remove all data points with prices that are 0.0
result <- result[result$minimum_price > 0,]

#Add additional variable for difference between no competition vs competition
result$deregulated <- result$number_companies > 1
result$deregulated <- as.numeric(result$deregulated)

#Generate basic plot of number of companies and average 
#price per kilowatt hour
plot(result$number_companies, result$average_price)

#Generate basic plot of number of companies and minimum 
#price per kilowatt hour
plot(result$number_companies, result$minimum_price)

#T Test to see the difference in prices from regulated and deregulated markets
regulated_zip_codes <- result$average_price[result$deregulated == 0]
deregulated_zip_codes <- result$average_price[result$deregulated == 1]

t.test(x = regulated_zip_codes, 
       y = deregulated_zip_codes)

#Linear Regression on the relationship between number of companies and 
#price of energy per kilowatt hour
relationship <- lm(result$average_price ~ result$number_companies)
summary(relationship)

#Normalize for States
normalize_for_states <- lm(result$average_price ~ result$number_companies + 
                             result$state)
summary(normalize_for_states)

#Average Cost per State
average_price_per_state <- aggregate(result$average_price, by = list(result$state), FUN = mean)