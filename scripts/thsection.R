# Read and parse command line arguments
args<-commandArgs()
files<-strsplit(args[5],',')[[1]]
fcst.str<-args[6]
levtype<-args[7]
coord<-args[8]
toplevel<-as.numeric(args[9])
botlevel<-as.numeric(args[10])
legend.x<-args[11]
type<-args[12]
nodiag<-as.logical(args[13])
contour<-as.numeric(strsplit(args[14],':')[[1]])
colmap<-strsplit(args[15],':')[[1]]
time.units<-args[16]
interp<-args[17]
col.rev<-as.logical(args[18])
ipcfile<-args[19]
paths<-args[20:length(args)]

# Basic configuration
lwd<-3

# Acquire SCM support utilities
source(paste(Sys.getenv('SCM_SCRIPTS_LIBPATH'),'R','utils.R',sep='/'))

# Common setup
fcst.desc<-as.numeric(unlist(strsplit(fcst.str,',')))
fld.name.default<-fldname(files[1])
fld.cnt<-length(paths)*length(files)
ext=strsplit(files[1],'_')[[1]][length(strsplit(files[1],'_')[[1]])]
pfile<-paste(coord,levtype,'_',ext,sep='')
dfile<-paste('DIAG',levtype,'_',ext,sep='')
date.init<-strptime(strsplit(ext,'.txt',fixed=TRUE)[[1]][1],format="%Y%m%d.%H%M%S")
date.start<-date.init + fcst.desc[1]
oname<-paste(fld.name.default,'.',type,sep='')
write(oname,file=ipcfile)
coord.mult<-1.
coord.unit<-''
if (coord=='PRES'){
    log.y<-'y'
    coord.mult<-0.01
    coord.unit<-'(hPa)'
} else if (coord=='HGHT'){
    tmp<-toplevel
    toplevel<-botlevel
    botlevel<-tmp
    coord.unit<-'(m)'
}
coord.name<-paste(coord,'Level',coord.unit)
if (interp == 'linear'){
    interp.func<-'approx'
} else {
    interp.func<-'spline'
}

# Initialize data elements
exp<-c()
fld.x<-list()
fld.y<-list()
fld.z<-list()
fld.ymax<--Inf
fld.ymin<-Inf
fld.zmax<--Inf
fld.zmin<-Inf

# Loop over inputs to plot
for (i in 1:length(paths)){
    exp.this<-capwords(basename(paths[i])[1])
    
    # Loop over fields to plot
    for (j in 1:length(files)){
        fld.this<-fldname(files[j])
        expfld.this<-paste(exp.this,fld.this)
        if (length(exp) == 0){fld.0<-fld.this}

        # Experiment and data setup
        exp<-c(exp,expfld.this)
        if (any(expfld.this == names(fld.x))){next}
        fname<-paste(paths[i],'series',files[j],sep='/')
        fld<-read.table(fname,header=TRUE)
        pfld<-read.table(paste(paths[i],'coord',pfile,sep='/'),header=TRUE)

        # Extract temporal subset
        fld.dates<-as.POSIXct(strptime(fld[,1],format="%Y%m%dT%H%M%S"))
        pfld.dates<-as.POSIXct(strptime(pfld[,1],format="%Y%m%dT%H%M%S"))
        if (fcst.desc[2] > 0){
            date.end<-date.init + fcst.desc[2]
        } else {
            date.end<-fld.dates[length(fld.dates)]
        }
        date.mask.fld<-fld.dates>=date.start & fld.dates<=date.end
        date.mask.pfld<-pfld.dates>=date.start & pfld.dates<=date.end
        fld.x[[expfld.this]]<-fld.dates[date.mask.fld]
        fld.values<-data.frame(lapply(fld[date.mask.fld,2:dim(fld)[2]], as.numeric))
        pfld.values<-data.frame(lapply(pfld[date.mask.pfld,2:dim(pfld)[2]], as.numeric))*coord.mult
        
        # Retrieve diagnostic values and reshape fields if necessary        
        if (nodiag){
            fld.values<-fld.values[,1:ncol(fld.values)-1]
        } else {
            if (coord == 'PRES'){
                if (ncol(fld.values) < ncol(pfld.values)){
                    stop(paste('there are an insufficient number of levels in',fname))
                } else if (ncol(fld.values) == (ncol(pfld.values)+1)) {
                    dfld<-read.table(paste(paths[i],'coord',dfile,sep='/'),header=TRUE)
                    pfld.values<-cbind(pfld.values,as.numeric(dfld[,2]))
                }
            }
        }
        if (coord == 'HGHT'){
            fld.values<-rev(fld.values)
            pfld.values<-rev(pfld.values)
        }

        # Vertical interpolation to constructed coordinate values
        pbot<-min(botlevel,max(pfld.values))
        ptop<-max(toplevel,min(pfld.values))
        pfld.init<-as.numeric(pfld.values[1,])
        sig<-(pfld.init-pfld.init[1])/(pfld.init[length(pfld.init)]-pfld.init[1])
        fld.y[[expfld.this]]<-sig*(pbot-ptop)+ptop
        fld.z[[expfld.this]]<-c()
        for (r in 1:nrow(fld.values)){
            fld.interp <- get(interp.func)(pfld.values[r,],y=fld.values[r,],xout=fld.y[[expfld.this]])$y
            fld.z[[expfld.this]]<-rbind(fld.z[[expfld.this]], fld.interp)
        }
        
        # Accumulate field y and z values for plots
        fld.ymax<-max(fld.ymax,max(fld.y[[expfld.this]]),na.rm=TRUE)
        fld.ymin<-min(fld.ymin,min(fld.y[[expfld.this]]),na.rm=TRUE)
        if (fld.0 == fld.this){
            fld.zmax<-max(fld.zmax,max(fld.z[[expfld.this]]),na.rm=TRUE)
            fld.zmin<-min(fld.zmin,min(fld.z[[expfld.this]]),na.rm=TRUE)
        }
    }
}

# Override plot ranges on user request
col.palette.func<-colmap[1]
col.palette.name<-colmap[2]
if (contour[1] > -Inf){fld.zmin<-contour[1]}
if (contour[2] < Inf){fld.zmax<-contour[2]}
yrange<-c(min(fld.ymax,botlevel),toplevel)
zrange<-c(fld.zmin,fld.zmax)
if (grepl('diverging', col.palette.func)){
    zrange<-c(-max(abs(zrange)), max(abs(zrange)))
}
if (coord=='HGHT'){yrange<-rev(yrange)}

# Select plot device type
if (type == 'png'){
  png(oname)
} else if (type == 'jpeg'){
  jpeg(oname,quality=90)
} else if (type == 'ps'){
  postscript(oname)
} else {
  png(oname)
}

# Set up levels and colours
if (contour[3] > 0){
    lev<-seq(min(zrange),max(zrange),by=contour[3])
} else {
    lev<-pretty(zrange,20)
}
xaxis.at<-pretty(fld.x[[exp[1]]])
xaxis.lab<-xaxis.at - fld.x[[exp[1]]][1]
units(xaxis.lab)<-time.units

# Utility plot functions for additional fields
all.contours<-function(fld.x, fld.y, fld.z, col=c()){    
    if (length(exp) > 1){
        for (i in 2:length(exp)){            
            if (length(col) >= i){
                col.this <- col[i]
            } else {
                col.this <- i-1
            }
            if (strsplit(exp[i], ' ')[[1]][2] == fld.0){
                contour(fld.x[[exp[i]]], fld.y[[exp[i]]], fld.z[[exp[i]]], add=TRUE,
                        col=col.this, levels=lev, lwd=lwd)
            } else {
                contour(fld.x[[exp[i]]], fld.y[[exp[i]]], fld.z[[exp[i]]], add=TRUE,
                        col=col.this, lwd=lwd)
            }
        }
    }
}
all.legend<-function(col=c()){
    if (length(col) > 0){
        legend(x=legend.x, legend=exp, inset=0.01, col=col, lwd=lwd, bg='white')
    } else {   
        legend(x=legend.x,legend=exp,inset=0.01,col=seq(0,length(exp)),
               lwd=c(0,rep(lwd,length(exp)-1)),bg='white')
    }
}

# Generic plotting parameters
title <- paste("Time-Height Section of",fld.name.default)
xlab <- paste0('Forecast Time (',time.units,')')

# Generate plot
col.split <- strsplit(col.palette.func,',')[[1]]
if (any(col.split[1] == colours())){
    # Contour plot
    contour(fld.x[[exp[1]]], fld.y[[exp[1]]], fld.z[[exp[1]]], ylim=yrange,
            main=title, xlab=xlab, ylab=coord.name, zlim=zrange, levels=lev,
            col=col.split[1], lwd=lwd, xaxt='n', xaxs='i')
    axis(1, xaxis.at, labels=as.vector(xaxis.lab))
    all.contours(fld.x, fld.y, fld.z, col=col.split)
    all.legend(col=col.split)
} else {
    # Colour-filled plot
    source(paste(Sys.getenv('SCM_SCRIPTS_LIBPATH'),'R','plotting.R',sep='/'))
    require(colorspace, quietly=TRUE)
    col.pal <- get(col.palette.func)(length(lev), palette=col.palette.name)
    if (col.rev){col.pal <- rev(col.pal)}
    scm.filled.contour(fld.x[[exp[1]]], fld.y[[exp[1]]], fld.z[[exp[1]]], ylim=yrange,
                       main=title, xlab=xlab, ylab=coord.name, zlim=zrange, levels=lev,
                       xaxs='i', col=col.pal,
                       key.title={
                           mtext(fld.name.default,side=4,line=3,las=0)
                       },
                       plot.axes={
                           all.contours(fld.x, fld.y, fld.z);
                           all.legend();
                           axis(1, xaxis.at, labels=as.vector(xaxis.lab));
                           axis(2, las=2);
                       })
}
dev.off()
