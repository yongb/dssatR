write.tier <- function(tier,file.name,fmt.list=NULL){
    cnames = colnames(tier)
    fmt = vector(length=length(cnames),mode='character')
    if(is.null(fmt.list)) fmt.list = fmt.default()
    for(i in 1:length(fmt.list)){
        fmt[cnames%in%fmt.list[[i]]]=names(fmt.list)[i]
    }
    class = fmt2class(fmt)
    if(!grepl('@',cnames[1])){
        cnames[1] = paste('@',gsub(' ','',cnames[1]),sep='')
    }
    for(c in 1:ncol(tier)){
        if(c==1&&!grepl('-',fmt[1])) fmt[1] = paste('%-',fmt2width(fmt[1]),'s',sep='')
        tier[,c] = sprintf(fmt[c],tier[,c])
        cnames[c] = sprintf(gsub('\\..*[fi]','s',fmt[c]),cnames[c])
    }
    tier = rbind(cnames,tier)
    tier = do.call(paste,c(tier,sep=''))
    write(tier,file=file.name,append=TRUE)
    return(invisible(tier))
}
