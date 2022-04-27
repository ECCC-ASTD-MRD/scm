# General-purpose utilities for SCM diagnostics and post-processing

# Read thermodynamic constants
utils.read.constants<-function(){
    # Read and parse the constants file into a list
    cmcconst<-Sys.getenv('CMCCONST',unset=NA)
    if (is.na(cmcconst)){stop('Error: Environment variable CMCCONST must be defined for constants')}
    fn<-paste(cmcconst,'thermoconsts',sep='/')
    c<-read.table(fn,colClasses=c("character","double",rep("NULL",max(count.fields(fn)-2))),fill=TRUE,header=FALSE)
    const<-list()
    for (i in 1:nrow(c)){const[c[i,1]]<-c[i,2]}
    return(const)
}

# Capitalization function
capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
         {s <- substring(s,2); if(strict) tolower(s) else s},
          sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

# Field name function
fldname <- function(file){
    return(paste(strsplit(file,'_')[[1]][1:length(strsplit(file,'_')[[1]])-1],collapse='_'))
}
