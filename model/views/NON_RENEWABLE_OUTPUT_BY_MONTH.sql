create or replace view EDG.MODEL.NON_RENEWABLE_OUTPUT_BY_MONTH(
	MONTH,
	GAS_GWH,
	NUCLEAR_GWH,
	BIOMASS_GWH
) as
SELECT
    MONTH,
    GAS_GWH AS GAS_GWH,
    NUCLEAR_GWH AS NUCLEAR_GWH,
    BIOMASS_GWH AS BIOMASS_GWH,
FROM edg.prep.SCOTLAND_ENERGY_FLATTENED
ORDER BY month;