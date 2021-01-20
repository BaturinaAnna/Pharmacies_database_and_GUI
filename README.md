# Pharmacies_database_and_GUI

Database for the network of pharmacies and GUI to work with tables of this database.

### Tables:
 - specialization - information about specialization of pharmacy
 - producer - information about medicine producer
 - medicine_type - information about type of medicine (e.g., tablet, ointment etc.)
 - medicine - information about medicine
 - pharmacy - information about pharmacy
 - indication - information about indication for use of medicine
 - contraindication - information about contraindication for use of medicine
 - pharmacy_medicine - information about medicines that are available in the pharmacy
 - medicine_indication - table for connection of medicine and indication
 - medicine_contraindication - table for connection of medicine and contraindication
 
##### Database satisfies 3NF, as:
 - It is satisfies 1NF: All values in the tables are atomic
 - It is satisfies 2NF: satisfies 1NF and all tables have only one candidat key that can be a primary key.
 - It is satisfies 3NF: satisfies 2NF and all tables have no transitive functional dependency
 
##### Indexes by text field:
 - pharmacy address - pharmacy(address) - find and delete by index
 - indication name - indication(indication) - delete by index
 - contraindication name - contraindication(contraindication) - delete by index
 - medicine name - medicine(medicine_name) - delete by index

##### Trigger field:
 - total_price - the field changes after the price of the drug or the quantity of the drug in the specified pharmacy has been changed 
