# ku-covid-testing-data

*Caveats* **(Please read):**

  * See https://protect.ku.edu/ for information about the University of Kansas' response to the COVID-19 pandemic.
  * Be aware the this repository is *not* a primary (or even a vetted) source for data on SARS-CoV-2 at KU. The data in this repository is read from the figures published on that site. Errors can occur in that transcription. Treat the data at https://protect.ku.edu/ as the canonical source of information.
  * I ([Mark Holder](http://orcid.org/0000-0001-5575-0536)) am not part of KU's [Pandemic Medical Advisory Team](https://protect.ku.edu/pmat), and I do not intend this repository to be interpreted as a official source of information for KU. I created the repository because, I am interested in test-positivity rates over time. Because I am a strong proponent of open science, I am making the CSV files and scripts available here.
  * See the "Known issues" section below.
  * I am not really sure whether or not the prevalence testing (discussed below) is a random sampling procedure. I don't know the details. If it is not, then the test positivity rates may be biased estimates. **update on this point:** In the newly released (Wed 16, Sept) edition of ["Chancellor’s Weekly COVID-19 Update" (Episode 15)](https://coronavirus.ku.edu/chancellor%E2%80%99s-weekly-covid-19-update): 
      1. (at timestamp=4:18 on the video) Dr. Chris Wilson refers to page 2 of the reports used to generate the data in this repo: "this page here relates to the entry and prevalence testing. This was the saliva-based testing that we did, initially upon entry, and then some targeted, randomized efforts for both close contacts and samples that are representative of the campus population..."
      2. (at timestamp=17:47) Dr. David Wild on testing wanted to comment on "the change in strategy: moving now to testing contacts and, at some point, prevalence or randomized testing and those that are symptomatic..." The "at some point, prevalence or randomized testing" phrase makes me think that the page 2 of the dashboard reports may contain Entry and contact-tests, rather than randomized tests. Tests from close contacts would be a biased sample of the overall population, so a higher positivity rate would be expected for that form of testing.


## Background
KU performed entry testing on students, faculty and staff who would be returning to campus. 
Summaries of that data were made available at https://protect.ku.edu/covid-19-test-reporting
I believe that the data in those summaries, was tabulated using the date the test results were reported (rather than the date of the test).
Some of the interim reports on that site may not have distinguished entry testing from targeted tests (tests from symptomatic people or known contacts of a positive test).

Starting on Friday 11 September, KU moved to publish reports at https://protect.ku.edu/data (also see [this message from Dr. Girod](https://chancellor.ku.edu/news/2020/sep11) which explains more of the context behind testing and the newer dashboard).

Currently the reports are for the periods:
  * [August 1 to Sept 10](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept10.pdf)
  * [August 1 to Sept 13](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept13.pdf)
  * [August 1 to Sept 16](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept16.pdf)
  * [August 1 to Sept 20](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept20.pdf)
  * [August 1 to Sept 23](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Aug1toSept23.pdf)
  * [Sept 3 to Sept 9](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept3toSept9.pdf)
  * [Sept 7 to Sept 13](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept7toSept13.pdf)
  * [Sept 7 to Sept 13](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept7toSept13.pdf)
   * [Sept 10 to Sept 16](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept10toSept16.pdf)
   * [Sept 14 to Sept 20](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept14toSept20.pdf)
   * [Sept 17 to Sept 23](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept17toSept23.pdf)
   * [Sept 21 to Sept 27](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept21toSept27.pdf)
   * [Sept 28 to Oct 04](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Sept28toOct4.pdf)
   * [Oct 01 to Oct 07](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Oct1toOct7.pdf)
   * [Oct 05 to Oct 11](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Oct5toOct11.pdf)
   * [Oct 08 to Oct 14](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboa_Oct8toOct14.pdf)
   * [Oct 12 to Oct 18](https://protect.ku.edu/sites/protect/files/documents/Dashboard/COVID-19_Dashboard_Oct12toOct18.pdf)
 
None of the reports trace the test-positivity percentage over time, which I was interested in.
For a time-series of test-positivity rates to be easily interpreted as a proxy of the campus-wide prevalence of SARS-CoV-2 infections, it is important to either have detailed knowledge of the biases associated with targeted testing, or to focus on the entry tests and "randomized prevalence testing."
Thus, this repository contains only data from the "Entry & Prevalence Testing" page of the Dashboard reports (that is page 2 in each of the reports).



## Data aggregation
Data in the dashboard reports is presented in a few summary statistics, and 2 sets of stacked bar charts: one for the number of negative tests, and the other for the number of positive tests.
The bar charts show data by date, and they use 4 shades of blue to indicate whether the test subject was from Athletics, from the Edwards Campus, Lawrence Faculty/Staff, or a Lawrence student.

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


## Plots
Currently the `plots.R` script is used to create to 3plots:

![plot of number of tests by time](https://raw.githubusercontent.com/mtholder/ku-covid-testing-data/master/images/number-of-nonath-tests-over-time.png)


![plot of number of tests by time](https://raw.githubusercontent.com/mtholder/ku-covid-testing-data/master/images/number-of-tests-over-time.png)

As mentioned above in the "update on this point", it is not clear how to interpret the following graph of positivity rates because it is very unclear what the population being sampled (since we don't know what fraction of the tests are from contact tracing), but the test positivity over time is:

![plot of test positivity over time](https://raw.githubusercontent.com/mtholder/ku-covid-testing-data/master/images/test-positivity-over-time.png)

## Known issues

**Note**: following the Tuesday, Sept 15 update, I updated the counts covered in the smaller report (Sept 7-13), but I did **not** reread older dates from the comprehensive report. There was one labelled bar (for 08/26/2020) in the comprehensive report that changed. So that was updated. Measuring all of the bars takes quite a bit of time, hopefully most of the earlier dates are stable. But those numbers should be re-measured at some point if KU does not release the results in a text form. 

  * For the Aug 1 - Sept 10 check, the approximations I read from the bar charts indicated 25,034 negative tests, but the pdf on the dashboard's summary stats report 25,035 negative tests. So my pixel reading of at least on of the bar charts in that reports negative tests visualization was probably a little off. That was the hardest chart to read accurately, because the tests-represented-by-each-pixel calibration was the most extreme of all of the plots (unsurprisingly, given the large numbers depicted in that graph). 

  * Note that the Total Tests number in the dashboard reports is greater than the sum of "Neg. Results" and "Pos. Results". In checking by approximations of the data, I used the "Neg. Results" and "Pos. Results" summaries.
  
  * Apparently, I can't spell "athletics" so the 2nd column in the CSV file really is "NegTestAthlectics". I'll need to fix that in the R script, too.

Note that (unlike [the previous entry testing data](https://protect.ku.edu/covid-19-test-reporting)), the data in the dashboard reports is list as "by Collection Date". I am interpreting "Collection Date" as the sample collection date, rather than the day that the data was reported.
If that is correct, we should not expect perfect agreement between the numbers in this repository and the previous "by week" reporting; and we do see some discrepancies.
These are fairly small and it seems plausible to me that they are just the result of the difference between "date reported" vs "date collected."
