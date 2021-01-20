CREATE OR REPLACE FUNCTION create_database(_user TEXT, _password TEXT) RETURNS VOID AS $$
BEGIN
	CREATE EXTENSION IF NOT EXISTS dblink; -- enable extension
		IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'pharmacy_db') THEN
			RAISE EXCEPTION 'Database already exists';
		ELSE
			PERFORM dblink_connect('host=localhost user=' || _user ||
			 ' password=' || _password || ' dbname=' || current_database());
			PERFORM dblink_exec('CREATE DATABASE pharmacy_db OWNER my_user');
		END IF;
END
$$ LANGUAGE plpgsql;
-------------------------DROP DATABASE-----------------------------
CREATE OR REPLACE FUNCTION drop_database(_user TEXT, _password TEXT) RETURNS VOID AS $$
BEGIN
	IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'pharmacy_db') THEN
		RAISE EXCEPTION 'Database does not exists';  -- optional
	ELSE
	    PERFORM dblink_connect('host=localhost user=' || _user ||
			 ' password=' || _password || ' dbname=' || current_database());
		PERFORM dblink_exec('DROP DATABASE pharmacy_db');
	END IF;
END;
$$ LANGUAGE plpgsql;
