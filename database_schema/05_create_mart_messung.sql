CREATE TABLE mart.fct_messung(
    fahrzeug_id INT NOT NULL,
    gesendet TIMESTAMP WITH TIME ZONE,
    empfangen TIMESTAMP WITH TIME ZONE,
    geschwindigkeit INT
) PARTITION BY  RANGE(gesendet);

CREATE TABLE mart.fct_messung_2023 PARTITION OF  mart.fct_messung
FOR VALUES FROM ('2023-01-01 00:00:00') TO('2023-12-31 23:59:59');

CREATE TABLE mart.fct_messung_2024 PARTITION OF  mart.fct_messung
    FOR VALUES FROM ('2024-01-01 00:00:00') TO('2024-12-31 23:59:59');

CREATE OR REPLACE VIEW mart.agg_sampling_1min_simple AS
SELECT
    fahrzeug_id,
    date_trunc('minute', gesendet) AS minute,
    AVG(geschwindigkeit) AS durch_geschwindigkeit,
    COUNT(*) AS anzahl
FROM mart.fct_messung
GROUP BY fahrzeug_id, minute
ORDER BY minute, fahrzeug_id;

CREATE OR REPLACE VIEW mart.agg_sampling_1min_advanced AS
WITH minutes AS(
    SELECT generate_series
           (
                   date_trunc('minute', min(gesendet)),
                   date_trunc('minute', max(gesendet)),
                   '1 minute'::interval
           ) as minute
        FROM mart.fct_messung)
SELECT
    fahrzeug_id,
    minutes.minute as minute,
    AVG(geschwindigkeit) AS durch_geschwindigkeit,
    COUNT(*) AS anzahl
FROM minutes
LEFT JOIN mart.fct_messung
ON (date_trunc('minute',fct_messung.gesendet) = minutes.minute)
GROUP BY fahrzeug_id, minute
ORDER BY minute, fahrzeug_id;