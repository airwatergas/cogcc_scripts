set search_path to import;
drop table production_amounts;
create table production_amounts (
	id serial primary key not null, 
	well_id integer, 
	production_year varchar(4),
	production_month varchar(3),
	formation_name varchar(50),
	sidetrack varchar(2),
	well_status_code varchar(2),
	days_producing integer,
	oil_bom varchar(20),
	oil_produced varchar(20),
	oil_sold varchar(20),
	oil_adj varchar(20),
	oil_eom varchar(20),
	oil_gravity varchar(20),
	gas_production varchar(20),
	gas_flared varchar(20),
	gas_used varchar(20),
	gas_shrinkage varchar(20),
	gas_sold varchar(20),
	gas_btu varchar(20),
	water_production varchar(20), 
	water_disposal_code varchar(1), 
	created_at date, 
	updated_at date
);