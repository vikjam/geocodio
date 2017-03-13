library(dplyr)
# Load the data
census    <- readRDS('../../data/interim/census.rds')
geocod.io <- read.csv('../../data/interim/geocodio.csv',
	                  as.is = TRUE)

# Rename and subset variables
census <- census %>% select(census.addr.submit = submit.addr,
	                        census.addr.result = result.addr,
	                        census.tract       = tract,
	                        census.block       = block,
                            unique.id          = id)

geocod.io$Zip.1 <- str_pad(geocod.io$Zip.1, 5, pad = '0')
concat_addr <- function(number, street, city, state, zip) {
	paste(paste(paste(number,
		              street,
		              sep = ' '),
	            city,
	            state,
	            sep = ', '),
	      zip, sep = ' ')
}


geocod.io <- geocod.io                                          %>%
             mutate(geocodio.addr.submit = concat_addr(Number,
	                                                   Street,
	                                                   City.1,
	                                                   State.1,
	                                                   Zip.1))  %>% 
			 select(geocodio.addr.submit,
			 	    geocodio.tract = Census.Tract.Code,
	                geocodio.block = Census.Block.Code,
                    unique.id      = id)

merged.results <- merge(census, geocod.io, by = 'unique.id', all = TRUE)
