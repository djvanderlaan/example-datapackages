

library(datapackage)

dp <- opendatapackage("energy_consumption0")

dta <- dp |> dpresource("energy_consumption") |> dpgetdata()


codelist_ht <- dp |> dpresource("housing_type-codelist") |> dpgetdata()
codelist_ht


head(dta)


codelist_region <- dp |> dpresource("region-codelist") |> dpgetdata()
codelist_region
names(codelist_region)[1] <- "value"
attr(codelist_region, "resource") <- NULL
codelist_region <- split(codelist_region, seq_len(nrow(codelist_region))) |> lapply(as.list)
names(codelist_region) <- NULL
codelist_region

codelist_ht <- dp |> dpresource("housing_type-codelist") |> dpgetdata()
codelist_ht
names(codelist_ht)[1] <- "value"
attr(codelist_ht, "resource") <- NULL
codelist_ht <- split(codelist_ht, seq_len(nrow(codelist_ht))) |> lapply(as.list)
names(codelist_ht) <- NULL
codelist_ht

f <- dp |> dpresource("energy_consumption") |> dpfield("housing_type")
f$categories <- codelist_ht
dp$resources[[1]]$schema$fields[[1]] <- f

f <- dp |> dpresource("energy_consumption") |> dpfield("region")
f$categories <- codelist_region
dp$resources[[1]]$schema$fields[[2]] <- f

dp$resources[[3]] <- NULL
dp$resources[[2]] <- NULL

dir.create("energy_consumption2", recursive = TRUE, showWarnings = FALSE)

datapackage:::writedatapackage(dp, "energy_consumption2", "datapackage.json")

readLines("energy_consumption2/datapackage.json") |> writeLines()
 
dta |> head() 

write.csv2(dta, "energy_consumption2/energy_consumption.csv", 
  row.names = FALSE, na = "-", fileEncoding = "UTF-8", quote=FALSE)
readLines("energy_consumption2/energy_consumption.csv") |> 
  writeLines()



