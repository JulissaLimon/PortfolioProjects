"""
Program: LIMON-JULISSA-CH-5-EX-7.py
Author: Julissa Limon
Purpose: Create a program that inputs a text file and prints the unique words in the file in alphabetical order.
Date: 06.25.2023

"""

# Request the input
fileName = input("Enter the file name: ")

# Create an empty list
uniqueWords = []

# Open and read the file
inputFile = open(fileName, 'r')

# Process the file lines and sort the words in alphabetical order
for line in inputFile:                      # Separates lines into words
    words = line.split()
    for word in words:                      # Removes spaces from words
        word = word.strip()
        if word not in uniqueWords:         # Adds unique words to list (prevents repetition)
            uniqueWords.append(word)
uniqueWords.sort()                          # Sorts the unique words in alphabetical order

# Display the unique words in alphabetical order in a vertical list format
print()
print("The unique words in alphabetical order are:")
for word in uniqueWords:
    print(word)
