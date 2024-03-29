"""
Program: LIMON-JULISSA-CH-2-EX-3.py
Author: Julissa Limon
Purpose: Compute the total cost for a customer's video rentals at Five Star Retro Video.
Date: 06.04.2023

"""

# Initialize the constants
DVD_RENTAL_RATE = 3.00
VHS_TAPE_RENTAL_RATE = 2.00

# Request the inputs
numDVDs = int(input("Enter the number of DVD rentals: "))
numVHSTapes = int(input("Enter the number of VHS tape rentals: "))

# Compute the total cost
totalCost = numDVDs * DVD_RENTAL_RATE + \
            numVHSTapes * VHS_TAPE_RENTAL_RATE

# Display the total cost
print("The total cost of the video rentals is $" + "{:.2f}".format(round(totalCost)))
