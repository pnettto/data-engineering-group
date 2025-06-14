create or replace view EDG.MODEL.VW_SCOTLAND_MONTHLY_WINDSPEED_TREND(
	MONTH_START,
	AVG_WINDSPEED_SCOTLAND
) as
SELECT
    DATE_TRUNC('month', DATETIME) AS month_start,
    ROUND(AVG(WINDSPEED_10M), 2) AS avg_windspeed_scotland
FROM PREP.SCOTLAND_WEATHER_DATA
GROUP BY DATE_TRUNC('month', DATETIME)
ORDER BY month_start;