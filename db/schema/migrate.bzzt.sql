ALTER TABLE person ADD COLUMN url VARCHAR(255);
ALTER TABLE member ADD COLUMN updated TIMESTAMP;

UPDATE person SET name = NULL WHERE name = email;
