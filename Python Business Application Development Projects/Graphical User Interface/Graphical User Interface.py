"""
Program: LIMON-JULISSA-CH-8-EX-1.py
Author: Julissa Limon
Purpose: Create a GUI-based program that implements the tax calculator program shown in Figure 8-2.
Date: 07.06.2023

"""
# Initialize the constants (calculated based on the numbers given in Figure 8-2).
STANDARD_DEDUCTION = 10000.00
DEPENDENT_DEDUCTION = 3000.00
TAX_RATE = 0.20

# Import EasyFrame class from breezypythongui module
from breezypythongui import EasyFrame

class TaxCalculator(EasyFrame):
    """ Computes and displays the total tax owed. """
    def __init__(self):
        """ Sets up the window and widgets. """
        EasyFrame.__init__(self, title = "Tax Calculator")

        # Label and text field for the gross income
        self.addLabel(text = "Gross Income", row = 0, column = 0)
        self.income = self.addFloatField(value = 0.0, row = 0, column = 1)

        # Label and text field for the number of dependents
        self.addLabel(text = "Dependents", row = 1, column = 0)
        self.dep = self.addIntegerField(value = 0, row = 1, column = 1)

        # The command button
        self.addButton(text = "Compute", row = 2, column = 0, columnspan = 2, command = self.computeTax)

        # Label and text field for the total tax
        self.addLabel(text = "Total Tax", row = 3, column = 0)
        self.tax = self.addFloatField(value = 0.0, row = 3, column = 1, precision = 2)

    # The event handling method for the button
    def computeTax(self):
        """ Computes and outputs taxes owed based on obtained and valid inputs. """
        income = self.income.getNumber()
        dependents = self.dep.getNumber()
        tax = (income - STANDARD_DEDUCTION - dependents * DEPENDENT_DEDUCTION) * TAX_RATE
        self.tax.setNumber(tax)

# The main function for this program
def main():
        TaxCalculator().mainloop()

# The entry point for program execution
if __name__ == "__main__":
    main()
