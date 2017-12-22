#!/usr/bin/python

import sys

#Test file
#file = open("testfile.txt")

try:
    for line in sys.stdin:
        #Validate for comma or tab delimeted file
        
        if line.find(',')==0:
            data = line.strip().split(",")
        else:
            data = line.strip().split("\t")
        
        #Validate the length of the line
        if len(data)==6:
            date, time, location, product, amount, card_type = data
        else:
            raise Exception('Error in file Format')
        
        print product, "\t", amount
except:
    print "Failed to load the file"
