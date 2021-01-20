------------------------CREATE TABLES-----------------------
--if not exists
CREATE OR REPLACE FUNCTION create_tables() RETURNS VOID AS $$
BEGIN
	CREATE TABLE IF NOT EXISTS specialization (
		id_specialization SERIAL,
		specialization VARCHAR(40) NOT NULL UNIQUE,
		PRIMARY KEY(id_specialization)
	);

	CREATE TABLE IF NOT EXISTS producer (
		id_producer SERIAL,
		producer VARCHAR(40) NOT NULL UNIQUE,
		PRIMARY KEY(id_producer)
	);

	CREATE TABLE IF NOT EXISTS medicine_type (
		id_medicine_type SERIAL,
		medicine_type VARCHAR(40) NOT NULL UNIQUE,
		PRIMARY KEY(id_medicine_type)
	);

	CREATE TABLE IF NOT EXISTS medicine (
		id_medicine SERIAL,
		id_medicine_type INTEGER NOT NULL,
		medicine_name TEXT NOT NULL,
		id_producer INTEGER NOT NULL,
		price FLOAT NOT NULL,
		PRIMARY KEY (id_medicine),
		FOREIGN KEY (id_medicine_type) REFERENCES medicine_type(id_medicine_type) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (id_producer) REFERENCES producer(id_producer) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE IF NOT EXISTS pharmacy (
		id_pharmacy SERIAL,
		pharmacy_name VARCHAR(40) NOT NULL,
		id_specialization INTEGER NOT NULL,
		address TEXT NOT NULL,
		PRIMARY KEY(id_pharmacy)
	);

	CREATE TABLE IF NOT EXISTS indication (
		id_indication SERIAL,
		indication TEXT NOT NULL UNIQUE,
		PRIMARY KEY(id_indication)
	);

	CREATE TABLE IF NOT EXISTS contraindication (
		id_contraindication SERIAL,
		contraindication TEXT NOT NULL UNIQUE,
		PRIMARY KEY(id_contraindication)
	);

	CREATE TABLE IF NOT EXISTS pharmacy_medicine (
		id_pharmacy_medicine SERIAL,
		id_pharmacy INTEGER NOT NULL,
		id_medicine INTEGER NOT NULL,
		medicine_amount INTEGER NOT NULL,
		production_date DATE NOT NULL,
		expiration_date DATE NOT NULL,
		total_price FLOAT NOT NULL,
		PRIMARY KEY (id_pharmacy_medicine),
		FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT check_dates CHECK (production_date < expiration_date),
		CONSTRAINT check_amount CHECK (medicine_amount > 0)
	);

	CREATE TABLE IF NOT EXISTS medicine_indication (
		id_medicine_indication SERIAL,
		id_medicine INTEGER NOT NULL,
		id_indication INTEGER NOT NULL,
		PRIMARY KEY (id_medicine_indication), 
		UNIQUE(id_medicine, id_indication), 
		FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (id_indication) REFERENCES indication(id_indication) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE IF NOT EXISTS medicine_contraindication (
		id_medicine_contraindication SERIAL,
		id_medicine INTEGER NOT NULL,
		id_contraindication INTEGER NOT NULL,
		PRIMARY KEY (id_medicine_contraindication), 
		UNIQUE(id_medicine, id_contraindication),
		FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (id_contraindication) REFERENCES contraindication(id_contraindication) ON DELETE CASCADE ON UPDATE CASCADE
	);
	CREATE INDEX ON pharmacy(address);
	CREATE INDEX ON indication(indication);
	CREATE INDEX ON contraindication(contraindication);
	CREATE INDEX ON medicine(medicine_name);
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------