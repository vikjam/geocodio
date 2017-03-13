library(data.table)
library(stringr)
library(tractR)
library(httr)
library(dotenv)

# Download and format
CAMBRIDGE_URL <- 'https://data.cambridgema.gov/api/views/crnm-mw9n/rows.csv?accessType=DOWNLOAD&bom=true'
assessing     <- fread(CAMBRIDGE_URL, nrows = 1250)
assessing$id  <- 1:nrow(assessing)
assessing$Zip <- str_pad(assessing$Zip, 5, pad = '0')

# Geocode via Census
assessing.geo <- getTracts(data       = assessing,
                           unique_id  = 'id',
                           address    = 'Mailing Address',
                           city       = 'City',
                           state      = 'State',
                           postalcode = 'Zip')

saveRDS(object = as.data.frame(assessing.geo),
	      file   = '../../data/interim/census.rds')

write.table(x         = assessing,
            file      = '../../data/interim/assessing.csv',
            sep       = ',',
            row.names = FALSE)

# Geocode via Gecod.io
load_dot_env(file = '../../.env')
geocod.io.key <- Sys.getenv('GEOCODIO_BATCHGEO')

curl -X POST \
  -H "Content-Type: application/json" \
  -d '["1109 N Highland St, Arlington VA", "525 University Ave, Toronto, ON, Canada", "4410 S Highway 17 92, Casselberry FL", "15000 NE 24th Street, Redmond WA", "17015 Walnut Grove Drive, Morgan Hill CA"]' \
  https://api.geocod.io/v1/geocode?api_key=YOUR_API_KEY
