create or replace view EDG.MODEL.VW_WIND_FARM_VS_ENERGY_INDUSTRIES(
	INDUSTRY,
	WIND_FARMS_NEEDED_TO_REPLACE
) as
WITH ENERGY_TOTALS AS (
    -- Calculate total annual energy production for each non-renewable energy source
    SELECT 
        AVG(GAS_GWH) * 12 as gas_annual_output_gwh,
        AVG(NUCLEAR_GWH) * 12 as nuclear_annual_output_gwh,
        AVG(BIOMASS_GWH) * 12 as biomass_annual_output_gwh,
        AVG(SOLAR_GWH) * 12 as solar_annual_output_gwh,
        AVG(WIND_GWH) * 12 as wind_annual_output_gwh,
        AVG(HYDRO_GWH) * 12 as hydro_annual_output_gwh,
        (AVG(WIND_GWH) * 12 + AVG(SOLAR_GWH) * 12 + AVG(HYDRO_GWH) * 12 + AVG(BIOMASS_GWH) * 12) as total_renewable_annual_output_gwh,
        (AVG(GAS_GWH) * 12 + AVG(NUCLEAR_GWH) * 12) as total_non_renewable_annual_output_gwh,
        total_renewable_annual_output_gwh + total_non_renewable_annual_output_gwh AS total_annual_output_gwh
    FROM EDG.PREP.SCOTLAND_ENERGY_FLATTENED
),
WIND_CAPACITY AS (
    -- Calculate annual capacity of the wind farm
    SELECT 
        AVG(TOTAL_ENERGY_PRODUCED_GWH) * 12 as wind_farm_annual_output_gwh,
    FROM EDG.MODEL.TURBINES_TOTAL_OUTPUT_BY_MONTH
),
CALCULATIONS AS (
    -- Calculate wind farms needed for each energy source
    SELECT 
        'Gas' as INDUSTRY,
        CEIL(e.gas_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Nuclear' as INDUSTRY,
        CEIL(nuclear_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Biomass' as INDUSTRY,
        CEIL(biomass_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Solar' as INDUSTRY,
        CEIL(solar_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Hydro' as INDUSTRY,
        CEIL(hydro_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Wind' as INDUSTRY,
        CEIL(wind_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
    
    UNION ALL
    
    SELECT 
        'Total' as INDUSTRY,
        CEIL(total_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
)
SELECT 
    INDUSTRY,
    WIND_FARMS_NEEDED_TO_REPLACE
FROM CALCULATIONS;