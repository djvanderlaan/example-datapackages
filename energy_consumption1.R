

library(datapackage)

dp <- opendatapackage("energy_consumption0")

dta <- dp |> dpresource("energy_consumption") |> dpgetdata()

codelist_region <- dp |> dpresource("region-codelist") |> dpgetdata()
codelist_region

codelist_ht <- dp |> dpresource("housing_type-codelist") |> dpgetdata()
codelist_ht

dta$housing_type <- factor(dta$housing_type, levels = codelist_ht$code, 
  labels = codelist_ht$label) |> as.character()

dta$region <- factor(dta$region, levels = codelist_region$code, 
  labels = codelist_region$label) |> as.character()

head(dta)


f <- dp |> dpresource("energy_consumption") |> dpfield("housing_type")
f$categories <- codelist_ht$label
dp$resources[[1]]$schema$fields[[1]] <- f

f <- dp |> dpresource("energy_consumption") |> dpfield("region")
f$categories <- codelist_region$label
dp$resources[[1]]$schema$fields[[2]] <- f

dp$resources[[3]] <- NULL
dp$resources[[2]] <- NULL

dir.create("energy_consumption1", recursive = TRUE, showWarnings = FALSE)

datapackage:::writedatapackage(dp, "energy_consumption1", "datapackage.json")
 
dta |> head() 

write.csv2(dta, "energy_consumption1/energy_consumption.csv", row.names = FALSE, na = "")



