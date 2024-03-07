
INSERT INTO mart.dim_kfz_kennzeichen(kfz_kennzeichen)
SELECT staging.fzg_kauf.kfz_kennzeichen FROM staging.fzg_kauf;

INSERT INTO mart.dim_fahrzeug(fin,
                              produktionsdatum,
                              modell,
                              hersteller_code,
                              hersteller_name)
SELECT fin,
       produktionsdatum,
       modell,
       hersteller.hersteller_code,
       hersteller.hersteller_name FROM staging.fahrzeug
LEFT JOIN staging.hersteller hersteller
ON hersteller.hersteller_code = fahrzeug.hersteller_code;

INSERT INTO mart.dim_kunde(kunde_account,
                           vorname,
                           nachname,
                           geschlecht,
                           geburtsdatum,
                           ort,
                           land)
SELECT staging.kunde.kunde_account,
       staging.kunde.vorname,
       staging.kunde.nachname,
       staging.kunde.geschlecht,
       staging.kunde.geburtsdatum,
       staging.ort.ort,
       staging.land.land
FROM staging.kunde
LEFT JOIN staging.ort
ON staging.kunde.wohnort_id = staging.ort.ort_id
LEFT JOIN staging.land
ON staging.ort.land_id = staging.land.land_id;

INSERT INTO mart.fct_verkauf(kfz_kennzeichen_id,
                             kunde_id,
                             fahrzeug_id,
                             kaufdatum,
                             lieferdatum,
                             kaufpreis,
                             rabatt_pct)
SELECT mart.dim_kfz_kennzeichen.kfz_kennzeichen_id,
       mart.dim_kunde.kunde_id,
       mart.dim_fahrzeug.fahrzeug_id,
       staging.fzg_kauf.kaufdatum,
       staging.fzg_kauf.lieferdatum,
       staging.fzg_kauf.kaufpreis,
       staging.fzg_kauf.rabatt_pct
FROM staging.fzg_kauf
RIGHT JOIN mart.dim_fahrzeug
ON staging.fzg_kauf.fin = mart.dim_fahrzeug.fin
RIGHT JOIN mart.dim_kunde
ON staging.fzg_kauf.kunde_account = mart.dim_kunde.kunde_account
RIGHT JOIN mart.dim_kfz_kennzeichen
ON staging.fzg_kauf.kfz_kennzeichen = mart.dim_kfz_kennzeichen.kfz_kennzeichen;
