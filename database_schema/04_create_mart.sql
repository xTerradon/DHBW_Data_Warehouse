CREATE SCHEMA mart;

CREATE TABLE mart.dim_kunde (
    kunde_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kunde_account VARCHAR(50) UNIQUE NOT NULL,
    vorname VARCHAR(200) NOT NULL,
    nachname VARCHAR(200) NOT NULL,
    geschlecht VARCHAR(20) NOT NULL,
    geburtsdatum DATE,
    ort VARCHAR(200) NOT NULL,
    land VARCHAR(200) NOT NULL
);

CREATE TABLE mart.dim_fahrzeug (
    fahrzeug_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fin CHAR(17) UNIQUE NOT NULL,
    hersteller_code CHAR(3) NOT NULL,
    hersteller_name VARCHAR(200) NOT NULL,
    modell VARCHAR(200) NOT NULL,
    produktionsdatum DATE
);


CREATE TABLE mart.dim_kfz_kennzeichen (
    kfz_kennzeichen_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kfz_kennzeichen VARCHAR(20) NOT NULL
);

CREATE TABLE mart.fct_verkauf (
    kfz_kennzeichen_id INT NOT NULL,
    kunde_id INT NOT NULL,
    fahrzeug_id INT NOT NULL,
    kaufdatum DATE,
    lieferdatum DATE,
    kaufpreis INT,
    rabatt_pct INT,
    CONSTRAINT fk_kfz_kennzeichen_id FOREIGN KEY(kfz_kennzeichen_id) REFERENCES mart.dim_kfz_kennzeichen(kfz_kennzeichen_id),
    CONSTRAINT fk_kunde_id FOREIGN KEY(kunde_id) REFERENCES mart.dim_kunde(kunde_id),
    CONSTRAINT fk_fahrzeug_id FOREIGN KEY(fahrzeug_id) REFERENCES mart.dim_fahrzeug(fahrzeug_id)
);
    
