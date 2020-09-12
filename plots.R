kucovid <- read.csv("negative-positive-tests-by-day.csv", header=TRUE, sep="\t", strip.white=TRUE);
kucovid$Date <- as.Date(kucovid$Date , "%m/%d/%y")

# function that returns an array of the sliding-window sums over nc (window size = ncwin)
#   yes, yes, I know R programmers don't write loops, I'm not a good R programmer...
sum.over.window <- function(nc, ncwin) {
  tdwnc = c()
  for (i in ncwin:length(nc)) {
    tind = i + 1 - ncwin;
    tdwnc[tind] = 0;
    for (j in 1:ncwin) {
      tdwnc[tind] = tdwnc[tind] + nc[1 + i - j] ;
    }
  }
  return(tdwnc);
}

# function that returns an array of the sliding-window means over nc (window size = ncwin)
#   yes, yes, I know R programmers don't write loops, I'm not a good R programmer...
mean.over.window <- function(nc, ncwin) {
  tdwnc <- sum.over.window(nc, ncwin);
  return(tdwnc/ncwin);
}

ratio.or.zero <- function(num, denom) {
  r <- num / denom;
  r[is.nan(r)] = 0;
  return(r);
}

posTestAll = kucovid$PosTestAthletics + kucovid$PosTestEdwards + kucovid$PosTestLFS + kucovid$PosTestLStudents
allTestsAthletics = kucovid$NegTestAthlectics + kucovid$PosTestAthletics
allTestsEdwards = kucovid$NegTestEdwards + kucovid$PosTestEdwards
allTestsLFS = kucovid$NegTestLFS + kucovid$PosTestLFS
allTestsLStudents = kucovid$NegTestLStudents + kucovid$PosTestLStudents
allTests = allTestsAthletics + allTestsEdwards + allTestsLFS + allTestsLStudents

win.len <- 7
swDates = kucovid$Date[win.len:length(kucovid$Date)]
swTests = mean.over.window(allTests, win.len)

posRateAthletics = ratio.or.zero(kucovid$PosTestAthletics, allTestsAthletics);
posRateEdwards = ratio.or.zero(kucovid$PosTestEdwards, allTestsEdwards);
posRateLFS = ratio.or.zero(kucovid$PosTestLFS, allTestsLFS);
posRateLStudents = ratio.or.zero(kucovid$PosTestLStudents, allTestsLStudents);
posRateAll = ratio.or.zero(posTestAll, allTests);

swPosTestsAll = sum.over.window(posRateAll, win.len);
swPosTestsLFS = sum.over.window(kucovid$PosTestLFS, win.len);
swPosTestsLStudents = sum.over.window(kucovid$PosTestLStudents, win.len);

swAllTestsAll = sum.over.window(allTests, win.len);
swAllTestsLFS = sum.over.window(allTestsLFS, win.len);
swAllTestsLStudents = sum.over.window(allTestsLStudents, win.len);

swPosRateAll = ratio.or.zero(swPosTestsAll, swAllTestsAll);
swPosRateLFS = ratio.or.zero(swPosTestsLFS, swAllTestsLFS);
swPosRateLStudents = ratio.or.zero(swPosTestsLStudents, swAllTestsLStudents);

# Agresti-Coull confidence intervals on positivity proportions for windows
swPPrimeLFS <- (swPosTestsLFS + 2)/(swAllTestsLFS + 4)
swPPrimeLStudents <- (swPosTestsLStudents + 2)/(swAllTestsLStudents + 4)

# Agresti-Coull Std. Errors
swSELFS <- sqrt(swPPrimeLFS*(1-swPPrimeLFS)/(swAllTestsLFS + 4))
swSELStudents <- sqrt(swPPrimeLStudents*(1-swPPrimeLStudents)/(swAllTestsLStudents + 4))

swUpperCILFS = swPPrimeLFS + 1.96*swSELFS
swUpperCILStudents = swPPrimeLStudents + 1.96*swSELStudents

swLowerCILFS = swPPrimeLFS - 1.96*swSELFS
swLowerCILFS[swLowerCILFS<0] = 0
swLowerCILStudents = swPPrimeLStudents - 1.96*swSELStudents
swLowerCILStudents[swLowerCILStudents<0] = 0

# If there is no data, but report no CI rather than a silly one
swUpperCILFS[swAllTestsLFS<1] = 1
swLowerCILFS[swAllTestsLFS<1] = 0

# barplot(allTests)
png("images/number-of-tests-over-time.png")
plot(swDates, swTests, type="l",
     main="# Entry+Prevalence tests per day (Mean over 7-day sliding window) by date",
     ylab="mean # of tests in previous 7 days",
     xlab="Last date in the 7-day window", ylim=c(0,2000));
abline(h=seq(00, 2000, by=100), lty=3, col="grey");
abline(h=seq(0, 2000, by=500), lty=1, col="grey");
dev.off()

png("images/test-positivity-over-time.png")
plot(swDates, swPosRateLStudents, type="l", col="red", ylim=c(0, .2),
     xlab = "Last date in the 7-day window",
     ylab="Proportion of tests postive in 7-day window",
     main="Proportion of tests positive (7-day window) with 95% CI"
     )
polygon(c(swDates, rev(swDates)), c(swUpperCILFS, rev(swLowerCILFS)), col=rgb(.6, .6, 1, .5), border=NA)
polygon(c(swDates, rev(swDates)), c(swUpperCILStudents, rev(swLowerCILStudents)), col=rgb(1, .6, .6, .5), border=NA)
lines(swDates, swPosRateLStudents, type="l", col="red")
lines(swDates, swPosRateLFS, type="l", col="blue")
lines(swDates, swPosRateAll, type="l", col="black", lty=3)
legend(c(swDates[4], swDates[4]), c(.19, .17),
       c("Lawrence Students", "Lawrence Fac/Staff"),
       col=c("red", "blue"), lty=1, bty="n",
       text.col = c("red", "blue"))
dev.off()
     