
INSERT INTO mart.fct_messung(fahrzeug_id,
                             gesendet,
                             empfangen,
                             geschwindigkeit)
SELECT fahrzeug_id,
       to_timestamp((messung.payload->>'zeit')::int) at time zone 'UTC-2',
       empfangen,
       (messung.payload->>'geschwindigkeit')::int
FROM staging.messung
INNER JOIN mart.dim_fahrzeug
ON dim_fahrzeug.fin = messung.payload->>'fin';
