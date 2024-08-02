#### LIBRARIES ####

library(readr)

#### BASE IPCA ####

# IMPORT #

IPCA_sample <- read.csv("IPCA_Mensal.csv", sep = ";")
View(IPCA_sample)

# TRANSFORM #

colnames(IPCA_sample) <- c("DATE","RATE")

IPCA_sample$RATE <- as.numeric(IPCA_sample$RATE)

IPCA_sample <- na.omit(IPCA_sample)

# HIST #

hist(IPCA_sample$RATE, col='grey')

#### STIR ####

### Simulate Sample Paths - CIR ###

## define model parameters
r0 <- tail(IPCA_sample$RATE, n=1)
theta <- mean(IPCA_sample$RATE)
k <- 1
beta <- sd(IPCA_sample$RATE,na.rm = TRUE)

## simulate short rate paths
n <- 10    # MC simulation trials
T <- 12    # total time
m <- 20000   # subintervals
dt <- T/m  # difference in time each subinterval

r <- matrix(0,m+1,n)  # matrix to hold short rate paths
r[1,] <- r0

for(j in 1:n){
  for(i in 2:(m+1)){
    dr <- k*(theta-r[i-1,j])*dt + beta*sqrt(dt)*rnorm(1,0,1)
    r[i,j] <- r[i-1,j] + dr
    #ava <- mean(r[31,])
      }
} 

#### PLOT PATHS ####

t <- seq(0, T, dt)
rT.expected <- theta + (r0-theta)*exp(-k*t)
rT.stdev <- sqrt(beta^2/(2*k)*(1-exp(-2*k*t)))
matplot(t, r[,1:10], type="l", lty=1, main="Short Rate Paths", ylab="rt", col = "gray") 
abline(h=theta, col="red", lty=2)
lines(t, rT.expected, lty=2, col="red") 
lines(t, rT.expected + 2*rT.stdev, lty=2) 
lines(t, rT.expected - 2*rT.stdev, lty=2)
lines(t,rowMeans(r[,1:10]),col="red")
points(0,r0)
mean(rT.expected)
min(rT.expected)
max(rT.expected)
View(colMeans(r[,1:10]))

