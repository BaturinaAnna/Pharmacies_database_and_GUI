-----------------------TRIGGERS-------------------------
--triggers for update pahrmacy.total_price
--update medicine.price
CREATE OR REPLACE FUNCTION update_total_price_by_medicine_price()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE pharmacy_medicine
	SET total_price = pharmacy_medicine.medicine_amount * NEW.price
	WHERE pharmacy_medicine.id_medicine = NEW.id_medicine;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS t_total ON medicine;

CREATE TRIGGER t_total 
AFTER UPDATE OF price ON medicine
FOR EACH ROW
EXECUTE PROCEDURE update_total_price_by_medicine_price();

--update pharmacy_medicine.medicine_amount and insert into pharmacy_medicine
CREATE OR REPLACE FUNCTION update_total_price_by_medicine_amount()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'UPDATE' OR TG_OP = 'INSERT' THEN
		NEW.total_price = NEW.medicine_amount * (SELECT price FROM medicine WHERE id_medicine = NEW.id_medicine);
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS t_total ON pharmacy_medicine;

CREATE TRIGGER t_total 
BEFORE UPDATE OF medicine_amount ON pharmacy_medicine
FOR EACH ROW
EXECUTE PROCEDURE update_total_price_by_medicine_amount();

--insert into pharmacy_medicine-------------------------------
DROP TRIGGER IF EXISTS t_insert_pharmacy_medicine ON pharmacy_medicine;

CREATE TRIGGER t_insert_pharmacy_medicine
BEFORE INSERT ON pharmacy_medicine
FOR EACH ROW
EXECUTE PROCEDURE update_total_price_by_medicine_amount();
------------------------------------------------
