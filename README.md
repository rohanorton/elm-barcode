# Barcode Creator

## Code 128

## Code 39

## Code 93

## Universal Product Code (UPC)

95 columns
15 sections
12 for numbers
+ left guard, centre guard, right guard
codes on left always have odd number of ones
codes on right always have even number of ones
all codes on left side begin with 0 and end with 1
all codes on right side begin with 1 and end with 0

7 modules per section

First number (outside barcode on left) tells what type of barcode
Last number modulo check char

10 - ((3(Σ odd) + (Σ even)) % 10)
- add digits in odd number positions
- add digits in even number positions

## EAN-13


## Databar?
