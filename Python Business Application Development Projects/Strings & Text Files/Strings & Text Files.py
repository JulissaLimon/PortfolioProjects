"""
Program: LIMON-JULISSA-CH-4-EX-12.py
Author: Julissa Limon
Purpose: Create a report from a text file of the wages paid to employees for a given period in tabular format.
Date: 06.17.2023

"""

# Request the input
fileName = input("Enter the file name: ")

# Open the file
inputFile = open(fileName, 'r')

# Display the header for the table
print("%-14s%-16s%-16s" % \
      ("Name", "Hours Worked", "Wages Paid"))

# Process file lines and compute wages paid
for line in inputFile:
    field = line.strip(' ').split(' ')
    name = field[0]
    hourlyWage = float(field[2])
    hours = int(field [1])
    wagesPaid = hourlyWage * hours
    print("%-14s%-16d%-16.2f" % \
          (name, hours, wagesPaid))
