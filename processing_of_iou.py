#Python version 2.7
#Copyright by Nile Dixon, Tall For Nothing Productions

import csv
import json
from statistics import mean

data = {}
final_data = {'number_companies' : [], 'state' : [], 'average_price' : [], 'minimum_price' : []}

#Opens CSV file to prepare data for R script
with open("iouzipcodes2015.csv","r") as filetoread:
	csvfile = csv.reader(filetoread)
	for row in csvfile:
		zip_code = row[0]
		state = row[3]
		residential_rate = float(row[8])
		if zip_code not in data:
			data[zip_code] = {'state' : state, 'residential_rates' : []}
		data[zip_code]['residential_rates'].append(residential_rate)

#Putting Data into Dictionary to be read in for R script
for zip_code in data:
	number_of_companies = len(data[zip_code]['residential_rates'])
	state = data[zip_code]['state']
	average_price = float(mean(data[zip_code]['residential_rates']))
	minimum_price = float(min(data[zip_code]['residential_rates']))

	final_data['number_companies'].append(number_of_companies)
	final_data['state'].append(state)
	final_data['average_price'].append(average_price)
	final_data['minimum_price'].append(minimum_price)

#Saves Dictionary into JSON file for R Script
with open("preprocessed_iou.json","w") as filetowrite:
	json.dump(final_data, filetowrite, indent = 4)	