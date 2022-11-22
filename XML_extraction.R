########Opening required libraries##########3

library(xml2)
library(XML)

###############Extracting the required file#############
File<- choose.files() 
Parsed_File<- xmlParse(File)

Elements_File<- xmlRoot(Parsed_File)

#######Extracting data##############

PatientName<- xmlToList(Elements_File[16][[1]][[1]][[1]][[2]][[1]])
PatientAge<- xmlToList(Elements_File[17][[1]][[1]][[1]])
TestDate<- xmlToList(Elements_File[51][[1]][[1]][[1]])
FP_Percent_OD<- xmlToList(Elements_File[39][[1]][[1]][[1]])
FP_Percent_OS<- xmlToList(Elements_File[39][[1]][[2]][[1]])
TestDuration_OD<- xmlToList(Elements_File[53][[1]][[1]][[1]])
TestDuration_OS<- xmlToList(Elements_File[53][[1]][[2]][[1]])
Missed_Presented_OD<- xmlToList(Elements_File[54][[1]][[1]][[1]])
Missed_Presented_OS<- xmlToList(Elements_File[54][[1]][[2]][[1]])



X_Y_data<- xmlToList( Elements_File[55][[1]])

X <- vector("list",length(X_Y_data)-1)
Y <- vector("list",length(X_Y_data)-1)
R_resp<- vector("list",length(X_Y_data)-1)
L_resp<- vector("list",length(X_Y_data)-1)




for (i in 1: (length(X_Y_data)-1)){
  X[[i]]<- X_Y_data[[i]][[1]][[1]][[1]]
  Y[[i]]<- X_Y_data[[i]][[2]][[1]][[1]]
  R_res<-  Elements_File[55][[1]][[i]][[3]][[1]][[1]]
  L_res<-  Elements_File[55][[1]][[i]][[3]][[2]][[1]]
  R_resp[[i]]<- ifelse(length(R_res) > 0, xmlToList(R_res),"NA")
  L_resp[[i]]<- ifelse(length(L_res) > 0, xmlToList(L_res), "NA")
  
}

######Making data frame#####


Sr_num<- c(1:100)

X_data<- data.frame(row.names = paste("XL_", 1:length(X), sep = ""),
                    X= unlist(X))
Y_data<- data.frame(row.names = paste("YL_", 1:length(X), sep = ""),
                    Y= unlist(Y))


Resp_OD_data<- data.frame(row.names = paste("Resp_OD_L_", 1:length(X), sep = ""),
                          OD_resp = unlist(R_resp))

Resp_OS_data<- data.frame(row.names = paste("Resp_OS_L_", 1:length(X), sep = ""),
                          OS_resp = unlist(L_resp))

loc_data<- cbind(t(X_data), t(Y_data), t(Resp_OD_data), t(Resp_OS_data))


Demographics<- data.frame(PatientName, PatientAge, TestDate,FP_Percent_OD,
                          FP_Percent_OS, TestDuration_OD, TestDuration_OS,
                          Missed_Presented_OD, Missed_Presented_OS)
Sup_data<- cbind(Demographics, loc_data, 
                 row.names = Sr_num[length(Demographics$PatientName)])







