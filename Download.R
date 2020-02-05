library(httr)
library(rvest)
library(tidyverse)
library(taskscheduleR)
#Function to automate the process of getting data from REST API
query = "select * from :parquetCustMobile: limit "
location <- 'D:/DataR/Download/1.csv'
download <- function(query,location){
data = list(query = query, JobName = 'test', private = 'true')
response <- POST("http://10.58.244.171:9126/job",body = data ,encode = "form",verbose())
id   <-  response %>% content('text') %>% str_extract('\\d+') 
link <-  paste0("http://10.58.244.171:9126/job?jobId=",id,"&private=true")
dl <- link %>% read_html %>% html_text

while(dl %>% str_detect("http.+csv") == FALSE){
 if(dl %>% str_detect("Failed") == TRUE){
   break
    }
dl <- link %>% read_html %>% html_text

  }
if(dl %>% str_detect("Failed") == TRUE){
  dl %>% writeLines()
}
else if(dl %>% str_detect("http.+csv") == TRUE){
dl %>% str_extract("http.+csv") %>% download.file(location)
return(dl %>% writeLines())
  }
}
download(query,location)


