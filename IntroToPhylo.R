##Gettting started with R for phylogenetics

# Lets install some packages that we will use.
#install the "haplotypes" package
install.packages("haplotypes")

#load the haplotypes package
library(haplotypes)

#install the "ape" package
install.packages("ape")

#load the ape package
library(ape)

#phangorn - There are some issues with phangorn presently, but this is a package that you may want to investigate in the future.
#install.packages("phangorn")
#library(phangorn)

#phytools is another powerful package. We will not explore it much here, but you should check it out.
install.packages("phytools")
library(phytools)

# The first thing we will do is take a look at some aligned sequences (nrITS) of a single species (Curvularia lunata) contained in a fasta file.
# These sequences were downloaded from GenBank, aligned in mafft, and trimmed so they are of equal length.
# Below we are going to see how many distinct haplotypes we have in this alignment and identify the haplotype groups.

#install the "haplotypes" package
install.packages("haplotypes")

#load the haplotypes package
library(haplotypes)

#change to the directory containing the alignment in fasta format
setwd("/Users/vinson/Dropbox/Teaching/Phylogenetics/Day5_Practical/") #Your file path will be different. You can drag the folder into R to get the file path.
getwd()

#read in the aligned fasta file with all sequences. You may want to open the alignment in Aliview to take a look at it.
compltAlignmt <- read.fas("Clunata.its.mafft.GINSi.trimmed.fasta") #You can use tab to find the files in your working directory.
compltAlignmt #See some features of the compltAlignmt
compltAlignmt@seqnames #use the slot attributes to see the sequence names
compltAlignmt@seqlengths #use the slot attributes to see the sequence lengths

#identify haplotypes (unique sequences)
uniqueHaplos <-haplotype(compltAlignmt,indels="sic")

#print haplotype assignments
uniqueHaplos

#How many haplotypes?
uniqueHaplos@nhap
uniqueHaplos@uniquehapind #Identify a representative of each haplotype.

####################
####################

#Using ape to read in phylogenetic trees

# Read in one of the best trees from your Garli ML search.
garBest1 <- read.nexus("garli_run.run00.best.tre") #Tree is in nexus format. Use read.tree for phylip/newick format.

# Read in the other tree
garBest2 <- read.nexus("garli_run.run01.best.tre")

#Write tree to file in newick format.
write.tree(garBest1, file = "garli.run00.best.phy")

#Read tree in newick format
garBest1.phy <- read.tree("garli.run00.best.phy")

#Trees are stored in objects of class "phylo". Usually we can see everything that is stored within an object by typing the name of the object.
garBest1
garBest2
garBest1.phy

# However, for phylo objects, use str function to see what is stored.
str(garBest1)
garBest1$edge  #internal and external branches - first column is starting node and second is ending node
garBest1$edge.length #branch lengths correspond to edges above
garBest1$Nnode #number of nodes
garBest1$tip.label #tip labels


# Plot the tree
plot.phylo(garBest1)
help("plot.phylo") #see what options are available for plotting phylogenies
plot.phylo(garBest1, type = "phylogram", edge.width = 1) # plot with thin branches
plot.phylo(garBest1, type = "phylogram", edge.width = 4) # plot with thick branches
plot.phylo(garBest1, type = "phylogram", edge.width = 4, show.tip.label=FALSE) #drop tip labels
plot.phylo(garBest1, type = "radial", edge.width = 4, show.tip.label=TRUE) #radial plot
plot.phylo(garBest1, type = "phylogram", edge.width = 4, show.tip.label=TRUE, use.edge.length = FALSE) #without branch lengths

#Lets see how R numbers the tips and nodes for later reference
plot.phylo(garBest1, type = "phylogram", edge.width = 4, show.tip.label=TRUE) #First, plot the tree.
tiplabels() #see the numerical labels for the tips [1-8]
nodelabels() # 9-14
garBest1$edge  #internal and external branches - first column is starting node and second is ending node
# nodes that share a common starting node share a recent common ancestor

# Lets remove Boletus edulis from the tree
help(drop.tip)
garBest1.ascos <- drop.tip(garBest1, "EU554664.1.Boletus.edulis")
plot(garBest1.ascos)


#Root tree on JQ726609.1.Saccharomyces.cerevisiae
help(root)
#Check to see if it is already rooted.
is.rooted(garBest1.ascos)
rooted.garBest1.ascos <- root(garBest1.ascos, "JQ726609.1.Saccharomyces.cerevisiae", resolve.root = TRUE)
is.rooted(rooted.garBest1)
plot(rooted.garBest1.ascos)

#Lets look at the distribution of edge lengths
hist(garBest1$edge.length)

#Lets extract a subtree
plot(rooted.garBest1.ascos)
nodelabels()
#Extract subtree that descends from node 9
subTreePezizomycotina <- extract.clade(rooted.garBest1.ascos, 9) 
plot(subTreePezizomycotina)
is.rooted(subTreePezizomycotina)

# Color branches and tips
plot(subTreePezizomycotina)
subTreePezizomycotina$edge #see edge order
nodelabels() #show nodelabels for seeing the order to color branches
tiplabels() #show tiplabels for seeing the order to color tips

colors() #see all the colors R knows about

plot(subTreePezizomycotina, edge.color=c("blue","orange","orange","orange","orange","orange","blue","blue"), edge.width=4, tip.color=c("purple","violetred","purple","purple","violetred"))

# Change direction of plot
#Left
plot(subTreePezizomycotina, edge.color=c("blue","orange","orange","orange","orange","orange","blue","blue"), edge.width=4, tip.color=c("purple","violetred","purple","purple","violetred"), direction = "l")
#Up
plot(subTreePezizomycotina, edge.color=c("blue","orange","orange","orange","orange","orange","blue","blue"), edge.width=4, tip.color=c("purple","violetred","purple","purple","violetred"), direction = "u")
#Down
plot(subTreePezizomycotina, edge.color=c("blue","orange","orange","orange","orange","orange","blue","blue"), edge.width=4, tip.color=c("purple","violetred","purple","purple","violetred"), direction = "d")

# Saving plot to a file in pdf format
pdf("coloredTreePlot.pdf")
plot(subTreePezizomycotina, edge.color=c("blue","orange","orange","orange","orange","orange","blue","blue"), edge.width=4, tip.color=c("purple","violetred","purple","purple","violetred"))
dev.off()

##Combine two trees into a multiphylo object and compute distance between trees
bestTrees <- c(garBest1,garBest2)
class(bestTrees)
multiRF(bestTrees)

------------------
------------------












#################BROKEN below here.
# Plot two trees facing one another

#Divide the plot into two parts with layout function
layout(matrix(1:2,1,2))
#check matrix
matrix(1:2,1,2)
#Plot tree 1 and tree 2 facing one another
plot(garBest1)
plot(garBest2, direction="l", show.tip.label=FALSE)
dev.off()
