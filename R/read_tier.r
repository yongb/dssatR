read.tier <- function(header,l1,nrows,file.name,fmt.list=NULL){
    header = gsub('@',' ',header)
    cnames = strsplit(gsub('@','',header),split='  *')[[1]]
    cnames = gsub('\\.*','',cnames[cnames!=''])
    pos = vector(length=length(cnames),mode='list')
    fmt = vector(length=length(cnames),mode='character')
    if(is.null(fmt.list)) fmt.list = fmt.default()
    for(i in 1:length(fmt.list)){
        fmt[cnames%in%fmt.list[[i]]]=names(fmt.list)[i]
    }
    class = fmt2class(fmt)
    if(all(cnames%in%unlist(fmt.list))){
        widths = fmt2width(fmt)
    }else{
        widths = vector(length=length(cnames),mode='numeric')
        for(i in 1:length(cnames)){
            tmp = str.index(header,cnames[i])
            widths[i]=tmp$stop-tmp$start+1
        }
    }
    vars = try(read.fwf(file.name,widths=widths,skip=l1,nrow=nrows,
        colClasses=class,comment.char='!',
        na.strings=c('-99','-99.','-99.0','-99.00',substring('********',1,1:8)),
        header=FALSE,fill=TRUE),silent=TRUE)
    if(class(vars)=='try-error'){
        vars = read.table(file.name,skip=l1,nrow=nrows,
            colClasses=class,comment.char='!',blank.lines.skip=TRUE,
            na.strings=c('-99','-99.','-99.0','-99.00',substring('********',1,1:8)),
            header=FALSE,fill=TRUE)
    }
    colnames(vars)=cnames
    if(any(grepl('yrdoy',fmt))){
        for(i in (1:ncol(vars))[grepl('yrdoy',fmt)]){
            vars[,i] = as.numeric(vars[,i])
            if(floor(vars[1,i]/1000)<30){
                vars[,i]=sprintf('%7i',vars[,i]+2000000)
            }else{
                vars[,i]=sprintf('%7i',vars[,i]+1900000)
            }
            vars[,i] = as.POSIXct(vars[,i],format='%Y%j')
        }
    }
    if(any(grepl('yeardoy',fmt))){
        for(i in (1:ncol(vars))[grepl('yeardoy',fmt)]){
            vars[,i] = as.POSIXct(vars[,i],format='%Y%j')
        }
    }
    return(invisible(vars))
}
