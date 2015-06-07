OttoTrain <- read.csv("/Users/Zach/Dropbox/_Professional Work/Sites/kaggle/Ottotrain.csv", header = TRUE)
OttoTest <- read.csv("/Users/Zach/Dropbox/_Professional Work/Sites/kaggle/Ottotest.csv", header = TRUE)


str(OttoTrain)
summary(OttoTrain)

#each row is a product
#each column is a feature
#9 categories (fashion, electronics etc.)
#each product has to go into one of these 9 categories based off the features 

#SVM Package
install.packages("kernlab")
library(kernlab)

#Any NA's
#No NA's
any(is.na(OttoTrain))

#shows that data set has 144368 rows and 95 columns
dim(OttoTrain)

#for training-set us 1/10 of data to train

#create random data set and take 1st element of vector
randIndex <- sample(1:dim(OttoTrain)[1])

#floor gets rid of decimal because an index variable needs to be an integer - training
cutPoint1_10 <- floor(1 * dim(OttoTrain)[1]/10)
cutPoint1_10

#generate our train using 1/10 of data set
OttoTrain2 <- OttoTrain[randIndex[1:cutPoint1_10],]

#SVM model use training data to build model
svmOutput <- ksvm(target ~ ., data=OttoTrain2, kernel="rbfdot", 
                  kpar="automatic",C=5,cross=3,prob.model=TRUE)

#apply model to testing to help you classify payment plan arrangement, if it's accurate
svmPred <- predict(svmOutput, OttoTest, type="votes")
table(svmPred)

#transpose data
svmPredTransposed <- t(svmPred)

#copy into new df
ZachResult <- svmPredTransposed 

#convert matrix into a df
ZachResult <- as.data.frame(ZachResult)

#rename columns to ZachResult
colnames(ZachResult) <- c("Class_1", "Class_2", "Class_3", "Class_4","Class_5","Class_6",
                          "Class_7","Class_8", "Class_9")

#add in column
ZachResult$id <- OttoTest$id

#reorder id column to first index
ZachResult <- ZachResult[c(10,1:9)]

#write prediction results to csv
write.csv(ZachResult, "~/Dropbox/_Professional Work/Sites/kaggle/Otto_Zach.csv")

