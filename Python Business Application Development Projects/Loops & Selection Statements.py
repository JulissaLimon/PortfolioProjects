"""
Program: LIMON-JULISSA-CH-3-EX-10.PY
Author: Julissa Limon
Purpose: Create a credit plan based on a given purchase price at TidBit Computer Store.
Date: 06.11.2023

"""

# Initialize the constants
ANNUAL_RATE = 0.12
MONTHLY_RATE = ANNUAL_RATE / 12

# Request the input
purPrice = float(input("Enter the total value of your purchase: "))

# Setup the variables
downPmt = purPrice * 0.10
loanAmt = purPrice - downPmt
monPmt = loanAmt * 0.05

# Display the header for the table
print("%5s%15s%15s%16s%17s%19s" % \
      ("Month", "Total Balance", "Interest Owed",
       "Principal Owed", "Monthly Payment", "Remaining Balance"))

# Compute and display the results of each month
monCount = 1
while loanAmt > 0:
    if monPmt < loanAmt:
        intOwed = loanAmt * MONTHLY_RATE
        prinOwed = monPmt - intOwed
    else:
        prinOwed = loanAmt
        intOwed = loanAmt * MONTHLY_RATE
        monPmt = prinOwed + intOwed
    remBalance = loanAmt - prinOwed
    print("%5d%15.2f%15.2f%16.2f%17.2f%19.2f" % \
          (monCount, loanAmt, intOwed, prinOwed, monPmt, remBalance))
    loanAmt = remBalance
    monCount = monCount + 1
