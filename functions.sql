----------------------------SELECTS---------------------------------
------------------------specialization------------------------------
CREATE OR REPLACE FUNCTION get_specialization() RETURNS SETOF specialization AS $$
BEGIN
	RETURN QUERY SELECT * FROM specialization;
END;
$$ LANGUAGE plpgsql;
---------------------------producer---------------------------------

CREATE OR REPLACE FUNCTION get_producer() RETURNS SETOF producer AS $$
BEGIN
	RETURN QUERY SELECT * FROM producer;
END;
$$ LANGUAGE plpgsql;
--------------------------medicine_type-----------------------------

CREATE OR REPLACE FUNCTION get_medicine_type() RETURNS SETOF medicine_type AS $$
BEGIN
	RETURN QUERY SELECT * FROM medicine_type;
END;
$$ LANGUAGE plpgsql;
-----------------------------medicine-------------------------------

CREATE OR REPLACE FUNCTION get_medicine() RETURNS SETOF medicine AS $$
BEGIN
	RETURN QUERY SELECT * FROM medicine;
END;
$$ LANGUAGE plpgsql;
-----------------------------pharmacy-------------------------------

CREATE OR REPLACE FUNCTION get_pharmacy() RETURNS SETOF pharmacy AS $$
BEGIN
	RETURN QUERY SELECT * FROM pharmacy;
END;
$$ LANGUAGE plpgsql;
-----------------------------indication-------------------------------

CREATE OR REPLACE FUNCTION get_indication() RETURNS SETOF indication AS $$
BEGIN
	RETURN QUERY SELECT * FROM indication;
END;
$$ LANGUAGE plpgsql;
-----------------------------contraindication-------------------------------

CREATE OR REPLACE FUNCTION get_contraindication() RETURNS SETOF contraindication AS $$
BEGIN
	RETURN QUERY SELECT * FROM contraindication;
END;
$$ LANGUAGE plpgsql;
-----------------------------pharmacy_medicine-------------------------------

CREATE OR REPLACE FUNCTION get_pharmacy_medicine() RETURNS SETOF pharmacy_medicine AS $$
BEGIN
	RETURN QUERY SELECT * FROM pharmacy_medicine;
END;
$$ LANGUAGE plpgsql;
-----------------------------medicine_indication-------------------------------

CREATE OR REPLACE FUNCTION get_medicine_indication() RETURNS SETOF medicine_indication AS $$
BEGIN
	RETURN QUERY SELECT * FROM medicine_indication;
END;
$$ LANGUAGE plpgsql;
-----------------------------medicine_contraindication-------------------------------

CREATE OR REPLACE FUNCTION get_medicine_contraindication() RETURNS SETOF medicine_contraindication AS $$
BEGIN
	RETURN QUERY SELECT * FROM medicine_contraindication;
END;
$$ LANGUAGE plpgsql;

-----------------------get record from table by id--------------------------------
CREATE OR REPLACE FUNCTION get_record_by_id(table_name TEXT, record_id integer) RETURNS record AS $$
DECLARE
r_Return record;
BEGIN
EXECUTE 'SELECT * FROM '|| $1 ||' WHERE id = ' || $2 INTO r_Return;

RETURN r_Return;
END;
$$ LANGUAGE plpgsql;
-----------------------DELETE FROM TABLES------------------------------

CREATE OR REPLACE FUNCTION clear_table(table_name TEXT) RETURNS VOID AS $$
BEGIN
	EXECUTE 'TRUNCATE '|| $1 || ' CASCADE';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION clear_all_tables() RETURNS VOID AS $$
BEGIN
	TRUNCATE specialization, producer, medicine_type, medicine, pharmacy, indication,
		contraindication, pharmacy_medicine, medicine_indication, medicine_contraindication; 
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-------------------INSERT NEW RECORDS-------------------------------

CREATE OR REPLACE FUNCTION insert_into_specialization(VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	INSERT INTO specialization(specialization) VALUES ($1);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_producer(VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	INSERT INTO producer(producer) VALUES ($1);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_medicine_type(VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	INSERT INTO medicine_type(medicine_type) VALUES ($1);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_medicine(INTEGER, TEXT, INTEGER, FLOAT) RETURNS VOID AS $$
BEGIN
	INSERT INTO medicine(id_medicine_type, medicine_name, id_producer, price) VALUES ($1, $2, $3, $4);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_pharmacy(VARCHAR(40), INTEGER, TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO pharmacy(pharmacy_name, id_specialization, address) VALUES ($1, $2, $3);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_indication(TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO indication(indication) VALUES ($1);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_contraindication(TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO contraindication(contraindication) VALUES ($1);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_pharmacy_medicine(INTEGER, INTEGER, INTEGER, DATE, DATE) RETURNS VOID AS $$
BEGIN
	INSERT INTO pharmacy_medicine(id_pharmacy, id_medicine, medicine_amount, production_date, expiration_date) VALUES ($1, $2, $3, $4, $5);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_medicine_indication(INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO medicine_indication(id_medicine, id_indication) VALUES ($1, $2);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_medicine_contraindication(INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO medicine_contraindication(id_medicine, id_contraindication) VALUES ($1, $2);
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-------------------SEARCH RECORDS BY TEXT FIELD---------------------

CREATE OR REPLACE FUNCTION search_pharmacy_by_address(TEXT) RETURNS SETOF pharmacy AS $$
BEGIN
	RETURN QUERY SELECT * FROM pharmacy WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-----------------------UPDATE RECORDS-------------------------------

CREATE OR REPLACE FUNCTION update_specialization(record_id INTEGER, VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	UPDATE specialization
	SET specialization = $2
	WHERE id_specialization = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_producer(record_id INTEGER, VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	UPDATE producer
	SET producer = $2
	WHERE id_producer = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_medicine_type(record_id INTEGER, VARCHAR(40)) RETURNS VOID AS $$
BEGIN
	UPDATE medicine_type
	SET medicine_type = $2
	WHERE id_medicine_type = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_medicine(record_id INTEGER, INTEGER, TEXT, INTEGER, FLOAT) RETURNS VOID AS $$
BEGIN
	UPDATE medicine
	SET id_medicine_type = $2, medicine_name = $3, id_producer = $4, price = $5
	WHERE id_medicine = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_pharmacy(record_id INTEGER, VARCHAR(40), INTEGER, TEXT) RETURNS VOID AS $$
BEGIN
	UPDATE pharmacy
	SET pharmacy_name = $2, id_specialization = $3, address = $4
	WHERE id_pharmacy = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_pharmacy_medicine(record_id INTEGER, INTEGER, INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE pharmacy_medicine
	SET id_pharmacy = $2, id_medicine = $3, medicine_amount = $4
	WHERE id_pharmacy_medicine = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_indication(record_id INTEGER, TEXT) RETURNS VOID AS $$
BEGIN
	UPDATE indication
	SET indication = $2
	WHERE id_indication = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_contraindication(record_id INTEGER, TEXT) RETURNS VOID AS $$
BEGIN
	UPDATE contraindication
	SET contraindication = $2
	WHERE id_contraindication = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_medicine_indication(record_id INTEGER, INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE medicine_indication
	SET id_medicine = $2, id_indication = $3
	WHERE id_medicine_indication = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_medicine_contraindication(record_id INTEGER, INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE medicine_contraindication
	SET id_medicine = $2, id_contraindication = $3
	WHERE id_medicine_contraindication = record_id;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------
-----------------------DELETE BY TEXT FIELD-------------------------------

CREATE OR REPLACE FUNCTION delete_pharmacy_by_address(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM pharmacy WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_indication_by_name(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM indication WHERE indication.indication LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_contraindication_by_name(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM contraindication WHERE contraindication.contraindication LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_medicine_by_name(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM medicine WHERE medicine_name LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------
-----------------------DELETE RECORD FROM TABLE---------------------------

CREATE OR REPLACE FUNCTION delete_record_from_table(record_id INTEGER, table_name TEXT) RETURNS VOID AS $$
BEGIN
	EXECUTE 'DELETE FROM '||table_name||' WHERE id_'||table_name||' = '|| record_id;
END;
$$ LANGUAGE plpgsql;
