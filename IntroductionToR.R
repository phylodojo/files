###Introduction to R

##What is R?
##A programming language for statistical data analyis and data visualization

##Why use R?
#Free, open source, constantly updated, lots of free guidance (caution)

##What is RStudio?
##An integrated development environment (IDE) for working within R and writing scripts, documenting analyses, replcation.

##Parts of RStudio
#editor - top left
#console - bottom left
#history - top right
#Misc - bottom right - includes plots

##What is a script?
##A place to store your R code and replicate analyses.

##How do I create a script in RStudio?
###File -> New File -> R script

#What is a comment?
# denotes a comment and is ignored by R
help(c) #tell how to use the c function


#where can I find data to play with (also used in tutorials/vignettes)
#data()

#How do I find packages related to the types of analyses I am interested in
#https://crantastic.org
#http://rseek.org/
#https://cran.r-project.org/web/views/
#https://mran.microsoft.com/ (formerly insideR)

citation("ape") #retrieve package citation

##How to install packages
#install.packages("diveRsity", dependencies = TRUE)
#Tools > Install packages...

#What to do if I need help?
?install.packages()
help(install.packages)

#Function is install.packages(). Look at usage and arguments to provide the function.
#Important dependencies=TRUE
install.packages("diveRsity", dependencies = TRUE)

##installation does not mean the package is loaded
##packages are called libraries once loaded into R
library(diveRsity)

2+2
x <- 2+2

###Data Types
#Vectors, Matrices, and Data Frames 
#There are others
##VECTORS
myVector <- c(3,4,5,4,4,3,5,6,7,2) #create a vector by using the function c to combine a list of numbers and assign them to a variable called myVector using <- or =
myVector #see what is contained in the variable myVector
length(myVector) #how many elements are in myVector
myVector[9] #what is the value of the 9th element in myVector
myVector[c(9,10)] #see two values using the combine function
class(myVector) #see how R is interpreting the values stored in myVector - 'numeric'

myFactorVector <- as.factor(myVector) #convert numeric values to factors and assign to a new variable myFactorVector
class(myFactorVector) #see how R is interpreting the values stored in myFactorVector - 'factor'
myFactorVector #see what is contained in myFactorVector
myVector
levels(myFactorVector) #see how many different factors are represented in myFactorVector

##MATRICES
# generates 5 x 4 numeric matrix 
myMatrix <-matrix(1:25, nrow=5,ncol=5, byrow = TRUE)
myMatrix
class(myMatrix)
myMatrix[1,] #look at row 1
myMatrix[,1] #look at column 1
myMatrix[3,3] #look at value in row 3 column 5

column1 <- c(1,2,3,4)
column2 <- c("red", "white", "red", "green")
column3 <- c(TRUE,FALSE,TRUE,TRUE)
mydataFrame <- data.frame(column1,column2, column3)
names(mydataFrame) <- c("ID","Color","PRIMARY COLOR") # column names
mydataFrame
names(mydataFrame) <- c("ID","Color","PRIMARY_COLOR") #bad idea to have spaces in column names (or anywhere else)
mydataFrame
class(mydataFrame$ID)
class(mydataFrame$Color)
class(mydataFrame$PRIMARY_COLOR)
mydataFrame$ID[2] ##Access the second value in the ID column
mydataFrame[,1][2] ##Different way to access the second value in the first (ID) column
mydataFrame[2,1] ##Different way to access the second row, first column (ID)
sum(mydataFrame$ID) #add all values in my first column
sum(mydataframe$ID) #case matters. Error: object 'mydataframe' not found
sum(mydataFrame$id) #NO ERROR! be careful because sometimes you will not get an error, but case matters
sum(mydataFrame$Color) #Error: ‘sum’ not meaningful for factors. Check class of mydataFrame$Color - not numeric

##Objects - R stores everything in objects (including results of analyses)
objects() #see all objects you have created with the objects() function


##setting and getting your working directory (folder)
getwd()
list.files(".") #show the files that are in your current directory
setwd("/Users/vinson/Dropbox/Teaching/ADVANCEDMYCOLOGY/Class4/") #change to desired directory
list.files(".") #list the files in the new directory

#reading in a datafile in csv format
anacardIsos <- read.csv("AnacardiumIsolatesSpecies.csv", header=TRUE) #you should always explicitly specify if a header exists 

#examine data file to make sure it is as expected
head(anacardIsos) #shows first 6 lines by default
?head
head(anacardIsos,10) #specify number of lines with second argument
tail(anacardIsos) #shows last lines

#Check for misspelled names and fix
levels(anacardIsos$Species)

#Set new level for correct names
levels(anacardIsos$Species) <- c(levels(anacardIsos$Species), "C. chrysophilum", "C. fragariae","C. communis", "C. endomangiferae")
anacardIsos$Species[anacardIsos$Species == "C. chrisophilum"]  <- "C. chrysophilum"
anacardIsos$Species[anacardIsos$Species == "C. fragareae"]  <- "C. fragariae"
anacardIsos$Species[anacardIsos$Species == "C.communis"]  <- "C. communis"
anacardIsos$Species[anacardIsos$Species == "C.endomagifereae"]  <- "C. endomangiferae"

#Drop unused levels
levels(anacardIsos$Species) #before dropping
anacardIsos$Species <- factor(anacardIsos$Species)
levels(anacardIsos$Species) #after dropping
anacardIsos

##Add column for biomes Amazon [PA], Atlantic Forest [AL, PE, SC], Caatinga [CE, PB, RN], Cerrado [DF, MG, GO]
anacardIsos$Biomes <- NA
head(anacardIsos)
anacardIsos$Biomes[which(anacardIsos$Code=="PA")] <- "Amazon"
anacardIsos$Biomes[which(anacardIsos$Code=="AL" | anacardIsos$Code=="PE" | anacardIsos$Code=="SC")] <- "Atlantic"
anacardIsos$Biomes[which(anacardIsos$Code=="CE" | anacardIsos$Code=="PB" | anacardIsos$Code=="RN")] <- "Caatinga"
anacardIsos$Biomes[which(anacardIsos$Code=="DF" | anacardIsos$Code=="MG" | anacardIsos$Code=="GO")] <- "Cerrado"

#change Biomes column to factors
anacardIsos$Biomes <- as.factor(anacardIsos$Biomes)

sumData <- summary(anacardIsos) #summarize data
sumData #does not include everything (see Other)
sumData <- summary(anacardIsos, maxsum = 50)
sumData

#Build a contingency table of counts and plot
?table
counts <- table(anacardIsos$Host, anacardIsos$Code)
counts

#Plot stacked barplot
par(mfrow=c(1, 1), mar=c(5, 5, 4, 8)) #set plotting parameters
barplot(counts)
barplot(counts, main="Isolates per Host by State", xlab="State") #add labels
barplot(counts, main="Isolates per Host by State", xlab="State", col=c("yellow","forestgreen","darkblue")) #add colors
barplot(counts, main="Isolates per Host by State", xlab="State", col=c("yellow","forestgreen","darkblue"), args.legend = list(x="topleft"),legend = rownames(counts))

#add legend separately and reduce size
barplot(counts, main="Isolates per Host by State", xlab="State", col=c("yellow","forestgreen","darkblue")) #add colors
legend("topleft", legend = rownames(counts), fill = c("yellow","forestgreen","darkblue"), cex = 0.666) #add legend separately and reduce its size with cex

#save plot to a pdf
pdf("NumberIsolatesPerHostbyState.pdf") #set name of pdf to be saved
par(mfrow=c(1, 1), mar=c(5, 5, 4, 8))
barplot(counts, main="Isolates per Host by State", xlab="State", col=c("yellow","forestgreen","darkblue")) #add colors
legend("topleft", legend = rownames(counts), fill = c("yellow","forestgreen","darkblue"), cex = 0.666) #add legend separately and reduce its size with cex
dev.off() #turns off plotting device
