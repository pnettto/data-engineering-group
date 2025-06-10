create or replace view EDG.MODEL.VW_ENERGY_SOURCE_MIX(
	MONTH,
	GAS_PCT,
	NUCLEAR_PCT,
	WIND_PCT,
	SOLAR_PCT,
	BIOMASS_PCT,
	HYDRO_PCT,
	IMPORTS_PCT
) as
SELECT
  month,
  ROUND(gas_gwh * 100.0 / total_generation_gwh, 2) AS gas_pct,
  ROUND(nuclear_gwh * 100.0 / total_generation_gwh, 2) AS nuclear_pct,
  ROUND(wind_gwh * 100.0 / total_generation_gwh, 2) AS wind_pct,
  ROUND(solar_gwh * 100.0 / total_generation_gwh, 2) AS solar_pct,
  ROUND(biomass_gwh * 100.0 / total_generation_gwh, 2) AS biomass_pct,
  ROUND(hydro_gwh * 100.0 / total_generation_gwh, 2) AS hydro_pct,
  ROUND(imports_gwh * 100.0 / total_generation_gwh, 2) AS imports_pct
FROM edg.prep.SCOTLAND_ENERGY_FLATTENED
ORDER BY month;