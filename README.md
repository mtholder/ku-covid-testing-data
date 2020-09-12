# ku-covid-testing-data

**Please:**

  * See https://protect.ku.edu/ for information about the University of Kansas' response to the COVID-19 pandemic.
  * Be aware the this repository is *not* a primary (or even a vetted) source for data on SARS-CoV-2 at KU. The data in this repository is read from the figures published on that site. Errors can occur in that transcription. Treat the data at https://protect.ku.edu/ as the canonical source of information.
  * See the "Known issues" section below.


## Background
KU performed entry testing on students, faculty and staff who would be returning to campus. 
Summaries of that data were made available at https://protect.ku.edu/covid-19-test-reporting
I believe that the data in those summaries, was tabulated using the date the test results were reported (rather than the date of the test).
Some of the interim reports on that site may not have distinguished entry testing from targeted tests (tests from symptomatic people or known contacts of a positive test).

Starting on Friday 11 September, KU moved to publish reports at https://protect.ku.edu/data (also see [this message from Dr. Girod](https://chancellor.ku.edu/news/2020/sep11) which explains more of the context behind testing and the newer dashboard).

Currently the reports are for the periods:
  * [August 1 to Sept 10](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept10.pdf)
  * [August 3 to Sept 9](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept3toSept9.pdf)

Neither report traces the test-positivity percentage over time, which I was interested in.
Note that for a time-series of test-positivity rates to be easily interpreted as a proxy of the campus-wide prevalence of SARS-CoV-2 infections, it is important to either have rich, detailed knowledge of the biases associated with targeted testing, or to focus on the entry tests and "randomized prevalence testing."
Thus, this repository contains only data from the "Entry & Prevalence Testing" page of the Dashboard reports (that is page 2 in each of the reports).



## Data aggregation
Data in the dashboard reports is presented in a few summary statistics, and 2 sets stacked bar charts: one for the number of negative tests, and the other for the number of positive tests.
The bar charts present data by date, and they use 4 shades of blue to indicate whether the test subject was from Athletics, from the Edwards Campus, Lawrence Faculty/Staff, or a Lawrence student.

### Pipeline

  1. use a command like: `pdftk COVID-19_Dashboard_Aug1toSept10.pdf burst` to break the pdf into separate pages
  2. open page 2 in [Inkscape](https://inkscape.org/)
  3. For each stacked barchart:
    1. Record the y-coordinate of the pixel for the bottom of the chart,
    2. Find a bar for which the lowest set of bars are labelled with numbers
    3. Measure the y-coordinate of the top of that set of bars
    4. Calculate the # of tests per vertical pixel for that chart.
    5. Laboriously record the y-coordinates for all of the unknown bars in the charts (bars which do not show the number overlaid onto the bar itself)
    6. Convert the height of each bar to an approximate of the number of tests that the bar represents.
  4. Perform checks against the summary stats shown in the reports

Pixel reads and formulas for converting to approximations of the number of cases from each part of the bar chart are stored in [this Google Sheet](https://docs.google.com/spreadsheets/d/1K7SvMkJ8Vcy5eWaF7I3nVbRtYoLJeM91QlVwN46HK5I/edit?usp=sharing).

I am aware that there are some tools for measuring on-screen distances, but I was having to zoom in so far on the reports to increase precision, that I was finding the pixel-read method to be the most accurate.

## Data file
This repository contains a UTF-8-encoded "csv" file with tab as separators. The file has 9 data columns:
   1. Date in the month/day/year ("%m/%d/%y" in [strftime lingo](https://manpages.debian.org/buster/manpages-dev/strftime.3.en.html)) format that is preferred by most citizens of the USA.
   2. NegTestAthlectics - the number of negative tests collected from KU Athletics on that day
   3. NegTestEdwards - the number of negative tests collected from Edwards campus (Students+Faculty+Staff) on that day
   4. NegTestLFS - the number of negative tests collected from Lawrence Faculty and Staff on that day
   5. NegTestLStudents - the number of negative tests collected from Lawrence Students on that day
   6. PosTestAthletics - the number of positive tests collected from KU Athletics on that day
   7. PosTestEdwards - the number of positive tests collected from Edwards campus (Students+Faculty+Staff) on that day
   8. PosTestLFS - the number of positive tests collected from Lawrence Faculty and Staff on that day
   9. PosTestLStudents - the number of positive tests collected from Lawrence Students on that day


## Known issues

For the Aug 1 - Sept 10 check, the approximations I read from the bar charts indicated 25,034 negative tests, but the pdf on the dashboard's summary stats report 25,035 negative tests. So my pixel reading of at least on of the bar charts in that reports negative tests visualization was probably a little off. That was the hardest chart to read accurately, because the tests-represented-by-each-pixel calibration was the most extreme of all of the plots (unsurprisingly, given the large numbers depicted in that graph). 


Note that (unlike [the previous entry testing data](https://protect.ku.edu/covid-19-test-reporting)), the data in the dashboard reports is list as "by Collection Date". I am interpreting "Collection Date" as the sample collection date, rather than the day that the data was reported.
If that is correct, we should not expect perfect agreement between the numbers in this repository and the previous "by week" reporting; and we do see some discrepancies.
These are fairly small and it seems plausible to me that they are just the result of the difference between "date reported" vs "date collected."
