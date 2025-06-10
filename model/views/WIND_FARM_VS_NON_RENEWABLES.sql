create or replace view EDG.MODEL.WIND_FARM_VS_NON_RENEWABLES(
	INDUSTRY,
	WIND_FARMS_NEEDED_TO_REPLACE
) as
WITH ENERGY_TOTALS AS (
    -- Calculate total annual energy production for each non-renewable energy source
    SELECT 
        AVG(GAS_GWH) * 12 as gas_annual_output_gwh,
        AVG(NUCLEAR_GWH) * 12 as nuclear_annual_output_gwh,
        AVG(BIOMASS_GWH) * 12 as biomass_annual_output_gwh,
        (AVG(GAS_GWH) * 12 + AVG(NUCLEAR_GWH) * 12 + AVG(BIOMASS_GWH) * 12) as total_annual_output_gwh
    FROM NON_RENEWABLE_OUTPUT_BY_MONTH
),
WIND_CAPACITY AS (
    -- Calculate annual capacity of the wind farm
    SELECT 
        AVG(TOTAL_ENERGY_PRODUCED_GWH) * 12 as wind_farm_annual_output_gwh,
    FROM TURBINES_TOTAL_OUTPUT_BY_MONTH
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
        'Total' as INDUSTRY,
        CEIL(total_annual_output_gwh / w.wind_farm_annual_output_gwh) as WIND_FARMS_NEEDED_TO_REPLACE
    FROM ENERGY_TOTALS e, WIND_CAPACITY w
)
SELECT 
    INDUSTRY,
    WIND_FARMS_NEEDED_TO_REPLACE
FROM CALCULATIONS
ORDER BY 
    CASE INDUSTRY 
        WHEN 'Gas' THEN 1
        WHEN 'Nuclear' THEN 2
        WHEN 'Biomass' THEN 3
        WHEN 'Total' THEN 4
    END;