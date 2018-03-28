library(ada)
# Rattle is Copyright (c) 2006-2015 Togaware Pty Ltd.

#============================================================
# Rattle timestamp: 2017-03-15 23:33:18 x86_64-w64-mingw32 

# Rattle version 4.1.0 user 'Chirag'

# This log file captures all Rattle interactions as R commands. 

#Export this log to a file using the Export button or the Tools 
# menu to save a log of all your activity. This facilitates repeatability. For example, exporting 
# to a file called 'myrf01.R' will allow you to type in the R Console 
# the command source('myrf01.R') and so repeat all actions automatically. 
# Generally, you will want to edit the file to suit your needs. You can also directly 
# edit this current log in place to record additional information before exporting. 

# Saving and loading projects also retains this log.

# We begin by loading the required libraries.

library(rattle)   # To access the weather dataset and utility commands.
library(magrittr) # For the %>% and %<>% operators.

# This log generally records the process of building a model. However, with very 
# little effort the log can be used to score a new dataset. The logical variable 
# 'building' is used to toggle between generating transformations, as when building 
# a model, and simply using the transformations, as when scoring a dataset.

building <- TRUE
scoring  <- ! building


# A pre-defined value is used to reset the random seed so that results are repeatable.

crv$seed <- 42 

#============================================================
# Rattle timestamp: 2017-03-15 23:35:14 x86_64-w64-mingw32 

# Load the data.

crs$dataset <- read.csv("file:///C:/Users/Chirag/Desktop/complaints.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

#============================================================
# Rattle timestamp: 2017-03-15 23:36:01 x86_64-w64-mingw32 

# Note the user selections. 


#============================================================
# Rattle timestamp: 2017-03-15 23:37:52 x86_64-w64-mingw32 

# Note the user selections. 

# Build the training/validate/test datasets.

set.seed(crv$seed) 
crs$nobs <- nrow(crs$dataset) # 245709 observations 
crs$sample <- crs$train <- sample(nrow(crs$dataset), 0.7*crs$nobs) # 171996 observations
crs$validate <- sample(setdiff(seq_len(nrow(crs$dataset)), crs$train), 0.15*crs$nobs) # 36856 observations
crs$test <- setdiff(setdiff(seq_len(nrow(crs$dataset)), crs$train), crs$validate) # 36857 observations

# The following variable selections have been noted.

crs$input <- c("Date_received", "Product", "Issue", "Company",
               "State", "ZIP_code", "Consumer_consent_provided.", "Submitted_via",
               "Date_sent_to_company", "Company_response_to_consumer", "Consumer_disputed", "Complaint.ID")

crs$numeric <- "Complaint.ID"

crs$categoric <- c("Date_received", "Product", "Issue", "Company",
                   "State", "ZIP_code", "Consumer_consent_provided.", "Submitted_via",
                   "Date_sent_to_company", "Company_response_to_consumer", "Consumer_disputed")

crs$target  <- "Timely_response"
crs$risk    <- NULL
crs$ident   <- NULL
crs$ignore  <- c("Sub.product", "Sub.issue", "Consumer_complaint_narrative", "Company.public.response", "Tags")
crs$weights <- NULL

#============================================================
# Rattle timestamp: 2017-03-15 23:58:04 x86_64-w64-mingw32 

# Ada Boost 

# The `ada' package implements the boost algorithm.

# Build the Ada Boost model.

set.seed(crv$seed)
crs$ada <- ada::ada(Timely_response ~ .,
                    data=crs$dataset[crs$train,c(crs$input, crs$target)],
                    control=rpart::rpart.control(maxdepth=30,
                                                 cp=0.010000,
                                                 minsplit=20,
                                                 xval=10),
                    iter=50)

# Print the results of the modelling.

MYada<- crs$ada
MYada

print(crs$ada)
round(crs$ada$model$errs[crs$ada$iter,], 2)
cat('Variables actually used in tree construction:\n')
print(sort(names(listAdaVarsUsed(crs$ada))))
cat('\nFrequency of variables actually used:\n')
print(listAdaVarsUsed(crs$ada))
# Time taken: 47.66 mins


# Evaluate model performance. 

# Generate an Error Matrix for the Decision Tree model.

# Obtain the response from the Decision Tree model.

crs$pr <- predict(crs$rpart, newdata=crs$dataset[crs$validate, c(crs$input, crs$target)], type="class")

# Generate the confusion matrix showing counts.

table(crs$dataset[crs$validate, c(crs$input, crs$target)]$Timely_response, crs$pr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))

# Generate the confusion matrix showing proportions.

pcme <- function(actual, cl)
{
  x <- table(actual, cl)
  nc <- nrow(x) # Number of classes.
  nv <- length(actual) - sum(is.na(actual) | is.na(cl)) # Number of values.
  tbl <- cbind(x/nv,
               Error=sapply(1:nc,
                            function(r) round(sum(x[r,-r])/sum(x[r,]), 2)))
  names(attr(tbl, "dimnames")) <- c("Actual", "Predicted")
  return(tbl)
}
per <- pcme(crs$dataset[crs$validate, c(crs$input, crs$target)]$Timely_response, crs$pr)
round(per, 2)

# Calculate the overall error percentage.

cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))

# Calculate the averaged class error percentage.

cat(100*round(mean(per[,"Error"], na.rm=TRUE), 2))

# Generate an Error Matrix for the Ada Boost model.

# Obtain the response from the Ada Boost model.

crs$pr <- predict(crs$ada, newdata=crs$dataset[crs$validate, c(crs$input, crs$target)])

# Generate the confusion matrix showing counts.

table(crs$dataset[crs$validate, c(crs$input, crs$target)]$Timely_response, crs$pr,
      useNA="ifany",
      dnn=c("Actual", "Predicted"))

# Generate the confusion matrix showing proportions.

pcme <- function(actual, cl)
{
  x <- table(actual, cl)
  nc <- nrow(x) # Number of classes.
  nv <- length(actual) - sum(is.na(actual) | is.na(cl)) # Number of values.
  tbl <- cbind(x/nv,
               Error=sapply(1:nc,
                            function(r) round(sum(x[r,-r])/sum(x[r,]), 2)))
  names(attr(tbl, "dimnames")) <- c("Actual", "Predicted")
  return(tbl)
}
per <- pcme(crs$dataset[crs$validate, c(crs$input, crs$target)]$Timely_response, crs$pr)
round(per, 2)

# Calculate the overall error percentage.

cat(100*round(1-sum(diag(per), na.rm=TRUE), 2))

# Calculate the averaged class error percentage.

cat(100*round(mean(per[,"Error"], na.rm=TRUE), 2))
