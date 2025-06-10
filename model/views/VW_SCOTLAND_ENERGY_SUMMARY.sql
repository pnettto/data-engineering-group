create or replace view EDG.MODEL.VW_SCOTLAND_ENERGY_SUMMARY(
	MONTH,
	TOTAL_GENERATION_GWH,
	TOTAL_CO2_EMISSIONS,
	WIND_GWH,
	HYDRO_GWH
) as
SELECT
  month,
  total_generation_gwh,
  
  gas_co2_emissions + nuclear_co2_emissions + wind_co2_emissions +
  solar_co2_emissions + biomass_co2_emissions + hydro_co2_emissions +
  coal_co2_emissions + imports_co2_emissions AS total_co2_emissions,

  wind_gwh,
  hydro_gwh
FROM edg.prep.SCOTLAND_ENERGY_FLATTENED
ORDER BY month;