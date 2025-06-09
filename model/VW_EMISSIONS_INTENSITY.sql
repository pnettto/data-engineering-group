create or replace view EDG.MODEL.VW_EMISSIONS_INTENSITY(
	MONTH,
	GAS_INTENSITY,
	NUCLEAR_INTENSITY,
	WIND_INTENSITY,
	SOLAR_INTENSITY,
	BIOMASS_INTENSITY,
	HYDRO_INTENSITY,
	IMPORTS_INTENSITY
) as
SELECT
  month,
  ROUND(gas_co2_emissions / NULLIF(gas_gwh, 0), 2) AS gas_intensity,
  ROUND(nuclear_co2_emissions / NULLIF(nuclear_gwh, 0), 2) AS nuclear_intensity,
  ROUND(wind_co2_emissions / NULLIF(wind_gwh, 0), 2) AS wind_intensity,
  ROUND(solar_co2_emissions / NULLIF(solar_gwh, 0), 2) AS solar_intensity,
  ROUND(biomass_co2_emissions / NULLIF(biomass_gwh, 0), 2) AS biomass_intensity,
  ROUND(hydro_co2_emissions / NULLIF(hydro_gwh, 0), 2) AS hydro_intensity,
  ROUND(imports_co2_emissions / NULLIF(imports_gwh, 0), 2) AS imports_intensity
FROM edg.prep.SCOTLAND_ENERGY_FLATTENED
ORDER BY month;