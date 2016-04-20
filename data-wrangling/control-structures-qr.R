# Control structures quick-reference

# http://bit.ly/1quVBGY
# Case When equivalent
library(memisc)

df <- data.frame(x = rnorm(n=20), y = rnorm(n=20))
df <- df[do.call(order,df),]
(df <- within(df,{
  x1=cases(x>0,x<=0)
  y1=cases(y>0,y<=0)
  z1=cases(
    "Condition 1"=x<0,
    "Condition 2"=y<0,# only applies if x >= 0
    "Condition 3"=TRUE
  )
  z2=cases(x<0,(x>=0 & y <0), (x>=0 & y >=0))
}))
