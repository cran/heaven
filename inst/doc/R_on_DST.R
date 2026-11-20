## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# devtools::install_github("tagteam/heaven")

## ----eval=FALSE---------------------------------------------------------------
# vars <- c("var1","var2"...)
# for (x in vars) DT[get(x)==999,(x):=NA]

## -----------------------------------------------------------------------------
library(data.table)
DT1 <- data.table(a=1:5,b=11:15)
DT2 <- data.table(a=c(2,4,6),c=c(22,24,26))
setkey(DT1,"a")
setkey(DT2,"a")
DT1[DT2]

## -----------------------------------------------------------------------------
merge(DT1,DT2,by="a",all=TRUE)

## -----------------------------------------------------------------------------
merge(DT1,DT2,by="a") # or you could have written all=FALSE

## -----------------------------------------------------------------------------
library(data.table)
disease<-data.table(disease.date=sample(seq(as.Date('2015/01/01'), as.Date('2020/01/01'), by="day"), 6),
           pnr=seq(1:6),
           sex=rep(1:2,3))


hospital.adm<-data.table(admission.date=sample(seq(as.Date('2015/01/01'), as.Date('2021/01/01'), by="day"), 30),
                         pnr=sample(c(1:6),30, replace=TRUE))

#rolling join:
#prepare roll
disease[, rolldate := disease.date]
hospital.adm[, rolldate := admission.date]

setkey(disease,pnr,rolldate) #the variables which define the match
setkey(hospital.adm,pnr,rolldate) #the variables which define the match

# add the first hospital admission occuring after the disease
hospital.adm[disease,roll=-Inf]

# add the first hospital admission occuring after the disease date but within 1 year of disease
hospital.adm[disease,roll=-364.25]

## -----------------------------------------------------------------------------
library(data.table)
DT <- data.table(ID=c(1:3),number=c(1,2,3))
DT[] # Display the result
DT[,rownum:=1:.N] # variable indicating row
DT2 <- DT[,.(ID=ID,newvar=seq(1,number)),by="rownum"] # makes the extra records
DT2[] # Display the result

## -----------------------------------------------------------------------------
library(data.table)
DT <- data.table(ID=c(1:3),number=c(1,2,3),number2=c(8,9,10))
rbindlist(lapply(DT[,number],function(x){ # the function being defined right here
  data.table(PTID=DT[ID==x,ID],output=DT[ID==x,number2]*x) # Illustrative nonsense calculation
  # The last statement of a function is what is output
}))


## ----eval=TRUE----------------------------------------------------------------
if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(data.table)
  library(ggplot2)
  setDT(dt <- mpg) #toy dataset described at
  #[https://ggplot2.tidyverse.org/reference/mpg.html]
  ggplot(data=dt,mapping=aes(x=cty,y=hwy))+
      geom_point() #most simple scatterplot
}

## ----eval=TRUE,out.width = "50%"----------------------------------------------
if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot(data=dt,mapping=aes(x=cty,y=hwy))+
    geom_point()+ #most simple scatterplot
    theme_classic() #adding theme
}

## ----eval=TRUE,out.width = "50%"----------------------------------------------
if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot(data=dt,mapping=aes(x=cty,y=hwy))+
    geom_point()+ #most simple scatterplot
    theme_classic()+ #adding theme
    labs(title="Title",
          x="CTY",
          y="HWY") #adding plot titles
}

## ----eval=TRUE,out.width = "50%"----------------------------------------------
if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot(data=dt,mapping=aes(x=cty,y=hwy))+
    geom_point()+ #most simple scatterplot
    theme_classic()+ #adding theme
    labs(title="Title",
          x="CTY",
          y="HWY")+ #adding plot titles
    geom_point(mapping=aes(color=fl)) #adding grouping
    #(could also be included in the previous geom_point call)
}

