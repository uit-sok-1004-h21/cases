qs <- makeFun(a0 + a1*p ~ p, a0=a0, a1=a1)
qd <- makeFun(b0 + b1*p ~ p, b0=b0, b1=b1)

supply <- 
  ggplot(data = data.frame(p = c(0,200)), aes(x = p)) + 
  stat_function(fun = qs, colour = "blue") +
  labs(title = "Ordinary supply", subtitle = "flipped axis") + ylab("quantity") + xlab("price") +
  coord_flip()

demand <- 
  ggplot(data = data.frame(p = c(0,200)), aes(x = p)) + 
  stat_function(fun = qd, colour = "red") +
  labs(title = "Ordinary demand", subtitle = "flipped axis") + ylab("quantity") + xlab("price") +
  coord_flip()

equilibrium <- 
  ggplot(data = data.frame(p = c(0,200)), aes(x = p)) + 
  stat_function(fun = qs, colour = "blue") +
  stat_function(fun = qd, colour = "red") +
  labs(title = "Market equilibrium", subtitle = "flipped axis") + ylab("quantity") + xlab("price") +
  coord_flip()

grid.arrange(supply, demand, equilibrium, ncol=3)

mod1 <- lm(miles ~ income + age + kids, data = vacation)
summary(mod1)
confint(mod1)
#b
mod1 <- lm(miles ~ income + age + kids, data = vacation)
summary(mod1)
mod1 %>%
augment() %>%
select(.resid, income) %>% ggplot(aes(x=income,y=abs(.resid))) + geom_point(col="darkgreen") +
  ggtitle(": OLS residuals versus income") +
  xlab("Income is measured in $1000") + ylab(expression(abs(phantom(x)*hat(e)[i]*phantom(x)))) +
  theme_classic()
mod1 %>%
augment() %>% select(.resid, age) %>% ggplot(aes(x=age,y=abs(.resid))) + geom_point(col="darkgreen") +
  ggtitle(": OLS residuals versus age") +
  xlab("age") + ylab(expression(abs(phantom(x)*hat(e)[i]*phantom(x)))) +
  theme_classic()
geom_hline(yintercept=0, col="red")

require(broom)
fit.metrics <- augment(mod1)
ggplot(fit.metrics, aes(x=resid, y=age)) + geom_point() 
  
# The unit root test.
library(urca)
summary(ur.df(lcons_str, type = "trend", lags = 2))
summary(ur.df(inc_str, type = "trend", lags = 2))

library(tseries)
adf.test(lcons_str)
adf.test(inc_str)

#Unit root test at first diference of the variables
summary(ur.df(diff(lcons_str), type = "none", lags = 0))
summary(ur.df(diff(inc_str), type = "none", lags = 0))

adf.test(diff(lcons_str))
adf.test(diff(inc_str))

# Model 5 and 6
#*********************************************************

mod_5=dynlm(lcons~0+t+d_1+d_2+d_3+d_4+inc, data = dataa)
mod_6=dynlm(lcons_str~0+inc_str)

summary(mod_5)
summary(mod_6)

#Extract the residuals from each mode for cointegration test
res_5=resid(mod_5)
res_6=resid(mod_6)

#Cointegration test 
fit_5 <- dynlm(d(res_5)~t+L(res_5))
summary(fit_5)
#
library(lmtest)
#serial correlation 
bgtest(fit_5)
bgtest(fit_5,2)
bgtest(fit_5,3)

# Compare the the t-value from estimated model fit_5, i.e., t-value= -3.97
