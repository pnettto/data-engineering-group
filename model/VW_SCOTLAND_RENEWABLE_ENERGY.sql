create or replace view EDG.MODEL.VW_SCOTLAND_RENEWABLE_ENERGY(
	MONTH,
	TOTAL_RENEWABLE_GWH,
	RENEWABLE_PERCENT,
	WIND_GWH,
	HYDRO_GWH,
	SOLAR_GWH,
	BIOMASS_GWH,
	WIND_CO2_EMISSIONS,
	HYDRO_CO2_EMISSIONS,
	SOLAR_CO2_EMISSIONS,
	BIOMASS_CO2_EMISSIONS
) as
SELECT
  month,
  
  -- Total GWh from renewables
  wind_gwh + hydro_gwh + solar_gwh + biomass_gwh AS total_renewable_gwh,

  -- Percent of total generation that is renewable
  ROUND(
    (wind_gwh + hydro_gwh + solar_gwh + biomass_gwh) * 100.0 / total_generation_gwh,
    2
  ) AS renewable_percent,

  -- Renewable energy by source
  wind_gwh,
  hydro_gwh,
  solar_gwh,
  biomass_gwh,

  -- CO2 emissions from renewables
  wind_co2_emissions,
  hydro_co2_emissions,
  solar_co2_emissions,
  biomass_co2_emissions

FROM edg.prep.SCOTLAND_ENERGY_FLATTENED
ORDER BY month;