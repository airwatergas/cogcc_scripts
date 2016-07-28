---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
------------------------------------------ SCHEMAS ------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- import => most recent raw data collected

-- staging => transformation of import data to public data

-- backup => backup of previous production data

-- public => production ready data (latest and greatest)


-- WORKFLOW:  import => staging => public (copy previous public to backup)

-- Required for dynamic tables only



---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--------------------------------------- STATIC TABLES ---------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- these tables do not change (or infrequently change) from date scrape to next date scrape


---------------------------------------------------------------
-----------------------  COUNTIES  ----------------------------
---------------------------------------------------------------
set search_path to public;
drop table counties;
create table counties (
	id integer, 
	api_code varchar(3), 
	name varchar(11)
);

insert into counties (id, api_code, name) values (1,'001','Adams');
insert into counties (id, api_code, name) values (2,'003','Alamosa');
insert into counties (id, api_code, name) values (3,'005','Arapahoe');
insert into counties (id, api_code, name) values (4,'007','Archuleta');
insert into counties (id, api_code, name) values (5,'009','Baca');
insert into counties (id, api_code, name) values (6,'011','Bent');
insert into counties (id, api_code, name) values (7,'013','Boulder');
insert into counties (id, api_code, name) values (8,'014','Broomfield');
insert into counties (id, api_code, name) values (9,'015','Chaffee');
insert into counties (id, api_code, name) values (10,'017','Cheyenne');
insert into counties (id, api_code, name) values (11,'019','Clear Creek');
insert into counties (id, api_code, name) values (12,'021','Conejos');
insert into counties (id, api_code, name) values (13,'023','Costilla');
insert into counties (id, api_code, name) values (14,'025','Crowley');
insert into counties (id, api_code, name) values (15,'027','Custer');
insert into counties (id, api_code, name) values (16,'029','Delta');
insert into counties (id, api_code, name) values (17,'031','Denver');
insert into counties (id, api_code, name) values (18,'033','Dolores');
insert into counties (id, api_code, name) values (19,'035','Douglas');
insert into counties (id, api_code, name) values (20,'037','Eagle');
insert into counties (id, api_code, name) values (21,'041','El Paso');
insert into counties (id, api_code, name) values (22,'039','Elbert');
insert into counties (id, api_code, name) values (23,'043','Fremont');
insert into counties (id, api_code, name) values (24,'045','Garfield');
insert into counties (id, api_code, name) values (25,'047','Gilpin');
insert into counties (id, api_code, name) values (26,'049','Grand');
insert into counties (id, api_code, name) values (27,'051','Gunnison');
insert into counties (id, api_code, name) values (28,'053','Hinsdale');
insert into counties (id, api_code, name) values (29,'055','Huerfano');
insert into counties (id, api_code, name) values (30,'057','Jackson');
insert into counties (id, api_code, name) values (31,'059','Jefferson');
insert into counties (id, api_code, name) values (32,'061','Kiowa');
insert into counties (id, api_code, name) values (33,'063','Kit Carson');
insert into counties (id, api_code, name) values (34,'067','La Plata');
insert into counties (id, api_code, name) values (35,'065','Lake');
insert into counties (id, api_code, name) values (36,'069','Larimer');
insert into counties (id, api_code, name) values (37,'071','Las Animas');
insert into counties (id, api_code, name) values (38,'073','Lincoln');
insert into counties (id, api_code, name) values (39,'075','Logan');
insert into counties (id, api_code, name) values (40,'077','Mesa');
insert into counties (id, api_code, name) values (41,'079','Mineral');
insert into counties (id, api_code, name) values (42,'081','Moffat');
insert into counties (id, api_code, name) values (43,'083','Montezuma');
insert into counties (id, api_code, name) values (44,'085','Montrose');
insert into counties (id, api_code, name) values (45,'087','Morgan');
insert into counties (id, api_code, name) values (46,'089','Otero');
insert into counties (id, api_code, name) values (47,'091','Ouray');
insert into counties (id, api_code, name) values (48,'093','Park');
insert into counties (id, api_code, name) values (49,'095','Phillips');
insert into counties (id, api_code, name) values (50,'097','Pitkin');
insert into counties (id, api_code, name) values (51,'099','Prowers');
insert into counties (id, api_code, name) values (52,'101','Pueblo');
insert into counties (id, api_code, name) values (53,'103','Rio Blanco');
insert into counties (id, api_code, name) values (54,'105','Rio Grande');
insert into counties (id, api_code, name) values (55,'107','Routt');
insert into counties (id, api_code, name) values (56,'109','Saguache');
insert into counties (id, api_code, name) values (57,'111','San Juan');
insert into counties (id, api_code, name) values (58,'113','San Miguel');
insert into counties (id, api_code, name) values (59,'115','Sedgwick');
insert into counties (id, api_code, name) values (60,'117','Summit');
insert into counties (id, api_code, name) values (61,'119','Teller');
insert into counties (id, api_code, name) values (62,'121','Washington');
insert into counties (id, api_code, name) values (63,'123','Weld');
insert into counties (id, api_code, name) values (64,'125','Yuma');

alter table counties add primary key (id);


-- create copy in import for scraping purposes
set search_path to import;
drop table counties;
create table counties (
	id integer, 
	api_code varchar(3), 
	name varchar(11), 
	in_use boolean not null default false, 
	location_scraped boolean not null default false
);
insert into counties (id, api_code, name) select id, api_code, name from public.counties order by id;



---------------------------------------------------------------
--------------------  WELL STATUS CODES  ----------------------
---------------------------------------------------------------
set search_path to public;
drop table well_status_codes;
create table well_status_codes (
	id integer, 
	code varchar(2), 
	name varchar(30), 
	description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (1, 'AC', 'Active', 'Active well: gas storage well completion or monitor well.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (2, 'AL', 'Abandoned', 'Abandoned location: permit vacated; per operator: well has not been spud.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (3, 'DA', 'Dry and Abandoned', 'Dry and abandoned well.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (4, 'DG', 'Drilling', 'Drilling: well has spud but is not reported as completed.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (5, 'DM', 'Domestic', 'Domestic well.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (6, 'IJ', 'Injection', 'Injection well for waste disposal or secondary recovery.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (7, 'PA', 'Plugged and Abandoned', 'Plugged and abandoned well.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (8, 'PR', 'Producing', 'Producing well.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (9, 'SI', 'Shut-in', 'Shut-in well: completed well is not producing but is mechanically capable of production.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (10, 'SU', 'Suspended Permit', 'Suspended permit: permit to drill is suspended until an issue is resolved.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (11, 'TA', 'Temporarily Abandoned', 'Temporarily abandoned well: completed well not mechanically capable of production without intervention.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (12, 'WO', 'Waiting on Completion', 'Waiting on completion: well has been drilled but is not yet reported as completed.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (13, 'XX', 'Approved Permit', 'Approved permit to drill well; not yet reported as spud; includes expired permits.', now(), now());
insert into well_status_codes (id, code, name, description, created_at, updated_at) values (14, 'UN', 'Unknown', 'Unknown: old well with minimal information.', now(), now());

alter table well_status_codes add primary key (id);



---------------------------------------------------------------
----------------  SIDETRACK STATUS CODES  ---------------------
---------------------------------------------------------------
set search_path to public;
drop table sidetrack_status_codes;
create table sidetrack_status_codes (
	id integer, 
	code varchar(2), 
	name varchar(30), 
	description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (1, 'AB', 'Abandoned', 'Abandoned drilled wellbore or vacated permit for wellbore that will not be drilled; or the well has been abandoned.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (2, 'AC', 'Active', 'Active wellbore: gas storage well or monitor well.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (3, 'CM', 'Commingled', 'Commingled: multiple wellbores completed and producing from the same formation in the well; production is commingled and reported from only on wellbore; a non-reporting wellbore status is CM; the single reporting wellbore status is PR.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (4, 'DG', 'Drilling', 'Drilling wellbore: wellbore has spud but is not yet reported as completed.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (5, 'DM', 'Domestic', 'Domestic wellbore.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (6, 'IJ', 'Injection', 'Injection wellbore for waste disposal or secondary recovery.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (7, 'PR', 'Producing', 'Producing wellbore.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (8, 'SI', 'Shut-in', 'Shut-in wellbore: completed wellbore is not producing but is mechanically capable of production.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (9, 'TA', 'Temporarily Abandoned', 'Temporarily abandoned wellbore: completed wellbore not mechanically capable of production without intervention.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (10, 'WO', 'Waiting on Completion', 'Waiting on completion: wellbore has been drilled but is not yet reported as completed.', now(), now());
insert into sidetrack_status_codes (id, code, name, description, created_at, updated_at) values (11, 'XX', 'Approved Permit', 'Approved permit to drill wellbore: wellbore not yet reported as spud; includes expired permits.', now(), now());

alter table sidetrack_status_codes add primary key (id);



---------------------------------------------------------------
------------  COMPLETED INTERVAL STATUS CODES  ----------------
---------------------------------------------------------------
set search_path to public;
drop table completed_interval_status_codes;
create table completed_interval_status_codes (
	id integer, 
	code varchar(2), 
	name varchar(30), 
	description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (1, 'AB', 'Abandoned', 'Abandoned completion: perforations have been squeezed with cement or isolated by a bridge plug with 2 or more sacks of cement; or the well has been abandoned.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (2, 'AC', 'Active', 'Active formation completion: gas storage well completion or monitor well completion.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (3, 'CM', 'Commingled', 'Commingled: multiple formations completed and producing in the well and production is commingled downhole; a non-reporting formation code status is CM; a reporting formation code status is PR.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (4, 'DM', 'Domestic', 'Domestic well completion.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (5, 'IJ', 'Injection', 'Injection formation completion for waste disposal or secondary recovery.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (6, 'PR', 'Producing', 'Producing formation completion.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (7, 'SI', 'Shut-in', 'Shut-in formation completion: completed formation is not producing but is mechanically capable of production.', now(), now());
insert into completed_interval_status_codes (id, code, name, description, created_at, updated_at) values (8, 'TA', 'Temporarily Abandoned', 'Temporarily abandoned formation completion: completed formation not mechanically capable of production without intervention.', now(), now());

alter table completed_interval_status_codes add primary key (id);



---------------------------------------------------------------
-----------------  FACILITY STATUS CODES  ---------------------
---------------------------------------------------------------
set search_path to public;
drop table facility_status_codes;
create table facility_status_codes (
	id integer, 
	code varchar(2), 
	name varchar(30), 
	description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

insert into facility_status_codes (id, code, name, description, created_at, updated_at) values (1, 'AC', 'Active', 'Active location: approved form 2a (includes expired 2a - check expiration date) or historically created location for well/permit in existence prior to 2009.', now(), now());
insert into facility_status_codes (id, code, name, description, created_at, updated_at) values (2, 'AL', 'Abandoned', 'Abandoned location: permit vacated; per operator: location was never constructed.', now(), now());
insert into facility_status_codes (id, code, name, description, created_at, updated_at) values (3, 'CL', 'Closed', 'Closed location: location was built and has been reclaimed.', now(), now());

alter table facility_status_codes add primary key (id);



---------------------------------------------------------------
-------------------------  FIELDS  ----------------------------
---------------------------------------------------------------
-- fields data retrieved from pdf => http://cogcc.state.co.us/documents/about/COGIS_Help/field_list.pdf

-- used online pdf-to-excel converter, created csv from conversion file

set search_path to staging;
drop table fields;
create table fields (
	name varchar(30), 
	code integer, 
	discovery_well_api varchar(12), 
	discovery_year smallint, 
	abandon_year smallint
);

copy fields from '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/cogcc_fields.csv' (format csv, delimiter ',', null '');

alter table fields add column id serial not null primary key;
alter table fields add column created_at date default '2015-07-30';
alter table fields add column updated_at date default '2015-07-30';

COPY (select id, name, code, discovery_well_api, discovery_year, abandon_year, created_at, updated_at from fields order by code) TO '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/fields.csv' WITH CSV;

set search_path to public;
drop table fields;
create table fields (
	id integer, 
	name varchar(30), 
	code integer, 
	discovery_well_api varchar(12), 
	discovery_year smallint, 
	abandon_year smallint, 
	created_at date, 
	updated_at date
);

copy fields from '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/fields.csv' (format csv, delimiter ',', null '');

alter table fields add primary key (id);



---------------------------------------------------------------
----------------------  FORMATIONS  ---------------------------
---------------------------------------------------------------
-- formations data retrieved from pdf => http://cogcc.state.co.us/documents/about/COGIS_Help/formation_list.pdf

-- PDF is source, but already imported into raw database (awgrsn), use table dump

COPY (select id, code, description from cogcc_formation_codes order by code) TO '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/formations.csv' WITH CSV;

set search_path to public;
drop table formations;
create table formations (
	id integer, 
	code varchar(6), 
	description varchar(50)
);

copy formations from '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/formations.csv' (format csv, delimiter ',', null '');

alter table formations add primary key (id);
alter table formations add column created_at date default '2015-07-30';
alter table formations add column updated_at date default '2015-07-30';



---------------------------------------------------------------
--------------------  FIELD FORMATIONS  -----------------------
---------------------------------------------------------------
-- Download and import Oil and Gas Field Polygons shapefile using pgShapeLoader.app

-- Go to => http://cogcc.state.co.us/data2.html#/downloads

-- Click on => http://cogcc.state.co.us/documents/data/downloads/gis/COGCC_Fields.zip

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/COGCC_Fields and select COGCC_Fields.shp and click Open button

-- Replace 'public' with 'staging' for Schema

-- Replace 'cogcc_fields' with 'field_formations' for Table

-- Enter '26913' for SRID

-- Click Import button and wait for import process to complete

alter table field_formations drop constraint field_formations_pkey;
alter table field_formations rename column gid to id;
alter table field_formations add primary key (id);
alter table field_formations drop column field_code;
alter table field_formations rename column code_int to field_code;
alter table field_formations rename column update to update_date;
alter table field_formations rename column format10 to formation10;
alter table field_formations rename column format11 to formation11;
alter table field_formations rename column format12 to formation12;
alter table field_formations add column field_id integer;
update field_formations set field_id = (select id from fields where code = field_formations.field_code);

set search_path to staging;
COPY (select id, field_name, field_code, formation1, formation2, formation3, formation4, formation5, formation6, formation7, formation8, formation9, formation10, formation11, formation12, update_date from field_formations order by field_code) TO '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/field_formations_formatted.csv' WITH CSV;

set search_path to public;
drop table field_formations;
create table field_formations (
	id integer, 
	field_name varchar(30), 
	field_code integer, 
	formation_1 varchar(50), 
	formation_2 varchar(50), 
	formation_3 varchar(50), 
	formation_4 varchar(50), 
	formation_5 varchar(50), 
	formation_6 varchar(50), 
	formation_7 varchar(50), 
	formation_8 varchar(50), 
	formation_9 varchar(50), 
	formation_10 varchar(50), 
	formation_11 varchar(50), 
	formation_12 varchar(50),
	updated_at date
);

copy field_formations from '/Users/troyburke/Data/cogcc_query_database/static_table_dumps/field_formations_formatted.csv' (format csv, delimiter ',', null '');

alter table field_formations add primary key (id);



---------------------------------------------------------------
------------------  DISPOSITION CODES  ------------------------
---------------------------------------------------------------
set search_path to public;
drop table disposition_codes;
create table disposition_codes (
	id integer, 
	code varchar(1), 
	description varchar(30)
);
insert into disposition_codes (id, code, description)  values (1, 'M', 'Commercial Disposal facility');
insert into disposition_codes (id, code, description)  values (2, 'C', 'Central Disposal pit or well');
insert into disposition_codes (id, code, description)  values (3, 'P', 'Onsite Pit');
insert into disposition_codes (id, code, description)  values (4, 'I', 'Injected on lease');
insert into disposition_codes (id, code, description)  values (5, 'S', 'Surface Discharge');

alter table disposition_codes add primary key (id);



---------------------------------------------------------------
-------------------  SHALE GAS BASINS  ------------------------
---------------------------------------------------------------
-- Download and import US Shale Basins EIA May 2011 shapefile using pgShapeLoader.app

-- Go to => http://www.eia.gov/pub/oil_gas/natural_gas/analysis_publications/maps/maps.htm

-- Click on => http://www.eia.gov/pub/oil_gas/natural_gas/analysis_publications/maps/ShalePlays_SedimentaryBasins_US_EIA.zip

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/ShalePlays_SedimentaryBasins_US_EIA and select ShalePlays_US_EIA_22Jul2015.shp and click Open button

-- NEW 2015 PROJECTION NOT WORKING USE 2011 FILE!!!

-- Keep 'public' for Schema

-- Replace 'ShalePlays_US_EIA' with 'shale_gas_basins' for Table

-- Enter 'geom_4269' for Geo Column

-- Enter '4269' for SRID

-- Click Import button and wait for import process to complete

alter table shale_gas_basins add column geom geometry(MultiPolygon,26913);
update shale_gas_basins set geom = ST_Transform(geom_4269, 26913);

-- **NOTE - this table is not used for production display, but needs to be in public schema for import geometry updates



---------------------------------------------------------------
--------------------  BEDROCK AQUIFERS  -----------------------
---------------------------------------------------------------
-- Download and import Statewide Bedrock Aquifers shapefile using pgShapeLoader.app

-- Go to => http://cdss.state.co.us/GIS/Pages/AllGISData.aspx

-- Click on => ftp://dwrftp.state.co.us/cdss/gis/BedrockAquifers.zip

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/BedrockAquifers and select Bedrock Aquifer.shp and click Open button

-- Keep 'public' for Schema

-- Replace 'bedrock_aquifers' with 'bedrock aquifer' for Table

-- Keep 'geom' for Geo Column

-- Enter '26913' for SRID

-- Click Import button and wait for import process to complete

-- **NOTE - this table is not used for production display, but needs to be in public schema for import geometry updates



---------------------------------------------------------------
--------------------  FACILITY TYPES  -------------------------
---------------------------------------------------------------
set search_path to public;
drop table facility_types;
create table facility_types (
	id integer, 
	name varchar(50)
);
insert into facility_types (id, name) values (1, 'WELL');
insert into facility_types (id, name) values (2, 'WATER GATHERING SYSTEM/LINE');
insert into facility_types (id, name) values (3, 'UIC WATER TRANSFER STATION');
insert into facility_types (id, name) values (4, 'UIC SIMULTANEOUS DISPOSAL');
insert into facility_types (id, name) values (5, 'UIC ENHANCED RECOVERY');
insert into facility_types (id, name) values (6, 'UIC DISPOSAL');
insert into facility_types (id, name) values (7, 'TANK BATTERY');
insert into facility_types (id, name) values (8, 'SPILL OR RELEASE');
insert into facility_types (id, name) values (9, 'SERVICE SITE');
insert into facility_types (id, name) values (10, 'PIT');
insert into facility_types (id, name) values (11, 'PIPELINE');
insert into facility_types (id, name) values (12, 'NONFACILITY');
insert into facility_types (id, name) values (13, 'LOCATION');
insert into facility_types (id, name) values (14, 'LEASE');
insert into facility_types (id, name) values (15, 'LAND APPLICATION SITE');
insert into facility_types (id, name) values (16, 'GAS STORAGE FACILITY');
insert into facility_types (id, name) values (17, 'GAS PROCESSING PLANT');
insert into facility_types (id, name) values (18, 'GAS GATHERING SYSTEM');
insert into facility_types (id, name) values (19, 'GAS COMPRESSOR');
insert into facility_types (id, name) values (20, 'FLOWLINE');
insert into facility_types (id, name) values (21, 'CENTRALIZED EP WASTE MGMT FAC');
insert into facility_types (id, name) values (22, 'CDP');

alter table facility_types add primary key (id);



---------------------------------------------------------------
--------------------  SCRAPE STATUSES  ------------------------
---------------------------------------------------------------
set search_path to import;
drop table scrape_statuses;
create table scrape_statuses (
	id serial primary key not null, 
	gid integer, 
	link_fld varchar(8),
	well_api_number varchar(12),
	well_api_county varchar(3),
	well_api_sequence varchar(5),
	well_id integer, 
	in_use boolean not null default false, 
	document_scrape_status varchar(20) default 'not scraped',
	mit_scrape_status varchar(20) default 'not scraped', 
	noav_scrape_status varchar(20) default 'not scraped'
);
insert into scrape_statuses (gid, link_fld, well_api_number, well_api_county, well_api_sequence, well_id)
select gid, link_fld, attrib_1, substring(attrib_1 from 4 for 3), substring(attrib_1 from 8 for 5), well_id from wells order by gid;

alter table scrape_statuses add column elevation_rounded integer;
alter table scrape_statuses add column sec;
alter table scrape_statuses add column twp_num;
alter table scrape_statuses add column twp_dir;
alter table scrape_statuses add column rng;
alter table scrape_statuses add column dist_n_s;
alter table scrape_statuses add column dir_n_s;
alter table scrape_statuses add column dist_e_w;
alter table scrape_statuses add column dir_e_w;

alter table scrape_statuses add column denver_aquifer_pdf_downloaded boolean default false;
alter table scrape_statuses add column denver_aquifer_pdf_download_failed boolean default false;





---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-------------------------------------- DYNAMIC TABLES ---------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- these tables are updated during scrapes


---------------------------------------------------------------
--------------------------  WELLS  ----------------------------
---------------------------------------------------------------

-- Download and import Well Surface Location Data shapefile using pgShapeLoader.app

-- Go to => http://cogcc.state.co.us/data2.html#/downloads

-- Click on => http://cogcc.state.co.us/documents/data/downloads/gis/WELL_SHP.ZIP

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/WELL_SHP and select Wells.shp and click Open button

-- Replace 'public' with 'import' for Schema

-- Enter '26913' for SRID

-- Click Import button and wait for import process to complete


-- copy table from import schema to staging schema
set search_path to import;
drop table staging.wells;
create table staging.wells as table wells;


-- update primary key and add well_id key column
set search_path to staging;
alter table wells drop constraint wells_pkey;
alter table wells add column id serial not null primary key;
alter table wells add column well_id integer;
update wells set well_id = link_fld::integer;
create unique index index_wells_on_well_id on wells(well_id);

-- add additional information columns
set search_path to staging;
alter table wells add column is_denver_basin boolean not null default false;
alter table wells add column is_piceance_basin boolean not null default false;
alter table wells add column is_raton_basin boolean not null default false;
alter table wells add column is_san_juan_basin boolean not null default false;
alter table wells add column is_denver_aquifer boolean not null default false;
alter table wells add column county_name varchar(11);
alter table wells add column is_directional boolean not null default false;

-- populate additional information columns
set search_path to public;
update staging.wells set is_denver_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='DENVER'));
update staging.wells set is_piceance_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='UINTA-PICEANCE'));
update staging.wells set is_raton_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='RATON BASIN'));
update staging.wells set is_san_juan_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='SAN JUAN'));
update staging.wells set is_denver_aquifer = 'true' where ST_Within(geom,(select geom from bedrock_aquifers where name ='Denver Basin'));
update staging.wells set county_name = (select name from counties where api_code = staging.wells.api_county);
update staging.wells set is_directional = 'true' where well_id in (select well_id from directional_bottomholes);


--------------------------------------------------------------
-- !!!! AFTER RUNNING SCOUT CARD SCRAPE (***SEE BELOW) !!!! --
--------------------------------------------------------------

-- dump table (join of wells and scout_cards) from staging schema
set search_path to staging;
COPY (select w.well_id, w.attrib_1, w.api_county, w.county_name, w.well_num, w.well_name, sc.lease_number, w.is_directional, sc.is_horizontal, w.facility_i, w.locationid, w.loc_name_n, w.facility_s, sc.status_date, w.operator_n, w.attrib_2, w.field_code, w.field_name, w.ground_ele, null, w.long, w.lat, w.utm_x, w.utm_y, w.sec, w.twp, w.range, w.qtrqtr, w.meridian, w.dist_n_s, w.dir_n_s, w.dist_e_w, w.dir_e_w, w.locqual, w.is_denver_basin, w.is_piceance_basin, w.is_raton_basin, w.is_san_juan_basin, w.is_denver_aquifer, sc.is_fracked, sc.has_frac_focus_report, sc.job_start_date, sc.job_end_date, sc.reported_date, sc.job_prior_to_rule_205, sc.days_to_report, sc.completion_data_confidential, 'http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid=' || w.link_fld || '&type=WELL', '2015-07-28 00:43:00', '2015-07-28 00:43:00' from wells w left outer join scout_cards sc on w.well_id = sc.well_id order by w.well_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/wells.csv' WITH CSV;

set search_path to public;
create table backup.wells as table wells;
drop table wells;
create table wells (id integer, 
	api_number varchar(12), 
	api_county varchar(3), 
	county_name varchar(10), 
	well_number varchar(15), 
	well_name varchar(35), 
	lease_number varchar(15), 
	is_vertical boolean, 
	is_drifted boolean, 
	is_directional boolean, 
	is_horizontal boolean, 
	facility_id integer, 
	location_id integer, 
	location_name varchar(45),
	status_code varchar(2), 
	status_date date, 
	operator_number integer, 
	operator_name varchar(50), 
	field_code integer, 
	field_name varchar(30), 
	elevation double precision, 
	usgs_elevation real, 
	longitude double precision, 
	latitude double precision, 
	utm_x real, 
	utm_y real,
	section varchar(2), 
	township varchar(5), 
	range varchar(5), 
	qtr_qtr varchar(6), 
	meridian varchar(1), 
	dist_n_s real, 
	dir_n_s varchar(1), 
	dist_e_w real, 
	dir_e_w varchar(1), 
	loc_qual varchar(18), 
	is_denver_basin boolean, 
	is_wattenberg boolean, 
	is_piceance_basin boolean, 
	is_raton_basin boolean,
	is_san_juan_basin boolean, 
	is_denver_aquifer boolean, 
	is_fracked boolean, 
	has_frac_focus_report boolean, 
	ff_job_start_date date, 
	ff_job_end_date date, 
	ff_reported_date date, 
	ff_job_prior_to_rule_205 boolean, 
	ff_days_to_report integer,
	completion_data_confidential boolean,
	scout_card_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp);


copy wells from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/wells.csv' (format csv, delimiter ',', null '');

alter table wells add primary key (id);

create index index_wells_on_api_number on wells (api_number);
create index index_wells_on_api_county on wells (api_county);
create index index_wells_on_status_code on wells (status_code);



COPY (select id, api_number, api_county, county_name, well_number, well_name, lease_number, is_vertical, is_drifted, is_directional, is_horizontal, facility_id, location_id, location_name, status_code, status_date, operator_number, operator_name, field_code, field_name, elevation, usgs_elevation, longitude, latitude, utm_x, utm_y, section, township, range, qtr_qtr, meridian, dist_n_s, dir_n_s, dist_e_w, dir_e_w, loc_qual, is_denver_basin, is_wattenberg, is_piceance_basin, is_raton_basin, is_san_juan_basin, is_denver_aquifer, is_fracked, has_frac_focus_report, ff_job_start_date, ff_job_end_date, ff_reported_date, ff_job_prior_to_rule_205, ff_days_to_report, completion_data_confidential, scout_card_url, created_at, updated_at from wells order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2016/wells.csv' WITH CSV;

copy wells from '/data/home/trbu5654/wells.csv' (format csv, delimiter ',', null '');




---------------------------------------------------------------
------------------  USGS WELL ELEVATIONS  ---------------------
---------------------------------------------------------------

-- WELL ELEVATIONS COPY FROM OLD WELL TABLE
set search_path to import;
drop table well_usgs_elevations;
create table well_usgs_elevations (
	id serial not null primary key, 
	well_id integer, 
	longitude double precision, 
	latitude double precision, 
	elevation real, 
	is_denver_basin boolean not null default false, 
	elevation_retreived boolean not null default false, 
	in_use boolean not null default false
);
insert into well_usgs_elevations (well_id, longitude, latitude, is_denver_basin) select well_id, long, lat, is_denver_basin from wells order by well_id;
create unique index index_well_usgs_elevations_on_well_id on well_usgs_elevations (well_id);
update well_usgs_elevations set elevation = (select usgs_elevation from public.wells where id = well_usgs_elevations.well_id);
update well_usgs_elevations set elevation_retreived = 'true' where elevation is not null;

-- run script to populate new well usgs elevations

-- update public wells table with usgs elevation values
set search_path to public;
update wells set usgs_elevation = (select elevation from import.well_usgs_elevations where well_id = wells.id);




---------------------------------------------------------------
----------------  DIRECTIONAL BOTTOMHOLES  --------------------
---------------------------------------------------------------
-- Download and import well shapefile using pgShapeLoader.app

-- Go to => http://cogcc.state.co.us/data2.html#/downloads

-- Click on => http://cogcc.state.co.us/documents/data/downloads/gis/DIR_BHLS.ZIP

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/DIR_BHLS and select DIR_BHLS.shp and click Open button

-- Replace 'public' with 'import' for Schema

-- Replace 'dir_bhls' with 'directional_bottomholes' for Table

-- Enter '26913' for SRID

-- Click Import button and wait for import process to complete

set search_path to import;
alter table directional_bottomholes add column well_id integer;
update directional_bottomholes set well_id = left(api,8)::integer;

set search_path to public;
drop table well_directional_bottomholes;
create table well_directional_bottomholes (
	id integer, 
	well_id integer, 
	bh_status varchar(10), 
	mdepth numeric(10,0), 
	tvd double precision, 
	long_nad83 double precision, 
	lat_nad83 double precision, 
	utmx_z13 double precision, 
	utmy_z13 double precision, 
	deviation varchar(15), 
	created_at timestamp, 
	updated_at timestamp
);

INSERT INTO well_directional_bottomholes (id, well_id, bh_status, mdepth, tvd, long_nad83, lat_nad83, utmx_z13, utmy_z13, deviation, created_at, updated_at)
SELECT gid, well_id, bh_status, mdepth, tvd, long_nad83, lat_nad83, utmx_z13, utmy_z13, deviation_, '2015-07-30', '2015-07-30' FROM import.directional_bottomholes ORDER BY gid;

alter table well_directional_bottomholes add primary key (id);

create index index_well_directional_bottomholes_on_well_id on well_directional_bottomholes (well_id);
create index index_well_directional_bottomholes_on_bh_status on well_directional_bottomholes (bh_status);



---------------------------------------------------------------
-------------------  DIRECTIONAL LINES  -----------------------
---------------------------------------------------------------
-- Download and import well shapefile using pgShapeLoader.app

-- Go to => http://cogcc.state.co.us/data2.html#/downloads

-- Click on => http://cogcc.state.co.us/documents/data/downloads/gis/DIRLINES.ZIP

-- Downlaod zipfile to //Data/cogcc_query_database/downloads and unzip

-- Open pgShapeLoader.app in Applications folder

-- Click View connection details... button

-- Enter 'cogcc' for username, leave password blank, enter 'cogcc_development' for database, and click OK button

-- Click Add file button

-- Browse to //Data/cogcc_query_database/data/downloads/DIRLINES and select DIRLINES.shp and click Open button

-- Replace 'public' with 'import' for Schema

-- Replace 'dirlines' with 'directional_lines' for Table

-- Enter '26913' for SRID

-- Click Import button and wait for import process to complete

set search_path to import;
alter table directional_lines add column well_id integer;
update directional_lines set well_id = left(et_id,8)::integer;

--set search_path to public;
--drop table well_directional_lines;
--create table well_directional_lines (
--	id integer, 
--	well_id integer, 
--	et_id varchar(12), 
--	geom geometry(MultiLineString,26913), 
--	created_at timestamp, 
--	updated_at timestamp
--);

--INSERT INTO directional_lines (id, well_id, et_id, geom, created_at, updated_at)
--SELECT gid, well_id, et_id, geom, now(), now() FROM import.directional_lines ORDER BY gid;

--alter table directional_lines add primary key (id);
--create index index_directional_lines_on_well_id on directional_lines (well_id);



---------------------------------------------------------------
---------------------  OPERATORS  -----------------------------
---------------------------------------------------------------
COPY (select distinct operator_n, name, '2015-07-28 00:43:00', '2015-07-28 00:43:00' from import.wells order by name) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/operators.csv' WITH CSV;

set search_path to staging;
drop table operators;
create table operators (
	operator_number integer, 
	name varchar(50), 
	created_at timestamp, 
	updated_at timestamp
);

copy operators from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/operators.csv' (format csv, delimiter ',', null '');

alter table operators add column id serial not null primary key;

COPY (select id, name, operator_number, created_at, updated_at from operators order by name) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/operators_formatted.csv' WITH CSV;


set search_path to public;
drop table operators;
create table operators (
	id integer, 
	name varchar(50), 
	operator_number integer, 
	created_at timestamp, 
	updated_at timestamp
);

copy operators from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/operators_formatted.csv' (format csv, delimiter ',', null '');

alter table operators add primary key (id);



---------------------------------------------------------------
-------------  SCOUT CARDS (AKA WELL DETAILS)  ----------------
---------------------------------------------------------------
set search_path to import;
drop table scout_card_scrapes;
drop table scout_cards;
drop table sidetracks;
drop table objective_formations;
drop table planned_casings;
drop table completed_casings;
drop table completed_formations;
drop table completed_intervals;
drop table formation_treatments;

create table scout_card_scrapes (
	id serial primary key not null,
	well_id integer, 
	well_facility_id varchar(8), 
	html_saved boolean not null default false, 
	html_status varchar(20), 
	in_use boolean not null default false
);
insert into scout_card_scrapes (well_id, well_facility_id) select well_id, link_fld from wells;

create table scout_cards (
	id serial primary key not null, 
	well_id integer, 
	status_date varchar(30), 
	lease_number varchar(20), 
	has_frac_focus_report boolean not null default false, 
	job_start_date varchar(10), 
	job_end_date varchar(10), 
	reported_date varchar(30), 
	days_to_report varchar(10), 
	completion_data_confidential boolean not null default false, 
	created_at timestamp, 
	updated_at timestamp
);

create table sidetracks (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer, 
	sidetrack_number varchar(2), 
	status_code varchar(30), 
	status_date varchar(30), 
	spud_date varchar(10), 
	spud_date_type varchar(30),
	wellbore_permit varchar(50),
	permit_number varchar(50), 
	permit_expiration_date varchar(30), 
	prop_depth_form varchar(20), 
	surface_mineral_owner_same varchar(30),
	mineral_owner varchar(30),
	surface_owner varchar(30), 
	unit varchar(50), 
	unit_number varchar(50), 
	completion_date varchar(10),
	measured_td varchar(20),
	measured_pb_depth varchar(20), 
	true_vertical_td varchar(20), 
	true_vertical_pb_depth varchar(20), 
	top_pz_location varchar(30), 
	footage varchar(30), 
	bottom_hole_location varchar(30), 
	footages varchar(30), 
	log_types varchar(1000), 
	created_at timestamp, 
	updated_at timestamp
);

create table objective_formations (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer, 
	sidetrack_id integer, 
	description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

create table planned_casings (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer,
	sidetrack_id integer, 
	casing_description varchar(250),
	cement_description varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

create table completed_casings (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer,
	sidetrack_id integer, 
	casing_description varchar(250),
	cement_description varchar(250),
	is_additional boolean not null default false, 
	created_at timestamp, 
	updated_at timestamp
);

create table completed_formations (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer,
	sidetrack_id integer, 
	formation_name varchar(100), 
	log_top varchar(20), 
	log_bottom varchar(20), 
	cored varchar(30), 
	dst varchar(30), 
	created_at timestamp, 
	updated_at timestamp
);

create table completed_intervals (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer,
	sidetrack_id integer, 
	formation_code varchar(20), 
	status_code varchar(2), 
	status_date varchar(10), 
	first_production_date varchar(10), 
	choke_size varchar(20), 
	open_hole_completion varchar(20), 
	commingled varchar(20), 
	production_method varchar(250), 
	formation_name varchar(50), 
	tubing_size varchar(20), 
	tubing_setting_depth varchar(20), 
	tubing_packer_depth varchar(20), 
	tubing_multiple_packer varchar(20), 
	open_hole_top varchar(20), 
	open_hole_bottom varchar(20), 
	test_date varchar(10), 
	test_method varchar(50), 
	hours_tested varchar(20), 
	test_gas_type varchar(30), 
	gas_disposal varchar(30), 
	bbls_h20 varchar(20), 
	bbls_oil varchar(20), 
	btu_gas varchar(20), 
	calc_bbls_h20 varchar(20), 
	calc_bbls_oil varchar(20), 
	calc_gor varchar(20), 
	calc_mcf_gas varchar(20), 
	casing_press varchar(20), 
	gravity_oil varchar(20), 
	mcf_gas varchar(20), 
	tubing_press varchar(20),
	perf_bottom varchar(20), 
	perf_top varchar(20), 
	perf_holes_number varchar(20), 
	perf_hole_size varchar(20), 
	created_at timestamp, 
	updated_at timestamp
);

create table formation_treatments (
	id serial primary key not null, 
	well_id integer, 
	scout_card_id integer,
	sidetrack_id integer, 
	completed_interval_id integer,
	treatment_type varchar(50), 
	treatment_date varchar(10), 
	treatment_end_date varchar(10), 
	treatment_summary text, 
	total_fluid_used varchar(20), 
	max_pressure varchar(20), 
	total_gas_used varchar(20), 
	fluid_density varchar(20), 
	gas_type varchar(20), 
	staged_intervals varchar(20), 
	total_acid_used varchar(20), 
	max_frac_gradient varchar(20), 
	recycled_water_used varchar(20), 
	total_flowback_recovered varchar(20), 
	produced_water_used varchar(20), 
	flowback_disposition varchar(30), 
	total_proppant_used varchar(20), 
	green_completions varchar(20), 
	no_green_reasons varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

-------------------------------------------------------------------
-------------------------------------------------------------------
-- run ruby script to scrape scout card html
-- //Data/cogcc_query_database/scripts/import/scout_card_html_scrape.rb
-- while true; do ./scout_card_html_scrape.rb & sleep 6; done
-------------------------------------------------------------------
-------------------------------------------------------------------

-- After scrape completed, copy from import schema to staging schema
set search_path to import;
drop table staging.scout_cards;
drop table staging.sidetracks;
drop table staging.objective_formations;
drop table staging.planned_casings;
drop table staging.completed_casings;
drop table staging.completed_formations;
drop table staging.completed_intervals;
drop table staging.formation_treatments;
create table staging.scout_cards as table scout_cards;
create table staging.sidetracks as table sidetracks;
create table staging.objective_formations as table objective_formations;
create table staging.planned_casings as table planned_casings;
create table staging.completed_casings as table completed_casings;
create table staging.completed_formations as table completed_formations;
create table staging.completed_intervals as table completed_intervals;
create table staging.formation_treatments as table formation_treatments;


------------------------------------------------------------
------------------------------------------------------------
------- clean up scripts for scraped scout card data   -----
------------------------------------------------------------
------------------------------------------------------------

---------------------------------------------------------------
----------------------  SCOUT CARDS  --------------------------
---------------------------------------------------------------
set search_path to staging;

select status_date, split_part(status_date, ' ', 1) from scout_cards;
update scout_cards set status_date = split_part(status_date, ' ', 1);
alter table scout_cards alter column status_date type date using status_date::date;

alter table scout_cards alter column lease_number varchar(15);

update scout_cards set job_start_date = null where trim(job_start_date) = '';
alter table scout_cards alter column job_start_date type date using job_start_date::date;

update scout_cards set job_end_date = null where trim(job_end_date) = '';
alter table scout_cards alter column job_end_date type date using job_end_date::date;

alter table scout_cards add column job_prior_to_rule_205 boolean not null default false;
update scout_cards set job_prior_to_rule_205 = 'true' where reported_date = 'Prior to rule 205A.b.(2)(A)';
update scout_cards set reported_date = null where reported_date = 'Prior to rule 205A.b.(2)(A)';
alter table scout_cards alter column reported_date type date using reported_date::date;

update scout_cards set created_at = '2015-08-05 16:49:50.939735' where created_at is null;
update scout_cards set updated_at = '2015-08-05 16:49:50.939735' where updated_at is null;

alter table scout_cards alter column days_to_report type integer using days_to_report::integer;

alter table scout_cards add column is_fracked boolean not null default false;

update scout_cards set is_fracked = 'true' where has_frac_focus_report is true; --9608
update scout_cards set is_fracked = 'true' where is_fracked is false and well_id in (select well_id from formation_treatments where treatment_type = 'FRACTURE STIMULATION'); --78
update scout_cards set is_fracked = 'true' where  is_fracked is false and well_id in (select well_id from formation_treatments where treatment_summary ilike '%frac%fluid%' or treatment_summary ilike '%fluid%frac%' or treatment_summary ilike '%frac%perf%' or treatment_summary ilike '%perf%frac%' or treatment_summary ilike '%frac%sand%' or treatment_summary ilike '%sand%frac%' or treatment_summary ilike '%perf%sand%' or treatment_summary ilike '%sand%perf%' or treatment_summary ilike '%sand%fluid%' or treatment_summary ilike '%fluid%sand%' or treatment_summary ilike '%sand%gal%' or treatment_summary ilike '%gal%sand%' or treatment_summary ilike '%water%sand%' or treatment_summary ilike '%sand%water%' or treatment_summary ilike '%h2o%sand%' or treatment_summary ilike '%sand%h2o%' or treatment_summary ilike '%mesh%sand%' or treatment_summary ilike '%sand%mesh%' or treatment_summary ilike '%sand%slurry%' or treatment_summary ilike '%slurry%sand%' or treatment_summary ilike '%sand%bbl%' or treatment_summary ilike '%bbl%sand%' or treatment_summary ilike '%fw%sand%' or treatment_summary ilike '%sand%fw%' or treatment_summary ilike '%bw%sand%' or treatment_summary ilike '%sand%bw%' or treatment_summary ilike '%#%#%sand%' or treatment_summary ilike '%sand%#%#%' or treatment_summary ilike '%clay%stab%' or treatment_summary ilike '%claytreat%' or treatment_summary ilike '%clayfix%' or treatment_summary ilike '%resin%' or treatment_summary ilike '%proppant%' or treatment_summary ilike '%ottawa%'or treatment_summary ilike '%slick%water%' or treatment_summary ilike '%cross%link%' or treatment_summary ilike '%emulsifrac%' or treatment_summary ilike '%siber%prop%' or treatment_summary ilike '%permstim%' or treatment_summary ilike '%silver%stim%' or treatment_summary ilike '%vistar%' or treatment_summary ilike '%x-linked%' or treatment_summary ilike '%gel%fluid%' or treatment_summary ilike '%fluid%gel%' or treatment_summary ilike '%gel%water%' or treatment_summary ilike '%water%gel%' or treatment_summary ilike '%gel%agent%' or treatment_summary ilike '%agent%gel%' or treatment_summary ilike '%gel%sand%' or treatment_summary ilike '%sand%gel%'); --28767

-- 38453 frac'd wells
has_frac_focus_report = 'true' or treatment_type = 'FRACTURE STIMULATION' 
or treatment_summary ilike '%frac%fluid%' or treatment_summary ilike '%fluid%frac%' 
or treatment_summary ilike '%frac%perf%' or treatment_summary ilike '%perf%frac%' 
or treatment_summary ilike '%frac%sand%' or treatment_summary ilike '%sand%frac%' 
or treatment_summary ilike '%perf%sand%' or treatment_summary ilike '%sand%perf%' 
or treatment_summary ilike '%sand%fluid%' or treatment_summary ilike '%fluid%sand%' 
or treatment_summary ilike '%sand%gal%' or treatment_summary ilike '%gal%sand%' 
or treatment_summary ilike '%water%sand%' or treatment_summary ilike '%sand%water%' 
or treatment_summary ilike '%h2o%sand%' or treatment_summary ilike '%sand%h2o%' 
or treatment_summary ilike '%mesh%sand%' or treatment_summary ilike '%sand%mesh%' 
or treatment_summary ilike '%sand%slurry%' or treatment_summary ilike '%slurry%sand%' 
or treatment_summary ilike '%sand%bbl%' or treatment_summary ilike '%bbl%sand%' 
or treatment_summary ilike '%fw%sand%' or treatment_summary ilike '%sand%fw%' 
or treatment_summary ilike '%bw%sand%' or treatment_summary ilike '%sand%bw%' 
or treatment_summary ilike '%#%#%sand%' or treatment_summary ilike '%sand%#%#%' 
or treatment_summary ilike '%clay%stab%' or treatment_summary ilike '%claytreat%' 
or treatment_summary ilike '%clayfix%' or treatment_summary ilike '%resin%' 
or treatment_summary ilike '%proppant%' or treatment_summary ilike '%ottawa%'
or treatment_summary ilike '%slick%water%' or treatment_summary ilike '%cross%link%' 
or treatment_summary ilike '%emulsifrac%' or treatment_summary ilike '%siber%prop%' 
or treatment_summary ilike '%permstim%' or treatment_summary ilike '%silver%stim%' 
or treatment_summary ilike '%vistar%' or treatment_summary ilike '%x-linked%' 
or treatment_summary ilike '%gel%fluid%' or treatment_summary ilike '%fluid%gel%' 
or treatment_summary ilike '%gel%water%' or treatment_summary ilike '%water%gel%' 
or treatment_summary ilike '%gel%agent%' or treatment_summary ilike '%agent%gel%' 
or treatment_summary ilike '%gel%sand%' or treatment_summary ilike '%sand%gel%';


alter table scout_cards add column is_horizontal boolean not null default false;

update scout_cards set is_horizontal = 'true' where well_id in (select well_id from sidetracks where trim(upper(wellbore_permit)) = 'HORIZONTAL'); --8096
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from directional_bottomholes where trim(upper(deviation_)) = 'HORIZONTAL'); --7
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from wells where well_num ilike '%hz%') and well_id in (select well_id from sidetracks where wellbore_permit is null); --6
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from wells where well_num ilike '%hn%') and well_id in (select well_id from sidetracks where wellbore_permit is null); --6
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from wells where well_num ilike '%hc%') and well_id in (select well_id from sidetracks where wellbore_permit is null); --4
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from wells where well_num ilike '%-h%') and well_id in (select well_id from sidetracks where wellbore_permit is null); --6
update scout_cards set is_horizontal = 'true' where is_horizontal is false and well_id in (select well_id from wells where well_num like '%1H%' or well_num like '%2H%' or well_num like '%3H%' or well_num like '%4H%' or well_num like '%5H%' or well_num like '%6H%' or well_num like '%7H%' or well_num like '%8H%' or well_num like '%9H%' or well_num like '%0H%') and well_id in (select well_id from sidetracks where wellbore_permit is null); --133

select count(*) from scout_cards where is_horizontal is true; --8258

-- roll scout card data into wells table export (SEE ABOVE)



---------------------------------------------------------------
-----------------------  SIDE TRACKS  -------------------------
---------------------------------------------------------------
set search_path to staging;

-- fix status_code and status_date
alter table sidetracks add column status_string varchar(30);
update sidetracks set status_string = status_code;

-- update status_code
select left(status_string,2) from sidetracks where left(status_string,2) ~ '[a-zA-Z]'; 
update sidetracks set status_code = left(status_string,2) where left(status_string,2) ~ '[a-zA-Z]';
update sidetracks set status_code = null where length(status_code) > 2; --0
update sidetracks set status_code = null where trim(status_code) = ''; --0
alter table sidetracks alter column status_code type varchar(2);

-- update status_date
select regexp_replace(status_string, '[a-zA-Z]', '', 'g') from sidetracks order by length(status_string);
update sidetracks set status_date = trim(regexp_replace(status_string, '[a-zA-Z]', '', 'g'));
update sidetracks set status_date = null where status_date = '/'; --31
alter table sidetracks alter column status_date type date using status_date::date;

update sidetracks set spud_date = null where spud_date = 'N/A'; --1
alter table sidetracks alter column spud_date type date using spud_date::date;

update sidetracks set spud_date_type = upper(trim(spud_date_type));
update sidetracks set spud_date_type = null where spud_date_type = '';
alter table sidetracks alter column spud_date_type type varchar(10);

update sidetracks set wellbore_permit = upper(trim(wellbore_permit));
update sidetracks set wellbore_permit = null where wellbore_permit = '';
alter table sidetracks alter column wellbore_permit type varchar(11);

update sidetracks set permit_number = trim(permit_number);
update sidetracks set permit_number = null where permit_number = ''; --24560
alter table sidetracks alter column permit_number type varchar(10);

select permit_expiration_date, split_part(permit_expiration_date, ' ', 1) from sidetracks;
update sidetracks set permit_expiration_date = split_part(permit_expiration_date, ' ', 1);
update sidetracks set permit_expiration_date = null where permit_expiration_date = ''; --261
alter table sidetracks alter column permit_expiration_date type date using permit_expiration_date::date;

update sidetracks set prop_depth_form = null where prop_depth_form = ''; --18418
alter table sidetracks alter column prop_depth_form type integer using prop_depth_form::integer;

update sidetracks set surface_mineral_owner_same = trim(surface_mineral_owner_same);
update sidetracks set surface_mineral_owner_same = null where surface_mineral_owner_same = ''; --50668
update sidetracks set surface_mineral_owner_same = 'N/A' where surface_mineral_owner_same = 'not available'; --321
alter table sidetracks alter column surface_mineral_owner_same type varchar(3);

update sidetracks set mineral_owner = trim(mineral_owner);
update sidetracks set mineral_owner = null where mineral_owner = ''; --195
update sidetracks set mineral_owner = 'N/A' where mineral_owner = 'not available'; --321
alter table sidetracks alter column mineral_owner type varchar(7);

update sidetracks set surface_owner = trim(surface_owner);
update sidetracks set surface_owner = null where surface_owner = ''; --42088
update sidetracks set surface_owner = null where surface_owner = '0'; --1
update sidetracks set surface_owner = 'N/A' where surface_owner = 'not available'; --321
alter table sidetracks alter column surface_owner type varchar(7);

update sidetracks set unit = upper(trim(unit));
update sidetracks set unit = null where unit = ''; --101720
alter table sidetracks alter column unit type varchar(31);

update sidetracks set unit_number = upper(trim(unit_number));
update sidetracks set unit_number = null where unit_number = ''; --99365
update sidetracks set unit_number = null where unit_number = "\"; --1
update sidetracks set unit_number = 'N/A' where unit_number = 'NA'; --47
update sidetracks set unit_number = 'N/A' where unit_number = 'N. A.'; --1
alter table sidetracks alter column unit_number type varchar(14);

update sidetracks set completion_date = null where completion_date = 'N/A'; --25408
alter table sidetracks alter column completion_date type date using completion_date::date;

update sidetracks set measured_td = null where measured_td = ''; --23596
alter table sidetracks alter column measured_td type integer using measured_td::integer;

update sidetracks set measured_pb_depth = null where measured_pb_depth = ''; --33975
alter table sidetracks alter column measured_pb_depth type integer using measured_pb_depth::integer;

update sidetracks set true_vertical_td = null where true_vertical_td = ''; --54017
alter table sidetracks alter column true_vertical_td type integer using true_vertical_td::integer;

update sidetracks set true_vertical_pb_depth = null where true_vertical_pb_depth = ''; --89603
alter table sidetracks alter column true_vertical_pb_depth type integer using true_vertical_pb_depth::integer;

-- top_pz_location not scraped correctly!!  ADD NOTE TO WEBPAGE - fix for next scrape.
update sidetracks set top_pz_location = null;
 
update sidetracks set footage = upper(trim(footage));
update sidetracks set footage = null where footage = ''; --0
update sidetracks set footage = null where footage = 'FSL   FWL'; --1
update sidetracks set footage = null where footage = 'FSL   FEL'; --1
update sidetracks set footage = null where footage = 'FNL   FWL'; --2
update sidetracks set footage = null where footage = 'FNL   FEL'; --1
update sidetracks set footage = null where footage = 'FL   FL'; --1069

update sidetracks set footages = upper(trim(footages));
update sidetracks set footages = null where footages = ''; --0
update sidetracks set footages = null where footages = 'FSL   FWL'; --18
update sidetracks set footages = null where footages = 'FSL   FEL'; --6
update sidetracks set footages = null where footages = 'FNL   FWL'; --8
update sidetracks set footages = null where footages = 'FNL   FEL'; --12
update sidetracks set footages = null where footages = 'FNL   FFWLL'; --1
update sidetracks set footages = null where footages = 'FL   FL'; --1185

update sidetracks set log_types = upper(trim(log_types));
update sidetracks set log_types = null where log_types = ''; --991
alter table sidetracks alter column log_types type varchar(800);

set search_path to staging;
COPY (select id, well_id, sidetrack_number, status_code, status_date, spud_date, spud_date_type, wellbore_permit, completion_date, log_types, measured_td, measured_pb_depth, true_vertical_td, true_vertical_pb_depth, permit_number, permit_expiration_date, prop_depth_form, surface_mineral_owner_same, mineral_owner, surface_owner, unit, unit_number, null as top_pz_location, footage, bottom_hole_location, footages, created_at, updated_at from sidetracks order by well_id, sidetrack_number) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/sidetracks.csv' WITH CSV;

set search_path to public;
create table backup.sidetracks as table sidetracks;
drop table sidetracks;
create table sidetracks (
	id integer, 
	well_id integer, 
	sidetrack_number varchar(2), 
	status_code varchar(2), 
	status_date date, 
	spud_date date, 
	spud_date_type varchar(10),
	wellbore_permit varchar(11),
	completion_date date,
	log_types varchar(800), 
	measured_td integer,
	measured_pb_depth integer, 
	true_vertical_td integer, 
	true_vertical_pb_depth integer, 
	permit_number varchar(10), 
	permit_expiration_date date, 
	prop_depth_form integer, 
	surface_mineral_owner_same varchar(3),
	mineral_owner varchar(7),
	surface_owner varchar(7), 
	unit varchar(31), 
	unit_number varchar(14), 
	top_pz_location varchar(30), 
	footage varchar(30), 
	bottom_hole_location varchar(30), 
	footages varchar(30), 
	created_at timestamp, 
	updated_at timestamp
);

copy sidetracks from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/sidetracks.csv' (format csv, delimiter ',', null '');

alter table sidetracks add primary key (id);

create index index_sidetracks_on_well_id on sidetracks (well_id);
create index index_sidetracks_on_status_code on sidetracks (status_code);
create index index_sidetracks_on_wellbore_permit on sidetracks (wellbore_permit);



-------------------------------------------------------------
-----------------  OBJECTIVE FORMATIONS  ----------------------
---------------------------------------------------------------
set search_path to staging;

select distinct upper(trim(split_part(split_part(description, 'Code:', 2), ',', 1))) from objective_formations;
alter table objective_formations add column formation_code varchar(5);
update objective_formations set formation_code = upper(trim(split_part(split_part(description, 'Code:', 2), ',', 1)));

select distinct upper(trim(split_part(split_part(description, 'Formation:', 2), ',', 1))) from objective_formations;
alter table objective_formations add column formation_name varchar(50);
update objective_formations set formation_name = upper(trim(split_part(split_part(description, 'Formation:', 2), ',', 1)));

select distinct upper(trim(split_part(split_part(description, 'Order:', 2), ',', 1))) from objective_formations;
alter table objective_formations add column order_detail varchar(10);
update objective_formations set order_detail = upper(trim(split_part(split_part(description, 'Order:', 2), ',', 1)));
update objective_formations set order_detail = null where order_detail = '.'; --1
update objective_formations set order_detail = null where order_detail = '`'; --1
update objective_formations set order_detail = '139-53' where order_detail = '`139-53'; --1
update objective_formations set order_detail = '191-8' where order_detail = '`191-8'; --1
update objective_formations set order_detail = null where order_detail = '='; --2
update objective_formations set order_detail = null where order_detail = '?'; --3
update objective_formations set order_detail = 'N/A' where order_detail = 'NA'; --203
update objective_formations set order_detail = 'UNSPACED' where order_detail = 'UN-SPACED'; --4
update objective_formations set order_detail = 'UNSPACED' where order_detail = 'UNPSACED'; --1
update objective_formations set order_detail = 'UNSPACED' where order_detail = 'UNSOACED'; --1
update objective_formations set order_detail = 'UNSPACED' where order_detail = 'UNSPASED'; --1
update objective_formations set order_detail = 'UNMAPPED' where order_detail = 'NMAPPED'; --1
update objective_formations set order_detail = 'STATEWIDE' where order_detail = 'STATE WIDE'; --2

select distinct trim(split_part(split_part(description, 'Unit Acreage:', 2), ',', 1)) from objective_formations;
alter table objective_formations add column unit_acreage varchar(10);
update objective_formations set unit_acreage = trim(split_part(split_part(description, 'Unit Acreage:', 2), ',', 1));
update objective_formations set unit_acreage = null where unit_acreage = ''; --38649
alter table objective_formations alter column unit_acreage type integer using unit_acreage::integer;

select distinct upper(trim(split_part(split_part(description, 'Drill Unit:', 2), ',', 1))) from objective_formations;
alter table objective_formations add column drill_unit varchar(20);
update objective_formations set drill_unit = upper(trim(split_part(split_part(description, 'Drill Unit:', 2), ',', 1)));

set search_path to staging;
COPY (select id, well_id, sidetrack_id, formation_code, formation_name, order_detail, unit_acreage, drill_unit, created_at, updated_at from objective_formations order by well_id, sidetrack_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/objective_formations.csv' WITH CSV;


set search_path to public;
create table backup.objective_formations as table objective_formations;
drop table objective_formations;
create table objective_formations (
	id integer, 
	well_id integer, 
	sidetrack_id integer, 
	formation_code varchar(5), 
	formation_name varchar(50), 
	order_detail varchar(10), 
	unit_acreage integer, 
	drill_unit varchar(20), 
	created_at timestamp, 
	updated_at timestamp
);

copy objective_formations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/objective_formations.csv' (format csv, delimiter ',', null '');

alter table objective_formations add primary key (id);

create index index_objective_formations_on_well_id on objective_formations (well_id);
create index index_objective_formations_on_sidetrack_id on objective_formations (sidetrack_id);
create index index_objective_formations_on_formation_code on objective_formations (formation_code);



---------------------------------------------------------------
--------------------  PLANNED CASINGS  ------------------------
---------------------------------------------------------------
set search_path to staging;

select distinct upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1))) from planned_casings;
alter table planned_casings add column casing_string_type varchar(10);
update planned_casings set casing_string_type = upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1)));

select distinct trim(split_part(split_part(casing_description, 'Hole Size:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column casing_hole_size varchar(8);
update planned_casings set casing_hole_size = trim(split_part(split_part(casing_description, 'Hole Size:', 2), ',', 1));
update planned_casings set casing_hole_size = null where casing_hole_size = ''; --3238

select distinct trim(split_part(split_part(casing_description, ', Size:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column casing_size varchar(8);
update planned_casings set casing_size = trim(split_part(split_part(casing_description, ', Size:', 2), ',', 1));
update planned_casings set casing_size = null where casing_size = ''; --3383

select distinct trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column casing_top varchar(10);
update planned_casings set casing_top = trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1));
update planned_casings set casing_top = null where casing_top = ''; --41724
alter table planned_casings alter column casing_top type integer using casing_top::integer;

select distinct trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column casing_depth varchar(10);
update planned_casings set casing_depth = trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1));
update planned_casings set casing_depth = null where casing_depth = ''; --1006
alter table planned_casings alter column casing_depth type integer using casing_depth::integer;

select distinct upper(trim(split_part(split_part(casing_description, 'Weight:', 2), ',', 1))) from planned_casings;
alter table planned_casings add column casing_weight varchar(10);
update planned_casings set casing_weight = upper(trim(split_part(split_part(casing_description, 'Weight:', 2), ',', 1)));

select distinct trim(split_part(split_part(cement_description, 'Sacks:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column cement_sacks varchar(10);
update planned_casings set cement_sacks = trim(split_part(split_part(cement_description, 'Sacks:', 2), ',', 1));
update planned_casings set cement_sacks = null where cement_sacks = ''; --10970
alter table planned_casings alter column cement_sacks type integer using cement_sacks::integer;

select distinct trim(split_part(split_part(cement_description, 'Top:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column cement_top varchar(10);
update planned_casings set cement_top = trim(split_part(split_part(cement_description, 'Top:', 2), ',', 1));
update planned_casings set cement_top = null where cement_top = ''; --19322
alter table planned_casings alter column cement_top type integer using cement_top::integer;

select distinct trim(split_part(split_part(cement_description, 'Bottom:', 2), ',', 1)) from planned_casings;
alter table planned_casings add column cement_bottom varchar(10);
update planned_casings set cement_bottom = trim(split_part(split_part(cement_description, 'Bottom:', 2), ',', 1));
update planned_casings set cement_bottom = null where cement_bottom = ''; --8999
alter table planned_casings alter column cement_bottom type integer using cement_bottom::integer;

select distinct upper(trim(split_part(split_part(cement_description, 'Method Grade:', 2), ',', 1))) from planned_casings;
alter table planned_casings add column cement_method_grade varchar(4);
update planned_casings set cement_method_grade = upper(trim(split_part(split_part(cement_description, 'Method Grade:', 2), ',', 1)));
update planned_casings set cement_method_grade = null where cement_method_grade = ''; --93801


set search_path to staging;
COPY (select id, well_id, sidetrack_id, casing_string_type, casing_hole_size, casing_size, casing_top, casing_depth, casing_weight, cement_sacks, cement_top, cement_bottom, cement_method_grade, created_at, updated_at from planned_casings order by well_id, sidetrack_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/planned_casings.csv' WITH CSV;

set search_path to public;
create table backup.planned_casings as table planned_casings;
drop table planned_casings;
create table planned_casings (
	id integer, 
	well_id integer, 
	sidetrack_id integer, 
	casing_string_type varchar(10), 
	casing_hole_size varchar(8), 
	casing_size varchar(8), 
	casing_top integer, 
	casing_depth integer, 
	casing_weight varchar(10), 
	cement_sacks integer, 
	cement_top integer, 
	cement_bottom integer, 
	cement_method_grade varchar(4), 
	created_at timestamp, 
	updated_at timestamp
);

copy planned_casings from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/planned_casings.csv' (format csv, delimiter ',', null '');

alter table planned_casings add primary key (id);

create index index_planned_casings_on_well_id on planned_casings (well_id);
create index index_planned_casings_on_sidetrack_id on planned_casings (sidetrack_id);



---------------------------------------------------------------
-------------------  COMPLETED CASINGS  -----------------------
---------------------------------------------------------------
set search_path to staging;

-- is additional is false
select distinct upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1))) from completed_casings where is_additional is false;
alter table completed_casings add column casing_string_type varchar(10);
update completed_casings set casing_string_type = upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1))) where is_additional is false;

select distinct trim(split_part(split_part(casing_description, 'Hole Size:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column casing_hole_size varchar(8);
update completed_casings set casing_hole_size = trim(split_part(split_part(casing_description, 'Hole Size:', 2), ',', 1)) where is_additional is false;
update completed_casings set casing_hole_size = null where casing_hole_size = '' and is_additional is false; --27459

select distinct trim(split_part(split_part(casing_description, ', Size:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column casing_size varchar(8);
update completed_casings set casing_size = trim(split_part(split_part(casing_description, ', Size:', 2), ',', 1)) where is_additional is false;
update completed_casings set casing_size = null where casing_size = '' and is_additional is false; --8079

select distinct trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column casing_top varchar(10);
update completed_casings set casing_top = trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1)) where is_additional is false;
update completed_casings set casing_top = null where casing_top = '' and is_additional is false; --42106
alter table completed_casings alter column casing_top type integer using casing_top::integer;

select distinct trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column casing_depth varchar(10);
update completed_casings set casing_depth = trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1)) where is_additional is false;
update completed_casings set casing_depth = null where casing_depth = '' and is_additional is false; --3483
alter table completed_casings alter column casing_depth type integer using casing_depth::integer;

select distinct upper(trim(split_part(split_part(casing_description, 'Weight:', 2), ',', 1))) from completed_casings where is_additional is false;
alter table completed_casings add column casing_weight varchar(10);
update completed_casings set casing_weight = upper(trim(split_part(split_part(casing_description, 'Weight:', 2), ',', 1))) where is_additional is false;

select distinct trim(split_part(split_part(cement_description, 'Sacks:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column cement_sacks varchar(10);
update completed_casings set cement_sacks = trim(split_part(split_part(cement_description, 'Sacks:', 2), ',', 1)) where is_additional is false;
update completed_casings set cement_sacks = null where cement_sacks = '' and is_additional is false; --11153

select distinct trim(split_part(split_part(cement_description, 'Top:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column cement_top varchar(10);
update completed_casings set cement_top = trim(split_part(split_part(cement_description, 'Top:', 2), ',', 1)) where is_additional is false;
update completed_casings set cement_top = null where cement_top = '' and is_additional is false; --30571

select distinct trim(split_part(split_part(cement_description, 'Bottom:', 2), ',', 1)) from completed_casings where is_additional is false;
alter table completed_casings add column cement_bottom varchar(10);
update completed_casings set cement_bottom = trim(split_part(split_part(cement_description, 'Bottom:', 2), ',', 1)) where is_additional is false;
update completed_casings set cement_bottom = null where cement_bottom = '' and is_additional is false; --77187

select distinct upper(trim(split_part(split_part(cement_description, 'Method Grade:', 2), ',', 1))) from completed_casings where is_additional is false;
alter table completed_casings add column cement_method_grade varchar(18);
update completed_casings set cement_method_grade = upper(trim(split_part(split_part(cement_description, 'Method Grade:', 2), ',', 1))) where is_additional is false;
update completed_casings set cement_method_grade = null where cement_method_grade = '' and is_additional is false; --90680


-- is additional is true
select distinct upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1))) from completed_casings where is_additional is true;
update completed_casings set casing_string_type = upper(trim(split_part(split_part(casing_description, 'String Type:', 2), ',', 1))) where is_additional is true; --5263

select distinct trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1)) from completed_casings where is_additional is true;
update completed_casings set cement_top = trim(split_part(split_part(casing_description, 'Top:', 2), ',', 1)) where is_additional is true;
update completed_casings set cement_top = null where cement_top = '' and is_additional is true; --240
alter table completed_casings alter column cement_top type integer using cement_top::integer;

select distinct trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1)) from completed_casings where is_additional is true;
alter table completed_casings add column cement_depth varchar(10);
update completed_casings set cement_depth = trim(split_part(split_part(casing_description, 'Depth:', 2), ',', 1)) where is_additional is true;
update completed_casings set cement_depth = null where cement_depth = '' and is_additional is true; --1165
alter table completed_casings alter column cement_depth type integer using cement_depth::integer;

select distinct trim(split_part(split_part(casing_description, 'Bottom:', 2), ',', 1)) from completed_casings where is_additional is true;
update completed_casings set cement_bottom = trim(split_part(split_part(casing_description, 'Bottom:', 2), ',', 1)) where is_additional is true;
update completed_casings set cement_bottom = null where cement_bottom = '' and is_additional is true; --213
alter table completed_casings alter column cement_bottom type integer using cement_bottom::integer;

select distinct trim(split_part(split_part(casing_description, 'Sacks:', 2), ',', 1)) from completed_casings where is_additional is true;
update completed_casings set cement_sacks = trim(split_part(split_part(casing_description, 'Sacks:', 2), ',', 1)) where is_additional is true;
update completed_casings set cement_sacks = null where cement_sacks = '' and is_additional is true; --95
alter table completed_casings alter column cement_sacks type integer using cement_sacks::integer;

select distinct upper(trim(split_part(split_part(casing_description, 'Method Grade:', 2), ',', 1))) from completed_casings where is_additional is true;
update completed_casings set cement_method_grade = upper(trim(split_part(split_part(casing_description, 'Method Grade:', 2), ',', 1))) where is_additional is true;
update completed_casings set cement_method_grade = null where cement_method_grade = '' and is_additional is true; --1159


set search_path to staging;
COPY (select id, well_id, sidetrack_id, casing_string_type, casing_hole_size, casing_size, casing_top, casing_depth, casing_weight, cement_sacks, cement_top, cement_bottom, cement_method_grade, cement_depth, is_additional, created_at, updated_at from completed_casings order by well_id, sidetrack_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_casings.csv' WITH CSV;

set search_path to public;
create table backup.completed_casings as table completed_casings;
drop table completed_casings;
create table completed_casings (
	id integer, 
	well_id integer, 
	sidetrack_id integer, 
	casing_string_type varchar(10), 
	casing_hole_size varchar(8), 
	casing_size varchar(8), 
	casing_top integer, 
	casing_depth integer, 
	casing_weight varchar(10), 
	cement_sacks integer, 
	cement_top integer, 
	cement_bottom integer, 
	cement_method_grade varchar(18), 
	cement_depth integer, 
	is_additional_cement boolean, 
	created_at timestamp, 
	updated_at timestamp
);

copy completed_casings from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_casings.csv' (format csv, delimiter ',', null '');

alter table completed_casings add primary key (id);

create index index_completed_casings_on_well_id on completed_casings (well_id);
create index index_completed_casings_on_sidetrack_id on completed_casings (sidetrack_id);
create index index_completed_casings_on_casing_string_type on completed_casings (casing_string_type);



---------------------------------------------------------------
-----------------  COMPLETED FORMATIONS  ----------------------
---------------------------------------------------------------
set search_path to staging;

update completed_formations set formation_name = upper(trim(formation_name));
alter table completed_formations alter column formation_name type varchar(30);

update completed_formations set log_top = trim(log_top);
update completed_formations set log_top = null where log_top = ''; --612
alter table completed_formations alter column log_top type integer using log_top::integer;

update completed_formations set log_bottom = trim(log_bottom);
update completed_formations set log_bottom = null where log_bottom = ''; --334151
alter table completed_formations alter column log_bottom type integer using log_bottom::integer;

update completed_formations set cored = trim(cored);
update completed_formations set cored = null where cored = ''; --227985
alter table completed_formations alter column cored type varchar(1);

update completed_formations set dst = trim(dst);
update completed_formations set dst = null where dst = ''; --234073
alter table completed_formations alter column dst type boolean using dst::boolean;


set search_path to staging;
COPY (select id, well_id, sidetrack_id, formation_name, log_top, log_bottom, cored, dst, created_at, updated_at from completed_formations order by well_id, sidetrack_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_formations.csv' WITH CSV;

set search_path to public;
create table backup.completed_formations as table completed_formations;
drop table completed_formations;
create table completed_formations (
	id integer, 
	well_id integer, 
	sidetrack_id integer, 
	formation_name varchar(30), 
	log_top integer, 
	log_bottom integer, 
	cored varchar(1), 
	dst boolean, 
	created_at timestamp, 
	updated_at timestamp
);

copy completed_formations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_formations.csv' (format csv, delimiter ',', null '');

alter table completed_formations add primary key (id);

create index index_completed_formations_on_well_id on completed_formations (well_id);
create index index_completed_formations_on_sidetrack_id on completed_formations (sidetrack_id);



---------------------------------------------------------------
------------------  COMPLETED INTERVALS  ----------------------
---------------------------------------------------------------
set search_path to staging;

update completed_intervals set formation_code = upper(trim(formation_code));
alter table completed_intervals alter column formation_code type varchar(6);

update completed_intervals set status_code = upper(trim(status_code));
select count(*) from completed_intervals where status_code ilike '%/%';
update completed_intervals set status_code = null where status_code ilike '%/%'; --690

update completed_intervals set status_date = null where status_date = 'N/A'; --514
alter table completed_intervals alter column status_date type date using status_date::date;

update completed_intervals set first_production_date = null where first_production_date = 'N/A'; --36133
alter table completed_intervals alter column first_production_date type date using first_production_date::date;

update completed_intervals set choke_size = trim(choke_size);
update completed_intervals set choke_size = null where choke_size = ''; --59417
alter table completed_intervals alter column choke_size type varchar(10);

update completed_intervals set open_hole_completion = trim(open_hole_completion);
update completed_intervals set open_hole_completion = null where open_hole_completion = ''; --50566
alter table completed_intervals alter column open_hole_completion type boolean using open_hole_completion::boolean;

update completed_intervals set commingled = upper(trim(commingled));
update completed_intervals set commingled = null where commingled = ''; --39153
alter table completed_intervals alter column commingled type boolean using commingled::boolean;

update completed_intervals set production_method = upper(trim(production_method));
update completed_intervals set production_method = null where production_method = ''; --81774
alter table completed_intervals alter column production_method type varchar(150);

update completed_intervals set formation_name = upper(trim(formation_name));

update completed_intervals set tubing_size = trim(tubing_size);
update completed_intervals set tubing_size = null where tubing_size = ''; --61579
alter table completed_intervals alter column tubing_size type varchar(12);

update completed_intervals set tubing_setting_depth = trim(tubing_setting_depth);
update completed_intervals set tubing_setting_depth = null where tubing_setting_depth = ''; --62159
alter table completed_intervals alter column tubing_setting_depth type integer using tubing_setting_depth::integer;

update completed_intervals set tubing_packer_depth = trim(tubing_packer_depth);
update completed_intervals set tubing_packer_depth = null where tubing_packer_depth = ''; --106153
alter table completed_intervals alter column tubing_packer_depth type integer using tubing_packer_depth::integer;

update completed_intervals set tubing_multiple_packer = trim(tubing_multiple_packer);
update completed_intervals set tubing_multiple_packer = null where tubing_multiple_packer = ''; --110359
alter table completed_intervals alter column tubing_multiple_packer type boolean using tubing_multiple_packer::boolean;

update completed_intervals set open_hole_top = trim(open_hole_top);
update completed_intervals set open_hole_top = null where open_hole_top = ''; --109981
alter table completed_intervals alter column open_hole_top type integer using open_hole_top::integer;

update completed_intervals set open_hole_bottom = trim(open_hole_bottom);
update completed_intervals set open_hole_bottom = null where open_hole_bottom = ''; --109982
alter table completed_intervals alter column open_hole_bottom type integer using open_hole_bottom::integer;

update completed_intervals set test_date = null where test_date = 'N/A'; --6079
alter table completed_intervals alter column test_date type date using test_date::date;

update completed_intervals set test_method = upper(trim(test_method));
update completed_intervals set test_method = null where test_method = ''; --6635
alter table completed_intervals alter column test_method type varchar(15);

update completed_intervals set hours_tested = trim(hours_tested);
update completed_intervals set hours_tested = null where hours_tested = ''; --9869
alter table completed_intervals alter column hours_tested type varchar(10);

update completed_intervals set test_gas_type = upper(trim(test_gas_type));
update completed_intervals set test_gas_type = null where test_gas_type = ''; --25892
alter table completed_intervals alter column test_gas_type type varchar(10);

update completed_intervals set gas_disposal = upper(trim(gas_disposal));
update completed_intervals set gas_disposal = null where gas_disposal = ''; --16943
alter table completed_intervals alter column gas_disposal type varchar(11);

update completed_intervals set bbls_h20 = trim(bbls_h20);
update completed_intervals set bbls_h20 = null where bbls_h20 = ''; --2
alter table completed_intervals alter column bbls_h20 type varchar(10);

update completed_intervals set bbls_oil = trim(bbls_oil);
update completed_intervals set bbls_oil = null where bbls_oil = ''; --3
alter table completed_intervals alter column bbls_oil type varchar(10);

update completed_intervals set btu_gas = trim(btu_gas);
update completed_intervals set btu_gas = null where btu_gas = ''; --2
alter table completed_intervals alter column btu_gas type varchar(10);

update completed_intervals set calc_bbls_h20 = trim(calc_bbls_h20);
update completed_intervals set calc_bbls_h20 = null where calc_bbls_h20 = ''; --1
alter table completed_intervals alter column calc_bbls_h20 type varchar(10);

update completed_intervals set calc_bbls_oil = trim(calc_bbls_oil);
update completed_intervals set calc_bbls_oil = null where calc_bbls_oil = ''; --0
alter table completed_intervals alter column calc_bbls_oil type varchar(10);

update completed_intervals set calc_gor = trim(calc_gor);
update completed_intervals set calc_gor = null where calc_gor = ''; --2
alter table completed_intervals alter column calc_gor type varchar(10);

update completed_intervals set calc_mcf_gas = trim(calc_mcf_gas);
update completed_intervals set calc_mcf_gas = null where calc_mcf_gas = ''; --1
alter table completed_intervals alter column calc_mcf_gas type varchar(10);

update completed_intervals set casing_press = trim(casing_press);
update completed_intervals set casing_press = null where casing_press = ''; --2
alter table completed_intervals alter column casing_press type varchar(10);

update completed_intervals set gravity_oil = trim(gravity_oil);
update completed_intervals set gravity_oil = null where gravity_oil = ''; --1
alter table completed_intervals alter column gravity_oil type varchar(10);

update completed_intervals set mcf_gas = trim(mcf_gas);
update completed_intervals set mcf_gas = null where mcf_gas = ''; --2
alter table completed_intervals alter column mcf_gas type varchar(10);

update completed_intervals set tubing_press = trim(tubing_press);
update completed_intervals set tubing_press = null where tubing_press = ''; --5
alter table completed_intervals alter column tubing_press type varchar(10);

update completed_intervals set perf_bottom = trim(perf_bottom);
update completed_intervals set perf_bottom = null where perf_bottom = ''; --1214
alter table completed_intervals alter column perf_bottom type integer using perf_bottom::integer;

update completed_intervals set perf_top = trim(perf_top);
update completed_intervals set perf_top = null where perf_top = ''; --1166
alter table completed_intervals alter column perf_top type integer using perf_top::integer;

update completed_intervals set perf_holes_number = trim(perf_holes_number);
update completed_intervals set perf_holes_number = null where perf_holes_number = ''; --9894
alter table completed_intervals alter column perf_holes_number type integer using perf_holes_number::integer;

update completed_intervals set perf_hole_size = trim(perf_hole_size);
update completed_intervals set perf_hole_size = null where perf_hole_size = ''; --29739
alter table completed_intervals alter column perf_hole_size type varchar(10);


set search_path to staging;
COPY (select id, well_id, sidetrack_id, formation_code, formation_name, status_code, status_date, first_production_date, choke_size, open_hole_completion, commingled, production_method, perf_bottom, perf_top, perf_holes_number, perf_hole_size, tubing_size, tubing_setting_depth, tubing_packer_depth, tubing_multiple_packer, open_hole_top, open_hole_bottom, test_date, test_method, hours_tested, test_gas_type, gas_disposal, bbls_h20, bbls_oil, btu_gas, calc_bbls_h20, calc_bbls_oil, calc_gor, calc_mcf_gas, casing_press, gravity_oil, mcf_gas, tubing_press, created_at, updated_at from completed_intervals order by well_id, sidetrack_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_intervals.csv' WITH CSV;

set search_path to public;
create table backup.completed_intervals as table completed_intervals;
drop table completed_intervals;
create table completed_intervals (
	id integer, 
	well_id integer, 
	sidetrack_id integer, 
	formation_code varchar(6), 
	formation_name varchar(50),
	status_code varchar(2), 
	status_date date, 
	first_production_date date, 
	choke_size varchar(10), 
	open_hole_completion boolean, 
	commingled boolean, 
	production_method varchar(150), 
	perf_bottom integer, 
	perf_top integer, 
	perf_holes_number integer, 
	perf_hole_size varchar(10),
	tubing_size varchar(12), 
	tubing_setting_depth integer, 
	tubing_packer_depth integer, 
	tubing_multiple_packer boolean, 
	open_hole_top integer, 
	open_hole_bottom integer, 
	test_date date, 
	test_method varchar(15), 
	hours_tested varchar(10), 
	test_gas_type varchar(10), 
	gas_disposal varchar(11), 
	bbls_h20 varchar(10), 
	bbls_oil varchar(10), 
	btu_gas varchar(10), 
	calc_bbls_h20 varchar(10), 
	calc_bbls_oil varchar(10), 
	calc_gor varchar(10), 
	calc_mcf_gas varchar(10), 
	casing_press varchar(10), 
	gravity_oil varchar(10), 
	mcf_gas varchar(10), 
	tubing_press varchar(10),
	created_at timestamp, 
	updated_at timestamp
);

copy completed_intervals from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/completed_intervals.csv' (format csv, delimiter ',', null '');

alter table completed_intervals add primary key (id);

create index index_completed_intervals_on_well_id on completed_intervals (well_id);
create index index_completed_intervals_on_sidetrack_id on completed_intervals (sidetrack_id);
create index index_completed_intervals_on_status_code on completed_intervals (status_code);



-------------------------------------------------------------
-----------------  FORMATION TREATMENTS  ----------------------
---------------------------------------------------------------
set search_path to staging;

update formation_treatments set treatment_type = upper(trim(treatment_type));
update formation_treatments set treatment_type = null where treatment_type = ''; --1281
alter table formation_treatments alter column treatment_type type varchar(20);

alter table formation_treatments alter column treatment_date type date using treatment_date::date;

update formation_treatments set treatment_end_date = null where treatment_end_date = 'N/A'; --1169
alter table formation_treatments alter column treatment_end_date type date using treatment_end_date::date;

update formation_treatments set total_fluid_used = trim(total_fluid_used);
update formation_treatments set total_fluid_used = null where total_fluid_used = ''; --1481
alter table formation_treatments alter column total_fluid_used type integer using total_fluid_used::integer;

update formation_treatments set max_pressure = trim(max_pressure);
update formation_treatments set max_pressure = null where max_pressure = ''; --1681
alter table formation_treatments alter column max_pressure type integer using max_pressure::integer;

update formation_treatments set total_gas_used = trim(total_gas_used);
update formation_treatments set total_gas_used = null where total_gas_used = ''; --4401
alter table formation_treatments alter column total_gas_used type integer using total_gas_used::integer;

update formation_treatments set fluid_density = trim(fluid_density);
update formation_treatments set fluid_density = null where fluid_density = ''; --2059
alter table formation_treatments alter column fluid_density type varchar(10);

update formation_treatments set gas_type = upper(trim(gas_type));
update formation_treatments set gas_type = null where gas_type = ''; --6322
alter table formation_treatments alter column gas_type type varchar(14);

update formation_treatments set staged_intervals = trim(staged_intervals);
update formation_treatments set staged_intervals = null where staged_intervals = ''; --1960
alter table formation_treatments alter column staged_intervals type integer using staged_intervals::integer;

update formation_treatments set total_acid_used = trim(total_acid_used);
update formation_treatments set total_acid_used = null where total_acid_used = ''; --3080
alter table formation_treatments alter column total_acid_used type integer using total_acid_used::integer;

update formation_treatments set max_frac_gradient = trim(max_frac_gradient);
update formation_treatments set max_frac_gradient = null where max_frac_gradient = ''; --2203
alter table formation_treatments alter column max_frac_gradient type varchar(10);

update formation_treatments set recycled_water_used = trim(recycled_water_used);
update formation_treatments set recycled_water_used = null where recycled_water_used = ''; --2463
alter table formation_treatments alter column recycled_water_used type integer using recycled_water_used::integer;

update formation_treatments set total_flowback_recovered = trim(total_flowback_recovered);
update formation_treatments set total_flowback_recovered = null where total_flowback_recovered = ''; --2540
alter table formation_treatments alter column total_flowback_recovered type integer using total_flowback_recovered::integer;

update formation_treatments set produced_water_used = trim(produced_water_used);
update formation_treatments set produced_water_used = null where produced_water_used = ''; --3263
alter table formation_treatments alter column produced_water_used type integer using produced_water_used::integer;

update formation_treatments set flowback_disposition = upper(trim(flowback_disposition));
update formation_treatments set flowback_disposition = null where flowback_disposition = ''; --1867
alter table formation_treatments alter column flowback_disposition type varchar(8);

update formation_treatments set total_proppant_used = trim(total_proppant_used);
update formation_treatments set total_proppant_used = null where total_proppant_used = ''; --2122
alter table formation_treatments alter column total_proppant_used type integer using total_proppant_used::integer;

update formation_treatments set green_completions = trim(green_completions);
update formation_treatments set green_completions = null where green_completions = ''; --2135
alter table formation_treatments alter column green_completions type boolean using green_completions::boolean;

update formation_treatments set no_green_reasons = upper(trim(no_green_reasons));
update formation_treatments set no_green_reasons = null where no_green_reasons = ''; --5902
alter table formation_treatments alter column no_green_reasons type varchar(8);


set search_path to staging;
COPY (select id, well_id, sidetrack_id, completed_interval_id, treatment_type, treatment_date, treatment_end_date, treatment_summary, total_fluid_used, max_pressure, total_gas_used, fluid_density, gas_type, staged_intervals, total_acid_used, max_frac_gradient, recycled_water_used, total_flowback_recovered, produced_water_used, flowback_disposition, total_proppant_used, green_completions, no_green_reasons, created_at, updated_at from formation_treatments order by well_id, sidetrack_id, completed_interval_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/formation_treatments.csv' WITH CSV;

set search_path to public;
create table backup.formation_treatments as table formation_treatments;
drop table formation_treatments;
create table formation_treatments (
	id integer, 
	well_id integer, 
	sidetrack_id integer,
	completed_interval_id integer,
	treatment_type varchar(20), 
	treatment_date date, 
	treatment_end_date date, 
	treatment_summary text, 
	total_fluid_used integer, 
	max_pressure integer, 
	total_gas_used integer, 
	fluid_density varchar(10), 
	gas_type varchar(14), 
	staged_intervals integer, 
	total_acid_used integer, 
	max_frac_gradient varchar(10), 
	recycled_water_used integer, 
	total_flowback_recovered integer, 
	produced_water_used integer, 
	flowback_disposition varchar(8), 
	total_proppant_used integer, 
	green_completions boolean, 
	no_green_reasons varchar(8), 
	created_at timestamp, 
	updated_at timestamp
);

copy formation_treatments from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/formation_treatments.csv' (format csv, delimiter ',', null '');

alter table formation_treatments add primary key (id);

create index index_formation_treatments_on_well_id on formation_treatments (well_id);
create index index_formation_treatments_on_sidetrack_id on formation_treatments (sidetrack_id);
create index index_formation_treatments_on_completed_interval_id on formation_treatments (completed_interval_id);



---------------------------------------------------------------
---------------------  WELL DOCUMENTS  ------------------------
---------------------------------------------------------------
set search_path to import;
drop table well_documents;
create table well_documents (
	id serial not null primary key, 
	well_id integer, 
	well_link_id varchar(10), 
	document_id integer, 
	document_number integer, 
	document_name varchar(500), 
	document_date varchar(20), 
	download_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);

-- run well_document_cataloger.rb import script

set search_path to import;
drop table staging.well_documents;
create table staging.well_documents as table well_documents;

-- clean up records
update well_documents set document_name = trim(document_name);
update well_documents set document_name = null where document_name = ''; --6369

select count(*) from well_documents where left(document_name,1) = '`';
update well_documents set document_name = replace(document_name,'`','') where left(document_name,1) = '`';

alter table well_documents add column doc_name_ucase varchar(65);
update well_documents set doc_name_ucase = upper(document_name) where document_name is not null;

update well_documents set document_date = trim(document_date);
update well_documents set document_date = null where document_date = ''; --884
alter table well_documents alter column document_date type date using document_date::date;

update well_documents set document_date = '2011-10-26' where document_date = '6201-01-02';
update well_documents set document_date = '2014-01-28' where document_date = '2814-01-29';
update well_documents set document_date = '2012-04-24' where document_date = '2631-02-17';
update well_documents set document_date = '2010-03-10' where document_date = '2440-03-10';
update well_documents set document_date = '2015-04-10' where document_date = '2105-04-10';
update well_documents set document_date = '2009-05-04' where document_date = '2077-05-04';
update well_documents set document_date = '2012-08-21' where document_date = '2021-08-21';
update well_documents set document_date = '2011-10-23' where document_date = '2020-10-28';
update well_documents set document_date = '2009-12-24' where document_date = '2015-09-24' and document_id = 3646304;

alter table well_documents add column document_year smallint;
alter table well_documents add column document_month smallint;
update well_documents set document_year = extract(year from document_date) where document_date is not null;
update well_documents set document_month = extract(month from document_date) where document_date is not null;

alter table well_documents add column well_api_number varchar(12);
alter table well_documents add column well_api_county varchar(3);
update well_documents set well_api_number = '05-' || left(well_link_id,3) || '-' || right(well_link_id,5);
update well_documents set well_api_county = left(well_link_id,3);


set search_path to public;
create table backup.well_documents as table well_documents;
drop table well_documents;
create table well_documents (
	id integer, 
	well_id integer, 
	well_link_id varchar(8), 
	document_id integer, 
	document_number integer, 
	document_name varchar(65), 
	document_date date, 
	document_year smallint, 
	document_month smallint, 
	well_api_number varchar(12), 
	well_api_county varchar(3), 
	download_url varchar(40), 
	created_at timestamp, 
	updated_at timestamp
);

insert into well_documents select d.id, d.well_id, d.well_link_id::varchar(8), d.document_id, d.document_number, d.doc_name_ucase, d.document_date, d.document_year, d.document_month, d.well_api_number, d.well_api_county, d.download_url::varchar(40), d.created_at, d.updated_at from staging.well_documents d order by d.well_id, d.document_date;

alter table well_documents add primary key (id);

create index index_well_documents_on_well_id on well_documents (well_id);
create index index_well_documents_on_document_date on well_documents (document_date);
create index index_well_documents_on_document_year on well_documents (document_year);
create index index_well_documents_on_document_month on well_documents (document_month);



---------------------------------------------------------------
------------------  WELL DOCUMENT COUNTS  ---------------------
---------------------------------------------------------------
set search_path to public;
COPY (select count(*) as document_count, document_name from well_documents group by document_name order by document_count desc, document_name) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/well_document_counts.csv' WITH CSV;

-- open in Excel and add id columm sequence

create table backup.well_document_counts as table well_document_counts;
drop table well_document_counts;
create table well_document_counts (
	id integer, 
	document_count integer, 
	document_name varchar(65)
);

copy well_document_counts from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/well_document_counts.csv' (format csv, delimiter ',', null '');

alter table well_document_counts add primary key (id);



---------------------------------------------------------------
-----------------------  COMPLAINTS  --------------------------
---------------------------------------------------------------
set search_path to import;

drop table complaints;
drop table complaint_issue_details;
drop table complaint_notifications;

create table complaints (
	id serial primary key not null, 
	incident_date varchar(10), 
	document_number integer, 
	api_num_facility_id varchar(20), 
	well_api_number varchar(16), 
	complainant_name varchar(100), 
	complainant_address varchar(100), 
	complaint_date varchar(20), 
	complainant_connection varchar(100), 
	operator_name varchar(100), 
	operator_number varchar(20), 
	facility_type varchar(50), 
	facility_id varchar(20), 
	well_name_no varchar(100), 
	county_name varchar(50), 
	operator_contact varchar(100), 
	qtr_qtr varchar(20), 
	section varchar(20), 
	township varchar(20), 
	range varchar(20), 
	meridian varchar(20), 
	created_at timestamp, 
	updated_at timestamp, 
	details_scraped boolean default false, 
	invalid_text boolean default false, 
	in_use boolean default false
);

create table complaint_issue_details (
	id serial primary key not null, 
	complaint_id integer, 
	issue varchar(250), 
	assigned_to varchar(100), 
	status varchar(100), 
	description text, 
	resolution text, 
	letter_sent varchar(1), 
	report_links varchar(250), 
	created_at timestamp, 
	updated_at timestamp
);

create table complaint_notifications (
	id serial primary key not null, 
	complaint_id integer, 
	notification_date varchar(10), 
	agency varchar(100), 
	contact varchar(100), 
	response_details text,
	created_at timestamp, 
	updated_at timestamp
);

-- run scrape/import scripts

set search_path to import;
drop table staging.complaints;
drop table staging.complaint_issue_details;
drop table staging.complaint_notifications;
create table staging.complaints as table complaints;
create table staging.complaint_issue_details as table complaint_issue_details;
create table staging.complaint_notifications as table complaint_notifications;


set search_path to staging;

update complaints set incident_date = trim(incident_date);
update complaints set incident_date = null where incident_date = ''; --0
alter table complaints alter column incident_date type date using incident_date::date;

--api_num_facility_id mix of facility ids and well apis
update complaints set api_num_facility_id = trim(api_num_facility_id);
update complaints set api_num_facility_id = null where api_num_facility_id = ''; --1242
alter table complaints alter column api_num_facility_id type varchar(12);

update complaints set well_api_number = trim(well_api_number);
update complaints set well_api_number = null where well_api_number = ''; --0
alter table complaints alter column well_api_number type varchar(12);

update complaints set complainant_name = upper(trim(complainant_name));
update complaints set complainant_name = null where complainant_name = ''; --66
alter table complaints alter column complainant_name type varchar(50);

update complaints set complainant_address = upper(trim(complainant_address));
update complaints set complainant_address = null where complainant_address = ''; --0
update complaints set complainant_address = null where complainant_address = ','; --385

update complaints set complaint_date = trim(complaint_date);
update complaints set complaint_date = null where complaint_date = ''; --0
update complaints set complaint_date = null where complaint_date = 'N/A'; --23
alter table complaints alter column complaint_date type date using complaint_date::date;

alter table complaints add column complaint_year smallint;
alter table complaints add column complaint_month smallint;
update complaints set complaint_year = extract(year from complaint_date) where complaint_date is not null;
update complaints set complaint_month = extract(month from complaint_date) where complaint_date is not null;

update complaints set complainant_connection = upper(trim(complainant_connection));
update complaints set complainant_connection = null where complainant_connection = ''; --558
alter table complaints alter column complainant_connection type varchar(30);

update complaints set operator_name = upper(trim(operator_name));
update complaints set operator_name = null where operator_name = ''; --1026
alter table complaints alter column operator_name type varchar(50);

update complaints set operator_number = trim(operator_number);
update complaints set operator_number = null where operator_number = ''; --1026
alter table complaints alter column operator_number type integer using operator_number::integer;

update complaints set facility_type = upper(trim(facility_type));
update complaints set facility_type = null where facility_type = ''; --1192
alter table complaints alter column facility_type type varchar(20);

-- need to remove extra spaces in well_name_no
update complaints set well_name_no = upper(trim(well_name_no));
update complaints set well_name_no = null where well_name_no = ''; --1033
alter table complaints alter column well_name_no type varchar(60);

update complaints set county_name = upper(trim(county_name));
update complaints set county_name = null where county_name = ''; --739
alter table complaints alter column county_name type varchar(10);

-- need to remove extra spaces in operator_contact
update complaints set operator_contact = upper(trim(operator_contact));
update complaints set operator_contact = null where operator_contact = ''; --2845
alter table complaints alter column operator_contact type varchar(50);

update complaints set qtr_qtr = upper(trim(qtr_qtr));
update complaints set qtr_qtr = null where qtr_qtr = ''; --1000
update complaints set qtr_qtr = null where qtr_qtr = 'NULL'; --14
alter table complaints alter column qtr_qtr type varchar(6);

update complaints set section = upper(trim(section));
update complaints set section = null where section = ''; --784
update complaints set section = null where section = 'NULL'; --0
alter table complaints alter column section type varchar(2);

update complaints set township = upper(trim(township));
update complaints set township = null where township = ''; --748
update complaints set township = null where township = 'NULL'; --10
alter table complaints alter column township type varchar(4);

update complaints set range = upper(trim(range));
update complaints set range = null where range = ''; --747
update complaints set range = null where range = 'NULL'; --10
alter table complaints alter column range type varchar(4);

update complaints set meridian = upper(trim(meridian));
update complaints set meridian = null where meridian = ''; --395
update complaints set meridian = null where meridian = 'NULL'; --0
alter table complaints alter column meridian type varchar(1);

-- clean up complaint issues table first
alter table complaints add column complaint_issues varchar(100);
update complaints set complaint_issues = (select array_to_string(array(select issue from complaint_issue_details where complaint_id = complaints.id), ' ~ '));

alter table complaints add column well_id integer;
update complaints set well_id = replace(right(well_api_number,9),'-','')::integer where length(well_api_number) = 12;

--copy facility ids from api_num_facility_id to facility_id
update complaints set facility_id = api_num_facility_id where api_num_facility_id not ilike '%-%';
alter table complaints alter column facility_id type integer using facility_id::integer;

alter table complaints add column issue_assigned_to varchar(35) default 'see complaint issue details table';
alter table complaints add column issue_status varchar(35) default 'see complaint issue details table';
alter table complaints add column issue_description text default 'see complaint issue details table';
alter table complaints add column issue_resolution text default 'see complaint issue details table';
alter table complaints add column issue_letter_sent boolean;

update complaints set issue_assigned_to = (select assigned_to from complaint_issue_details where complaint_id = complaints.id) where (select count(*) from complaint_issue_details where complaint_id = complaints.id) < 2;
update complaints set issue_status = (select status from complaint_issue_details where complaint_id = complaints.id) where (select count(*) from complaint_issue_details where complaint_id = complaints.id) < 2;
update complaints set issue_description = (select description from complaint_issue_details where complaint_id = complaints.id) where (select count(*) from complaint_issue_details where complaint_id = complaints.id) < 2;
update complaints set issue_resolution = (select resolution from complaint_issue_details where complaint_id = complaints.id) where (select count(*) from complaint_issue_details where complaint_id = complaints.id) < 2;
update complaints set issue_letter_sent = (select letter_sent from complaint_issue_details where complaint_id = complaints.id) where (select count(*) from complaint_issue_details where complaint_id = complaints.id) < 2;

set search_path to staging;
COPY (select id, incident_date, document_number, well_id, well_api_number, well_name_no, facility_id, facility_type, county_name, complaint_date, complaint_year, complaint_month, complaint_issues, issue_assigned_to, issue_status, issue_description, issue_resolution, issue_letter_sent, operator_name, operator_number, operator_contact, complainant_name, complainant_address, complainant_connection, qtr_qtr, section, township, range, meridian, created_at, updated_at from complaints order by incident_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaints.csv' WITH CSV;


set search_path to public;
create table backup.complaints as table complaints;
drop table complaints;
create table complaints (
	id integer, 
	incident_date date, 
	document_number integer, 
	well_id integer, 
	well_api_number varchar(12), 
	well_name_no varchar(60), 
	facility_id integer, 
	facility_type varchar(20), 
	county_name varchar(10), 
	complaint_date date, 
	complaint_year smallint, 
	complaint_month smallint, 
	complaint_issues varchar(100),
	issue_assigned_to varchar(35), 
	issue_status varchar(35), 
	issue_description text, 
	issue_resolution text, 
	issue_letter_sent boolean,
	operator_name varchar(50), 
	operator_number integer, 
	operator_contact varchar(50), 
	complainant_name varchar(50), 
	complainant_address varchar(100), 
	complainant_connection varchar(30), 
	qtr_qtr varchar(6), 
	section varchar(2), 
	township varchar(4), 
	range varchar(4), 
	meridian varchar(1), 
	created_at timestamp, 
	updated_at timestamp
);

copy complaints from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaints.csv' (format csv, delimiter ',', null '');

alter table complaints add primary key (id);

create index index_complaints_on_well_id on complaints (well_id);
create index index_complaints_on_well_api_number on complaints (well_api_number);
create index index_complaints_on_complaint_year on complaints (complaint_year);
create index index_complaints_on_complaint_month on complaints (complaint_month);
create index index_complaints_on_complaint_date on complaints (complaint_date);



---------------------------------------------------------------
-----------------  COMPLAINT ISSUE DETAILS  -------------------
---------------------------------------------------------------
set search_path to staging;

update complaint_issue_details set issue = upper(trim(issue));
update complaint_issue_details set issue = null where issue = ''; --162
alter table complaint_issue_details alter column issue type varchar(30);

update complaint_issue_details set assigned_to = trim(assigned_to);
update complaint_issue_details set assigned_to = null where assigned_to = ''; --20
alter table complaint_issue_details alter column assigned_to type varchar(20);

update complaint_issue_details set status = trim(status);
update complaint_issue_details set status = null where status = ''; --0
alter table complaint_issue_details alter column status type varchar(35);

update complaint_issue_details set description = trim(description);
update complaint_issue_details set description = null where description = ''; --24

update complaint_issue_details set resolution = trim(resolution);
update complaint_issue_details set resolution = null where resolution = ''; --281

update complaint_issue_details set letter_sent = trim(letter_sent);
update complaint_issue_details set letter_sent = null where letter_sent = ''; --421
alter table complaint_issue_details alter letter_sent type boolean using letter_sent::boolean;

-- report_links ??
update complaint_issue_details set report_links = trim(report_links);
update complaint_issue_details set report_links = null where report_links = ''; --3773
alter table complaint_issue_details alter column report_links type varchar(60);

-- complaint issue clean up
update complaint_issue_details set issue = 'ACCESS ROAD COVERED' where issue = 'ACCESS RD COVERED'; --1
update complaint_issue_details set issue = 'BOND ISSUE' where issue = 'BOND ISUE'; --1
update complaint_issue_details set issue = 'COAL FINES STAIN' where issue = 'COAL FINES STAINING'; --1
update complaint_issue_details set issue = 'ENVIRONMENTAL' where issue = 'ENV. N. SM. RCL'; --1
update complaint_issue_details set issue = 'EROSION' where issue = 'EROSION-ENVIR'; --1
update complaint_issue_details set issue = 'FENCING' where issue = 'FENCE'; --3
update complaint_issue_details set issue = 'GAS SEEP' where issue = 'GAS SEEP NEARBY'; --1
update complaint_issue_details set issue = 'GROUND WATER BASELINE' where issue = 'GW BASELINE'; --2
update complaint_issue_details set issue = 'HEALTH & SAFETY' where issue = 'HEALTH/SAFETY'; --2
update complaint_issue_details set issue = 'HEALTH & SAFETY' where issue = 'HEALTH SAFETY'; --1
update complaint_issue_details set issue = 'HEALTH & SAFETY' where issue = 'HEALTH AND SAFETY'; --32
update complaint_issue_details set issue = 'HISTORIC GAS' where issue = 'HIST0RIC GAS'; --1
update complaint_issue_details set issue = 'LANDFILL & RUNOFF' where issue = 'LANDFILL AND RUNOFF'; --1
update complaint_issue_details set issue = 'MISCELLANEOUS' where issue = 'MISC.'; --1
update complaint_issue_details set issue = 'MISCELLANEOUS' where issue = 'MISCELLAN'; --1
update complaint_issue_details set issue = 'MISCELLANEOUS' where issue = 'MISC'; --3
update complaint_issue_details set issue = 'NOISE & ACCESS' where issue = 'NOISE AND ACCESS'; --1
update complaint_issue_details set issue = 'NOISE & LIGHTING' where issue = 'NOISE AND LIGHTING'; --1
update complaint_issue_details set issue = 'NOISE & LIGHTING' where issue = 'NOISE AND LIGHTS'; --1
update complaint_issue_details set issue = 'NOISE, LIGHTS, HAWKS' where issue = 'NOISE,LIGHTS, HAWKS'; --1
update complaint_issue_details set issue = 'OPERATOR RELATIONSHIP' where issue = 'OPERATOR RELATIONS'; --1
update complaint_issue_details set issue = 'P&A WELL' where issue = 'P & A'; --1
update complaint_issue_details set issue = 'P&A WELL' where issue = 'P & A WELL'; --1
update complaint_issue_details set issue = 'P&A WELL' where issue = 'PA'; --1
update complaint_issue_details set issue = 'P&A WELL' where issue = 'PA WELL'; --1
update complaint_issue_details set issue = 'PITS' where issue = 'PIT'; --2
update complaint_issue_details set issue = 'PRODUCTION' where issue = 'PRODUCITON'; --1
update complaint_issue_details set issue = 'PRODUCTION WATER' where issue = 'PRODUCTION H2O'; --1
update complaint_issue_details set issue = 'PROJECT 1594' where issue = 'PROJ 1594'; --1
update complaint_issue_details set issue = 'RATHOLE' where issue = 'RAT HOLE'; --1
update complaint_issue_details set issue = 'ROADS' where issue = 'ROAD'; --1
update complaint_issue_details set issue = 'ROYALTY INTEREST THEFT' where issue = 'ROYALTY INT. THEFT'; --1
update complaint_issue_details set issue = 'SAFETY & NOISE' where issue = 'SAFETY AND NOISE'; --1
update complaint_issue_details set issue = 'SAFETY & WEEDS' where issue = 'SAFETY AND WEEDS'; --1
update complaint_issue_details set issue = 'SEE BELOW' where issue = 'SEE BELOW.'; --1
update complaint_issue_details set issue = 'SETBACKS' where issue = 'SET-BACK ISSUE'; --1
update complaint_issue_details set issue = 'SPRING' where issue = 'SPRINGS'; --1
update complaint_issue_details set issue = 'SHUT-IN' where issue = 'SI WELL'; --3
update complaint_issue_details set issue = 'SHUT-IN' where issue = 'SI-TA WELL'; --1
update complaint_issue_details set issue = 'RECLAMATION' where issue = 'SITE RECLAMINATION'; --1
update complaint_issue_details set issue = 'RECLAMATION' where issue = 'SITE RECLAMATION'; --3
update complaint_issue_details set issue = 'SPILL' where issue = 'SPILLS'; --100
update complaint_issue_details set issue = 'STORMWATER BMPS' where issue = 'STORWATER BMP`S'; --1
update complaint_issue_details set issue = 'TRACE OF BTEX IN WATER' where issue = 'TRACE OF BTEX IN WTR'; --1
update complaint_issue_details set issue = 'TRESPASS' where issue = 'TRESPASSING'; --1
update complaint_issue_details set issue = 'UTILITY LINES SEVERED' where issue = 'UTIL. LINES SEVERED'; --1
update complaint_issue_details set issue = 'VARIOUS COMPLAINTS' where issue = 'VARIOUS'; --1
update complaint_issue_details set issue = 'WATER WELL' where issue = 'WATER  WELL'; --2
update complaint_issue_details set issue = 'WATER SAMPLING' where issue = 'WATER SAMPLE'; --1


set search_path to staging;
COPY (select id, complaint_id, issue, assigned_to, status, description, resolution, letter_sent, created_at, updated_at from complaint_issue_details order by complaint_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_issue_details.csv' WITH CSV;


set search_path to public;
create table backup.complaint_issue_details as table complaint_issue_details;
drop table complaint_issue_details;
create table complaint_issue_details (
	id integer, 
	complaint_id integer, 
	issue varchar(30), 
	assigned_to varchar(20), 
	status varchar(35), 
	description text, 
	resolution text, 
	letter_sent boolean, 
	created_at timestamp, 
	updated_at timestamp
);

copy complaint_issue_details from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_issue_details.csv' (format csv, delimiter ',', null '');

alter table complaint_issue_details add primary key (id);

create index index_complaint_issue_details_on_complaint_id on complaint_issue_details (complaint_id);
create index index_complaint_issue_details_on_issue on complaint_issue_details (issue);



---------------------------------------------------------------
----------------  COMPLAINT NOTIFICATIONS  --------------------
---------------------------------------------------------------
set search_path to staging;

update complaint_notifications set notification_date = trim(notification_date);
update complaint_notifications set notification_date = null where notification_date = ''; --0
update complaint_notifications set notification_date = null where notification_date = 'N/A'; --1
alter table complaint_notifications alter column notification_date type date using notification_date::date;

alter table complaint_notifications add column notification_year smallint;
alter table complaint_notifications add column notification_month smallint;
update complaint_notifications set notification_year = extract(year from notification_date) where notification_date is not null;
update complaint_notifications set notification_month = extract(month from notification_date) where notification_date is not null;

update complaint_notifications set agency = trim(agency);
update complaint_notifications set agency = null where agency = ''; --370
alter table complaint_notifications alter column agency type varchar(30);

update complaint_notifications set contact = trim(contact);
update complaint_notifications set contact = null where contact = ''; --16
alter table complaint_notifications alter column contact type varchar(30);

update complaint_notifications set response_details = trim(response_details);
update complaint_notifications set response_details = null where response_details = ''; --218


set search_path to staging;
COPY (select id, complaint_id, notification_date, notification_year, notification_month, agency, contact, response_details, created_at, updated_at from complaint_notifications order by complaint_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_notifications.csv' WITH CSV;


set search_path to public;
create table backup.complaint_notifications as table complaint_notifications;
drop table complaint_notifications;
create table complaint_notifications (
	id integer, 
	complaint_id integer, 
	notification_date date, 
	notification_year smallint, 
	notification_month smallint, 
	agency varchar(30), 
	contact varchar(30), 
	response_details text,
	created_at timestamp, 
	updated_at timestamp
);

copy complaint_notifications from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_notifications.csv' (format csv, delimiter ',', null '');

alter table complaint_notifications add primary key (id);

create index index_complaint_notifications_on_complaint_id on complaint_notifications (complaint_id);
create index index_complaint_notifications_on_notification_year on complaint_notifications (notification_year);
create index index_complaint_notifications_on_notification_month on complaint_notifications (notification_month);
create index index_complaint_notifications_on_notification_date on complaint_notifications (notification_date);



---------------------------------------------------------------
----------------  COMPLAINT ISSUE COUNTS  ---------------------
---------------------------------------------------------------
set search_path to public;
COPY (select issue, count(*) as issue_count from complaint_issues group by issue order by issue_count desc, issue) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_issue_counts.csv' WITH CSV;

-- open in Excel and add id columm sequence and enter 'N/A' for null value issue text

set search_path to public;
create table backup.complaint_issue_counts as table complaint_issue_counts;
drop table complaint_issue_counts;
create table complaint_issue_counts (
	id integer, 
	issue varchar(30), 
	occurrence_count smallint
);

copy complaint_issue_counts from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/complaint_issue_counts.csv' (format csv, delimiter ',', null '');

alter table complaint_issue_counts add primary key (id);



---------------------------------------------------------------
-------------------------  NOAVS  -----------------------------
---------------------------------------------------------------
set search_path to import;

drop table noavs;
drop table noav_details;

create table noavs (
	id serial not null primary key, 
	violation_date varchar(20), 
	document_number integer, 
	facility_id varchar(20), 
	operator_number varchar(20), 
	operator_name varchar(50), 
	created_at timestamp, 
	updated_at timestamp
);

create table noav_details (
	id serial not null primary key, 
	noav_id integer, 
	date_received varchar(30), 
	operator_address varchar(100), 
	operator_rep varchar(50), 
	facility_type varchar(30), 
	well_name_number varchar(100), 
	well_api_number varchar(20), 
	plss_location varchar(30), 
	county varchar(20), 
	cogcc_rep varchar(50), 
	phone varchar(20), 
	violation_time varchar(30), 
	alleged_violation varchar(5000), 
	cited_conditions varchar(2000), 
	abatement varchar(5000), 
	abatement_date varchar(30), 
	company_comments varchar(5000), 
	company_rep varchar(50), 
	rep_title varchar(50), 
	rep_signature varchar(1), 
	rep_signature_date varchar(30), 
	cogcc_signature varchar(1), 
	cogcc_signature_date varchar(30), 
	resolution_approved_by varchar(50), 
	approved_by_title varchar(50), 
	resolution_date varchar(30), 
	case_closed varchar(1), 
	letter_sent varchar(1), 
	cogcc_person varchar(50), 
	resolution_comments varchar(5000), 
	created_at timestamp, 
	updated_at timestamp
);

-- run scrape/import scripts

set search_path to import;
drop table staging.noavs;
drop table staging.noav_details;
create table staging.noavs as table noavs;
create table staging.noav_details as table noav_details;


-- clean up data records
set search_path to staging;

update noavs set facility_id = null where trim(facility_id) = '';
alter table noavs alter column facility_id type integer using facility_id::integer;

alter table noavs alter column violation_date type date using violation_date::date;

alter table noavs add column violation_year smallint;
alter table noavs add column violation_month smallint;
update noavs set violation_year = extract(year from violation_date) where violation_date is not null;
update noavs set violation_month = extract(month from violation_date) where violation_date is not null;

alter table noavs alter column operator_number type integer using operator_number::integer;

alter table noavs alter column operator_name type varchar(50);

alter table noavs add column in_use boolean not null default false;

alter table noavs add column details_scraped boolean not null default false;

update noav_details set date_received = trim(date_received);
update noav_details set date_received = null where date_received = ''; --0
alter table noav_details alter column date_received type date using date_received::date;

update noav_details set operator_address = upper(trim(operator_address));
update noav_details set operator_address = null where operator_address = ''; --0
update noav_details set operator_address = null where operator_address = ','; --1

update noav_details set operator_rep = upper(trim(operator_rep));
update noav_details set operator_rep = null where operator_rep = ''; --1558

update noav_details set facility_type = upper(trim(facility_type));
update noav_details set facility_type = null where facility_type = ''; --221

update noav_details set well_name_number = upper(trim(well_name_number));
update noav_details set well_name_number = null where well_name_number = ''; --221
alter table noav_details alter column well_name_number type varchar(50);

update noav_details set well_api_number = trim(well_api_number);
update noav_details set well_api_number = null where well_api_number = ''; --0
alter table noav_details alter column well_api_number type varchar(12);

alter table noav_details add column well_id integer;
update noav_details set well_id = replace(right(well_api_number,9),'-','')::integer where length(well_api_number) = 12;

update noav_details set plss_location = upper(trim(plss_location));
update noav_details set plss_location = null where plss_location = ''; --0

update noav_details set county = upper(trim(county));
update noav_details set county = null where county = ''; --221
alter table noav_details alter column county type varchar(10);

update noav_details set cogcc_rep = trim(cogcc_rep);
update noav_details set cogcc_rep = null where cogcc_rep = ''; --3
alter table noav_details alter column cogcc_rep type varchar(30);

update noav_details set phone = upper(trim(phone));
update noav_details set phone = null where phone = ''; --0
alter table noav_details alter column phone type varchar(20);

-- violation_time all values are null??

update noav_details set alleged_violation = trim(alleged_violation);
update noav_details set alleged_violation = null where alleged_violation = ''; --6
alter table noav_details alter column alleged_violation type varchar(4000);

update noav_details set cited_conditions = trim(cited_conditions);
update noav_details set cited_conditions = null where cited_conditions = ''; --20
alter table noav_details alter column cited_conditions type varchar(1250);

update noav_details set abatement = trim(abatement);
update noav_details set abatement = null where abatement = ''; --19

update noav_details set abatement_date = trim(abatement_date);
update noav_details set abatement_date = null where abatement_date = ''; --0
update noav_details set abatement_date = null where abatement_date = 'N/A'; --81
alter table noav_details alter column abatement_date type date using abatement_date::date;

update noav_details set company_comments = trim(company_comments);
update noav_details set company_comments = null where company_comments = ''; --3012
alter table noav_details alter column company_comments type varchar(1000);

update noav_details set company_rep = upper(trim(company_rep));
update noav_details set company_rep = null where company_rep = ''; --2864
alter table noav_details alter column company_rep type varchar(30);

update noav_details set rep_title = upper(trim(rep_title));
update noav_details set rep_title = null where rep_title = ''; --2980
alter table noav_details alter column rep_title type varchar(30);

update noav_details set rep_signature = upper(trim(rep_signature));
update noav_details set rep_signature = null where rep_signature = ''; --2963

--rep_signature_date
alter table noav_details add column rep_signature_timestamp varchar(30);
update noav_details set rep_signature_timestamp = rep_signature_date;
select rep_signature_date, split_part(rep_signature_date, ' ', 1) from noav_details;
update noav_details set rep_signature_date = split_part(rep_signature_date, ' ', 1);
update noav_details set rep_signature_date = trim(rep_signature_date);
update noav_details set rep_signature_date = null where rep_signature_date = ''; --0
update noav_details set rep_signature_date = null where rep_signature_date = 'N/A'; --10
alter table noav_details alter column rep_signature_date type date using rep_signature_date::date;


update noav_details set cogcc_signature = upper(trim(cogcc_signature));
update noav_details set cogcc_signature = null where cogcc_signature = ''; --1228

--cogcc_signature_date ??
alter table noav_details add column cogcc_signature_timestamp varchar(30);
update noav_details set cogcc_signature_timestamp = cogcc_signature_date;
select cogcc_signature_date, split_part(cogcc_signature_date, ' ', 1) from noav_details;
update noav_details set cogcc_signature_date = split_part(cogcc_signature_date, ' ', 1);
update noav_details set cogcc_signature_date = trim(cogcc_signature_date);
update noav_details set cogcc_signature_date = null where cogcc_signature_date = ''; --0
update noav_details set cogcc_signature_date = null where cogcc_signature_date = 'N/A'; --698
update noav_details set cogcc_signature_date = null where cogcc_signature_date ilike '%:%'; --227
alter table noav_details alter column cogcc_signature_date type date using cogcc_signature_date::date;

update noav_details set resolution_approved_by = upper(trim(resolution_approved_by));
update noav_details set resolution_approved_by = null where resolution_approved_by = ''; --408
alter table noav_details alter column resolution_approved_by type varchar(30);

update noav_details set approved_by_title = trim(approved_by_title);
update noav_details set approved_by_title = null where approved_by_title = ''; --4263
alter table noav_details alter column approved_by_title type varchar(15);

update noav_details set resolution_date = trim(resolution_date);
update noav_details set resolution_date = null where resolution_date = ''; --0
update noav_details set resolution_date = null where resolution_date = 'No Final data found.'; --135
alter table noav_details alter column resolution_date type date using resolution_date::date;

-- case_closed all values null??
update noav_details set case_closed = upper(trim(case_closed));
update noav_details set case_closed = null where case_closed = ''; --4130

update noav_details set letter_sent = upper(trim(letter_sent));
update noav_details set letter_sent = null where letter_sent = ''; --0

-- cogcc_person all values null??
update noav_details set cogcc_person = upper(trim(cogcc_person));
update noav_details set cogcc_person = null where cogcc_person = ''; --4130

update noav_details set resolution_comments = trim(resolution_comments);
update noav_details set resolution_comments = null where resolution_comments = ''; --645
alter table noav_details alter column resolution_comments type varchar(500);


set search_path to staging;
COPY (select n.id, n.document_number, n.violation_date, n.violation_year, n.violation_month, d.date_received, n.facility_id, d.facility_type, d.well_name_number, d.well_api_number, d.well_id, n.operator_number, n.operator_name, d.operator_address, d.operator_rep, d.plss_location, d.county, d.cogcc_rep, d.phone, d.alleged_violation, d.cited_conditions, d.abatement, d.abatement_date, d.company_comments, d.company_rep, d.rep_title, d.rep_signature, d.rep_signature_date, d.cogcc_signature, d.cogcc_signature_date, d.resolution_approved_by, d.approved_by_title, d.resolution_date, d.letter_sent, d.resolution_comments, case when d.created_at is not null then d.created_at else n.created_at end as created_at, case when d.updated_at is not null then d.updated_at else n.updated_at end as updated_at from noavs n left outer join noav_details d on n.id = d.noav_id order by n.violation_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/noavs.csv' WITH CSV;


set search_path to public;
create table backup.noavs as table noavs;
drop table noavs;
create table noavs (
	id integer, 
	document_number integer, 
	violation_date date, 
	violation_year smallint, 
	violation_month smallint, 
	date_received date, 
	facility_id integer, 
	facility_type varchar(30), 
	well_name_number varchar(50), 
	well_api_number varchar(12), 
	well_id integer, 
	operator_number integer, 
	operator_name varchar(50), 
	operator_address varchar(100), 
	operator_rep varchar(50), 
	plss_location varchar(30), 
	county varchar(10), 
	cogcc_rep varchar(30), 
	phone varchar(20), 
	--violation_time varchar(30), 
	alleged_violation text, 
	cited_conditions varchar(1250), 
	abatement text, 
	abatement_date date, 
	company_comments varchar(1000), 
	company_rep varchar(30), 
	rep_title varchar(30), 
	rep_signature varchar(1), 
	rep_signature_date date, 
	cogcc_signature varchar(1), 
	cogcc_signature_date date, 
	resolution_approved_by varchar(30), 
	approved_by_title varchar(15), 
	resolution_date date, 
	--case_closed varchar(1), 
	letter_sent varchar(1), 
	--cogcc_person varchar(50), 
	resolution_comments varchar(500), 
	created_at timestamp, 
	updated_at timestamp
);

copy noavs from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/noavs.csv' (format csv, delimiter ',', null '');

alter table noavs add primary key (id);

create index index_noavs_on_violation_date on noavs (violation_date);
create index index_noavs_on_violation_year on noavs (violation_year);
create index index_noavs_on_violation_month on noavs (violation_month);
create index index_noavs_on_well_api_number on noavs (well_api_number);
create index index_noavs_on_well_id on noavs (well_id);
create index index_noavs_on_county on noavs (county);



---------------------------------------------------------------
---------------  MECHANICAL INTEGRITY TESTS  ------------------
---------------------------------------------------------------
set search_path to import;

drop table mechanical_integrity_tests;

create table mechanical_integrity_tests (
	id serial primary key not null, 
	well_id integer, 
	well_api_number varchar(12), 
	well_status varchar(2), 
	document_number integer, 
	test_type varchar(30), 
	test_date varchar(12), 
	facility_id integer, 
	facility_name varchar(100), 
	facility_type varchar(50), 
	facility_status varchar(2), 
	operator_name varchar(100), 
	operator_number integer, 
	operator_address varchar(250), 
	operator_contact varchar(100), 
	date_submitted varchar(20), 
	mit_assigned_by varchar(100), 
	date_received varchar(20), 
	field_rep varchar(100), 
	approved_date varchar(13), 
	approved_by varchar(100), 
	condition_of_approval varchar(1000), 
	last_approved_mit varchar(13), 
	qtrqtr varchar(4), 
	section varchar(4), 
	township varchar(4), 
	range varchar(4), 
	meridian varchar(1), 
	formation_zones varchar(100), 
	repair_type varchar(50), 
	repair_description varchar(1000), 
	perforation_interval varchar(50), 
	open_hole_interval varchar(50), 
	plug_depth varchar(20), 
	tubing_size varchar(10), 
	tubing_depth varchar(10), 
	top_packer_depth varchar(10), 
	multiple_packers varchar(10), 
	ten_min_case_psi varchar(10), 
	five_min_case_psi varchar(10), 
	case_before_psi varchar(10), 
	final_case_psi varchar(10), 
	final_tube_psi varchar(10), 
	initial_tube_psi varchar(10),  
	loss_gain_psi varchar(10), 
	start_case_psi varchar(10), 
	created_at timestamp, 
	updated_at timestamp, 
	details_scraped boolean default false, 
	invalid_text boolean default false, 
	in_use boolean default false
);

-- run scrape/import scripts

set search_path to import;
drop table staging.mechanical_integrity_tests;
create table staging.mechanical_integrity_tests as table mechanical_integrity_tests;


-- clean up data records
set search_path to staging;

update mechanical_integrity_tests set well_api_number = trim(well_api_number);
update mechanical_integrity_tests set well_api_number = null where well_api_number = ''; --0

update mechanical_integrity_tests set well_status = upper(trim(well_status));
update mechanical_integrity_tests set well_status = null where well_status = ''; --0

update mechanical_integrity_tests set test_type = upper(trim(test_type));
update mechanical_integrity_tests set test_type = null where test_type = ''; --0
alter table mechanical_integrity_tests alter column test_type type varchar(24);

update mechanical_integrity_tests set test_date = trim(test_date);
update mechanical_integrity_tests set test_date = null where test_date = ''; --0
alter table mechanical_integrity_tests alter column test_date type date using test_date::date;

alter table mechanical_integrity_tests add column test_year smallint;
alter table mechanical_integrity_tests add column test_month smallint;
update mechanical_integrity_tests set test_year = extract(year from test_date) where test_date is not null;
update mechanical_integrity_tests set test_month = extract(month from test_date) where test_date is not null;

update mechanical_integrity_tests set facility_name = upper(trim(facility_name));
update mechanical_integrity_tests set facility_name = null where facility_name = ''; --0

alter table mechanical_integrity_tests add column well_name_num varchar(50);
update mechanical_integrity_tests set well_name_num = trim(left(facility_name,35)) || ' '|| trim(substr(facility_name,37,(length(facility_name)-35)));

update mechanical_integrity_tests set facility_type = upper(trim(facility_type));
update mechanical_integrity_tests set facility_type = null where facility_type = ''; --0
alter table mechanical_integrity_tests alter column facility_type type varchar(25);

update mechanical_integrity_tests set facility_status = upper(trim(facility_status));
update mechanical_integrity_tests set facility_status = null where facility_status = ''; --0

update mechanical_integrity_tests set operator_name = upper(trim(operator_name));
update mechanical_integrity_tests set operator_name = null where operator_name = ''; --0
alter table mechanical_integrity_tests alter column operator_name type varchar(50);

update mechanical_integrity_tests set operator_address = upper(trim(operator_address));
update mechanical_integrity_tests set operator_address = null where operator_address = ''; --0
alter table mechanical_integrity_tests alter column operator_address type varchar(60);

update mechanical_integrity_tests set operator_contact = upper(trim(operator_contact));
update mechanical_integrity_tests set operator_contact = null where operator_contact = ''; --838
alter table mechanical_integrity_tests alter column operator_contact type varchar(30);

update mechanical_integrity_tests set date_submitted = trim(date_submitted);
update mechanical_integrity_tests set date_submitted = null where date_submitted = ''; --0
alter table mechanical_integrity_tests alter column date_submitted type date using date_submitted::date;

update mechanical_integrity_tests set mit_assigned_by = upper(trim(mit_assigned_by));
update mechanical_integrity_tests set mit_assigned_by = null where mit_assigned_by = ''; --403
alter table mechanical_integrity_tests alter column mit_assigned_by type varchar(30);

update mechanical_integrity_tests set date_received = trim(date_received);
update mechanical_integrity_tests set date_received = null where date_received = ''; --0
alter table mechanical_integrity_tests alter column date_received type date using date_received::date;

update mechanical_integrity_tests set field_rep = upper(trim(field_rep));
update mechanical_integrity_tests set field_rep = null where field_rep = ''; --2276
alter table mechanical_integrity_tests alter column field_rep type varchar(30);

update mechanical_integrity_tests set approved_date = trim(approved_date);
update mechanical_integrity_tests set approved_date = null where approved_date = ''; --0
update mechanical_integrity_tests set approved_date = null where approved_date = 'Not Available'; --2
alter table mechanical_integrity_tests alter column approved_date type date using approved_date::date;

update mechanical_integrity_tests set approved_by = upper(trim(approved_by));
update mechanical_integrity_tests set approved_by = null where approved_by = ''; --403
alter table mechanical_integrity_tests alter column approved_by type varchar(30);

update mechanical_integrity_tests set condition_of_approval = trim(condition_of_approval);
update mechanical_integrity_tests set condition_of_approval = null where condition_of_approval = ''; --5341
alter table mechanical_integrity_tests alter column condition_of_approval type varchar(500);

update mechanical_integrity_tests set last_approved_mit = trim(last_approved_mit);
update mechanical_integrity_tests set last_approved_mit = null where last_approved_mit = ''; --0
update mechanical_integrity_tests set last_approved_mit = null where last_approved_mit = 'Not Available'; --2255
alter table mechanical_integrity_tests alter column last_approved_mit type date using last_approved_mit::date;

update mechanical_integrity_tests set qtrqtr = upper(trim(qtrqtr));
update mechanical_integrity_tests set qtrqtr = null where qtrqtr = ''; --372

update mechanical_integrity_tests set section = upper(trim(section));
update mechanical_integrity_tests set section = null where section = ''; --372
alter table mechanical_integrity_tests alter column section type varchar(2);

update mechanical_integrity_tests set township = upper(trim(township));
update mechanical_integrity_tests set township = null where township = ''; --372

update mechanical_integrity_tests set range = upper(trim(range));
update mechanical_integrity_tests set range = null where range = ''; --372

update mechanical_integrity_tests set meridian = upper(trim(meridian));
update mechanical_integrity_tests set meridian = null where meridian = ''; --380

update mechanical_integrity_tests set formation_zones = upper(trim(formation_zones));
update mechanical_integrity_tests set formation_zones = null where formation_zones = ''; --97
alter table mechanical_integrity_tests alter column formation_zones type varchar(6);

update mechanical_integrity_tests set repair_type = upper(trim(repair_type));
update mechanical_integrity_tests set repair_type = null where repair_type = ''; --27
alter table mechanical_integrity_tests alter column repair_type type varchar(30);

update mechanical_integrity_tests set repair_description = trim(repair_description);
update mechanical_integrity_tests set repair_description = null where repair_description = ''; --148
alter table mechanical_integrity_tests alter column repair_description type varchar(750);

update mechanical_integrity_tests set perforation_interval = upper(trim(perforation_interval));
update mechanical_integrity_tests set perforation_interval = null where perforation_interval = ''; --182
alter table mechanical_integrity_tests alter column perforation_interval type varchar(30);

update mechanical_integrity_tests set open_hole_interval = upper(trim(open_hole_interval));
update mechanical_integrity_tests set open_hole_interval = null where open_hole_interval = ''; --1189
alter table mechanical_integrity_tests alter column open_hole_interval type varchar(30);

update mechanical_integrity_tests set plug_depth = upper(trim(plug_depth));
update mechanical_integrity_tests set plug_depth = null where plug_depth = ''; --3
update mechanical_integrity_tests set plug_depth = null where plug_depth = '?'; --2
update mechanical_integrity_tests set plug_depth = null where plug_depth = 'N/A'; --4
update mechanical_integrity_tests set plug_depth = null where plug_depth = 'NA'; --1801
update mechanical_integrity_tests set plug_depth = null where plug_depth = 'UNK'; --1
update mechanical_integrity_tests set plug_depth = null where plug_depth = '0000'; --1
update mechanical_integrity_tests set plug_depth = replace(plug_depth,',','') where plug_depth ilike '%,%'; --2
update mechanical_integrity_tests set plug_depth = replace(plug_depth,'''','') where plug_depth ilike '%''%'; --19
update mechanical_integrity_tests set plug_depth = '6591' where plug_depth = '6590.5'; --1
update mechanical_integrity_tests set plug_depth = '6566' where plug_depth = '6565.8'; --1
update mechanical_integrity_tests set plug_depth = '6498' where plug_depth = '6498.4'; --1
update mechanical_integrity_tests set plug_depth = '6259' where plug_depth = '6258.9'; --1
update mechanical_integrity_tests set plug_depth = '6970' where plug_depth = '6969.8'; --1
update mechanical_integrity_tests set plug_depth = '7393' where plug_depth = '7392.7'; --1
update mechanical_integrity_tests set plug_depth = '6368' where plug_depth = '6367.9'; --1
alter table mechanical_integrity_tests alter column plug_depth type integer using plug_depth::integer;

update mechanical_integrity_tests set tubing_size = upper(trim(tubing_size));
update mechanical_integrity_tests set tubing_size = null where tubing_size = ''; --1940
alter table mechanical_integrity_tests alter column tubing_size type varchar(6);

update mechanical_integrity_tests set tubing_depth = upper(trim(tubing_depth));
update mechanical_integrity_tests set tubing_depth = null where tubing_depth = ''; --1989
alter table mechanical_integrity_tests alter column tubing_depth type varchar(6);

update mechanical_integrity_tests set top_packer_depth = upper(trim(top_packer_depth));
update mechanical_integrity_tests set top_packer_depth = null where top_packer_depth = ''; --2007
alter table mechanical_integrity_tests alter column top_packer_depth type varchar(6);

update mechanical_integrity_tests set multiple_packers = trim(multiple_packers);
update mechanical_integrity_tests set multiple_packers = null where multiple_packers = ''; --2120
alter table mechanical_integrity_tests alter column multiple_packers type boolean using multiple_packers::boolean;

update mechanical_integrity_tests set ten_min_case_psi = trim(ten_min_case_psi);
update mechanical_integrity_tests set ten_min_case_psi = null where ten_min_case_psi = ''; --359
alter table mechanical_integrity_tests alter column ten_min_case_psi type integer using ten_min_case_psi::integer;

update mechanical_integrity_tests set five_min_case_psi = trim(five_min_case_psi);
update mechanical_integrity_tests set five_min_case_psi = null where five_min_case_psi = ''; --359
alter table mechanical_integrity_tests alter column five_min_case_psi type integer using five_min_case_psi::integer;

update mechanical_integrity_tests set case_before_psi = trim(case_before_psi);
update mechanical_integrity_tests set case_before_psi = null where case_before_psi = ''; --838
alter table mechanical_integrity_tests alter column case_before_psi type integer using case_before_psi::integer;

update mechanical_integrity_tests set final_case_psi = trim(final_case_psi);
update mechanical_integrity_tests set final_case_psi = null where final_case_psi = ''; --1
alter table mechanical_integrity_tests alter column final_case_psi type integer using final_case_psi::integer;

update mechanical_integrity_tests set final_tube_psi = trim(final_tube_psi);
update mechanical_integrity_tests set final_tube_psi = null where final_tube_psi = ''; --2286
alter table mechanical_integrity_tests alter column final_tube_psi type integer using final_tube_psi::integer;

update mechanical_integrity_tests set initial_tube_psi = trim(initial_tube_psi);
update mechanical_integrity_tests set initial_tube_psi = null where initial_tube_psi = ''; --2282
alter table mechanical_integrity_tests alter column initial_tube_psi type integer using initial_tube_psi::integer;

update mechanical_integrity_tests set loss_gain_psi = trim(loss_gain_psi);
update mechanical_integrity_tests set loss_gain_psi = null where loss_gain_psi = ''; --4
alter table mechanical_integrity_tests alter column loss_gain_psi type integer using loss_gain_psi::integer;

update mechanical_integrity_tests set start_case_psi = trim(start_case_psi);
update mechanical_integrity_tests set start_case_psi = null where start_case_psi = ''; --1
alter table mechanical_integrity_tests alter column start_case_psi type integer using start_case_psi::integer;

alter table mechanical_integrity_tests add column well_id integer;
update mechanical_integrity_tests set well_id = replace(right(api_number,9),'-','')::integer where length(api_number) = 12;


set search_path to staging;
COPY (select id, well_id, well_api_number, well_name_num, well_status, document_number, test_type, test_date, test_year, test_month, facility_id, facility_type, facility_status, operator_name, operator_number, operator_address, operator_contact, date_submitted, mit_assigned_by, date_received, field_rep, approved_date, approved_by, condition_of_approval, last_approved_mit, qtrqtr, section, township, range, meridian, formation_zones, repair_type, repair_description, perforation_interval, open_hole_interval, plug_depth, tubing_size, tubing_depth, top_packer_depth, multiple_packers, ten_min_case_psi, five_min_case_psi, case_before_psi, final_case_psi, final_tube_psi, initial_tube_psi, loss_gain_psi, start_case_psi, created_at, updated_at from mechanical_integrity_tests order by test_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/mechanical_integrity_tests.csv' WITH CSV;


set search_path to public;
create table backup.mechanical_integrity_tests as table mechanical_integrity_tests;
drop table mechanical_integrity_tests;
create table mechanical_integrity_tests (
	id integer, 
	well_id integer, 
	well_api_number varchar(12), 
	well_name_num varchar(50), 
	well_status varchar(2), 
	document_number integer, 
	test_type varchar(24), 
	test_date date, 
	test_year smallint, 
	test_month smallint, 
	facility_id integer, 
	facility_type varchar(25), 
	facility_status varchar(2), 
	operator_name varchar(50), 
	operator_number integer, 
	operator_address varchar(60), 
	operator_contact varchar(30), 
	date_submitted date, 
	mit_assigned_by varchar(30), 
	date_received date, 
	field_rep varchar(30), 
	approved_date date, 
	approved_by varchar(30), 
	condition_of_approval varchar(500), 
	last_approved_mit date, 
	qtrqtr varchar(4), 
	section varchar(2), 
	township varchar(4), 
	range varchar(4), 
	meridian varchar(1), 
	formation_zones varchar(6), 
	repair_type varchar(30), 
	repair_description varchar(750), 
	perforation_interval varchar(30), 
	open_hole_interval varchar(30), 
	plug_depth integer, 
	tubing_size varchar(6), 
	tubing_depth varchar(6), 
	top_packer_depth varchar(6), 
	multiple_packers boolean, 
	ten_min_case_psi integer, 
	five_min_case_psi integer, 
	case_before_psi integer, 
	final_case_psi integer, 
	final_tube_psi integer, 
	initial_tube_psi integer,  
	loss_gain_psi integer, 
	start_case_psi integer, 
	created_at timestamp, 
	updated_at timestamp
);

copy mechanical_integrity_tests from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/mechanical_integrity_tests.csv' (format csv, delimiter ',', null '');

alter table mechanical_integrity_tests add primary key (id);

create index index_mechanical_integrity_tests_on_well_id on mechanical_integrity_tests (well_id);
create index index_mechanical_integrity_tests_on_well_api_number on mechanical_integrity_tests (well_api_number);
create index index_mechanical_integrity_tests_on_well_status on mechanical_integrity_tests (well_status);
create index index_mechanical_integrity_tests_on_test_date on mechanical_integrity_tests (test_date);
create index index_mechanical_integrity_tests_on_test_year on mechanical_integrity_tests (test_year);
create index index_mechanical_integrity_tests_on_test_month on mechanical_integrity_tests (test_month);



---------------------------------------------------------------
------------------  SPILLS/RELEASES  --------------------------
---------------------------------------------------------------
set search_path to import;

drop table spill_releases;

create table spill_releases (id serial primary key not null, submit_date varchar(10), document_number integer, document_url varchar(100), fac_id_api_num varchar(20), facility_id varchar(20), api_number varchar(20), operator_number varchar(20), company_name varchar(100), ground_water varchar(1), surface_water varchar(1), berm_contained varchar(1), spill_area varchar(20), facility_status varchar(10), facility_name_no varchar(100), status_date varchar(10), county_name varchar(50), county_fips varchar(3), location varchar(100), latitude double precision, longitude double precision, comment varchar(2500), date_received varchar(10), report_taken_by varchar(100), operator_address varchar(250), operator_phone varchar(30), operator_fax varchar(30), operator_contact varchar(50), incident_date varchar(10), facility_type varchar(30), well_name_no varchar(250), qtr_qtr varchar(10), section varchar(10), township varchar(10),	range varchar(10), meridian varchar(10), oil_spilled varchar(20), oil_recovered varchar(20), water_spilled varchar(20), water_recovered varchar(20), other_spilled varchar(20), other_recovered varchar(20), condensate_spilled varchar(20), flow_back_spilled varchar(20), produced_water_spilled varchar(20), drilling_fluid_spilled varchar(20), current_land_use varchar(100), weather_conditions varchar(100), soil_geology_description varchar(750), distance_to_surface_water varchar(20), depth_to_ground_water varchar(20), wetlands varchar(20), buildings varchar(20), livestock varchar(20), water_wells varchar(20), spill_cause text, immediate_response varchar(2500), emergency_pits varchar(1000), extent_determination text, further_remediation varchar(2500), problem_prevention varchar(2500), detailed_description text, additional_details text, resolution_date varchar(12), case_closed varchar(1), letter_sent varchar(1), cogcc_person varchar(50), final_resolution text, created_at timestamp, updated_at timestamp, details_scraped boolean default false, in_use boolean default false, invalid_text boolean default false);

create table spill_releases (
	id integer, 
	submit_date varchar(10), 
	document_number integer, 
	document_url varchar(100), 
	fac_id_api_num varchar(20), 
	facility_id varchar(20), 
	api_number varchar(20), 
	operator_number varchar(20), 
	company_name varchar(100), 
	ground_water varchar(1), 
	surface_water varchar(1), 
	berm_contained varchar(1), 
	spill_area varchar(20), 
	facility_status varchar(10), 
	facility_name_no varchar(100), 
	status_date varchar(10), 
	county_name varchar(50), 
	county_fips varchar(3), 
	location varchar(100), 
	latitude double precision, 
	longitude double precision, 
	comment varchar(2500), 
	date_received varchar(10), 
	report_taken_by varchar(100), 
	operator_address varchar(250), 
	operator_phone varchar(30), 
	operator_fax varchar(30), 
	operator_contact varchar(50), 
	incident_date varchar(10), 
	facility_type varchar(30), 
	well_name_no varchar(60), 
	qtr_qtr varchar(10), 
	section varchar(10), 
	township varchar(10),	
	range varchar(10), 
	meridian varchar(10), 
	oil_spilled varchar(20), 
	oil_recovered varchar(20), 
	water_spilled varchar(20), 
	water_recovered varchar(20), 
	other_spilled varchar(20), 
	other_recovered varchar(20), 
	condensate_spilled varchar(20), 
	flow_back_spilled varchar(20), 
	produced_water_spilled varchar(20), 
	drilling_fluid_spilled varchar(20), 
	current_land_use varchar(100), 
	weather_conditions varchar(100), 
	soil_geology_description varchar(750), 
	distance_to_surface_water varchar(20), 
	depth_to_ground_water varchar(20), 
	wetlands varchar(20), 
	buildings varchar(20), 
	livestock varchar(20), 
	water_wells varchar(20), 
	spill_cause text, 
	immediate_response varchar(2500), 
	emergency_pits varchar(1000), 
	extent_determination text, 
	further_remediation varchar(2500), 
	problem_prevention varchar(2500), 
	detailed_description text, 
	additional_details text, 
	resolution_date varchar(12), 
	case_closed varchar(1), 
	letter_sent varchar(1), 
	cogcc_person varchar(50), 
	final_resolution text, 
	created_at timestamp, 
	updated_at timestamp, 
	details_scraped boolean default false, 
	in_use boolean default false, 
	invalid_text boolean default false
);

-- run scrape/import scripts


-- now import/scrape pdf reports
set search_path to import;
alter table spill_releases add documents_indexed boolean not null default false;
update spill_releases set in_use = 'f' where in_use is true;
alter table 
drop table spill_release_documents;
create table spill_release_documents (
	id serial not null primary key, 
	spill_release_id integer, 
	facility_id integer, 
	document_id integer, 
	document_number integer, 
	document_name varchar(500), 
	document_date varchar(20), 
	download_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp
); 

-- run ruby script to catalog spill documents

alter table spill_release_documents add primary_document boolean not null default false;

update spill_release_documents set primary_document = 'true' where id = (select d.id from spill_release_documents d where d.facility_id = spill_release_documents.facility_id and (d.document_name ilike 'FORM 19%' or d.document_name ilike 'SPILL/RELEASE REPORT%') order by d.document_date desc limit 1);

alter table spill_release_documents add in_use boolean not null default false;
alter table spill_release_documents add document_downloaded boolean not null default false;

-- run ruby script to download pdfs

-- convert pdfs to text docs

-- parse with sql

alter table spill_releases add pdf_sourced boolean not null default false;

alter table spill_release_documents add text_imported boolean not null default false;
alter table spill_release_documents add report_text text;

-- run text import script

alter table spill_release_documents add is_rev_8_13 boolean not null default false;
update spill_release_documents set is_rev_8_13 = 't' where report_text ilike '%Rev 8/13%'; --1062/1063
update spill_releases set pdf_sourced = 't' where id in (select spill_release_id from spill_release_documents where is_rev_8_13 is true);


-- detailed_description
select spill_release_id, trim(regexp_replace(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(report_text, 'Describe what is known about the spill/release event (what happened -- including how it was stopped, contained, and recovered):', 2),  'I hereby certify all statements made in this form are to the best of my knowledge true, correct, and complete.', 1), 'COA Type Description', 1), 'OPERATOR COMMENTS:', 1), 'SPILL/RELEASE DETAIL REPORTS', 1), 'Attachment Check List', 1), 'User Group Comment', 1), 'By field measurements and mapping with a Trimble GPS unit.', 1), 'Rentsac channery loam', 1), 'Soil/Geology Description:', 1), 'Surface Area Impacted: Length of Impact (feet):', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(report_text, 'Describe what is known about the spill/release event (what happened -- including how it was stopped, contained, and recovered):', 2),  'I hereby certify all statements made in this form are to the best of my knowledge true, correct, and complete.', 1), 'COA Type Description', 1), 'OPERATOR COMMENTS:', 1), 'SPILL/RELEASE DETAIL REPORTS', 1), 'Attachment Check List', 1), 'User Group Comment', 1), 'By field measurements and mapping with a Trimble GPS unit.', 1), 'Rentsac channery loam', 1), 'Soil/Geology Description:', 1), 'Surface Area Impacted: Length of Impact (feet):', 1), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set detailed_description = (select trim(regexp_replace(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(split_part(report_text, 'Describe what is known about the spill/release event (what happened -- including how it was stopped, contained, and recovered):', 2),  'I hereby certify all statements made in this form are to the best of my knowledge true, correct, and complete.', 1), 'COA Type Description', 1), 'OPERATOR COMMENTS:', 1), 'SPILL/RELEASE DETAIL REPORTS', 1), 'Attachment Check List', 1), 'User Group Comment', 1), 'By field measurements and mapping with a Trimble GPS unit.', 1), 'Rentsac channery loam', 1), 'Soil/Geology Description:', 1), 'Surface Area Impacted: Length of Impact (feet):', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- spill_cause
select spill_release_id, trim(regexp_replace(split_part(split_part(report_text, 'Describe Incident & Root Cause (include specific equipment and point of failure)', 2),  'Describe measures taken to prevent the problem(s) from reoccurring:', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(split_part(split_part(report_text, 'Describe Incident & Root Cause (include specific equipment and point of failure)', 2),  'Describe measures taken to prevent the problem(s) from reoccurring:', 1), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
alter table spill_releases alter column spill_cause type text;
update spill_releases set spill_cause = (select trim(regexp_replace(split_part(split_part(report_text, 'Describe Incident & Root Cause (include specific equipment and point of failure)', 2),  'Describe measures taken to prevent the problem(s) from reoccurring:', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- problem_prevention
select spill_release_id, trim(regexp_replace(split_part(split_part(report_text, 'Describe measures taken to prevent the problem(s) from reoccurring:', 2),  'Volume of Soil Excavated (cubic yards):', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(split_part(split_part(report_text, 'Describe measures taken to prevent the problem(s) from reoccurring:', 2),  'Volume of Soil Excavated (cubic yards):', 1), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
alter table spill_releases alter column problem_prevention type varchar(1500);
update spill_releases set problem_prevention = (select trim(regexp_replace(split_part(split_part(report_text, 'Describe measures taken to prevent the problem(s) from reoccurring:', 2),  'Volume of Soil Excavated (cubic yards):', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- additional_details
select spill_release_id, trim(regexp_replace(split_part(split_part(split_part(split_part(split_part(report_text, 'Additional Spill Details Not Provided Above:', 2),  'Unknown', 1), 'None None', 1), 'CORRECTIVE ACTIONS', 1), 'None Springs None', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
alter table spill_releases add additional_details text;
update spill_releases set additional_details = (select trim(regexp_replace(split_part(split_part(split_part(split_part(split_part(report_text, 'Additional Spill Details Not Provided Above:', 2),  'Unknown', 1), 'None None', 1), 'CORRECTIVE ACTIONS', 1), 'None Springs None', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- depth_to_ground_water
select spill_release_id, trim(regexp_replace(split_part(split_part(report_text, 'Depth to Groundwater (feet BGS)', 2),  'Number Water Wells within 1/2 mile radius:', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set depth_to_ground_water = (select trim(regexp_replace(split_part(split_part(report_text, 'Depth to Groundwater (feet BGS)', 2),  'Number Water Wells within 1/2 mile radius:', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- water_wells
select spill_release_id, trim(regexp_replace(split_part(split_part(report_text, 'Number Water Wells within 1/2 mile radius:', 2), E'\n', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set water_wells = (select trim(regexp_replace(split_part(split_part(report_text, 'Number Water Wells within 1/2 mile radius:', 2), E'\n', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- soil_geology_description
select spill_release_id, trim(regexp_replace(split_part(split_part(split_part(report_text, 'Soil/Geology Description:', 2), 'Depth to Groundwater', 1), 'Unknown', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(split_part(split_part(split_part(report_text, 'Soil/Geology Description:', 2), 'Depth to Groundwater', 1), 'Unknown', 1), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set soil_geology_description = (select trim(regexp_replace(split_part(split_part(split_part(report_text, 'Soil/Geology Description:', 2), 'Depth to Groundwater', 1), 'Unknown', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- extent_determination
select spill_release_id, trim(regexp_replace(replace(split_part(split_part(split_part(report_text, 'How was extent determined?', 2), 'Soil/Geology Description:', 1), 'Was an Emergency Pit constructed?', 1), 'Unknown', ''), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(replace(split_part(split_part(split_part(report_text, 'How was extent determined?', 2), 'Soil/Geology Description:', 1), 'Was an Emergency Pit constructed?', 1), 'Unknown', ''), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set extent_determination = (select trim(regexp_replace(replace(split_part(split_part(split_part(report_text, 'How was extent determined?', 2), 'Soil/Geology Description:', 1), 'Was an Emergency Pit constructed?', 1), 'Unknown', ''), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- weather_conditions
select spill_release_id, trim(regexp_replace(split_part(split_part(report_text, 'Weather Condition:', 2), E'\n', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(regexp_replace(split_part(split_part(report_text, 'Weather Condition:', 2), E'\n', 1), '[\r\n]+', ' ', 'g')))) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set weather_conditions = (select trim(regexp_replace(split_part(split_part(report_text, 'Weather Condition:', 2), E'\n', 1), '[\r\n]+', ' ', 'g')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;

-- current_land_use
select spill_release_id, trim(replace(regexp_replace(split_part(split_part(split_part(report_text, 'Current Land Use:', 2), 'Land Use:', 2), 'Weather Condition:', 1), '[\r\n]+', ' ', 'g'), 'Other(Specify):', '')) from spill_release_documents where is_rev_8_13 is true;
select max(length(trim(replace(regexp_replace(split_part(split_part(split_part(report_text, 'Current Land Use:', 2), 'Land Use:', 2), 'Weather Condition:', 1), '[\r\n]+', ' ', 'g'), 'Other(Specify):', '')))) from spill_release_documents where is_rev_8_13 is true;
update spill_releases set current_land_use = (select trim(replace(regexp_replace(split_part(split_part(split_part(report_text, 'Current Land Use:', 2), 'Land Use:', 2), 'Weather Condition:', 1), '[\r\n]+', ' ', 'g'), 'Other(Specify):', '')) from spill_release_documents where is_rev_8_13 is true and spill_release_id = spill_releases.id) where pdf_sourced is true;


set search_path to import;
drop table staging.spill_releases;
create table staging.spill_releases as table spill_releases;

-- clean up data records
set search_path to staging;

update spill_releases set submit_date = trim(submit_date);
update spill_releases set submit_date = null where submit_date = ''; --0
alter table spill_releases alter column submit_date type date using submit_date::date;

alter table spill_releases add column submit_year smallint;
alter table spill_releases add column submit_month smallint;
update spill_releases set submit_year = extract(year from submit_date) where submit_date is not null;
update spill_releases set submit_month = extract(month from submit_date) where submit_date is not null;

update spill_releases set document_url = trim(document_url);
update spill_releases set document_url = null where document_url = ''; --0
alter table spill_releases alter column document_url type varchar(60);

update spill_releases set fac_id_api_num = trim(fac_id_api_num);
update spill_releases set fac_id_api_num = null where fac_id_api_num = ''; --780
alter table spill_releases alter column fac_id_api_num type varchar(9);

update spill_releases set facility_id = trim(facility_id);
update spill_releases set facility_id = null where facility_id = ''; --810
alter table spill_releases alter column facility_id type integer using facility_id::integer;

update spill_releases set api_number = trim(api_number);
update spill_releases set api_number = null where api_number = ''; --0
alter table spill_releases alter column api_number type varchar(12);

update spill_releases set operator_number = trim(operator_number);
update spill_releases set operator_number = null where operator_number = ''; --278
alter table spill_releases alter column operator_number type integer using operator_number::integer;

update spill_releases set company_name = upper(trim(company_name));
update spill_releases set company_name = null where company_name = ''; --278
alter table spill_releases alter column company_name type varchar(50);

update spill_releases set ground_water = trim(ground_water);
update spill_releases set ground_water = null where ground_water = ''; --1734
alter table spill_releases alter column ground_water type boolean using ground_water::boolean;

update spill_releases set surface_water = trim(surface_water);
update spill_releases set surface_water = null where surface_water = ''; --1927
alter table spill_releases alter column surface_water type boolean using surface_water::boolean;

update spill_releases set berm_contained = trim(berm_contained);
update spill_releases set berm_contained = null where berm_contained = ''; --1775
alter table spill_releases alter column berm_contained type boolean using berm_contained::boolean;

update spill_releases set spill_area = trim(spill_area);
update spill_releases set spill_area = null where spill_area = ''; --5218
alter table spill_releases alter column spill_area type integer using spill_area::integer;

update spill_releases set facility_status = upper(trim(facility_status));
update spill_releases set facility_status = null where facility_status = ''; --0
alter table spill_releases alter column facility_status type varchar(2);

update spill_releases set facility_name_no = trim(facility_name_no);
update spill_releases set facility_name_no = null where facility_name_no = ''; --0
alter table spill_releases alter column facility_name_no type varchar(30);

update spill_releases set status_date = trim(status_date);
update spill_releases set status_date = null where status_date = ''; --0
alter table spill_releases alter column status_date type date using status_date::date;

update spill_releases set county_name = upper(trim(county_name));
update spill_releases set county_name = null where county_name = ''; --0
alter table spill_releases alter column county_name type varchar(10);

update spill_releases set county_fips = trim(county_fips);
update spill_releases set county_fips = null where county_fips = ''; --0

update spill_releases set location = upper(trim(location));
update spill_releases set location = null where location = ''; --0
alter table spill_releases alter column location type varchar(30);

update spill_releases set comment = trim(comment);
update spill_releases set comment = null where comment = ''; --1035
alter table spill_releases alter column comment type varchar(750);

update spill_releases set date_received = trim(date_received);
update spill_releases set date_received = null where date_received = ''; --0
alter table spill_releases alter column date_received type date using date_received::date;

update spill_releases set report_taken_by = trim(report_taken_by);
update spill_releases set report_taken_by = null where report_taken_by = ''; --20
alter table spill_releases alter column report_taken_by type varchar(30);

update spill_releases set operator_address = upper(trim(operator_address));
update spill_releases set operator_address = null where operator_address = ''; --0
update spill_releases set operator_address = null where operator_address = ','; --62
update spill_releases set operator_address = null where operator_address = ', CO'; --1
alter table spill_releases alter column operator_address type varchar(150);

update spill_releases set operator_phone = trim(operator_phone);
update spill_releases set operator_phone = null where operator_phone = ''; --0
update spill_releases set operator_phone = null where operator_phone = '()'; --744
alter table spill_releases alter column operator_phone type varchar(20);

update spill_releases set operator_contact = upper(trim(operator_contact));
update spill_releases set operator_contact = null where operator_contact = ''; --926
alter table spill_releases alter column operator_contact type varchar(50);

update spill_releases set incident_date = trim(incident_date);
update spill_releases set incident_date = null where incident_date = ''; --0
update spill_releases set incident_date = null where incident_date = 'N/A'; --129
alter table spill_releases alter column incident_date type date using incident_date::date;

update spill_releases set facility_type = upper(trim(facility_type));
update spill_releases set facility_type = null where facility_type = ''; --1337
alter table spill_releases alter column facility_type type varchar(30);

update spill_releases set well_name_no = upper(trim(well_name_no));
update spill_releases set well_name_no = null where well_name_no = ''; --910
alter table spill_releases alter column well_name_no type varchar(60);

update spill_releases set qtr_qtr = upper(trim(qtr_qtr));
update spill_releases set qtr_qtr = null where qtr_qtr = ''; --204
alter table spill_releases alter column qtr_qtr type varchar(6);

update spill_releases set section = upper(trim(section));
update spill_releases set section = null where section = ''; --65
alter table spill_releases alter column section type varchar(2);

update spill_releases set township = upper(trim(township));
update spill_releases set township = null where township = ''; --57
alter table spill_releases alter column township type varchar(5);

update spill_releases set range = upper(trim(range));
update spill_releases set range = null where range = ''; --56
alter table spill_releases alter column range type varchar(5);

update spill_releases set meridian = upper(trim(meridian));
update spill_releases set meridian = null where meridian = ''; --306
alter table spill_releases alter column meridian type varchar(1);

update spill_releases set oil_spilled = trim(oil_spilled);
update spill_releases set oil_spilled = null where oil_spilled = ''; --3353
alter table spill_releases alter column oil_spilled type integer using oil_spilled::integer;

update spill_releases set oil_recovered = trim(oil_recovered);
update spill_releases set oil_recovered = null where oil_recovered = ''; --3853
alter table spill_releases alter column oil_recovered type integer using oil_recovered::integer;

update spill_releases set water_spilled = trim(water_spilled);
update spill_releases set water_spilled = null where water_spilled = ''; --2453
alter table spill_releases alter column water_spilled type integer using water_spilled::integer;

update spill_releases set water_recovered = trim(water_recovered);
update spill_releases set water_recovered = null where water_recovered = ''; --2506
alter table spill_releases alter column water_recovered type integer using water_recovered::integer;

update spill_releases set other_spilled = trim(other_spilled);
update spill_releases set other_spilled = null where other_spilled = ''; --4388
alter table spill_releases alter column other_spilled type integer using other_spilled::integer;

update spill_releases set other_recovered = trim(other_recovered);
update spill_releases set other_recovered = null where other_recovered = ''; --4739
alter table spill_releases alter column other_recovered type integer using other_recovered::integer;

-- all condensate_spilled values are null??
update spill_releases set condensate_spilled = trim(condensate_spilled);
update spill_releases set condensate_spilled = null where condensate_spilled = ''; --
alter table spill_releases alter column condensate_spilled type integer using condensate_spilled::integer;

-- all flow_back_spilled values are null??
update spill_releases set flow_back_spilled = trim(flow_back_spilled);
update spill_releases set flow_back_spilled = null where flow_back_spilled = ''; --
alter table spill_releases alter column flow_back_spilled type integer using flow_back_spilled::integer;

-- all produced_water_spilled values are null??
update spill_releases set produced_water_spilled = trim(produced_water_spilled);
update spill_releases set produced_water_spilled = null where produced_water_spilled = ''; --
alter table spill_releases alter column produced_water_spilled type integer using produced_water_spilled::integer;

-- all drilling_fluid_spilled values are null??
update spill_releases set drilling_fluid_spilled = trim(drilling_fluid_spilled);
update spill_releases set drilling_fluid_spilled = null where drilling_fluid_spilled = ''; --
alter table spill_releases alter column drilling_fluid_spilled type integer using drilling_fluid_spilled::integer;

update spill_releases set current_land_use = upper(trim(current_land_use));
update spill_releases set current_land_use = null where current_land_use = ''; --1966
alter table spill_releases alter column current_land_use type varchar(50);

update spill_releases set weather_conditions = upper(trim(weather_conditions));
update spill_releases set weather_conditions = null where weather_conditions = ''; --2609
alter table spill_releases alter column weather_conditions type varchar(35);

update spill_releases set soil_geology_description = upper(trim(soil_geology_description));
update spill_releases set soil_geology_description = null where soil_geology_description = ''; --2941

update spill_releases set distance_to_surface_water = trim(distance_to_surface_water);
update spill_releases set distance_to_surface_water = null where distance_to_surface_water = ''; --3279
alter table spill_releases alter column distance_to_surface_water type integer using distance_to_surface_water::integer;

update spill_releases set depth_to_ground_water = trim(depth_to_ground_water);
update spill_releases set depth_to_ground_water = null where depth_to_ground_water = ''; --4698
alter table spill_releases alter column depth_to_ground_water type integer using depth_to_ground_water::integer;

update spill_releases set wetlands = trim(wetlands);
update spill_releases set wetlands = null where wetlands = ''; --5379
alter table spill_releases alter column wetlands type integer using wetlands::integer;

update spill_releases set buildings = trim(buildings);
update spill_releases set buildings = null where buildings = ''; --4094
alter table spill_releases alter column buildings type integer using buildings::integer;

update spill_releases set livestock = trim(livestock);
update spill_releases set livestock = null where livestock = ''; --5755
alter table spill_releases alter column livestock type integer using livestock::integer;

update spill_releases set water_wells = trim(water_wells);
update spill_releases set water_wells = null where water_wells = ''; --4239
alter table spill_releases alter column water_wells type integer using water_wells::integer;

update spill_releases set spill_cause = upper(trim(spill_cause));
update spill_releases set spill_cause = null where spill_cause = ''; --993

update spill_releases set immediate_response = upper(trim(immediate_response));
update spill_releases set immediate_response = null where immediate_response = ''; --1564
alter table spill_releases alter column immediate_response type varchar(1500);

update spill_releases set emergency_pits = upper(trim(emergency_pits));
update spill_releases set emergency_pits = null where emergency_pits = ''; --2018
alter table spill_releases alter column emergency_pits type varchar(500);

update spill_releases set extent_determination = upper(trim(extent_determination));
update spill_releases set extent_determination = null where extent_determination = ''; --2303

update spill_releases set further_remediation = upper(trim(further_remediation));
update spill_releases set further_remediation = null where further_remediation = ''; --1941
alter table spill_releases alter column further_remediation type varchar(1500);

update spill_releases set problem_prevention = upper(trim(problem_prevention));
update spill_releases set problem_prevention = null where problem_prevention = ''; --2302
alter table spill_releases alter column problem_prevention type varchar(1500);

update spill_releases set detailed_description = upper(trim(detailed_description));
update spill_releases set detailed_description = null where detailed_description = ''; --1

update spill_releases set resolution_date = trim(resolution_date);
update spill_releases set resolution_date = null where resolution_date = ''; --0
update spill_releases set resolution_date = null where resolution_date = 'N/A'; --423
alter table spill_releases alter column resolution_date type date using resolution_date::date;

update spill_releases set case_closed = trim(case_closed);
update spill_releases set case_closed = null where case_closed = ''; --2
alter table spill_releases alter column case_closed type boolean using case_closed::boolean;

update spill_releases set letter_sent = trim(letter_sent);
update spill_releases set letter_sent = null where letter_sent = ''; --1394
alter table spill_releases alter column letter_sent type boolean using letter_sent::boolean;

update spill_releases set cogcc_person = trim(cogcc_person);
update spill_releases set cogcc_person = null where cogcc_person = ''; --566
alter table spill_releases alter column cogcc_person type varchar(30);

update spill_releases set final_resolution = upper(trim(final_resolution));
update spill_releases set final_resolution = null where final_resolution = ''; --1120

update spill_releases set additional_details = upper(trim(additional_details));
update spill_releases set additional_details = null where additional_details = ''; --893


alter table spill_releases add column well_id integer;
update spill_releases set well_id = replace(right(api_number,9),'-','')::integer where length(api_number) = 12; --5576



set search_path to staging;
COPY (select id, submit_date, submit_year, submit_month, document_number, document_url, well_id, api_number, well_name_no, county_name, county_fips, latitude, longitude, facility_id, facility_type, facility_status, status_date, operator_number, operator_name, operator_address, operator_phone, operator_fax, operator_contact, location, qtr_qtr, section, township, range, meridian, comment, date_received, report_taken_by, incident_date, ground_water, surface_water, berm_contained, spill_area, oil_spilled, oil_recovered, water_spilled, water_recovered, other_spilled, other_recovered, current_land_use, weather_conditions, soil_geology_description, distance_to_surface_water, depth_to_ground_water, wetlands, buildings, livestock, water_wells, spill_cause, immediate_response, emergency_pits, extent_determination, further_remediation, problem_prevention, detailed_description, additional_details, resolution_date, case_closed, letter_sent, cogcc_person, final_resolution, created_at, updated_at from spill_releases order by submit_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2016/spill_releases.csv' WITH CSV; --7729



set search_path to public;
drop table backup.spill_releases;
create table backup.spill_releases as table spill_releases;
drop table spill_releases;
create table spill_releases (id integer, 
	submit_date date, 
	submit_year smallint, 
	submit_month smallint, 
	document_number integer, 
	document_url varchar(60),
	well_id integer,  
	api_number varchar(12), 
	well_name_no varchar(60), 
	county_name varchar(10), 
	county_fips varchar(3), 
	latitude double precision, 
	longitude double precision,
	facility_id integer, 
	facility_type varchar(30), 
	facility_status varchar(2), 
	status_date date, 
	operator_number integer, 
	operator_name varchar(50), 
	operator_address varchar(150), 
	operator_phone varchar(20), 
	operator_fax varchar(30), 
	operator_contact varchar(50), 
	location varchar(30), 
	qtr_qtr varchar(6), 
	section varchar(2), 
	township varchar(5),	
	range varchar(5), 
	meridian varchar(1), 
	comment varchar(750), 
	date_received date, 
	report_taken_by varchar(30), 
	incident_date date, 
	ground_water boolean, 
	surface_water boolean, 
	berm_contained boolean, 
	spill_area integer, 
	oil_spilled integer, 
	oil_recovered integer, 
	water_spilled integer, 
	water_recovered integer, 
	other_spilled integer, 
	other_recovered integer, 
	--condensate_spilled integer, 
	--flow_back_spilled integer, 
	--produced_water_spilled integer, 
	--drilling_fluid_spilled integer, 
	current_land_use varchar(50), 
	weather_conditions varchar(35), 
	soil_geology_description varchar(750), 
	distance_to_surface_water integer, 
	depth_to_ground_water integer, 
	wetlands integer, 
	buildings integer, 
	livestock integer, 
	water_wells integer, 
	spill_cause text, 
	immediate_response varchar(1500), 
	emergency_pits varchar(500), 
	extent_determination text, 
	further_remediation varchar(1500), 
	problem_prevention varchar(1500), 
	detailed_description text, 
	additional_details text, 
	resolution_date date, 
	case_closed boolean, 
	letter_sent boolean, 
	cogcc_person varchar(30), 
	final_resolution text, 
	created_at timestamp, 
	updated_at timestamp);

create table spill_releases (id integer, submit_date date, submit_year smallint, submit_month smallint, document_number integer, document_url varchar(60), well_id integer, api_number varchar(12), well_name_no varchar(60), county_name varchar(10), county_fips varchar(3), latitude double precision, longitude double precision, facility_id integer, facility_type varchar(30), facility_status varchar(2), status_date date, operator_number integer, operator_name varchar(50), operator_address varchar(150), operator_phone varchar(20), operator_fax varchar(30), operator_contact varchar(50), location varchar(30), qtr_qtr varchar(6), section varchar(2), township varchar(5), range varchar(5), meridian varchar(1), comment varchar(750), date_received date, report_taken_by varchar(30), incident_date date, ground_water boolean, surface_water boolean, berm_contained boolean, spill_area integer, oil_spilled integer, oil_recovered integer, water_spilled integer, water_recovered integer, other_spilled integer, other_recovered integer, current_land_use varchar(50), weather_conditions varchar(35), soil_geology_description varchar(750), distance_to_surface_water integer, depth_to_ground_water integer, wetlands integer, buildings integer, livestock integer, water_wells integer, spill_cause text, immediate_response varchar(1500), emergency_pits varchar(500), extent_determination text, further_remediation varchar(1500), problem_prevention varchar(1500), detailed_description text, additional_details text, resolution_date date, case_closed boolean, letter_sent boolean, cogcc_person varchar(30), final_resolution text, created_at timestamp, updated_at timestamp);

copy spill_releases from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/spill_releases_updated.csv' (format csv, delimiter ',', null ''); --7729

alter table spill_releases add primary key (id);

create index index_spill_releases_on_well_id on spill_releases (well_id);
create index index_spill_releases_on_api_number on spill_releases (api_number);
create index index_spill_releases_on_submit_date on spill_releases (submit_date);
create index index_spill_releases_on_submit_year on spill_releases (submit_year);
create index index_spill_releases_on_submit_month on spill_releases (submit_month);
create index index_spill_releases_on_incident_date on spill_releases (incident_date);
create index index_spill_releases_on_county_name on spill_releases (county_name);



select p.detailed_description as public_text, b.detailed_description as backup_text from public.spill_releases p inner join backup.spill_releases b on p.id = b.id where b.detailed_description is null and p.detailed_description is not null order by p.id;

current_land_use
weather_conditions
soil_geology_description
depth_to_ground_water
water_wells
spill_cause
extent_determination
problem_prevention
detailed_description
additional_details (new column)



---------------------------------------------------------------
---------------------  REMEDIATIONS  --------------------------
---------------------------------------------------------------
set search_path to import;

drop table remediations;
drop table remediation_media_details;

create table remediations (
	id serial primary key not null, 
	submit_date varchar(10), 
	received_date varchar(10), 
	assigned_by varchar(100), 
	document_number integer,
	document_type varchar(20),  
	document_url varchar(100),
	related_documents_url varchar(100), 
	api_number varchar(16), 
	project_number varchar(10),
	facility_type varchar(30),
	facility_id varchar(20),
	facility_name varchar(100),
	operator_name varchar(100),  
	operator_number varchar(20),
	operator_address varchar(250), 
	operator_contact varchar(50),
	county_name varchar(50), 
	qtr_qtr varchar(10),
	section varchar(10),
	township varchar(10),
	range varchar(10),
	meridian varchar(10), 
	fips_code varchar(3), 
	report_reason varchar(50),
	condition_cause varchar(100),
	potential_receptors text,
	initial_action text,
	source_removed text,
	how_remediate text,
	monitoring_plan text,
	reclamation_plan text,
	approval_conditions text, 
	created_at timestamp, 
	updated_at timestamp, 
	details_scraped boolean default false, 
	in_use boolean default false, 
	invalid_text boolean default false
);

create table remediation_media_details (
	id serial primary key not null, 
	remediation_id integer, 
	media varchar(50),
	impacted varchar(10),
	extent varchar(100),
	how_determined varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);


-- run scrape/import scripts

set search_path to import;
drop table staging.remediations;
drop table staging.remediation_media_details;
create table staging.remediations as table remediations;
create table staging.remediation_media_details as table remediation_media_details;

-- clean up data records
set search_path to staging;

update remediations set submit_date = trim(submit_date);
update remediations set submit_date = null where submit_date = ''; --0
alter table remediations alter column submit_date type date using submit_date::date;

alter table remediations add column submit_year smallint;
alter table remediations add column submit_month smallint;
update remediations set submit_year = extract(year from submit_date) where submit_date is not null;
update remediations set submit_month = extract(month from submit_date) where submit_date is not null;

update remediations set received_date = trim(received_date);
update remediations set received_date = null where received_date = ''; --4
alter table remediations alter column received_date type date using received_date::date;

update remediations set assigned_by = trim(assigned_by);
update remediations set assigned_by = null where assigned_by = ''; --0
alter table remediations alter column assigned_by type varchar(30);

update remediations set document_url = trim(document_url);
update remediations set document_url = null where document_url = ''; --0
alter table remediations alter column document_url type varchar(50);

update remediations set related_documents_url = trim(related_documents_url);
update remediations set related_documents_url = null where related_documents_url = ''; --0

update remediations set api_number = trim(api_number);
update remediations set api_number = null where api_number = ''; --0
alter table remediations alter column api_number type varchar(12);

alter table remediations add column well_id integer;
update remediations set well_id = replace(right(api_number,9),'-','')::integer where length(api_number) = 12; --

update remediations set project_number = trim(project_number);
update remediations set project_number = null where project_number = ''; --2
alter table remediations alter column project_number type integer using project_number::integer;

update remediations set facility_type = upper(trim(facility_type));
update remediations set facility_type = null where facility_type = ''; --192

update remediations set facility_id = trim(facility_id);
update remediations set facility_id = null where facility_id = ''; --192
select count(*) from remediations where length(facility_id) = 12;
select count(*) from remediations where length(facility_id) = 12 and api_number = facility_id;
select id, api_number, facility_id from remediations where facility_id ilike '%-%-%' and length(facility_id) > 8;
update remediations set api_number = '05-123-08562' where id = 1800;
select count(*) from remediations where facility_id ilike '%-%-%' and length(facility_id) < 5;
update remediations set facility_id = null where facility_id ilike '%-%-%';
alter table remediations alter column facility_id type integer using facility_id::integer;

update remediations set facility_name = upper(trim(facility_name));
update remediations set facility_name = null where facility_name = ''; --358
alter table remediations alter column facility_name type varchar(35);

update remediations set operator_name = upper(trim(operator_name));
update remediations set operator_name = null where operator_name = ''; --6
alter table remediations alter column operator_name type varchar(50);

update remediations set operator_number = trim(operator_number);
update remediations set operator_number = null where operator_number = ''; --83
alter table remediations alter column operator_number type integer using operator_number::integer;

-- operator_address needs cleaning
update remediations set operator_address = upper(trim(operator_address));
update remediations set operator_address = null where operator_address = ''; --0
alter table remediations alter column operator_address type varchar(100);

update remediations set operator_contact = upper(trim(operator_contact));
update remediations set operator_contact = null where operator_contact = ''; --760

update remediations set county_name = upper(trim(county_name));
update remediations set county_name = null where county_name = ''; --502
update remediations set county_name = null where county_name = 'UNDEFINED'; --35
alter table remediations alter column county_name type varchar(10);

update remediations set qtr_qtr = upper(trim(qtr_qtr));
update remediations set qtr_qtr = null where qtr_qtr = ''; --38
alter table remediations alter column qtr_qtr type varchar(6);

update remediations set section = upper(trim(section));
update remediations set section = null where section = ''; --19
alter table remediations alter column section type varchar(2);

update remediations set township = upper(trim(township));
update remediations set township = null where township = ''; --15
alter table remediations alter column township type varchar(5);

update remediations set range = upper(trim(range));
update remediations set range = null where range = ''; --15
alter table remediations alter column range type varchar(7);

update remediations set meridian = upper(trim(meridian));
update remediations set meridian = null where meridian = ''; --187
alter table remediations alter column meridian type varchar(1);

--fips_code all values are null??

update remediations set report_reason = upper(trim(report_reason));
update remediations set report_reason = null where report_reason = ''; --193
alter table remediations alter column report_reason type varchar(10);

update remediations set condition_cause = upper(trim(condition_cause));
update remediations set condition_cause = null where condition_cause = ''; --256
alter table remediations alter column condition_cause type varchar(30);

update remediations set potential_receptors = upper(trim(potential_receptors));
update remediations set potential_receptors = null where potential_receptors = ''; --799
alter table remediations alter column potential_receptors type varchar(100);

update remediations set initial_action = upper(trim(initial_action));
update remediations set initial_action = null where initial_action = ''; --7

update remediations set source_removed = upper(trim(source_removed));
update remediations set source_removed = null where source_removed = ''; --33

update remediations set how_remediate = upper(trim(how_remediate));
update remediations set how_remediate = null where how_remediate = ''; --11

update remediations set monitoring_plan = upper(trim(monitoring_plan));
update remediations set monitoring_plan = null where monitoring_plan = ''; --59

update remediations set reclamation_plan = upper(trim(reclamation_plan));
update remediations set reclamation_plan = null where reclamation_plan = ''; --6

update remediations set approval_conditions = trim(approval_conditions);
update remediations set approval_conditions = null where approval_conditions = ''; --245


update remediation_media_details set media = upper(trim(media));
update remediation_media_details set media = null where media = ''; --0
alter table remediation_media_details alter column media type varchar(13);

update remediation_media_details set impacted = trim(impacted);
update remediation_media_details set impacted = null where impacted = ''; --3436
alter table remediation_media_details alter column impacted type boolean using impacted::boolean;

update remediation_media_details set extent = upper(trim(extent));
update remediation_media_details set extent = null where extent = ''; --692
alter table remediation_media_details alter column extent type varchar(35);

update remediation_media_details set how_determined = upper(trim(how_determined));
update remediation_media_details set how_determined = null where how_determined = ''; --1097
alter table remediation_media_details alter column how_determined type varchar(35);

alter table remediations add column media varchar(50);
update remediations set media = (select array_to_string(array(select media from remediation_media_details where remediation_id = remediations.id), ' ~ '));

alter table remediations add column media_impacted boolean;
alter table remediations add column media_extent varchar(100) default 'see remediation media details table';
alter table remediations add column media_how_determined varchar(100) default 'see remediation media details table';

update remediations set media_impacted = (select impacted from remediation_media_details where remediation_id = remediations.id) where (select count(*) from remediation_media_details where remediation_id = remediations.id) < 2;
update remediations set media_extent = (select extent from remediation_media_details where remediation_id = remediations.id) where (select count(*) from remediation_media_details where remediation_id = remediations.id) < 2;
update remediations set media_how_determined = (select how_determined from remediation_media_details where remediation_id = remediations.id) where (select count(*) from remediation_media_details where remediation_id = remediations.id) < 2;


set search_path to staging;
COPY (select id, submit_date, submit_year, submit_month, document_number, project_number, report_reason, condition_cause, media, media_impacted, media_extent, media_how_determined, well_id, api_number, county_name, facility_id, facility_type, facility_name, operator_name, operator_number, operator_address, operator_contact, received_date, assigned_by, qtr_qtr, section, township, range, meridian, potential_receptors, initial_action, source_removed, how_remediate, monitoring_plan, reclamation_plan, approval_conditions, document_url, related_documents_url, created_at, updated_at from remediations order by submit_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/remediations.csv' WITH CSV;


set search_path to staging;
COPY (select id, remediation_id, media, impacted, extent, how_determined, created_at, updated_at from remediation_media_details order by remediation_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/remediation_media_details.csv' WITH CSV;


set search_path to public;
create table backup.remediations as table remediations;
drop table remediations;
create table remediations (
	id integer, 
	submit_date date, 
	submit_year smallint, 
	submit_month smallint, 
	document_number integer,
	project_number integer,
	report_reason varchar(10),
	condition_cause varchar(30), 
	media varchar(50),
	media_impacted boolean,
	media_extent varchar(100),
	media_how_determined varchar(100),
	well_id integer, 
	api_number varchar(12), 
	county_name varchar(10), 
	facility_id integer,
	facility_type varchar(30),
	facility_name varchar(35),
	operator_name varchar(50),  
	operator_number integer,
	operator_address varchar(100), 
	operator_contact varchar(50),
	received_date date, 
	assigned_by varchar(100), 
	qtr_qtr varchar(6),
	section varchar(2),
	township varchar(5),
	range varchar(7),
	meridian varchar(1), 
	potential_receptors varchar(100),
	initial_action text,
	source_removed text,
	how_remediate text,
	monitoring_plan text,
	reclamation_plan text,
	approval_conditions text, 
	document_url varchar(50),
	related_documents_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);

copy remediations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/remediations.csv' (format csv, delimiter ',', null '');

alter table remediations add primary key (id);

create index index_remediations_on_submit_date on remediations (submit_date);
create index index_remediations_on_submit_year on remediations (submit_year);
create index index_remediations_on_submit_month on remediations (submit_month);
create index index_remediations_on_well_id on remediations (well_id);
create index index_remediations_on_api_number on remediations (api_number);
create index index_remediations_on_county_name on remediations (county_name);



set search_path to public;
create table backup.remediation_media_details as table remediation_media_details;
drop table remediation_media_details;
create table remediation_media_details (
	id integer, 
	remediation_id integer, 
	media varchar(13),
	impacted boolean,
	extent varchar(100),
	how_determined varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);

copy remediation_media_details from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/remediation_media_details.csv' (format csv, delimiter ',', null '');

alter table remediation_media_details add primary key (id);

create index index_remediation_media_details_on_remediation_id on remediation_media_details (remediation_id);



---------------------------------------------------------------
----------------------  INSPECTIONS  --------------------------
---------------------------------------------------------------
set search_path to import;

drop table inspections;
drop table inspection_details;

create table inspections (
	id serial not null primary key,
	inspection_date varchar(12), 
	insp_year smallint, 
	insp_month smallint, 
	document_number integer, 
	document_id integer, 
	location_id integer, 
	api_number varchar(14), 
	inspection_type varchar(2), 
	status_code varchar(2), 
	overall_inspection_status varchar(30),
	overall_ir varchar(4), 
	overall_fr varchar(4), 
	reclamation varchar(1), 
	p_and_a varchar(1), 
	violation varchar(1), 
	details_scraped boolean not null default false, 
	created_at timestamp, 
	updated_at timestamp
);

create table inspection_details (
	id serial not null primary key,
	inspection_id integer, 
	api_number varchar(16), 
	facility_location_id varchar(16), 
	name varchar(100), 
	location varchar(100),
	lat varchar(30), 
	long varchar(30), 
	operator_number varchar(30), 
	operator_name varchar(100), 
	inspection_date varchar(12), 
	inspector varchar(100), 
	inspection_was varchar(100), 
	insp_type varchar(10), 
	insp_stat varchar(10),
	reclamation varchar(10), 
	p_and_a varchar(4), 
	brhd_pressure varchar(10), 
	inj_pressure varchar(10), 
	t_c_ann_pressure varchar(10), 
	uic_violation_type varchar(50), 
	violation varchar(10), 
	noav_sent varchar(10), 
	date_corrective_action_due varchar(20), 
	date_remedied varchar(20), 
	pit_type varchar(10), 
	oil_on_pit varchar(10), 
	freeboard varchar(10), 
	num_pits varchar(10), 
	num_covered_lined varchar(10), 
	num_uncovered_unlined varchar(10), 
	pit_comments varchar(5000), 
	action varchar(5000), 
	fencecomment varchar(5000), 
	firewall varchar(5000), 
	genhouse varchar(5000),
	historical varchar(5000), 
	misc varchar(5000),
	spilcom varchar(5000),
	surfrh varchar(5000), 
	tankbat varchar(5000), 
	uiccom varchar(5000), 
	wellsign varchar(5000),  
	workov varchar(5000), 
	related_facility_url varchar(100), 
	related_docs_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);

-- run script to import inspection records (inspection_scrape.rb)
-- run script to import inspection details (inspection_details_scrape.rb)


set search_path to import;
drop table staging.inspections;
drop table staging.inspection_details;
create table staging.inspections as table inspections;
create table staging.inspection_details as table inspection_details;


-- clean up data records
set search_path to staging;

update inspections set inspection_date = trim(inspection_date);
update inspections set inspection_date = null where inspection_date = ''; --
alter table inspections alter column inspection_date type date using inspection_date::date;

update inspections set insp_year = extract(year from inspection_date) where inspection_date is not null;
update inspections set insp_month = extract(month from inspection_date) where inspection_date is not null;

update inspections set api_number = trim(api_number);
update inspections set api_number = null where api_number = ''; --13546
alter table inspections alter column api_number type varchar(9);

alter table inspections add column well_id integer;
update inspections set well_id = replace(api_number,'-','')::integer where length(api_number) = 9;

update inspections set overall_inspection_status = trim(overall_inspection_status);
update inspections set overall_inspection_status = null where overall_inspection_status = ''; --51467
alter table inspections alter column overall_inspection_status type varchar(15);

update inspections set overall_ir = trim(overall_ir);
update inspections set overall_ir = null where overall_ir = ''; --104916
alter table inspections alter column overall_ir type varchar(4);

update inspections set overall_fr = trim(overall_fr);
update inspections set overall_fr = null where overall_fr = ''; --132282
alter table inspections alter column overall_fr type varchar(4);

update inspections set reclamation = upper(trim(reclamation));
update inspections set reclamation = null where reclamation = ''; --123858
alter table inspections alter column reclamation type varchar(1);

update inspections set p_and_a = upper(trim(p_and_a));
update inspections set p_and_a = null where p_and_a = ''; --59240
alter table inspections alter column p_and_a type varchar(1);

update inspections set violation = trim(violation);
update inspections set violation = null where violation = ''; --17541
alter table inspections alter column violation type boolean using violation::boolean;



---------------------------------------------------------------
------------------  INSPECTION DETAILS  -----------------------
---------------------------------------------------------------
update inspection_details set api_number = trim(api_number);
update inspection_details set api_number = null where api_number = ''; --
alter table inspection_details alter column api_number type varchar(12);

alter table inspection_details add column well_id integer;
update inspection_details set well_id = replace(right(api_number,9),'-','')::integer where length(api_number) = 12;

update inspection_details set facility_location_id = trim(facility_location_id);
update inspection_details set facility_location_id = null where facility_location_id = ''; --
alter table inspection_details rename column facility_location_id to facility_id;
alter table inspection_details alter column facility_id integer using facility_id::integer;

update inspection_details set name = trim(name);
update inspection_details set name = null where name = ''; --
alter table inspection_details alter column name type varchar(60);

update inspection_details set location = upper(trim(location));
update inspection_details set location = null where location = ''; --
alter table inspection_details alter column location type varchar(30);

update inspection_details set lat = trim(lat);
update inspection_details set lat = null where lat = ''; --
alter table inspection_details alter column lat type double precision using lat::double precision;

update inspection_details set long = trim(long);
update inspection_details set long = null where long = ''; --
alter table inspection_details alter column long type double precision using long::double precision;

update inspection_details set operator_number = trim(operator_number);
update inspection_details set operator_number = null where operator_number = ''; --
alter table inspection_details alter column operator_number integer using operator_number::integer;

update inspection_details set operator_name = upper(trim(operator_name));
update inspection_details set operator_name = null where operator_name = ''; --
alter table inspection_details alter column operator_name type varchar(50);

update inspection_details set inspection_date = trim(inspection_date);
update inspection_details set inspection_date = null where inspection_date = ''; --
alter table inspection_details alter column inspection_date type date using inspection_date::date;

alter table inspection_details add column insp_year smallint;
alter table inspection_details add column insp_month smallint;
update inspection_details set insp_year = extract(year from inspection_date) where inspection_date is not null;
update inspection_details set insp_month = extract(month from inspection_date) where inspection_date is not null;

update inspection_details set inspector = trim(inspector);
update inspection_details set inspector = null where inspector = ''; --
alter table inspection_details alter column inspector type varchar(50);

update inspection_details set inspection_was = trim(inspection_was);
update inspection_details set inspection_was = null where inspection_was = ''; --
alter table inspection_details alter column inspection_was type varchar(14);

update inspection_details set insp_type = upper(trim(insp_type));
update inspection_details set insp_type = null where insp_type = ''; --
alter table inspection_details alter column insp_type type varchar(2);

update inspection_details set insp_stat = upper(trim(insp_stat));
update inspection_details set insp_stat = null where insp_stat = ''; --
alter table inspection_details alter column insp_stat type varchar(2);

update inspection_details set reclamation = upper(trim(reclamation));
update inspection_details set reclamation = null where reclamation = ''; --
alter table inspection_details alter column reclamation type varchar(1);

update inspection_details set p_and_a = upper(trim(p_and_a));
update inspection_details set p_and_a = null where p_and_a = ''; --
alter table inspection_details alter column p_and_a type varchar(1);

update inspection_details set brhd_pressure = trim(brhd_pressure);
update inspection_details set brhd_pressure = null where brhd_pressure = ''; --
alter table inspection_details alter column brhd_pressure type integer using brhd_pressure::integer;

update inspection_details set inj_pressure = trim(inj_pressure);
update inspection_details set inj_pressure = null where inj_pressure = ''; --
alter table inspection_details alter column inj_pressure type integer using inj_pressure::integer;

update inspection_details set t_c_ann_pressure = trim(t_c_ann_pressure);
update inspection_details set t_c_ann_pressure = null where t_c_ann_pressure = ''; --
alter table inspection_details alter column t_c_ann_pressure type integer using t_c_ann_pressure::integer;

update inspection_details set uic_violation_type = upper(trim(uic_violation_type));
update inspection_details set uic_violation_type = null where uic_violation_type = ''; --
alter table inspection_details alter column uic_violation_type type varchar(2);

update inspection_details set violation = trim(violation);
update inspection_details set violation = null where violation = ''; --
alter table inspection_details alter column violation type boolean using violation::boolean;

update inspection_details set noav_sent = trim(noav_sent);
update inspection_details set noav_sent = null where noav_sent = ''; --
update inspection_details set noav_sent = 'N' where noav_sent = 'm'; --1
alter table inspection_details alter column noav_sent type boolean using noav_sent::boolean;

update inspection_details set date_corrective_action_due = trim(date_corrective_action_due);
update inspection_details set date_corrective_action_due = null where date_corrective_action_due = ''; --
alter table inspection_details alter column date_corrective_action_due type date using date_corrective_action_due::date;

update inspection_details set date_remedied = trim(date_remedied);
update inspection_details set date_remedied = null where date_remedied = ''; --
alter table inspection_details alter column date_remedied type date using date_remedied::date;

update inspection_details set pit_type = upper(trim(pit_type));
update inspection_details set pit_type = null where pit_type = ''; --
alter table inspection_details alter column pit_type type varchar(2);

update inspection_details set oil_on_pit = trim(oil_on_pit);
update inspection_details set oil_on_pit = null where oil_on_pit = ''; --
alter table inspection_details alter column oil_on_pit type boolean using oil_on_pit::boolean;

update inspection_details set pit_comments = trim(pit_comments);
update inspection_details set pit_comments = null where pit_comments = ''; --
alter table inspection_details alter column pit_comments type varchar(500);

update inspection_details set action = trim(action);
update inspection_details set action = null where action = ''; --
alter table inspection_details alter column action type varchar(2000);

update inspection_details set fencecomment = trim(fencecomment);
update inspection_details set fencecomment = null where fencecomment = ''; --
alter table inspection_details alter column fencecomment type varchar(250);

update inspection_details set firewall = trim(firewall);
update inspection_details set firewall = null where firewall = ''; --
alter table inspection_details alter column firewall type varchar(750);

update inspection_details set genhouse = trim(genhouse);
update inspection_details set genhouse = null where genhouse = ''; --
alter table inspection_details alter column genhouse type varchar(1250);

update inspection_details set historical = trim(historical);
update inspection_details set historical = null where historical = ''; --
alter table inspection_details alter column historical type varchar(500);

update inspection_details set misc = trim(misc);
update inspection_details set misc = null where misc = ''; --
alter table inspection_details alter column misc type varchar(2000);

update inspection_details set spilcom = trim(spilcom);
update inspection_details set spilcom = null where spilcom = ''; --
alter table inspection_details alter column spilcom type varchar(1250);

update inspection_details set surfrh = trim(surfrh);
update inspection_details set surfrh = null where surfrh = ''; --
alter table inspection_details alter column surfrh type varchar(1250);

update inspection_details set tankbat = trim(tankbat);
update inspection_details set tankbat = null where tankbat = ''; --
alter table inspection_details alter column tankbat type varchar(750);

update inspection_details set uiccom = trim(uiccom);
update inspection_details set uiccom = null where uiccom = ''; --
alter table inspection_details alter column uiccom type varchar(750);

update inspection_details set wellsign = trim(wellsign);
update inspection_details set wellsign = null where wellsign = ''; --
alter table inspection_details alter column wellsign type varchar(250);

update inspection_details set workov = trim(workov);
update inspection_details set workov = null where workov = ''; --
alter table inspection_details alter column workov type varchar(2000);

update inspection_details set related_facility_url = trim(related_facility_url);
update inspection_details set related_facility_url = null where related_facility_url = ''; --
alter table inspection_details alter column related_facility_url type varchar(50);

update inspection_details set related_docs_url = trim(related_docs_url);
update inspection_details set related_docs_url = null where related_docs_url = ''; --
alter table inspection_details alter column related_docs_url type varchar(100);


set search_path to staging;
COPY (select id, inspection_date, insp_year, insp_month, document_number, document_id, location_id, api_number, well_id, inspection_type, status_code, overall_inspection_status, overall_ir, overall_fr, reclamation, p_and_a, violation, created_at, updated_at from inspections order by inspection_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/inspections.csv' WITH CSV;


set search_path to public;
create table backup.inspections as table inspections;
drop table inspections;
create table inspections (
	id integer,
	inspection_date date, 
	insp_year smallint, 
	insp_month smallint, 
	document_number integer, 
	document_id integer, 
	location_id integer, 
	api_number varchar(9), 
	well_id integer, 
	inspection_type varchar(2), 
	status_code varchar(2), 
	overall_inspection_status varchar(15),
	overall_ir varchar(4), 
	overall_fr varchar(4), 
	reclamation varchar(1), 
	p_and_a varchar(1), 
	violation boolean, 
	created_at date, 
	updated_at date
);

copy inspections from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/inspections.csv' (format csv, delimiter ',', null '');

alter table inspections add primary key (id);

create index index_inspections_on_inspection_date on inspections (inspection_date);
create index index_inspections_on_insp_year on inspections (insp_year);
create index index_inspections_on_insp_month on inspections (insp_month);
create index index_inspections_on_inspection_type on inspections (inspection_type);
create index index_inspections_on_well_id on inspections (well_id);



set search_path to staging;
COPY (select id, inspection_id, api_number, well_id, facility_id, name, location, lat, long, operator_number, operator_name, inspection_date, insp_year, insp_month, inspector, inspection_was, insp_type, insp_stat, reclamation, p_and_a, brhd_pressure, inj_pressure, t_c_ann_pressure, uic_violation_type, violation, noav_sent, date_corrective_action_due, date_remedied, pit_type, oil_on_pit, num_pits, num_covered_lined, num_uncovered_unlined, pit_comments, action, fencecomment, firewall, genhouse, historical, misc, spilcom, surfrh, tankbat, uiccom, wellsign, workov, related_facility_url, related_docs_url, created_at, updated_at from inspection_details order by inspection_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/inspection_details.csv' WITH CSV;


set search_path to public;
create table backup.inspection_details as table inspection_details;
drop table inspection_details;
create table inspection_details (id integer, 
	inspection_id integer, 
	api_number character varying(12), 
	well_id integer, 
	facility_id integer, 
	name character varying(60), 
	location character varying(30), 
	lat double precision, 
	long double precision, 
	operator_number integer, 
	operator_name character varying(50), 
	inspection_date date, 
	insp_year smallint, 
	insp_month smallint, 
	inspector character varying(50), 
	inspection_was character varying(14),
	insp_type character varying(2), 
	insp_stat character varying(2), 
	reclamation character varying(1), 
	p_and_a character varying(1), 
	brhd_pressure integer, 
	inj_pressure integer, 
	t_c_ann_pressure integer, 
	uic_violation_type character varying(2), 
	violation boolean, 
	noav_sent boolean, 
	date_corrective_action_due date, 
	date_remedied date, 
	pit_type character varying(2), 
	oil_on_pit boolean, 
	num_pits smallint, 
	num_covered_lined smallint, 
	num_uncovered_unlined smallint, 
	pit_comments character varying(500), 
	action character varying(2000), 
	fencecomment character varying(250), 
	firewall character varying(750), 
	genhouse character varying(1250), 
	historical character varying(500), 
	misc character varying(2000), 
	spilcom character varying(1250), 
	surfrh character varying(1250), 
	tankbat character varying(750), 
	uiccom character varying(750), 
	wellsign character varying(250), 
	workov character varying(2000), 
	related_facility_url character varying(50), 
	related_docs_url character varying(100), 
	created_at timestamp, updated_at timestamp);

copy inspection_details from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/inspection_details.csv' (format csv, delimiter ',', null '');

alter table inspection_details add primary key (id);

create index index_inspection_details_on_inspection_id on inspection_details (inspection_id);
create index index_inspection_details_on_api_number on inspection_details (api_number);
create index index_inspection_details_on_facility_id on inspection_details (facility_id);
create index index_inspection_details_on_inspection_date on inspection_details (inspection_date);
create index index_inspection_details_on_insp_year on inspection_details (insp_year);
create index index_inspection_details_on_insp_month on inspection_details (insp_month);
create index index_inspection_details_on_well_id on inspection_details (well_id);


---------------------------------------------------------------
--------------------  INSPECTION TYPES  -----------------------
---------------------------------------------------------------
set search_path to public;
create table backup.inspection_types as table inspection_types;
drop table inspection_types;
create table inspection_types (
	id integer, 
	name varchar(2), 
	description varchar(50), 
	created_at date, 
	updated_at date
);
insert into inspection_types (id, name, description, created_at, updated_at) values (1, 'BH', 'Bradenhead Test Witnessed', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (2, 'CA', 'Cementing for Abandon. Witness', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (3, 'CC', 'Cementing of Casing Witnessed', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (4, 'CO', 'Inspection of Public Complaint', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (5, 'DG', 'Drilling Operation Inspection', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (6, 'ER', 'Emergency Response', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (7, 'ES', 'Environmental Issue or Spill', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (8, 'HR', 'Historical PA Surface Reclam', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (9, 'ID', 'Idle Producing Well Inspection', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (10, 'MI', 'MIT Injection Well', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (11, 'MT', 'SI/TA Prod Well MIT Test Witns', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (12, 'OI', '', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (13, 'PM', 'State-Funded Projects:  On-Site Project Management', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (14, 'PR', 'Producing Well Inspection', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (15, 'RT', 'Routine UIC Inspection', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (16, 'SR', 'New Surface Reclam Inspection', now(), now());
insert into inspection_types (id, name, description, created_at, updated_at) values (17, 'WS', '', now(), now());

alter table inspection_types add primary key (id);



---------------------------------------------------------------
---------------  ENVIRONMENTAL SAMPLE SITES  ------------------
---------------------------------------------------------------
set search_path to import;

drop table water_locations;
drop table water_samples;
drop table water_results;
drop table environmental_sample_sites;
drop table environmental_sample_results;

-- create data tables to match Access table designs
create table water_locations (
	facility_id integer not null,
	facility_type varchar(255),
	utm_x double precision,
	utm_y double precision,
	latitude double precision,
	longitude double precision,
	quarter_quarter varchar(8),
	section integer,
	township varchar(14),
	range varchar(8),
	meridian varchar(30),
	county varchar(255),
	permit_number varchar(255),
	receipt_number varchar(255), 
	well_depth integer
);

create table water_samples (
	sample_id integer not null,
	facility_id integer not null,
	sample_date varchar(11),
	matrix varchar(10),
	sample_reason varchar(255)
);

create table water_results (
	result_id integer not null,
	sample_id integer,
	method_code varchar(50),
	param_description varchar(100),
	result_value double precision,
	qualifier varchar(7),
	units varchar(15),
	fraction_type varchar(20),
	detection_limit double precision
);

-- copy statement to import data from CSVs
copy water_locations from '/Users/troyburke/Data/cogcc_query_database/downloads/WaterWellDownload_20151001/DL_Locations_20150831.txt' delimiters ',' csv; --6080
copy water_samples from '/Users/troyburke/Data/cogcc_query_database/downloads/WaterWellDownload_20151001/DL_Samples_20150831.txt' delimiters ',' csv; --20932
copy water_results from '/Users/troyburke/Data/cogcc_query_database/downloads/WaterWellDownload_20151001/DL_Results_20150831.txt' delimiters ',' csv; --506908


-- create table to hold sample site scrape data
create table environmental_sample_sites (
	id serial not null primary key, 
  sample_site_id integer, 
	facility_type varchar(30), 
	project_number varchar(35), 
	county varchar(100), 
	plss_location varchar(100), 
	elevation integer, 
	longitude varchar(20), 
	latitude varchar(20), 
	dwr_receipt_number varchar(30), 
	well_depth integer, 
	created_at timestamp,  
	updated_at timestamp
);

-- run import script

alter table environmental_sample_sites add column sample_results_imported boolean not null default false;
alter table environmental_sample_sites add column in_use boolean not null default false;


-- this table holds import of sample result csv files
create table environmental_sample_results (
	id serial not null primary key,
	environmental_sample_site_id integer, 
	sample_site_id integer, -- aka facility_id
	sample_id integer, 
	sample_date date, 
	matrix varchar(10), 
	lab_id varchar(30), 
	lab_sample_id varchar(30), 
	sampler varchar(100), 
	method_code varchar(50), 
	parameter_name varchar(50), 
	parameter_description varchar(100), 
	result_value varchar(30), 
	units varchar(20), 
	detection_limit varchar(20), 
	qualifier varchar(10), 
	created_at timestamp,  
	updated_at timestamp
);

-- run import script


-- copy import tables to staging schema
set search_path to import;
drop table staging.enviro_sample_sites;
drop table staging.enviro_sample_results;
drop table staging.water_locations;
drop table staging.water_samples;
drop table staging.water_results;
create table staging.enviro_sample_sites as table environmental_sample_sites;
create table staging.enviro_sample_results as table environmental_sample_results;
create table staging.water_locations as table water_locations;
create table staging.water_samples as table water_samples;
create table staging.water_results as table water_results;


set search_path to staging;

--clean up bad results records from scrape data
alter table enviro_sample_results add column bad_result_value boolean not null default false;
select sample_id, result_value from enviro_sample_results where left(result_value,1) not in ('-','0','1','2','3','4','5','6','7','8','9') or right(result_value,2) = 'NE'; --83
update enviro_sample_results set bad_result_value = 'true' where left(result_value,1) not in ('-','0','1','2','3','4','5','6','7','8','9') or right(result_value,2) = 'NE'; --83

alter table enviro_sample_results add column bad_detection_limit_value boolean not null default false;
select sample_id, detection_limit from enviro_sample_results where left(detection_limit,1) not in ('-','0','1','2','3','4','5','6','7','8','9'); --84
update enviro_sample_results set bad_detection_limit_value = 'true' where left(detection_limit,1) not in ('-','0','1','2','3','4','5','6','7','8','9'); --84

select distinct sample_id from enviro_sample_results where bad_result_value is true or bad_detection_limit_value is true order by sample_id; --16

update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-14.82', units = 'per mil', detection_limit = null where id = 607908;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-93.3', units = 'per mil VSMOW', detection_limit = null where id = 607909;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-13.9', units = 'per mil', detection_limit = null where id = 608360;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-98.3', units = 'per mil VSMOW', detection_limit = null where id = 608361;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-11.34', units = 'per mil', detection_limit = null where id = 608798;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-78.4', units = 'per mil VSMOW', detection_limit = null where id = 608799;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-6.04', units = 'per mil', detection_limit = null where id = 609020;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-42.9', units = 'per mil VSMOW', detection_limit = null where id = 609021;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-8.26', units = 'per mil', detection_limit = null where id = 609026;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-59.1', units = 'per mil VSMOW', detection_limit = null where id = 609027;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-8.23', units = 'per mil', detection_limit = null where id = 609064;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-27.8', units = 'per mil VSMOW', detection_limit = null where id = 609065;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-7.98', units = 'per mil', detection_limit = null where id = 610022;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-53.8', units = 'per mil VSMOW', detection_limit = null where id = 610023;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-6.52', units = 'per mil', detection_limit = null where id = 610142;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-47.7', units = 'per mil VSMOW', detection_limit = null where id = 610143;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-12.26', units = 'per mil', detection_limit = null where id = 611352;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-86.3', units = 'per mil VSMOW', detection_limit = null where id = 611353;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-6.8', units = 'per mil', detection_limit = null where id = 611819;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-40.5', units = 'per mil VSMOW', detection_limit = null where id = 611820;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-14.68', units = 'per mil', detection_limit = null where id = 612265;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-100.6', units = 'per mil VSMOW', detection_limit = null where id = 612266;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'delta18O_H2O', parameter_description = 'DELTA 18O H2O', result_value = '-7.26', units = 'per mil', detection_limit = null where id = 654397;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'deltaD_H2O', parameter_description = 'DELTA D H2O', result_value = '-31.3', units = 'per mil VSMOW', detection_limit = null where id = 654398;

update enviro_sample_results set method_code = 'UnSpec', parameter_name = 'Field_H2S', parameter_description = 'HYDROGEN SULFIDE FIELD', result_value = '0.1', units = 'mg/L', detection_limit = '0.1', qualifier = null where id = 84961;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '74-82-8', parameter_description = 'METHANE', result_value = '2.3', units = 'mg/L', detection_limit = null where id = 84979;

update enviro_sample_results set sampler = 'Wiepking-Fullteron Energy LLC', method_code = 'SW8015', parameter_name = '8006-61-9', parameter_description = 'TVPH - Gasoline Range Organics', result_value = '0.05', units = 'mg/L', detection_limit = '0.2', qualifier = null where id = 505885;
update enviro_sample_results set sampler = 'Wiepking-Fullteron Energy LLC', method_code = 'SW8015', parameter_name = '71-43-2', parameter_description = 'BENZENE', result_value = '0.25', units = 'ug/L', detection_limit = '1', qualifier = null where id = 505888;
update enviro_sample_results set sampler = 'Wiepking-Fullteron Energy LLC', method_code = 'SW8015', parameter_name = '100-41-4', parameter_description = 'ETHYLBENZENE', result_value = '0.31', units = 'ug/L', detection_limit = '2', qualifier = null where id = 505893;
update enviro_sample_results set sampler = 'Wiepking-Fullteron Energy LLC', method_code = 'SW8015', parameter_name = '108-88-3', parameter_description = 'TOLUENE', result_value = '1', units = 'ug/L', detection_limit = '2', qualifier = null where id = 505900;
update enviro_sample_results set sampler = 'Wiepking-Fullteron Energy LLC', method_code = 'SW8015', parameter_name = '1330-20-7', parameter_description = 'TOTAL XYLENES', result_value = '1.5', units = 'ug/L', detection_limit = '3', qualifier = null where id = 505905;

update enviro_sample_results set sampler = 'PDC Energy Inc.', method_code = 'SW8260', parameter_name = '71-43-2', parameter_description = 'BENZENE', result_value = '0.25', units = 'ug/L', detection_limit = '1', qualifier = null where id = 581000;
update enviro_sample_results set sampler = 'PDC Energy Inc.', method_code = 'SW8260', parameter_name = '100-41-4', parameter_description = 'ETHYLBENZENE', result_value = '0.31', units = 'ug/L', detection_limit = '1', qualifier = null where id = 581002;
update enviro_sample_results set sampler = 'PDC Energy Inc.', method_code = 'SW8260', parameter_name = '108-88-3', parameter_description = 'TOLUENE', result_value = '0.8', units = 'ug/L', detection_limit = '1', qualifier = null where id = 581005;
update enviro_sample_results set sampler = 'PDC Energy Inc.', method_code = 'SW8260', parameter_name = '1330-20-7', parameter_description = 'TOTAL XYLENES', result_value = '0.89', units = 'ug/L', detection_limit = '2', qualifier = null where id = 581006;

update enviro_sample_results set method_code = 'UnSpec', parameter_name = '630-20-6', parameter_description = '1 1 1 2-TETRACHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670560;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '71-55-6', parameter_description = '1 1 1-TRICHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670561;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '79-34-5', parameter_description = '1 1 2 2-TETRACHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670562;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '79-00-5', parameter_description = '1 1 2-TRICHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670563;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-34-3', parameter_description = '1 1-DICHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670564;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '563-58-6', parameter_description = '1 1-DICHLOROPROPENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670565;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '87-61-6', parameter_description = '1 2 3-TRICHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670566;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '96-18-4', parameter_description = '1 2 3-TRICHLOROPROPANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670567;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '120-82-1', parameter_description = '1 2 4-TRICHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670568;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '95-63-6', parameter_description = '1 2 4-TRIMETHYLBENZENE', result_value = '17', units = 'ug/L', detection_limit = null, qualifier = null where id = 670569;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '96-12-8', parameter_description = '1 2-DIBROMO-3-CHLOROPROPANE', result_value = '0.2', units = 'ug/L', detection_limit = '0.2', qualifier = null where id = 670570;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '95-50-1', parameter_description = '1 2-DICHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670571;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '108-67-8', parameter_description = '1 3 5-TRIMETHYLBENZENE', result_value = '3', units = 'ug/L', detection_limit = null, qualifier = null where id = 670572;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '541-73-1', parameter_description = '1 3-DICHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670573;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '106-46-7', parameter_description = '1 4-DICHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670574;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '95-49-8', parameter_description = '2-CHLOROTOLUENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670575;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '99-87-6', parameter_description = '4-ISOPROPYLTOLUENE', result_value = '1.1', units = 'ug/L', detection_limit = null, qualifier = null where id = 670576;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '71-43-2', parameter_description = 'BENZENE', result_value = '7.4', units = 'ug/L', detection_limit = null, qualifier = null where id = 670577;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '108-86-1', parameter_description = 'BROMOBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670580;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '74-97-5', parameter_description = 'BROMOCHLOROMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670581;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-27-4', parameter_description = 'BROMODICHLOROMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670582;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-25-2', parameter_description = 'BROMOFORM', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670583;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '74-83-9', parameter_description = 'BROMOMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670584;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '56-23-5', parameter_description = 'CARBON TETRACHLORIDE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670587;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '108-90-7', parameter_description = 'CHLOROBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670592;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-00-3', parameter_description = 'CHLOROETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670593;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '67-66-3', parameter_description = 'CHLOROFORM', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670594;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '74-87-3', parameter_description = 'CHLOROMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670595;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '156-59-2', parameter_description = 'cis-1 2-DICHLOROETHENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670596;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '10061-01-5', parameter_description = 'cis-1 3-DICHLOROPROPENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670597;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '124-48-1', parameter_description = 'DIBROMOCHLOROMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670598;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '74-95-3', parameter_description = 'DIBROMOMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670599;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '100-41-4', parameter_description = 'ETHYLBENZENE', result_value = '3.5', units = 'ug/L', detection_limit = null, qualifier = null where id = 670600;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '87-68-3', parameter_description = 'HEXACHLORO-1 3-BUTADIENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670605;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '98-82-8', parameter_description = 'ISOPROPYLBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = null, qualifier = null where id = 670610;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '1634-04-4', parameter_description = 'METHYL-tert-BUTYL-ETHER (MTBE)', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670615;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '104-51-8', parameter_description = 'N-BUTYLBENZENE', result_value = '10', units = 'ug/L', detection_limit = null, qualifier = null where id = 670616;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '103-65-1', parameter_description = 'n-PROPYLBENZENE', result_value = '1.5', units = 'ug/L', detection_limit = null, qualifier = null where id = 670617;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '91-20-3', parameter_description = 'NAPHTHALENE', result_value = '130', units = 'ug/L', detection_limit = null, qualifier = null where id = 670618;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '135-98-8', parameter_description = 'sec-BUTYLBENZENE', result_value = '1.3', units = 'ug/L', detection_limit = null, qualifier = null where id = 670633;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '100-42-5', parameter_description = 'STYRENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670642;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '98-06-6', parameter_description = 'tert-BUTYLBENZENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670645;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '127-18-4', parameter_description = 'TETRACHLOROETHENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670646;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '108-88-3', parameter_description = 'TOLUENE', result_value = '13', units = 'ug/L', detection_limit = null, qualifier = null where id = 670647;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '1330-20-7', parameter_description = 'TOTAL XYLENES', result_value = '15.9', units = 'ug/L', detection_limit = null, qualifier = null where id = 670654;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '156-60-5', parameter_description = 'trans-1 2-DICHLOROETHENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670655;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '79-01-6', parameter_description = 'TRICHLOROETHENE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670656;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-69-4', parameter_description = 'TRICHLOROFLUOROMETHANE', result_value = '0.5', units = 'ug/L', detection_limit = '0.5', qualifier = null where id = 670657;
update enviro_sample_results set method_code = 'UnSpec', parameter_name = '75-01-4', parameter_description = 'VINYL CHLORIDE', result_value = '0.2', units = 'ug/L', detection_limit = '0.2', qualifier = null where id = 670658;

update enviro_sample_results set bad_result_value = 'f', bad_detection_limit_value = 'f' where id in (607908,607909,608360,608361,608798,608799,609020,609021,609026,609027,609064,609065,610022,610023,610142,610143,611352,611353,611819,611820,612265,612266,654397,654398,84961,84979,505885,505888,505893,505900,505905,581000,581002,581005,581006,670560,670561,670562,670563,670564,670565,670566,670567,670568,670569,670570,670571,670572,670573,670574,670575,670576,670577,670580,670581,670582,670583,670584,670587,670592,670593,670594,670595,670596,670597,670598,670599,670600,670605,670610,670615,670616,670617,670618,670633,670642,670645,670646,670647,670654,670655,670656,670657,670658); --84



drop table environmental_sample_sites;
create table environmental_sample_sites (
	id serial not null primary key, 
	sample_site_id integer, 
	facility_type varchar(255), 
	has_samples boolean, 
	project_number varchar(35), 
	receipt_number varchar(255), 
	permit_number varchar(255),
	well_depth integer, 
	elevation integer, 
	county varchar(255), 
	longitude varchar(20), 
	latitude varchar(20), 
	utm_x double precision,
	utm_y double precision,
	quarter_quarter varchar(8),
	section integer,
	township varchar(14),
	range varchar(8),
	meridian varchar(30),
	plss_location varchar(100), 
	created_at timestamp, 
	updated_at timestamp
);

-- insert access database records first
insert into environmental_sample_sites (sample_site_id, facility_type, utm_x, utm_y, latitude, longitude, quarter_quarter, section, township, range, meridian, county, permit_number, receipt_number, well_depth, created_at, updated_at) select facility_id, facility_type, utm_x, utm_y, latitude::varchar, longitude::varchar, quarter_quarter, section, township, range, meridian, county, permit_number, receipt_number, well_depth, '2015-07-31', '2015-07-31' from water_locations; --6080

-- now insert locations from scrape not in access database
insert into environmental_sample_sites (sample_site_id, facility_type, project_number, county, plss_location, elevation, latitude, longitude, receipt_number, well_depth, created_at, updated_at) select sample_site_id, facility_type, project_number, county, plss_location, elevation, latitude, longitude, dwr_receipt_number, well_depth, created_at, updated_at from enviro_sample_sites where sample_site_id not in (select facility_id from water_locations); --7845 out of 13900

set search_path to staging;
drop table environmental_samples;
create table environmental_samples (
	id serial not null primary key,
	sample_site_id integer, 
	sample_id integer, 
	sample_date varchar(11), 
	matrix varchar(10), 
	lab_id varchar(30), 
	lab_sample_id varchar(30), 
	sampler varchar(100), 
	sample_reason varchar(255), 
	created_at date, 
	updated_at date
);

-- insert access database records first
insert into environmental_samples (sample_site_id, sample_id, sample_date, matrix, sample_reason, created_at, updated_at) select facility_id, sample_id, sample_date, matrix, sample_reason, '2015-07-31', '2015-07-31' from water_samples; --20932

-- now insert locations from scrape not in access database
insert into environmental_samples (sample_site_id, sample_id, sample_date, matrix, lab_id, lab_sample_id, sampler, created_at, updated_at) select distinct sample_site_id, sample_id, sample_date::varchar, matrix, lab_id, lab_sample_id, sampler, '2015-08-07'::date, '2015-08-07'::date from enviro_sample_results where sample_id not in (select sample_id from water_samples); --11664 out of 30965

set search_path to staging;
drop table environmental_results;
create table environmental_results (
	id serial not null primary key,
	result_id integer, 
	sample_id integer, 
	method_code varchar(50), 
	parameter_name varchar(50), 
	parameter_description varchar(100), 
	result_value varchar(30), 
	units varchar(20), 
	detection_limit varchar(20), 
	fraction_type varchar(20),
	qualifier varchar(10), 
	created_at timestamp,  
	updated_at timestamp
);

-- insert access database records first
insert into environmental_results (result_id, sample_id, method_code, parameter_description, result_value, qualifier, units, fraction_type, detection_limit, created_at, updated_at) select result_id, sample_id, method_code, param_description, result_value, qualifier, units, fraction_type, detection_limit, '2015-07-31', '2015-07-31' from water_results; --506908

-- now insert locations from scrape not in access database
insert into environmental_results (sample_id, method_code, parameter_name, parameter_description, result_value, qualifier, units, detection_limit, created_at, updated_at) select sample_id, method_code, parameter_name, parameter_description, result_value, qualifier, units, detection_limit, created_at, updated_at from enviro_sample_results where sample_id not in (select sample_id from water_samples); --229736 out of 716542


-- clean up value types
set search_path to staging;

update environmental_sample_sites set facility_type = upper(trim(facility_type));
update environmental_sample_sites set facility_type = null where facility_type = ''; --68
--update environmental_sample_sites set facility_type = 'CISTERN' where facility_type = 'CIS'; --
--update environmental_sample_sites set facility_type = 'CREEK' where facility_type = 'CRK'; --
--update environmental_sample_sites set facility_type = 'DOMESTIC WELL' where facility_type = 'DOM'; --
--update environmental_sample_sites set facility_type = 'GROUND WATER' where facility_type = 'GW'; --
--update environmental_sample_sites set facility_type = 'GROUND WATER' where facility_type = 'GROUNDWATER'; --
--update environmental_sample_sites set facility_type = 'IRRIGATION' where facility_type = 'IRR'; --
--update environmental_sample_sites set facility_type = 'POND' where facility_type = 'PND'; --
--update environmental_sample_sites set facility_type = 'RIVER' where facility_type = 'RIV'; --
--update environmental_sample_sites set facility_type = 'SEEP' where facility_type = 'SEE'; --
--update environmental_sample_sites set facility_type = 'SPRING' where facility_type = 'SPG'; --
--update environmental_sample_sites set facility_type = 'SPRING' where facility_type = 'SPR'; --
update environmental_sample_sites set facility_type = 'STOCK OR IRRIGATION' where facility_type = 'STOCK OR  IRRIGATION'; --130
--update environmental_sample_sites set facility_type = 'SURFACE WATER' where facility_type = 'SW'; --
--update environmental_sample_sites set facility_type = 'TANK' where facility_type = 'TNK'; --
--update environmental_sample_sites set facility_type = 'UNKNOWN' where facility_type = 'UNK'; --
alter table environmental_sample_sites alter column facility_type type varchar(20);

update environmental_sample_sites set project_number = trim(project_number);
update environmental_sample_sites set project_number = null where project_number = ''; --6830 (10953)
alter table environmental_sample_sites alter column project_number type varchar(35);

update environmental_sample_sites set receipt_number = upper(trim(receipt_number));
update environmental_sample_sites set receipt_number = null where receipt_number = ''; --8062 (12223)
update environmental_sample_sites set receipt_number = null where receipt_number = 'NA'; --1
alter table environmental_sample_sites alter column receipt_number type varchar(8);

update environmental_sample_sites set permit_number = trim(permit_number);
update environmental_sample_sites set permit_number = null where permit_number = ''; --0
update environmental_sample_sites set permit_number = null where permit_number = '0'; --1
alter table environmental_sample_sites alter column permit_number type integer using permit_number::integer;

update environmental_sample_sites set well_depth = null where well_depth <= 0; --44

update environmental_sample_sites set elevation = null where elevation <= 0; --7035 (11369)

alter table environmental_sample_sites add column county_api varchar(3);

update environmental_sample_sites set county = upper(trim(county));
update environmental_sample_sites set county = null where county = ''; --0
update environmental_sample_sites set county = null where county = '- #'; --30
update environmental_sample_sites set county = null where left(county,7) = 'UNKNOWN'; --20 (17)

select county, left(county,36) as county_name from environmental_sample_sites;
select county, right(county,3) as county_api from environmental_sample_sites where length(county) > 11;
update environmental_sample_sites set county_api = right(county,3) where length(county) > 11; --7813
update environmental_sample_sites set county = trim(left(county,36)) where county is not null;
alter table environmental_sample_sites alter column county type varchar(10);

update environmental_sample_sites set longitude = trim(longitude);
update environmental_sample_sites set longitude = null where longitude = ''; --0
alter table environmental_sample_sites alter column longitude type double precision using longitude::double precision;
select count(*) from environmental_sample_sites where longitude > 0;
update environmental_sample_sites set longitude = -longitude where longitude > 0; --3

update environmental_sample_sites set latitude = trim(latitude);
update environmental_sample_sites set latitude = null where latitude = ''; --0
alter table environmental_sample_sites alter column latitude type double precision using latitude::double precision;

update environmental_sample_sites set quarter_quarter = upper(trim(quarter_quarter));
update environmental_sample_sites set quarter_quarter = null where quarter_quarter = ''; --0

update environmental_sample_sites set quarter_quarter = upper(trim(quarter_quarter));
update environmental_sample_sites set quarter_quarter = null where quarter_quarter = ''; --0

update environmental_sample_sites set township = upper(trim(township));
update environmental_sample_sites set township = null where township = ''; --0
alter table environmental_sample_sites alter township type varchar(4);

update environmental_sample_sites set range = upper(trim(range));
update environmental_sample_sites set range = null where range = ''; --0
alter table environmental_sample_sites alter range type varchar(5);

update environmental_sample_sites set meridian = upper(trim(meridian));
update environmental_sample_sites set meridian = null where meridian = ''; --136
alter table environmental_sample_sites alter meridian type varchar(1);

update environmental_sample_sites set plss_location = upper(trim(plss_location));
update environmental_sample_sites set plss_location = null where plss_location = ''; --128 (181)
alter table environmental_sample_sites alter column plss_location type varchar(25);

update environmental_sample_sites set has_samples = 'true' where sample_site_id in (select distinct sample_site_id from environmental_samples); --11035 out of 13925

alter table environmental_sample_sites add column is_denver_basin boolean not null default false;
alter table environmental_sample_sites add column is_piceance_basin boolean not null default false;
alter table environmental_sample_sites add column is_raton_basin boolean not null default false;
alter table environmental_sample_sites add column is_san_juan_basin boolean not null default false;

set search_path to public;
alter table staging.environmental_sample_sites add column geom_4269 geometry(Point,4269);
alter table staging.environmental_sample_sites add column geom geometry(Point,26913);
update staging.environmental_sample_sites set geom_4269 = ST_SetSRID(ST_Point(longitude, latitude),4269) where latitude is not null and longitude is not null;
update staging.environmental_sample_sites set geom = ST_Transform(ST_SetSRID(geom_4269, 4269), 26913) where geom_4269 is not null;

update staging.environmental_sample_sites set is_denver_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='DENVER'));
update staging.environmental_sample_sites set is_piceance_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='UINTA-PICEANCE'));
update staging.environmental_sample_sites set is_raton_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='RATON BASIN'));
update staging.environmental_sample_sites set is_san_juan_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='SAN JUAN'));


-- facility type site counts
drop table environmental_site_facility_types;
create table environmental_site_facility_types (
	id serial not null primary key, 
	facility_type varchar(19), 
	description varchar(50), 
	site_count smallint, 
	created_at date, 
	updated_at date
);
insert into environmental_site_facility_types (facility_type, site_count, created_at, updated_at) 
select facility_type, count(*) as site_count, '2015-08-26', '2015-08-26' from environmental_sample_sites group by facility_type order by site_count desc; --61

select sample_date, split_part(sample_date, ' ', 1) from environmental_samples;
update environmental_samples set sample_date = split_part(sample_date, ' ', 1);
alter table environmental_samples alter column sample_date type date using sample_date::date;

alter table environmental_samples add column sample_year smallint;
alter table environmental_samples add column sample_month smallint;
update environmental_samples set sample_year = extract(year from sample_date) where sample_date is not null;
update environmental_samples set sample_month = extract(month from sample_date) where sample_date is not null;

update environmental_samples set matrix = upper(trim(matrix));
update environmental_samples set matrix = null where matrix = ''; --25 (0)
alter table environmental_samples alter column matrix type varchar(8);

update environmental_samples set lab_id = trim(lab_id);
update environmental_samples set lab_id = null where lab_id = ''; --0
alter table environmental_samples alter column lab_id type integer using lab_id::integer;

update environmental_samples set lab_sample_id = trim(lab_sample_id);
update environmental_samples set lab_sample_id = null where lab_sample_id = ''; --0

update environmental_samples set sampler = trim(sampler);
update environmental_samples set sampler = null where sampler = ''; --0
alter table environmental_samples alter column sampler type varchar(35);

update environmental_samples set sample_reason = trim(sample_reason);
update environmental_samples set sample_reason = null where sample_reason = ''; --0
alter table environmental_samples alter column sample_reason type varchar(50);


update environmental_results set method_code = trim(method_code);
update environmental_results set method_code = null where method_code = ''; --0
alter table environmental_results alter column method_code type varchar(35);

update environmental_results set parameter_name = trim(parameter_name);
update environmental_results set parameter_name = null where parameter_name = ''; --0
alter table environmental_results alter column parameter_name type varchar(35);

update environmental_results set parameter_description = upper(trim(parameter_description));
update environmental_results set parameter_description = null where parameter_description = ''; --0
alter table environmental_results alter column parameter_description type varchar(70);

update environmental_results set result_value = trim(result_value);
update environmental_results set result_value = null where result_value = ''; --0
alter table environmental_results alter column result_value type double precision using result_value::double precision;

update environmental_results set units = trim(units);
update environmental_results set units = null where units = ''; --0
alter table environmental_results alter column units type varchar(15);

update environmental_results set detection_limit = trim(detection_limit);
update environmental_results set detection_limit = null where detection_limit = ''; --0
alter table environmental_results alter column detection_limit type double precision using detection_limit::double precision;

update environmental_results set fraction_type = upper(trim(fraction_type));
update environmental_results set fraction_type = null where fraction_type = ''; --0
alter table environmental_results alter column fraction_type type varchar(10);

update environmental_results set qualifier = trim(qualifier);
update environmental_results set qualifier = null where qualifier = ''; --78069 (0)
alter table environmental_results alter column qualifier type varchar(7);


update environmental_results set environmental_sample_id = (select id from environmental_samples where sample_id = environmental_results.sample_id);


set search_path to staging;
drop table environmental_parameters;
create table environmental_parameters (
	id serial not null primary key,
	name varchar(70), 
	alternate_names varchar(250), 
	created_at date default '2015-08-07',  
	updated_at date default '2015-08-07'
);

insert into environmental_parameters (name) select distinct parameter_description from environmental_results order by parameter_description; --775 (698)

update environmental_parameters set alternate_names = array_to_string(array(select distinct parameter_name from environmental_results where parameter_description = environmental_parameters.name), ', ');

alter table environmental_results add column environmental_parameter_id integer;
update environmental_results set environmental_parameter_id = (select id from environmental_parameters where name = trim(upper(parameter_description)));

alter table environmental_parameters add column result_count integer;
update environmental_parameters set result_count = (select count(*) from environmental_results where environmental_parameter_id = environmental_parameters.id);



set search_path to staging;
drop table environmental_matrices;
create table environmental_matrices (
	id serial not null primary key,
	name varchar(8), 
	created_at date default '2015-08-07',  
	updated_at date default '2015-08-07'
);

insert into environmental_matrices (name) select distinct matrix from environmental_samples order by matrix; --11 (10)

select count(r.*) as result_count, s.matrix from environmental_sample_results r inner join environmental_samples s on r.environmental_sample_id = s.id group by s.matrix order by result_count desc;
alter table environmental_matrices add column result_count integer;
update environmental_matrices set result_count = (select count(r.*) from environmental_results r inner join environmental_samples s on r.environmental_sample_id = s.id where s.matrix = environmental_matrices.name);




-- mark data source
update environmental_sample_sites set source = 'both' where sample_site_id in (select sample_site_id from enviro_sample_sites where sample_site_id in (select facility_id from water_locations));
update environmental_sample_sites set source = 'access database only' where sample_site_id in (select facility_id from water_locations where facility_id not in (select sample_site_id from enviro_sample_sites));
update environmental_sample_sites set source = 'scrape only' where source is null;

-- if BOTH, then records were taken from access database, so lets fill in missing data from corresponding scrape records
update environmental_sample_sites set project_number = (select trim(project_number) from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and project_number is null; --6055
update environmental_sample_sites set receipt_number = (select upper(trim(dwr_receipt_number)) from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and receipt_number is null; --4443
update environmental_sample_sites set well_depth = (select well_depth from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and well_depth is null; --2015
update environmental_sample_sites set well_depth = null where well_depth <= 0; --43
update environmental_sample_sites set elevation = (select elevation from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and elevation is null; --6055
update environmental_sample_sites set elevation = null where elevation <= 0; --4334
update environmental_sample_sites set longitude = (select trim(longitude)::double precision from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and longitude is null; --333
update environmental_sample_sites set latitude = (select trim(latitude)::double precision from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and latitude is null; --333

alter table enviro_sample_sites add column county_api varchar(3);
update enviro_sample_sites set county = upper(trim(county));
update enviro_sample_sites set county = null where county = ''; --0
update enviro_sample_sites set county = null where county = '- #'; --30
update enviro_sample_sites set county = null where left(county,7) = 'UNKNOWN'; --20 (17)
update enviro_sample_sites set county_api = right(county,3) where length(county) > 11; --7813
update enviro_sample_sites set county = trim(left(county,36)) where county is not null;
alter table enviro_sample_sites alter column county type varchar(10);

update environmental_sample_sites set county = (select county from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and county is null; --15
update environmental_sample_sites set county_api = (select county_api from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and county_api is null; --6055
update environmental_sample_sites set plss_location = (select upper(trim(plss_location)) from enviro_sample_sites where sample_site_id = environmental_sample_sites.sample_site_id) where source = 'both' and plss_location is null; --6055

alter table environmental_samples add column environmental_sample_site_id integer;
update environmental_samples set environmental_sample_site_id = (select id from environmental_sample_sites where sample_site_id = environmental_samples.sample_site_id);
alter table environmental_results add column environmental_sample_id integer;
update environmental_results set environmental_sample_id = (select id from environmental_samples where sample_id = environmental_results.sample_id);

alter table environmental_results add column environmental_sample_site_id integer;
update environmental_results set environmental_sample_site_id = (select environmental_sample_site_id from environmental_samples where sample_id = environmental_results.sample_id);



-- dump cleaned up staging records
set search_path to staging;

COPY (select id, sample_site_id, facility_type, has_samples, project_number, receipt_number, permit_number, well_depth, elevation, county, county_api, is_denver_basin, is_piceance_basin, is_raton_basin, is_san_juan_basin,longitude, latitude, utm_x, utm_y, quarter_quarter, section, township, range, meridian, plss_location, created_at, updated_at from environmental_sample_sites order by sample_site_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_sample_sites.csv' WITH CSV; --13925

COPY (select id, environmental_sample_site_id, sample_site_id, sample_id, sample_date, sample_year, sample_month, sample_reason, matrix, lab_id, lab_sample_id, sampler, created_at, updated_at from environmental_samples order by sample_date desc) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_samples.csv' WITH CSV; --32596

COPY (select id, environmental_sample_site_id, environmental_sample_id, environmental_parameter_id, sample_id, method_code, parameter_name, parameter_description, result_value, units, detection_limit, fraction_type, qualifier, created_at, updated_at from environmental_results order by sample_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_results.csv' WITH CSV; --736644

COPY (select id, facility_type, description, site_count, created_at, updated_at from environmental_site_facility_types order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_site_types.csv' WITH CSV; --61

COPY (select id, name, alternate_name, result_count, created_at, updated_at from environmental_parameters order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_parameters.csv' WITH CSV; --775

COPY (select id, name, result_count, created_at, updated_at from environmental_matrices where result_count > 0 order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_matrices.csv' WITH CSV; --10



-- move cleaned staging records to production
set search_path to public;

create table backup.environmental_sample_sites as table environmental_sample_sites;
create table backup.environmental_samples as table environmental_samples;
create table backup.environmental_sample_results as table environmental_sample_results;
create table backup.environmental_sample_site_types as table environmental_sample_site_types;
create table backup.environmental_sample_parameters as table environmental_sample_parameters;
create table backup.environmental_sample_matrices as table environmental_sample_matrices;

drop table environmental_sample_sites;
drop table environmental_samples;
drop table environmental_sample_results;
drop table environmental_sample_site_types;
drop table environmental_sample_parameters;
drop table environmental_sample_matrices;

create table environmental_sample_sites (
	id integer, 
	sample_site_id integer, 
	facility_type varchar(20), 
	has_samples boolean, 
	project_number varchar(35), 
	receipt_number varchar(8), 
	permit_number integer, 
	well_depth integer, 
	elevation integer, 
	county varchar(10), 
	api_county varchar(3), 
	is_denver_basin boolean, 
	is_piceance_basin boolean, 
	is_raton_basin boolean, 
	is_san_juan_basin boolean, 
	longitude double precision, 
	latitude double precision, 
	utm_x double precision,
	utm_y double precision,
	quarter_quarter varchar(8),
	section integer,
	township varchar(4),
	range varchar(5),
	meridian varchar(1),
	plss_location varchar(25), 
	created_at timestamp, 
	updated_at timestamp
);

create table environmental_samples (
	id integer,
	environmental_sample_site_id integer, 
	sample_site_id integer, 
	sample_id integer, 
	sample_date date, 
	sample_year smallint, 
	sample_month smallint, 
	sample_reason varchar(50), 
	matrix varchar(8), 
	lab_id integer, 
	lab_sample_id varchar(30), 
	sampler varchar(35), 
	created_at date,  
	updated_at date
);

create table environmental_sample_results (
	id integer,
	environmental_sample_site_id integer, 
	environmental_sample_id integer, 
	environmental_parameter_id integer, 
	sample_id integer, 
	method_code varchar(35), 
	parameter_name varchar(35), 
	parameter_description varchar(70), 
	result_value double precision, 
	units varchar(15), 
	detection_limit double precision, 
	fraction_type varchar(10), 
	qualifier varchar(7), 
	created_at timestamp,  
	updated_at timestamp
);

create table environmental_sample_site_types (
	id integer, 
	facility_type varchar(20), 
	description varchar(50), 
	site_count smallint, 
	created_at date, 
	updated_at date
);

create table environmental_sample_parameters (
	id integer,
	name varchar(70), 
	alternate_name varchar(35),
	result_count integer, 
	created_at date,  
	updated_at date
);

create table environmental_sample_matrices (
	id integer,
	name varchar(8), 
	result_count integer, 
	created_at date,  
	updated_at date
);

copy environmental_sample_sites from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_sample_sites.csv' (format csv, delimiter ',', null '');
copy environmental_samples from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_samples.csv' (format csv, delimiter ',', null '');
copy environmental_sample_results from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_results.csv' (format csv, delimiter ',', null '');
copy environmental_sample_site_types from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_site_types.csv' (format csv, delimiter ',', null '');
copy environmental_sample_parameters from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_parameters.csv' (format csv, delimiter ',', null '');
copy environmental_sample_matrices from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_matrices.csv' (format csv, delimiter ',', null '');

alter table environmental_sample_sites add primary key (id);
alter table environmental_sample_site_types add primary key (id);
alter table environmental_samples add primary key (id);
alter table environmental_sample_results add primary key (id);
alter table environmental_sample_reasons add primary key (id);
alter table environmental_sample_parameters add primary key (id);
alter table environmental_sample_matrices add primary key (id);

create index index_environmental_sample_sites_on_sample_site_id on environmental_sample_sites (sample_site_id);
create index index_environmental_sample_sites_on_facility_type on environmental_sample_sites (facility_type);
create index index_environmental_sample_sites_on_county on environmental_sample_sites (county);
create index index_environmental_sample_sites_on_api_county on environmental_sample_sites (api_county);

create index index_environmental_samples_on_environmental_sample_site_id on environmental_samples (environmental_sample_site_id);
create index index_environmental_samples_on_sample_site_id on environmental_samples (sample_site_id);
create index index_environmental_samples_on_sample_id on environmental_samples (sample_id);
create index index_environmental_samples_on_sample_date on environmental_samples (sample_date);
create index index_environmental_samples_on_sample_year on environmental_samples (sample_year);
create index index_environmental_samples_on_sample_month on environmental_samples (sample_month);
create index index_environmental_samples_on_matrix on environmental_samples (matrix);

create index index_environmental_sample_results_on_environmental_sample_site_id on environmental_sample_results (environmental_sample_site_id);
create index index_environmental_sample_results_on_environmental_sample_id on environmental_sample_results (environmental_sample_id);
create index index_environmental_sample_results_on_environmental_parameter_id on environmental_sample_results (environmental_parameter_id);
create index index_environmental_sample_results_on_sample_id on environmental_sample_results (sample_id);



create table public.environmental_sample_reasons as table environmental_sample_reasons;
alter table environmental_sample_reasons add primary key (id);



update environmental_results set parameter_name = '7783-06-4' where parameter_name = '6/4/83';
update environmental_parameters set alternate_names = '7783-06-4' where name = 'HYDROGEN SULFIDE';
update environmental_results set parameter_name = '222Rn' where parameter_name = '14859-67-7';
update environmental_parameters set alternate_names = '222Rn' where name = '222RADON';
update environmental_results set parameter_name = '108-39-4' where parameter_name = '15831-10-4';
update environmental_parameters set alternate_names = '108-39-4' where name = '3-METHYLPHENOL';
alter table environmental_parameters rename column alternate_names to alternate_name;


select (array_to_string(array(select distinct parameter_name from enviro_sample_results where upper(parameter_description) = environmental_parameters.name), ', ')) as alt_names, name from environmental_parameters where alternate_name is null;

update environmental_parameters set alternate_name = '107-18-6' where name = 'ALLYL ALCOHOL';
update environmental_parameters set alternate_name = '71-23-8' where name = '1-PROPANOL';
update environmental_parameters set alternate_name = '14C DIC' where name = '14C IN DISSOLVED INORGANIC CARBON';
update environmental_parameters set alternate_name = '182Ta' where name = '182TANTALUM';
update environmental_parameters set alternate_name = '112-34-5' where name = '2-(2-BUTOXYETHOXY)ETHANOL';
update environmental_parameters set alternate_name = '78-92-2' where name = '2-BUTANOL';
update environmental_parameters set alternate_name = '75-29-6' where name = '2-CHLOROPROPANE';
update environmental_parameters set alternate_name = '111-15-9' where name = '2-ETHOXYLETHYL ACETATE';
update environmental_parameters set alternate_name = '79-46-9' where name = '2-NITROPROPANE';
update environmental_parameters set alternate_name = '88-72-2' where name = '2-NITROTOLUENE';
update environmental_parameters set alternate_name = '107-87-9' where name = '2-PENTANONE';
update environmental_parameters set alternate_name = '2807-30-9' where name = '2-PROPOXYETHANOL';
update environmental_parameters set alternate_name = '224Ra' where name = '224RADIUM';
update environmental_parameters set alternate_name = '99-08-1' where name = '3-NITROTOLUENE';
update environmental_parameters set alternate_name = '123-42-2' where name = '4-HYDROXY-4-METHYL-2-PENTANONE';
update environmental_parameters set alternate_name = '99-99-0' where name = '4-NITROTOLUENE';
update environmental_parameters set alternate_name = '319-84-6' where name = 'ALPHA-BHC';
update environmental_parameters set alternate_name = '5103-71-9' where name = 'ALPHA-CHLORDANE';
update environmental_parameters set alternate_name = '11100-14-4' where name = 'AROCLOR 1268';
update environmental_parameters set alternate_name = '37324-23-5' where name = 'AROLCOR 1262';
update environmental_parameters set alternate_name = '100-52-7' where name = 'BENZALDEHYDE';
update environmental_parameters set alternate_name = 'BSSA' where name = 'BENZYL SUCCINATE SYNTHASE FUNCTIONAL GENES';
update environmental_parameters set alternate_name = '319-85-7' where name = 'BETA-BHC';
update environmental_parameters set alternate_name = '128-37-0' where name = 'BUTYLATED HYDROXYTOLUENE';
update environmental_parameters set alternate_name = 'Caffeine' where name = 'CAFFEINE';
update environmental_parameters set alternate_name = '471-34-1' where name = 'CALCIUM CARBONATE';
update environmental_parameters set alternate_name = '319-86-8' where name = 'DELTA-BHC';
update environmental_parameters set alternate_name = 'delta18O_SO4' where name = 'DELTA18O_SULFATE';
update environmental_parameters set alternate_name = 'delta34S_SO4' where name = 'DELTA34S_SULFATE';
update environmental_parameters set alternate_name = '34590-94-8' where name = 'DIPROPYLENE GLYCOL METHYL ETHER';
update environmental_parameters set alternate_name = '1031-07-8' where name = 'ENDOSULFAN SULFATE';
update environmental_parameters set alternate_name = '7421-93-4' where name = 'ENDRIN ALDEHYDE';
update environmental_parameters set alternate_name = '53494-70-5' where name = 'ENDRIN KETONE';
update environmental_parameters set alternate_name = '141-78-6' where name = 'ETHYL ACETATE';
update environmental_parameters set alternate_name = '462-06-6' where name = 'FLOUROBENZENE';
update environmental_parameters set alternate_name = '5103-74-2' where name = 'GAMMA-CHLORDANE';
update environmental_parameters set alternate_name = '2691-41-0' where name = 'HMX';
update environmental_parameters set alternate_name = '123-92-2' where name = 'ISOAMYL ACETATE';
update environmental_parameters set alternate_name = '110-19-0' where name = 'ISOBUTYL ACETATE';
update environmental_parameters set alternate_name = '108-21-4' where name = 'ISOPROPYL ACETATE';
update environmental_parameters set alternate_name = '143-50-0' where name = 'KEPONE';
update environmental_parameters set alternate_name = '108-38-3' where name = 'M-XYLENE';
update environmental_parameters set alternate_name = 'Flow' where name = 'MEASURED FLOW';
update environmental_parameters set alternate_name = 'Gas Flow' where name = 'MEASURED GAS FLOW';
update environmental_parameters set alternate_name = '2385-85-5' where name = 'MIREX';
update environmental_parameters set alternate_name = '1465-25-4' where name = 'N-(1-NAPHTHYL)ETHYLENEDIAMINE DIHYDROCHLORIDE';
update environmental_parameters set alternate_name = '123-86-4' where name = 'N-BUTYL ACETATE';
update environmental_parameters set alternate_name = '109-60-4' where name = 'N-PROPYL ACETATE';
update environmental_parameters set alternate_name = '4165-60-0' where name = 'NITROBENZENE-D5';
update environmental_parameters set alternate_name = 'Optical Brightener 220' where name = 'OPTICAL BRIGHTENER';
update environmental_parameters set alternate_name = 'SM4500-H+ B' where name = 'PH ELECTROMETRIC METHOD';
update environmental_parameters set alternate_name = 'Ra_Purge' where name = 'PURGE RATE';
update environmental_parameters set alternate_name = '121-82-4' where name = 'RDX';
update environmental_parameters set alternate_name = '105-46-4' where name = 'SEC-BUTYL ACETATE';
update environmental_parameters set alternate_name = '14265-45-8' where name = 'SULFITE';
update environmental_parameters set alternate_name = '7446-09-5' where name = 'SULFUR DIOXIDE';
update environmental_parameters set alternate_name = 'TBA' where name = 'TBA MONOOXYGENASE FUNCTIONAL GENE';
update environmental_parameters set alternate_name = 'TEPH-MRO' where name = 'TEPH MOTOR OIL RANGE ORGANICS';
update environmental_parameters set alternate_name = '1718-51-0' where name = 'TERPHENYL-D14';
update environmental_parameters set alternate_name = '479-45-8' where name = 'TETRYL';
update environmental_parameters set alternate_name = 'TPH (C12-C28 fraction) TNRCC' where name = 'TNRCC 1005 C12 TO C28 FRACTION';
update environmental_parameters set alternate_name = 'TPH (C28-C35 fraction) TNRCC' where name = 'TNRCC 1005 C28-C35 FRACTION';
update environmental_parameters set alternate_name = 'TPH (C6-C12 fraction) TNRCC' where name = 'TNRCC 1005 C6 TO C12 FRACTION';
update environmental_parameters set alternate_name = 'TPH (C6-C35 sum) TNRCC' where name = 'TNRCC 1005 TPH SUM OF FRACTIONS';
update environmental_parameters set alternate_name = 'RMO' where name = 'TOLUENE MONOOXYGENASE FUNCTIONAL GENE';
update environmental_parameters set alternate_name = '2037-26-5' where name = 'TOLUENE-D8';
update environmental_parameters set alternate_name = '7782-50-5(Res)' where name = 'TOTAL RESIDUAL CHLORINE';
update environmental_parameters set alternate_name = 'H2O-trit' where name = 'TRITIUM IN WATER';





set search_path to staging;
alter table environmental_sample_sites add column utm_x double precision;
alter table environmental_sample_sites add column utm_y double precision;
alter table environmental_sample_sites add column quarter_quarter varchar(8);
alter table environmental_sample_sites add column section integer;
alter table environmental_sample_sites add column township varchar(14);
alter table environmental_sample_sites add column range varchar(8);
alter table environmental_sample_sites add column meridian varchar(30);
alter table environmental_sample_sites add column permit_number varchar(255);
alter table environmental_sample_sites add column receipt_number varchar(255);
alter table environmental_sample_sites add column water_well_depth integer;



set search_path to staging;
alter table environmental_results add column result_id integer;
alter table environmental_results add column fraction_type varchar(10);

update environmental_results set fraction_type = (select upper(trim(fraction_type)) from import.water_results where sample_id = environmental_results.sample_id); --6482 out of 7254


set search_path to staging;
create index wells_geom_gist on wells (geom);
create index sample_sites_geom_gist on environmental_sample_sites (geom);

create table environmental_sample_well_distances (
	id serial not null primary key, 
	environmental_sample_site_id integer, 
	well_id integer, 
	distance real
);

set search_path to public;
insert into staging.environmental_sample_well_distances (environmental_sample_site_id, well_id, distance) select s.id, w.well_id, ST_Distance(s.geom,w.geom) from staging.environmental_sample_sites s cross join import.wells w where s.has_samples is true and w.facility_s <> 'AL' and ST_Distance(s.geom,w.geom) < 805;

alter table environmental_sample_well_distances add column facility_type varchar(20);
alter table environmental_sample_well_distances add column well_api_number varchar(12);
alter table environmental_sample_well_distances add column facility_id integer;
alter table environmental_sample_well_distances add column sample_count integer;
alter table environmental_sample_well_distances add column matrix_types varchar(100);

update environmental_sample_well_distances set facility_type = (select facility_type from environmental_sample_sites where id = environmental_sample_well_distances.environmental_sample_site_id);
update environmental_sample_well_distances set facility_id = (select sample_site_id from environmental_sample_sites where id = environmental_sample_well_distances.environmental_sample_site_id);
update environmental_sample_well_distances set sample_count = (select count(*) from environmental_samples where environmental_sample_site_id = environmental_sample_well_distances.environmental_sample_site_id);
update environmental_sample_well_distances set matrix_types = array_to_string(array(select distinct matrix from environmental_samples where environmental_sample_site_id = environmental_sample_well_distances.environmental_sample_site_id), ', ');

update environmental_sample_well_distances set well_api_number = (select api_number from public.wells where id = environmental_sample_well_distances.well_id);

select count(*) as sample_sites, well_id from environmental_sample_well_distances group by well_id order by sample_sites desc;

set search_path to staging;
COPY (select id, environmental_sample_site_id, well_id, facility_type, facility_id, well_api_number, matrix_types, sample_count, distance from environmental_sample_well_distances order by distance) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_sample_well_distances.csv' WITH CSV; --113527

set search_path to public;
drop table environmental_sample_well_distances;
create table environmental_sample_well_distances (
	id integer, 
	environmental_sample_site_id integer, 
	well_id integer, 
	facility_type varchar(20), 
	facility_id integer, 
	well_api_number varchar(12), 
	matrix_types varchar(20), 
	sample_count integer, 
	distance_meters real
);
copy environmental_sample_well_distances from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/environmental_sample_well_distances.csv' (format csv, delimiter ',', null '');

alter table environmental_sample_well_distances add primary key (id);


----------------------------------------------------------
------------------   PRODUCTIONS   -----------------------
----------------------------------------------------------

-- import date => '2015-07-17'

set search_path to import;

drop table productions;

create table productions (
	report_month varchar(2), 
	report_year smallint, 
	api_state_code varchar(2), 
	api_county_code varchar(3), 
	api_seq_num varchar(5), 
	sidetrack_num varchar(2), 
	formation_code varchar(6), 
	well_status varchar(2), 
	prod_days integer, 
	water_disp_code varchar(1), 
	water_vol integer, 
	water_press_tbg integer, 
	water_press_csg integer, 
	bom_invent integer, 
	oil_vol integer, 
	oil_sales integer, 
	adjustment integer, 
	eom_invent integer, 
	gravity_sales real, 
	gas_sales integer, 
	flared integer, 
	gas_vol integer, 
	shrink integer, 
	gas_prod integer, 
	btu_sales integer, 
	gas_press_tbg integer, 
	gas_press_csg integer, 
	operator_num integer, 
	operator_name varchar(50), 
	facility_name varchar(35), 
	facility_num varchar(15), 
	accepted_date date
);

copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/1999_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2000_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2001_prod_reports.csv' (format csv, delimiter ',', null '');

alter table productions add column revised varchar(1);

copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2002_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2003_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2004_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2005_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2006_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2007_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2008_prod_reports.csv' (format csv, delimiter ',', null '');

-- replace "UPRR 38 PAN AM "V'" with "UPRR 38 PAN AM V"
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2009_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2010_prod_reports.csv' (format csv, delimiter ',', null '');

-- replace "UPRR 38 PAN AM "V'" with "UPRR 38 PAN AM V" and replace "NCLP "USX AA" with "NCLP USX AA"
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2011_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2012_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2013_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2014_prod_reports.csv' (format csv, delimiter ',', null '');
copy productions from '/Users/troyburke/Data/cogcc_query_database/downloads/production_downloads/2015_prod_reports.csv' (format csv, delimiter ',', null '');


set search_path to import;
drop table staging.productions;
create table staging.productions as table productions;


-- clean up data records
set search_path to staging;

alter table productions add id serial not null primary key;

alter table productions add well_id varchar(8);

update productions set well_id = api_county_code || api_seq_num;
alter table productions alter column well_id type integer using well_id::integer;

alter table productions alter column report_month type smallint using report_month::smallint;

alter table productions add column formation_name varchar(50);
update productions set formation_name = (select description from public.formations where code = productions.formation_code);

update productions set revised = 'N' where trim(revised) = ''; --2497294
alter table productions alter column revised type boolean using revised::boolean;


COPY (select id, report_year, report_month, well_id, api_state_code || '-' || api_county_code || '-' || api_seq_num as well_api_number, sidetrack_num, api_county_code, formation_code, formation_name, well_status, prod_days, bom_invent, oil_vol, oil_sales, adjustment, eom_invent, gravity_sales, gas_prod, flared, gas_vol, shrink, gas_sales, btu_sales, gas_press_tbg, gas_press_csg, water_vol, water_disp_code, water_press_tbg, water_press_csg, operator_num, operator_name, facility_name, facility_num, accepted_date, revised, '2015-07-17', '2015-07-17' from productions order by report_year desc, report_month desc, well_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/productions.csv' WITH CSV;


set search_path to public;

create table backup.productions as table productions;
drop table productions;


create table productions (
	id serial not null primary key, 
	report_year smallint, 
	report_month smallint, 
	well_id integer, 
	api_number varchar(12), 
	sidetrack_num varchar(2), 
	api_county varchar(3), 
	formation_code varchar(6), 
	formation_name varchar(50), 
	well_status varchar(2), 
	days_producing integer, 
	oil_bom integer, 
	oil_prod integer, 
	oil_sold integer, 
	oil_adj integer, 
	oil_eom integer, 
	oil_gravity real, 
	gas_produced integer, 
	gas_flared integer, 
	gas_used integer, 
	gas_shrinkage integer, 
	gas_sold integer, 
	gas_btu integer, 
	gas_press_tbg integer, 
	gas_press_csg integer, 
	water_production integer, 
	water_disposal_code varchar(1), 
	water_press_tbg integer, 
	water_press_csg integer, 
	operator_number integer, 
	operator_name varchar(50), 
	facility_name varchar(35), 
	facility_number varchar(15), 
	accepted_date date, 
	revised boolean, 
	created_at date, 
	updated_at date
);

copy productions from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/productions.csv' (format csv, delimiter ',', null '');

alter table productions add primary key (id);

create index index_productions_on_well_id on productions (well_id);
create index index_productions_on_report_year on productions (report_year);
create index index_productions_on_report_month on productions (report_month);

insert into productions (report_year, report_month, well_id, sidetrack_num, api_county, formation_code, formation_name, well_status, days_producing, oil_bom, oil_prod, oil_sold, oil_adj, oil_eom, oil_gravity, gas_produced, gas_flared, gas_used, gas_shrinkage, gas_sold, gas_btu, gas_press_tbg, gas_press_csg, water_production, water_disposal_code, water_press_tbg, water_press_csg, operator_number, operator_name, facility_name, facility_number, accepted_date, revised) select distinct report_year, report_month, well_id, sidetrack_num, api_county_code, formation_code, formation_name, well_status, prod_days, bom_invent, oil_vol, oil_sales, adjustment, eom_invent, gravity_sales, gas_prod, flared, gas_vol, shrink, gas_sales, btu_sales, gas_press_tbg, gas_press_csg, water_vol, water_disp_code, water_press_tbg, water_press_csg, operator_num, operator_name, facility_name, facility_num, accepted_date, revised from staging.productions order by report_year desc, report_month desc, well_id;

-- api_state_code || '-' || api_county_code || '-' || api_seq_num as well_api_number

-- , '2015-07-17', '2015-07-17'



create table denver_2014_productions (
	report_month smallint, 
	well_id integer, 
	formation_code varchar(6), 
	oil_produced integer, 
	gas_produced integer, 
	accepted_date date, 
	revised boolean
);

insert into denver_2014_productions (report_month, well_id, formation_code, oil_produced, gas_produced, accepted_date, revised) 
select report_month, well_id, formation_code, oil_prod, gas_produced, accepted_date, revised from productions where is_denver_basin is true and report_year = 2014;
--

create table denver_2014_final_productions (
	id serial not null primary key, 
	production_id integer, 
	report_month smallint, 
	well_id integer, 
	formation_code varchar(6), 
	oil_produced integer, 
	gas_produced integer
);

insert into denver_2014_final_productions (production_id, report_month, well_id, formation_code, oil_produced, gas_produced) 
select id, report_month, well_id, formation_code, oil_produced, gas_produced from denver_2014_productions where revised is true;
--87087
insert into denver_2014_final_productions (production_id, report_month, well_id, formation_code, oil_produced, gas_produced) 
select id, report_month, well_id, formation_code, oil_produced, gas_produced from denver_2014_productions where well_month_formation not in (select well_month_formation from denver_2014_final_productions);
--325877

--412964
--417733

drop table denver_final_2014_productions;
create table denver_final_2014_productions (
	report_month smallint, 
	well_id integer, 
	formation_code varchar(6), 
	oil_produced integer, 
	gas_produced integer
);

insert into denver_final_2014_productions (report_month, well_id, formation_code, oil_produced, gas_produced) 
select distinct report_month, well_id, formation_code, oil_produced, gas_produced from denver_2014_final_productions;
--410957

select sum(oil_produced) as oil_prod, sum(gas_produced) as gas_prod from denver_final_2014_productions;

--88,019,629
--445,589,735


---------------------------------------------------------------
----------------------  FACILITIES  ---------------------------
---------------------------------------------------------------

set search_path to import;

drop table facilities;
drop table locations;
drop table well_locations;

create table facilities (
	id serial primary key not null, 
	facility_type_id integer, 
	facility_type varchar(50), 
	facility_detail_url varchar(100), 
	facility_id integer, 
	facility_name varchar(100), 
	facility_number varchar(20), 
	operator_name varchar(100), 
	operator_number varchar(20), 
	status_code varchar(20), 
	field_name varchar(100), 
	field_number integer, 
	location_county varchar(100), 
	location_plss varchar(100), 
	related_facilities_url varchar(100), 
	created_at timestamp, 
	updated_at timestamp, 
	details_scraped boolean not null default false, 
	in_use boolean not null default false
);

-- run scrape/import script to catalog facilities of type = LOCATION

create table locations (
	id serial primary key not null, 
	facility_id integer, 
	status_date varchar(12), 
	latitude double precision, 
	longitude double precision, 
	form_2a_doc_num varchar(20), 
	form_2a_exp_date varchar(20), 
	special_purpose_pits varchar(10), 
	drilling_pits varchar(10), 
	wells varchar(10), 
	production_pits varchar(10), 
	condensate_tanks varchar(10), 
	water_tanks varchar(10), 
	separators varchar(10), 
	electric_motors varchar(10), 
	gas_or_diesel_motors varchar(10),
	cavity_pumps varchar(10), 
	lact_unit varchar(10), 
	pump_jacks varchar(10), 
	electric_generators varchar(10),
	gas_pipeline varchar(10), 
	oil_pipeline varchar(10), 
	water_pipeline varchar(10), 
	gas_compressors varchar(10), 
	voc_combustor varchar(10), 
	oil_tanks varchar(10), 
	dehydrator_units varchar(10), 
	multi_well_pits varchar(10), 
	pigging_station varchar(10), 
	flare varchar(10), 
	fuel_tanks varchar(10),
	created_at timestamp, 
	updated_at timestamp
);

create table location_wells (
	id serial primary key not null, 
	facility_id integer,
	location_id integer,
	api_number varchar(16),
	well_name varchar(100), 
	well_url varchar(100), 
	facility_status varchar(10),
	wellbore_status varchar(10),
	authorization_date varchar(12),
	no_longer_injector_date varchar(12),
	max_water_inj_psi varchar(20),
	max_gas_inj_psi varchar(20),
	max_inj_volume varchar(20),
	last_mit varchar(50), 
	created_at timestamp, 
	updated_at timestamp
);

-- run scrape/import scripts to popluate location details

set search_path to import;
drop table staging.facilities;
drop table staging.locations;
drop table staging.location_wells;
create table staging.facilities as table facilities;
create table staging.locations as table locations;
create table staging.location_wells as table location_wells;


set search_path to staging;






---------------------------------------------------------------
-----------------------  LOCATIONS  ---------------------------
---------------------------------------------------------------

-- use 2014 scrape for import values

set search_path to staging;

update locations set facility_name = upper(trim(facility_name));
update locations set facility_name = null where facility_name = ''; --0
alter table locations alter column facility_name type varchar(35);

update locations set facility_number = trim(facility_number);
update locations set facility_number = null where facility_number = ''; --151
alter table locations alter column facility_number type varchar(15);

update locations set operator_name = upper(trim(operator_name));
update locations set operator_name = null where operator_name = ''; --0
alter table locations alter column operator_name type varchar(50);

update locations set operator_number = trim(operator_number);
update locations set operator_number = null where operator_number = ''; --0
alter table locations alter column operator_number type integer using operator_number::integer;

update locations set status_code = upper(trim(status_code));
update locations set status_code = null where status_code = ''; --37
alter table locations alter column status_code type varchar(2);

update locations set status_date = trim(status_date);
update locations set status_date = null where status_date = ''; --0
alter table locations alter column status_date type date using status_date::date;

update locations set field_code = upper(trim(field_code));
update locations set field_code = null where field_code = ''; --0
alter table locations alter column field_code type varchar(20);

update locations set field_number = trim(field_number);
update locations set field_number = null where field_number = ''; --0
alter table locations alter column field_number type integer using field_number::integer;

update locations set county = upper(trim(county));
update locations set county = null where county = ''; --0
alter table locations add column county_api varchar(3);
update locations set county_api = right(county,3) where county is not null;
update locations set county = trim(substr(county,1,36));
alter table locations alter column county type varchar(10);

update locations set plss = upper(trim(plss));
update locations set plss = null where plss = ''; --0
alter table locations alter column plss type varchar(25);

update locations set form_2a_doc_num = trim(form_2a_doc_num);
update locations set form_2a_doc_num = null where form_2a_doc_num = ''; --72157
alter table locations alter column form_2a_doc_num type integer using form_2a_doc_num::integer;

update locations set form_2a_exp_date = trim(form_2a_exp_date);
update locations set form_2a_exp_date = null where form_2a_exp_date = ''; --0
update locations set form_2a_exp_date = null where form_2a_exp_date = 'N/A'; --71612
alter table locations alter column form_2a_exp_date type date using form_2a_exp_date::date;

alter table locations alter column location_details_url type varchar(50);
alter table locations alter column related_facilities_url type varchar(50);

alter table locations add column is_denver_basin boolean not null default false;
alter table locations add column is_piceance_basin boolean not null default false;
alter table locations add column is_raton_basin boolean not null default false;
alter table locations add column is_san_juan_basin boolean not null default false;


set search_path to public;
alter table staging.locations add column geom_4269 geometry(Point,4269);
alter table staging.locations add column geom geometry(Point,26913);
update staging.locations set geom_4269 = ST_SetSRID(ST_Point(longitude, latitude),4269) where latitude is not null and longitude is not null;
update staging.locations set geom = ST_Transform(ST_SetSRID(geom_4269, 4269), 26913) where geom_4269 is not null;

update staging.locations set is_denver_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='DENVER'));
update staging.locations set is_piceance_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='UINTA-PICEANCE'));
update staging.locations set is_raton_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='RATON BASIN'));
update staging.locations set is_san_juan_basin = 'true' where ST_Within(geom,(select geom from shale_gas_basins where name ='SAN JUAN'));



set search_path to staging;
COPY (select id, facility_name, facility_number, operator_name, operator_number, status_code, status_date, field_code, field_number, county, county_api, is_denver_basin, is_piceance_basin, is_raton_basin, is_san_juan_basin, longitude, latitude, plss, form_2a_doc_num, form_2a_exp_date, special_purpose_pits, drilling_pits, wells, production_pits, condensate_tanks, water_tanks, separators, electric_motors, gas_or_diesel_motors, cavity_pumps, lact_unit, pump_jacks, electric_generators, gas_pipeline, oil_pipeline, water_pipeline, gas_compressors, voc_combustor, oil_tanks, dehydrator_units, multi_well_pits, pigging_station, flare, fuel_tanks, location_details_url, related_facilities_url, created_at, updated_at from locations order by facility_number) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/locations.csv' WITH CSV;



set search_path to public;
create table backup.locations as table locations;
drop table locations;

create table locations (
	id integer, 
	facility_name varchar(35), 
	facility_number varchar(15), 
	operator_name varchar(50), 
	operator_number integer, 
	status_code varchar(2), 
	status_date date, 
	field_name varchar(20), 
	field_number integer, 
	county_name varchar(10), 
	county_api varchar(3), 
	is_denver_basin boolean, 
	is_piceance_basin boolean, 
	is_raton_basin boolean, 
	is_san_juan_basin boolean,
	longitude double precision, 
	latitude double precision, 
	plss varchar(25), 
	form_2a_doc_num integer, 
	form_2a_exp_date date, 
	special_purpose_pits smallint, 
	drilling_pits smallint, 
	wells smallint, 
	production_pits smallint, 
	condensate_tanks smallint, 
	water_tanks smallint, 
	separators smallint, 
	electric_motors smallint, 
	gas_or_diesel_motors smallint, 
	cavity_pumps smallint, 
	lact_unit smallint, 
	pump_jacks smallint, 
	electric_generators smallint, 
	gas_pipeline smallint, 
	oil_pipeline smallint, 
	water_pipeline smallint, 
	gas_compressors smallint, 
	voc_combustor smallint, 
	oil_tanks smallint, 
	dehydrator_units smallint, 
	multi_well_pits smallint, 
	pigging_station smallint, 
	flare smallint, 
	fuel_tanks smallint, 
	location_details_url varchar(50), 
	related_facilities_url varchar(50), 
	created_at date, 
	updated_at date
);

copy locations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/locations.csv' (format csv, delimiter ',', null '');

alter table locations add primary key (id);



----------------------------------------------------------
----------------------   PITS   --------------------------
----------------------------------------------------------

--download and import pits shapefile


-- use last year's scrape in awgsrn main database
COPY (select p.facility_i as id, p.facility_1 as pit_name, p.facility_n as pit_number, p.facility_s as status_code, p.attrib_2 as operator_name, p.operator_n as operator_number, p.field_name, p.field_code, p.long, p.lat, p.utm_x, p.utm_y, p.county_name, p.api_county, pd.sensitive_area, pd.land_use, pd.water_source_distance, pd.surface_water_distance, pd.ground_water_distance, pd.water_well_distance, pd.size, pd.depth, pd.length, pd.width, pd.capacity, pd.daily_disposal_evap_rate, pd.daily_disposal_perc_rate, pd.pit_type, pd.liner_material, pd.liner_thickness, pd.treatment_method, pd.covering_fence, pd.covering_net, pd.comment, '2014-10-10' as created_at, '2014-10-10' as updated_at from cogcc_pits p inner join cogcc_pit_details pd on p.id = pd.cogcc_pit_id order by p.facility_i) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/pits.csv' WITH CSV;

set search_path to staging;
drop table pits;
create table pits (
	id integer, 
	pit_name varchar(35), 
	pit_number varchar(15), 
	status_code varchar(2), 
	operator_name varchar(50), 
	operator_number integer, 
	field_name varchar(30), 
	field_code integer, 
	longitude double precision, 
	latitude double precision, 
	utm_x double precision, 
	utm_y double precision, 
	county_name varchar(30), 
	api_county varchar(3), 
	sensitive_area varchar(255), 
	land_use varchar(255), 
	water_source_distance varchar(255), 
	surface_water_distance varchar(255), 
	ground_water_distance varchar(255), 
	water_well_distance varchar(255), 
	size varchar(255), 
	depth varchar(255), 
	length varchar(255), 
	width varchar(255), 
	capacity varchar(255), 
	daily_disposal_evap_rate varchar(255), 
	daily_disposal_perc_rate varchar(255), 
	pit_type varchar(255), 
	liner_material varchar(255), 
	liner_thickness varchar(255), 
	treatment_method varchar(255), 
	covering_fence varchar(255), 
	covering_net varchar(255), 
	comment text,  
	created_at date, 
	updated_at date
);

copy pits from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/pits.csv' (format csv, delimiter ',', null '');


-- clean up data
update pits set pit_name = upper(trim(pit_name));
update pits set pit_name = null where pit_name = ''; --0

update pits set pit_number = upper(trim(pit_number));
update pits set pit_number = null where pit_number = ''; --0

update pits set status_code = upper(trim(status_code));
update pits set status_code = null where status_code = ''; --0

update pits set operator_name = upper(trim(operator_name));
update pits set operator_name = null where operator_name = ''; --0

update pits set field_name = upper(trim(field_name));
update pits set field_name = null where field_name = ''; --0

update pits set county_name = trim(county_name);
update pits set county_name = null where county_name = ''; --0
alter table pits alter column county_name type varchar(10);

update pits set sensitive_area = upper(trim(sensitive_area));
update pits set sensitive_area = null where sensitive_area = ''; --6349
alter table pits alter column sensitive_area type boolean using sensitive_area::boolean;

update pits set land_use = upper(trim(land_use));
update pits set land_use = null where land_use = ''; --10502
alter table pits alter column land_use type varchar(13);

-- water_source_distance, all values null!
-- surface_water_distance, all values null!
-- ground_water_distance, all values null!
-- water_well_distance, all values null!
-- size, all values null!

update pits set depth = trim(depth);
update pits set depth = null where depth = ''; --9881
alter table pits alter column depth type integer using depth::integer;

update pits set length = trim(length);
update pits set length = null where length = ''; --9843
alter table pits alter column length type integer using length::integer;

update pits set width = trim(width);
update pits set width = null where width = ''; --9845
alter table pits alter column width type integer using width::integer;

update pits set capacity = trim(capacity);
update pits set capacity = null where capacity = ''; --9905
alter table pits alter column capacity type integer using capacity::integer;

update pits set daily_disposal_evap_rate = trim(daily_disposal_evap_rate);
update pits set daily_disposal_evap_rate = null where daily_disposal_evap_rate = ''; --10537
alter table pits alter column daily_disposal_evap_rate type real using daily_disposal_evap_rate::real;

update pits set daily_disposal_perc_rate = trim(daily_disposal_perc_rate);
update pits set daily_disposal_perc_rate = null where daily_disposal_perc_rate = ''; --10739
alter table pits alter column daily_disposal_perc_rate type real using daily_disposal_perc_rate::real;

update pits set pit_type = upper(trim(pit_type));
update pits set pit_type = null where pit_type = ''; --13232
alter table pits alter column pit_type type varchar(14);

update pits set liner_material = upper(trim(liner_material));
update pits set liner_material = null where liner_material = ''; --0
alter table pits alter column liner_material type varchar(30);

update pits set liner_thickness = trim(liner_thickness);
update pits set liner_thickness = null where liner_thickness = ''; --0
alter table pits alter column liner_thickness type real using liner_thickness::real;

update pits set treatment_method = upper(trim(treatment_method));
update pits set treatment_method = null where treatment_method = ''; --10794
alter table pits alter column treatment_method type varchar(30);

update pits set covering_fence = upper(trim(covering_fence));
update pits set covering_fence = null where covering_fence = ''; --8512
update pits set covering_fence = 'YES' where covering_fence = 'FENCED'; --452
alter table pits alter column covering_fence type boolean using covering_fence::boolean;

update pits set covering_net = upper(trim(covering_net));
update pits set covering_net = null where covering_net = ''; --9411
update pits set covering_net = 'NO' where covering_net = 'N'; --1
update pits set covering_net = 'YES' where covering_net = 'NETTED'; --132
alter table pits alter column covering_net type boolean using covering_net::boolean;

update pits set comment = trim(comment);
update pits set comment = null where comment = ''; --11403

COPY (select id, pit_name, pit_number, status_code, operator_name, operator_number, field_name, field_code, longitude, latitude, utm_x, utm_y, county_name, api_county, sensitive_area, land_use, depth, length, width, capacity, daily_disposal_evap_rate, daily_disposal_perc_rate, pit_type, liner_material, liner_thickness, treatment_method, covering_fence, covering_net, comment, created_at, updated_at from pits order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/pits.csv' WITH CSV;


set search_path to public;
create table backup.pits as table pits;
drop table pits;
create table pits (
	id integer, 
	pit_name varchar(35), 
	pit_number varchar(15), 
	status_code varchar(2), 
	operator_name varchar(50), 
	operator_number integer, 
	field_name varchar(30), 
	field_code integer, 
	longitude double precision, 
	latitude double precision, 
	utm_x double precision, 
	utm_y double precision, 
	county_name varchar(10), 
	api_county varchar(3), 
	sensitive_area boolean, 
	land_use varchar(13), 
	depth integer, 
	length integer, 
	width integer, 
	capacity integer, 
	daily_disposal_evap_rate real, 
	daily_disposal_perc_rate real, 
	pit_type varchar(14), 
	liner_material varchar(30), 
	liner_thickness real, 
	treatment_method varchar(30), 
	covering_fence boolean, 
	covering_net boolean, 
	comment text,  
	created_at date, 
	updated_at date
);

copy pits from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/pits.csv' (format csv, delimiter ',', null '');

alter table pits add primary key (id);



---------------------------------------------------------------
----------------  INJECTION FACILITIES  -----------------------
---------------------------------------------------------------

select cogcc_facility_id, count(*) from cogcc_facility_details group by cogcc_facility_id HAVING count(*) > 1;

COPY (select f.facility_id, f.id as cogcc_facility_id, f.facility_type, f.facility_name, f.facility_number, f.status as status_code, fd.status_date, f.operator_name, f.operator_number, f.field_name, f.field_number, fd.longitude, fd.latitude, f.location_county as county_name, f.location_plss as plss_location, fd.order_number, fd.inj_initial_date, fd.inj_fluid_type, fd.comments, f.facility_detail_url, f.related_facilities_url, '2014-09-05' as created_at, '2014-09-05' as updated_at from cogcc_facilities f inner join cogcc_facility_details fd on f.id = fd.cogcc_facility_id where left(f.facility_type,3) = 'UIC' order by f.facility_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_facilities.csv' WITH CSV;

set search_path to staging;
drop table injections;
create table injections (
	id integer, 
	cogcc_facility_id integer, 
	facility_type varchar(50), 
	facility_name varchar(100), 
	facility_number varchar(20), 
	status_code varchar(20), 
	status_date varchar(12), 
	operator_name varchar(100), 
	operator_number varchar(20), 
	field_name varchar(100), 
	field_number integer, 
	longitude double precision, 
	latitude double precision, 
	county_name varchar(100), 
	plss_location varchar(100), 
	order_number varchar(20), 
	inj_initial_date varchar(20), 
	inj_fluid_type varchar(50), 
	comments text, 
	facility_detail_url varchar(100), 
	related_facilities_url varchar(100), 
	created_at date, 
	updated_at date
);

copy injections from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_facilities.csv' (format csv, delimiter ',', null '');

update injections set facility_type = upper(trim(facility_type));
update injections set facility_type = null where facility_type = ''; --0
alter table injections alter column facility_type type varchar(30);

update injections set facility_name = upper(trim(facility_name));
update injections set facility_name = null where facility_name = ''; --0
alter table injections alter column facility_name type varchar(35);

-- drop facility_number
alter table injections drop column facility_number;

update injections set status_code = upper(trim(status_code));
update injections set status_code = null where status_code = ''; --0
alter table injections alter column status_code type varchar(2);

update injections set status_date = upper(trim(status_date));
update injections set status_date = null where status_date = ''; --0
update injections set status_date = null where status_date = 'N/A'; --9
alter table injections alter column status_date type date using status_date::date;

update injections set operator_name = upper(trim(operator_name));
update injections set operator_name = null where operator_name = ''; --0
alter table injections alter column operator_name type varchar(50);

alter table injections alter column operator_number type integer using operator_number::integer;

update injections set field_name = upper(trim(field_name));
update injections set field_name = null where field_name = ''; --0
alter table injections alter column field_name type varchar(30);

alter table injections alter column field_number type integer using field_number::integer;

select county_name, left(county_name,36) as county from injections;
select county_name, right(county_name,3) as county_api from injections where length(county_name) > 11;
alter table injections add column county_api varchar(3);
update injections set county_api = right(county_name,3) where length(county_name) > 11;
update injections set county_name = trim(left(county_name,36)) where county_name is not null;
alter table injections alter column county_name type varchar(10);

update injections set plss_location = upper(trim(plss_location));
update injections set plss_location = null where plss_location = ''; --50
alter table injections alter column plss_location type varchar(25);

update injections set order_number = upper(trim(order_number));
update injections set order_number = null where order_number = ''; --583
alter table injections alter column order_number type varchar(6);

update injections set inj_initial_date = upper(trim(inj_initial_date));
update injections set inj_initial_date = null where inj_initial_date = ''; --0
update injections set inj_initial_date = null where inj_initial_date = 'N/A'; --428
alter table injections alter column inj_initial_date type date using inj_initial_date::date;

update injections set inj_fluid_type = upper(trim(inj_fluid_type));
update injections set inj_fluid_type = null where inj_fluid_type = ''; --430
alter table injections alter column inj_fluid_type type varchar(20);

-- drop comments
alter table injections drop column comments;

alter table injections alter column facility_detail_url type varchar(70);
alter table injections alter column related_facilities_url type varchar(35);


COPY (select id, facility_type, facility_name, status_code, status_date, operator_name, operator_number, field_name, field_number, longitude, latitude, county_name, county_api, plss_location, order_number, inj_initial_date, inj_fluid_type, facility_detail_url, related_facilities_url, created_at, updated_at from injections order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_facilities.csv' WITH CSV;

set search_path to public;
drop table injection_facilities;
create table injection_facilities (
	id integer, 
	facility_type varchar(30), 
	facility_name varchar(35), 
	status_code varchar(2), 
	status_date date, 
	operator_name varchar(50), 
	operator_number integer, 
	field_name varchar(30), 
	field_number integer, 
	longitude double precision, 
	latitude double precision, 
	county_name varchar(10),
	county_api varchar(3),  
	plss_location varchar(25), 
	order_number varchar(6), 
	inj_initial_date date, 
	inj_fluid_type varchar(20), 
	facility_detail_url varchar(70), 
	related_facilities_url varchar(35), 
	created_at date, 
	updated_at date
);

copy injection_facilities from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_facilities.csv' (format csv, delimiter ',', null '');

alter table injection_facilities add primary key (id);



---------------------------------------------------------------
----------------  INJECTION FORMATIONS  -----------------------
---------------------------------------------------------------
COPY (select id, cogcc_facility_id, inj_zone_name, inj_zone_code, inj_avg_porosity, inj_avg_permeability, inj_tds, inj_frac_gradient, '2014-09-05' as created_at, '2014-09-05' as updated_at from cogcc_facility_formations order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_formations.csv' WITH CSV;

set search_path to staging;
drop table injection_formations;
create table injection_formations (
	id integer, 
	cogcc_facility_id integer, 
	inj_zone_name varchar(100), 
	inj_zone_code varchar(20), 
	inj_avg_porosity varchar(20), 
	inj_avg_permeability varchar(20), 
	inj_tds varchar(20), 
	inj_frac_gradient varchar(50), 
	created_at date, 
	updated_at date
);

copy injection_formations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_formations.csv' (format csv, delimiter ',', null '');

alter table injection_formations add column injection_facility_id integer;
update injection_formations set injection_facility_id = (select id from injections where cogcc_facility_id = injection_formations.cogcc_facility_id);

alter table injection_formations drop column cogcc_facility_id;

update injection_formations set inj_zone_name = upper(trim(inj_zone_name));
update injection_formations set inj_zone_name = null where inj_zone_name = ''; --19
alter table injection_formations alter column inj_zone_name type varchar(35);

update injection_formations set inj_zone_code = upper(trim(inj_zone_code));
update injection_formations set inj_zone_code = null where inj_zone_code = ''; --19
alter table injection_formations alter column inj_zone_code type varchar(5);

update injection_formations set inj_avg_porosity = trim(inj_avg_porosity);
update injection_formations set inj_avg_porosity = null where inj_avg_porosity = ''; --571
alter table injection_formations alter column inj_avg_porosity type smallint using inj_avg_porosity::smallint;

update injection_formations set inj_avg_permeability = trim(inj_avg_permeability);
update injection_formations set inj_avg_permeability = null where inj_avg_permeability = ''; --637
alter table injection_formations alter column inj_avg_permeability type smallint using inj_avg_permeability::smallint;

update injection_formations set inj_tds = trim(inj_tds);
update injection_formations set inj_tds = null where inj_tds = ''; --42
alter table injection_formations alter column inj_tds type integer using inj_tds::integer;

update injection_formations set inj_frac_gradient = trim(inj_frac_gradient);
update injection_formations set inj_frac_gradient = null where inj_frac_gradient = ''; --37
alter table injection_formations alter column inj_frac_gradient type double precision using inj_frac_gradient::double precision;

delete from injection_formations where inj_zone_name is null; --19

COPY (select id, injection_facility_id, inj_zone_name, inj_zone_code, inj_avg_porosity, inj_avg_permeability, inj_tds, inj_frac_gradient, created_at, updated_at from injection_formations order by injection_facility_id, inj_zone_name) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_formations.csv' WITH CSV;


set search_path to public;
drop table injection_formations;
create table injection_formations (
	id integer, 
	injection_facility_id integer, 
	inj_zone_name varchar(35), 
	inj_zone_code varchar(5), 
	inj_avg_porosity smallint, 
	inj_avg_permeability smallint, 
	inj_tds integer, 
	inj_frac_gradient double precision, 
	created_at date, 
	updated_at date
);

copy injection_formations from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_formations.csv' (format csv, delimiter ',', null '');

alter table injection_formations add primary key (id);



---------------------------------------------------------------
------------  INJECTION FACILITY WELLS  -----------------------
---------------------------------------------------------------
COPY (select cogcc_facility_id, api_number, well_name, well_url, facility_status, wellbore_status, authorization_date, no_longer_injector_date, max_water_inj_psi, max_gas_inj_psi, max_inj_volume, last_mit, '2014-09-05' as created_at, '2014-09-05' as updated_at from cogcc_facility_wells where cogcc_facility_id in (select id from cogcc_facilities where left(facility_type,3) = 'UIC') order by cogcc_facility_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_wells.csv' WITH CSV;

set search_path to staging;
drop table injection_wells;
create table injection_wells (
	cogcc_facility_id integer, 
	api_number varchar(16), 
	well_name varchar(100), 
	well_url varchar(100), 
	facility_status varchar(10), 
	wellbore_status varchar(10), 
	authorization_date varchar(12), 
	no_longer_injector_date varchar(12), 
	max_water_inj_psi varchar(20), 
	max_gas_inj_psi varchar(20), 	
	max_inj_volume varchar(20), 
	last_mit varchar(50),
	created_at date, 
	updated_at date
);

copy injection_wells from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/injection_wells.csv' (format csv, delimiter ',', null '');

alter table injection_wells add column injection_facility_id integer;
update injection_wells set injection_facility_id = (select id from injections where cogcc_facility_id = injection_wells.cogcc_facility_id);

alter table injection_wells drop column cogcc_facility_id;
alter table injection_wells add column id serial not null primary key;

update injection_wells set api_number = upper(trim(api_number));
update injection_wells set api_number = null where api_number = ''; --0
alter table injection_wells alter column api_number type varchar(12);

alter table injection_wells add column well_id integer;
update injection_wells set well_id = replace(right(api_number,9),'-','')::integer where length(api_number) = 12;

select well_name, left(well_name,37) as name from injection_wells;
select well_name, substr(well_name,39,length(well_name)-37) as num from injection_wells;
alter table injection_wells add column well_number varchar(20);
update injection_wells set well_number = substr(well_name,39,length(well_name)-37);
update injection_wells set well_name = trim(left(well_name,37));
alter table injection_wells alter column well_name type varchar(35);
alter table injection_wells alter column well_number type varchar(15);
update injection_wells set well_name = upper(trim(well_name));
update injection_wells set well_number = upper(trim(well_number));

update injection_wells set facility_status = upper(trim(facility_status));
update injection_wells set facility_status = null where facility_status = ''; --0
alter table injection_wells alter column facility_status type varchar(2);

update injection_wells set wellbore_status = upper(trim(wellbore_status));
update injection_wells set wellbore_status = null where wellbore_status = ''; --6
alter table injection_wells alter column wellbore_status type varchar(2);

update injection_wells set authorization_date = upper(trim(authorization_date));
update injection_wells set authorization_date = null where authorization_date = ''; --0
update injection_wells set authorization_date = null where authorization_date = 'N/A'; --3430
alter table injection_wells alter column authorization_date type date using authorization_date::date;

update injection_wells set no_longer_injector_date = upper(trim(no_longer_injector_date));
update injection_wells set no_longer_injector_date = null where no_longer_injector_date = ''; --0
update injection_wells set no_longer_injector_date = null where no_longer_injector_date = 'N/A'; --2735
alter table injection_wells alter column no_longer_injector_date type date using no_longer_injector_date::date;

update injection_wells set max_water_inj_psi = trim(max_water_inj_psi);
update injection_wells set max_water_inj_psi = null where max_water_inj_psi = ''; --8
alter table injection_wells alter column max_water_inj_psi type integer using max_water_inj_psi::integer;

update injection_wells set max_gas_inj_psi = trim(max_gas_inj_psi);
update injection_wells set max_gas_inj_psi = null where max_gas_inj_psi = ''; --350
alter table injection_wells alter column max_gas_inj_psi type integer using max_gas_inj_psi::integer;

update injection_wells set max_inj_volume = trim(max_inj_volume);
update injection_wells set max_inj_volume = null where max_inj_volume = ''; --3879
alter table injection_wells alter column max_inj_volume type integer using max_inj_volume::integer;

update injection_wells set last_mit = upper(trim(last_mit));
update injection_wells set last_mit = null where last_mit = ''; --973
select left(last_mit,position('/' in last_mit)+strpos(substr(last_mit,position('/' in last_mit)+1,length(last_mit)),'/')+4) || ',' || substr(last_mit,position('/' in last_mit)+strpos(substr(last_mit,position('/' in last_mit)+1,length(last_mit)),'/')+5,length(last_mit)), last_mit from injection_wells where length(last_mit) > 10;
update injection_wells set last_mit = left(last_mit,position('/' in last_mit)+strpos(substr(last_mit,position('/' in last_mit)+1,length(last_mit)),'/')+4) || ',' || substr(last_mit,position('/' in last_mit)+strpos(substr(last_mit,position('/' in last_mit)+1,length(last_mit)),'/')+5,length(last_mit)) where length(last_mit) > 10;
select last_mit, id from injection_wells where length(last_mit) > 21;
update injection_wells set last_mit = '10/25/2006,8/14/2009,4/6/2011' where id = 4130;
update injection_wells set last_mit = '8/10/2005,10/10/2006,6/17/2011' where id = 3907;
update injection_wells set last_mit = '8/10/2005,10/10/2006,6/17/2011' where id = 3908;
update injection_wells set last_mit = '11/29/2006,8/1/2007,4/4/2012' where id = 4100;
update injection_wells set last_mit = '11/29/2006,8/1/2007,4/4/2012' where id = 4101;
update injection_wells set last_mit = '10/25/2006,8/14/2009,4/6/2011' where id = 4135;
alter table injection_wells alter column last_mit type varchar(35);

COPY (select id, injection_facility_id, api_number, well_id, well_name, facility_status, wellbore_status, authorization_date, no_longer_injector_date, max_water_inj_psi, max_gas_inj_psi, max_inj_volume, last_mit, well_url, created_at, updated_at from injection_wells order by injection_facility_id, api_number) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_wells.csv' WITH CSV;


set search_path to public;
drop table injection_wells;
create table injection_wells (
	id integer, 
	injection_facility_id integer, 
	well_api_number varchar(12), 
	well_id integer, 
	well_name varchar(35), 
	facility_status varchar(2), 
	wellbore_status varchar(2), 
	authorization_date date, 
	no_longer_injector_date date, 
	max_water_inj_psi integer, 
	max_gas_inj_psi integer, 	
	max_inj_volume integer, 
	last_mit varchar(35),
	well_url varchar(70), 
	created_at date, 
	updated_at date
);

copy injection_wells from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/injection_wells.csv' (format csv, delimiter ',', null '');

alter table injection_wells add primary key (id);

create index index_injection_wells_on_well_id on injection_wells (well_id);


---------------------------------------------------------------
-------------------  OTHER FACILITIES  ------------------------
---------------------------------------------------------------
select count(*) as fac_count, facility_type from cogcc_facilities where facility_type not in ('LOCATION','LEASE','SPILL OR RELEASE') and left(facility_type,3) <> 'UIC' group by facility_type order by fac_count desc;

 fac_count |         facility_type
-----------+-------------------------------
       161 | GAS COMPRESSOR
       130 | GAS PROCESSING PLANT
       119 | NONFACILITY
        98 | GAS GATHERING SYSTEM
        84 | TANK BATTERY
        45 | CENTRALIZED EP WASTE MGMT FAC
        14 | PIPELINE
         9 | GAS STORAGE FACILITY
         7 | LAND APPLICATION SITE
         7 | FLOWLINE
         4 | WATER GATHERING SYSTEM/LINE
         1 | SERVICE SITE

select count(*) from cogcc_facilities where facility_type not in ('LOCATION','LEASE','SPILL OR RELEASE') and left(facility_type,3) <> 'UIC';--679


COPY (select f.facility_id, f.facility_type, f.facility_name, f.facility_number, f.status as status_code, fd.status_date, f.operator_name, f.operator_number, f.field_name, f.field_number, fd.longitude, fd.latitude, f.location_county as county_name, f.location_plss as plss_location, fd.order_number, fd.inj_initial_date, fd.inj_fluid_type, fd.comments, f.facility_detail_url, f.related_facilities_url, '2014-09-05' as created_at, '2014-09-05' as updated_at from cogcc_facilities f inner join cogcc_facility_details fd on f.id = fd.cogcc_facility_id where facility_type not in ('LOCATION','LEASE','SPILL OR RELEASE') and left(facility_type,3) <> 'UIC' order by f.facility_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/facilities_other.csv' WITH CSV;

set search_path to staging;
drop table facilities;
create table facilities (
	id integer, 
	facility_type varchar(50), 
	facility_name varchar(100), 
	facility_number varchar(20), 
	status_code varchar(20), 
	status_date varchar(12), 
	operator_name varchar(100), 
	operator_number varchar(20), 
	field_name varchar(100), 
	field_number integer, 
	longitude double precision, 
	latitude double precision, 
	county_name varchar(100), 
	plss_location varchar(100), 
	order_number varchar(20), 
	inj_initial_date varchar(20), 
	inj_fluid_type varchar(50), 
	comments text, 
	facility_detail_url varchar(100), 
	related_facilities_url varchar(100), 
	created_at date, 
	updated_at date
);

copy facilities from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2014/facilities_other.csv' (format csv, delimiter ',', null '');

update facilities set facility_type = upper(trim(facility_type));
update facilities set facility_type = null where facility_type = ''; --0
alter table facilities alter column facility_type type varchar(30);

update facilities set facility_name = upper(trim(facility_name));
update facilities set facility_name = null where facility_name = ''; --0
alter table facilities alter column facility_name type varchar(35);

update facilities set facility_number = upper(trim(facility_number));
update facilities set facility_number = null where facility_number = ''; --13
alter table facilities alter column facility_number type varchar(14);

update facilities set status_code = upper(trim(status_code));
update facilities set status_code = null where status_code = ''; --82
alter table facilities alter column status_code type varchar(2);

update facilities set status_date = upper(trim(status_date));
update facilities set status_date = null where status_date = ''; --0
update facilities set status_date = null where status_date = 'N/A'; --1
alter table facilities alter column status_date type date using status_date::date;

update facilities set operator_name = upper(trim(operator_name));
update facilities set operator_name = null where operator_name = ''; --0
alter table facilities alter column operator_name type varchar(50);

alter table facilities alter column operator_number type integer using operator_number::integer;

update facilities set field_name = upper(trim(field_name));
update facilities set field_name = null where field_name = ''; --0
alter table facilities alter column field_name type varchar(30);

alter table facilities alter column field_number type integer using field_number::integer;

select county_name, left(county_name,36) as county from facilities;
select county_name, right(county_name,3) as county_api from facilities where length(county_name) > 11;
alter table facilities add column county_api varchar(3);
update facilities set county_api = right(county_name,3) where length(county_name) > 11;
update facilities set county_name = trim(left(county_name,36)) where county_name is not null;
alter table facilities alter column county_name type varchar(10);

update facilities set plss_location = upper(trim(plss_location));
update facilities set plss_location = null where plss_location = ''; --23
alter table facilities alter column plss_location type varchar(25);

alter table facilities drop column order_number;
alter table facilities drop column inj_initial_date;
alter table facilities drop column inj_fluid_type;

update facilities set comments = trim(comments);
update facilities set comments = null where comments = ''; --300

alter table facilities alter column facility_detail_url type varchar(70);
alter table facilities alter column related_facilities_url type varchar(35);

COPY (select id, facility_type, facility_name, facility_number, status_code, status_date, operator_name, operator_number, field_name, field_number, longitude, latitude, county_name, county_api, plss_location, comments, facility_detail_url, related_facilities_url, created_at, updated_at from facilities order by id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/facilities_other.csv' WITH CSV;

set search_path to public;
drop table facilities;
create table facilities (
	id integer, 
	facility_type varchar(30), 
	facility_name varchar(35), 
	facility_number varchar(14), 
	status_code varchar(2), 
	status_date date, 
	operator_name varchar(50), 
	operator_number integer, 
	field_name varchar(30), 
	field_number integer, 
	longitude double precision, 
	latitude double precision, 
	county_name varchar(10),
	county_api varchar(3),  
	plss_location varchar(25), 
	comments text, 
	facility_detail_url varchar(70), 
	related_facilities_url varchar(35), 
	created_at date, 
	updated_at date
);

copy facilities from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/facilities_other.csv' (format csv, delimiter ',', null '');

alter table facilities add primary key (id);






-- pg_dump -d cogcc_development -U cogcc -w -n public -T bedrock_aquifers -T bradenhead_tests -T casing_details -T schema_migrations -T shale_gas_basins -T spatial_ref_sys -T well_denver_aquifer_depths > cogcc_development_20151006.sql

-- psql -d cogcc_production -f cogcc_development_20151006.sql



create table owen_samples (
	FacID integer, 
	FacType varchar(50),
	FacGroup varchar(50),
	ProjNum varchar(100),
	County varchar(20),
	Basin varchar(50),
	QQ varchar(12),
	Section varchar(12),
	Township varchar(12),
	Range varchar(12),
	Mer varchar(12),
	Elevation varchar(20),
	Long83 double precision,
	Lat83 double precision,
	UtmX13 double precision,
	UtmY13 double precision,
	SpatialQCflag varchar(50),
	WellName varchar(50),
	Owner varchar(50),
	DWRreceipt varchar(30),
	DWRpermit varchar(30),
	WellDepth varchar(20),
	WellAPI varchar(20),
	WellStatus varchar(10),
	SampleID integer,
	SampleDate varchar(20),
	Matrix varchar(35),
	Parameter varchar(100),
	Value varchar(35),
	Unit varchar(35),
	DetLimit varchar(35),
	Qualifier varchar(35),
	FractionType varchar(35),
	LabName varchar(100),
	SampleReason varchar(100),
	ResultID integer,
	MethodCode varchar(50),
	DataQCflag varchar(50)
);

copy owen_samples from '/Users/troyburke/Downloads/COGCC_MergedDataProduct_QCLevel1_Feb2015.csv' (format csv, delimiter ',', null 'NA');


COPY (select ss.sample_site_id as facid, ss.facility_type as factype, null as facgroup, ss.project_number as projnum, ss.county, case when ss.is_denver_basin is true then 'denver basin' when ss.is_piceance_basin is true then 'piceance basin' when ss.is_raton_basin is true then 'raton basin' when ss.is_san_juan_basin is true then 'san juan basin' else 'NA' end as basin, ss.quarter_quarter as qq, ss.section, ss.township, ss.range, ss.meridian as mer, ss.elevation, ss.longitude as long83, ss.latitude as lat83, ss.utm_x as utmx13, ss.utm_y as utmy13, null as spatialqcflag, null as wellname, null as owner, ss.receipt_number as dwrreceipt, ss.permit_number as dwrpermit, ss.well_depth as welldepth, null as wellapi, null as wellstatus, s.sample_id as sampleid, s.sample_date as sampledate, s.matrix, r.parameter_description as parameter, r.result_value as value, r.units as unit, r.detection_limit as detlimit, r.qualifier, r.fraction_type, s.sampler as labname, s.sample_reason as samplereason, r.method_code as methodcode, null as dataqcflag from environmental_sample_results r inner join environmental_samples s on r.environmental_sample_id = s.id inner join environmental_sample_sites ss on r.environmental_sample_site_id = ss.id where r.sample_id not in (select distinct sampleid from owen_samples) order by r.sample_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/new_owen_samples.csv' WITH CSV HEADER NULL AS 'NA';




---------------------------------------------------------------
--------------------  BRADENHEAD TESTS  -----------------------
---------------------------------------------------------------

-- Using well document index - download bradenhead test reports
set search_path to public;
create table backup.bradenhead_tests as table bradenhead_tests;
drop table bradenhead_tests;
create table bradenhead_tests (
	id serial not null primary key, 
	well_document_id integer, 
	well_id integer, 
	document_id integer, 
	document_number integer, 
	document_name varchar(100), 
	document_date date, 
	doc_year smallint, 
	well_api_number varchar(12), 
	county_api_code varchar(3), 
	text_imported boolean not null default false, 
	test_date date, 
	test_year smallint, 
	test_month smallint, 
	surface_casing_psi integer, 
	production_casing_psi integer, 
	intermediate_casing_psi integer, 
	tubing_1_psi integer, 
	tubing_2_psi integer, 
	end_of_test_psi varchar(10), 
	final_psi integer, 
	all_psi_null boolean not null default false, 
	is_denver_basin boolean not null default false, 
	is_denver_aquifer boolean not null default false, 
	is_new_scrape boolean not null default false, 
	created_at timestamp, 
	updated_at timestamp
);

COPY (select id, cogcc_document_id, well_id, document_id, document_number, document_name, document_date, doc_year, well_api_number, api_county, text_imported, test_date, year_int, month_int, surf_casing_psi, prod_casing_psi, intermediate_casing_psi, tubing_psi_1, tubing_psi_2, eot_psi, final_pressure, all_psi_null, is_denver_basin, is_denver_aquifer, is_new_scrape, now(), now() from cogcc_bradenhead_tests order by well_id, document_date) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/bradenhead_tests.csv' WITH CSV;

copy bradenhead_tests from '/Users/troyburke/Data/cogcc_query_database/table_dumps_2015/bradenhead_tests.csv' (format csv, delimiter ',', null '');

COPY (select count(*) as document_count, document_name from well_documents where document_name ilike '%bradenhead%' group by document_name order by document_count desc) TO '/Users/troyburke/Data/cogcc_query_database/bradenhead_docs.csv' WITH CSV HEADER;


select well_api_number, document_number, document_name, document_date, download_url from import.well_documents where document_name in ('CORRESPONDENCE_vent_bradenhead','BRADENHEAD REPORT AFTER CEMENT JOB','bradenhead squeeze procedure','CORRESPONDENCE_high_Bradenhead_pressure','noav-bradenhead pressure','CORRESPONDENCE_HIGH_BRADENHEAD','SUNDRY NOTICES-VENT BRADENHEAD GAS','EMAIL: ACTION PLAN TO BRADENHEAD TEST','SUNDRY NOTICE - VENT BRADENHEAD','EMAIL: REMEDIATE BRADENHEAD PRESSURE','bradenhead test report/noav','EMAIL BRADENHEAD PRESSURE UPDATE','request for bradenhead pressure plan','bradenhead pressure plan','EMAIL: BRADENHEAD UPDATE','BRADENHEAD WATER SAMPLE 04/18/2006','SUNDRY NOTICE_vent _bradenhead','EMAIL: SUMMARY/BRADENHEAD PRESSURE/VENTING & CBL','execess bradenhead pressures','CORRESPONDENCE_bradenhead_issue');


---------------------------------------------------------------
----------------------  CASING DETAILS  -----------------------
---------------------------------------------------------------
set search_path to public;
create table backup.casing_details as table casing_details;
drop table casing_details;
create table casing_details (
	id serial not null primary key, 
	well_id integer, 
	sidetrack_id integer
);

insert into casing_details (well_id, sidetrack_id) select well_id, id from sidetracks order by well_id, sidetrack_number;

alter table casing_details add column casing_1_string_type varchar(20);
alter table casing_details add column casing_1_hole_size varchar(10);
alter table casing_details add column casing_1_size varchar(10);
alter table casing_details add column casing_1_depth varchar(10);
alter table casing_details add column casing_1_weight varchar(15);
alter table casing_details add column casing_1_cement_top varchar(10);
alter table casing_details add column casing_1_cement_bottom varchar(10);
alter table casing_details add column casing_1_cement_method_grade varchar(20);

alter table casing_details add column casing_2_string_type varchar(20);
alter table casing_details add column casing_2_hole_size varchar(10);
alter table casing_details add column casing_2_size varchar(10);
alter table casing_details add column casing_2_depth varchar(10);
alter table casing_details add column casing_2_weight varchar(15);
alter table casing_details add column casing_2_cement_top varchar(10);
alter table casing_details add column casing_2_cement_bottom varchar(10);
alter table casing_details add column casing_2_cement_method_grade varchar(20);

alter table casing_details add column casing_3_string_type varchar(20);
alter table casing_details add column casing_3_hole_size varchar(10);
alter table casing_details add column casing_3_size varchar(10);
alter table casing_details add column casing_3_depth varchar(10);
alter table casing_details add column casing_3_weight varchar(15);
alter table casing_details add column casing_3_cement_top varchar(10);
alter table casing_details add column casing_3_cement_bottom varchar(10);
alter table casing_details add column casing_3_cement_method_grade varchar(20);

alter table casing_details add column casing_4_string_type varchar(20);
alter table casing_details add column casing_4_hole_size varchar(10);
alter table casing_details add column casing_4_size varchar(10);
alter table casing_details add column casing_4_depth varchar(10);
alter table casing_details add column casing_4_weight varchar(15);
alter table casing_details add column casing_4_cement_top varchar(10);
alter table casing_details add column casing_4_cement_bottom varchar(10);
alter table casing_details add column casing_4_cement_method_grade varchar(20);

alter table casing_details add column casing_5_string_type varchar(20);
alter table casing_details add column casing_5_hole_size varchar(10);
alter table casing_details add column casing_5_size varchar(10);
alter table casing_details add column casing_5_depth varchar(10);
alter table casing_details add column casing_5_weight varchar(15);
alter table casing_details add column casing_5_cement_top varchar(10);
alter table casing_details add column casing_5_cement_bottom varchar(10);
alter table casing_details add column casing_5_cement_method_grade varchar(20);

alter table casing_details add column casing_6_string_type varchar(20);
alter table casing_details add column casing_6_hole_size varchar(10);
alter table casing_details add column casing_6_size varchar(10);
alter table casing_details add column casing_6_depth varchar(10);
alter table casing_details add column casing_6_weight varchar(15);
alter table casing_details add column casing_6_cement_top varchar(10);
alter table casing_details add column casing_6_cement_bottom varchar(10);
alter table casing_details add column casing_6_cement_method_grade varchar(20);

alter table casing_details add column casing_7_string_type varchar(20);
alter table casing_details add column casing_7_hole_size varchar(10);
alter table casing_details add column casing_7_size varchar(10);
alter table casing_details add column casing_7_depth varchar(10);
alter table casing_details add column casing_7_weight varchar(15);
alter table casing_details add column casing_7_cement_top varchar(10);
alter table casing_details add column casing_7_cement_bottom varchar(10);
alter table casing_details add column casing_7_cement_method_grade varchar(20);

alter table casing_details add column casing_8_string_type varchar(20);
alter table casing_details add column casing_8_hole_size varchar(10);
alter table casing_details add column casing_8_size varchar(10);
alter table casing_details add column casing_8_depth varchar(10);
alter table casing_details add column casing_8_weight varchar(15);
alter table casing_details add column casing_8_cement_top varchar(10);
alter table casing_details add column casing_8_cement_bottom varchar(10);
alter table casing_details add column casing_8_cement_method_grade varchar(20);

alter table casing_details add column add_cement_1_string_type varchar(20);
alter table casing_details add column add_cement_1_top varchar(10);
alter table casing_details add column add_cement_1_depth varchar(10);
alter table casing_details add column add_cement_1_bottom varchar(10);
alter table casing_details add column add_cement_1_method_grade varchar(20);

alter table casing_details add column add_cement_2_string_type varchar(20);
alter table casing_details add column add_cement_2_top varchar(10);
alter table casing_details add column add_cement_2_depth varchar(10);
alter table casing_details add column add_cement_2_bottom varchar(10);
alter table casing_details add column add_cement_2_method_grade varchar(20);

alter table casing_details add column add_cement_3_string_type varchar(20);
alter table casing_details add column add_cement_3_top varchar(10);
alter table casing_details add column add_cement_3_depth varchar(10);
alter table casing_details add column add_cement_3_bottom varchar(10);
alter table casing_details add column add_cement_3_method_grade varchar(20);

alter table casing_details add column add_cement_4_string_type varchar(20);
alter table casing_details add column add_cement_4_top varchar(10);
alter table casing_details add column add_cement_4_depth varchar(10);
alter table casing_details add column add_cement_4_bottom varchar(10);
alter table casing_details add column add_cement_4_method_grade varchar(20);

alter table casing_details add column add_cement_5_string_type varchar(20);
alter table casing_details add column add_cement_5_top varchar(10);
alter table casing_details add column add_cement_5_depth varchar(10);
alter table casing_details add column add_cement_5_bottom varchar(10);
alter table casing_details add column add_cement_5_method_grade varchar(20);

alter table casing_details add column add_cement_6_string_type varchar(20);
alter table casing_details add column add_cement_6_top varchar(10);
alter table casing_details add column add_cement_6_depth varchar(10);
alter table casing_details add column add_cement_6_bottom varchar(10);
alter table casing_details add column add_cement_6_method_grade varchar(20);

alter table casing_details add column add_cement_7_string_type varchar(20);
alter table casing_details add column add_cement_7_top varchar(10);
alter table casing_details add column add_cement_7_depth varchar(10);
alter table casing_details add column add_cement_7_bottom varchar(10);
alter table casing_details add column add_cement_7_method_grade varchar(20);

alter table casing_details add column add_cement_8_string_type varchar(20);
alter table casing_details add column add_cement_8_top varchar(10);
alter table casing_details add column add_cement_8_depth varchar(10);
alter table casing_details add column add_cement_8_bottom varchar(10);
alter table casing_details add column add_cement_8_method_grade varchar(20);

alter table casing_details add column add_cement_9_string_type varchar(20);
alter table casing_details add column add_cement_9_top varchar(10);
alter table casing_details add column add_cement_9_depth varchar(10);
alter table casing_details add column add_cement_9_bottom varchar(10);
alter table casing_details add column add_cement_9_method_grade varchar(20);

alter table casing_details add column add_cement_10_string_type varchar(20);
alter table casing_details add column add_cement_10_top varchar(10);
alter table casing_details add column add_cement_10_depth varchar(10);
alter table casing_details add column add_cement_10_bottom varchar(10);
alter table casing_details add column add_cement_10_method_grade varchar(20);

alter table casing_details add column add_cement_11_string_type varchar(20);
alter table casing_details add column add_cement_11_top varchar(10);
alter table casing_details add column add_cement_11_depth varchar(10);
alter table casing_details add column add_cement_11_bottom varchar(10);
alter table casing_details add column add_cement_11_method_grade varchar(20);

alter table casing_details add column add_cement_12_string_type varchar(20);
alter table casing_details add column add_cement_12_top varchar(10);
alter table casing_details add column add_cement_12_depth varchar(10);
alter table casing_details add column add_cement_12_bottom varchar(10);
alter table casing_details add column add_cement_12_method_grade varchar(20);

alter table casing_details add column add_cement_13_string_type varchar(20);
alter table casing_details add column add_cement_13_top varchar(10);
alter table casing_details add column add_cement_13_depth varchar(10);
alter table casing_details add column add_cement_13_bottom varchar(10);
alter table casing_details add column add_cement_13_method_grade varchar(20);

alter table casing_details add column add_cement_14_string_type varchar(20);
alter table casing_details add column add_cement_14_top varchar(10);
alter table casing_details add column add_cement_14_depth varchar(10);
alter table casing_details add column add_cement_14_bottom varchar(10);
alter table casing_details add column add_cement_14_method_grade varchar(20);

alter table casing_details add column planned_surf_casing_depth integer;
alter table casing_details add column surface_casing_depth integer;
alter table casing_details add column has_surface_casing_check_doc boolean not null default false;
alter table casing_details add column has_sc_casing boolean not null default false;
alter table casing_details add column has_st_casing boolean not null default false;
alter table casing_details add column has_intermediate_casing boolean not null default false;
alter table casing_details add column has_no_casings boolean not null default false;

alter table casing_details add column has_1_casing  boolean not null default false;
alter table casing_details add column has_2_casings boolean not null default false;
alter table casing_details add column has_3_casings boolean not null default false;
alter table casing_details add column has_4_casings boolean not null default false;
alter table casing_details add column has_5_casings boolean not null default false;
alter table casing_details add column has_6_casings boolean not null default false;
alter table casing_details add column has_7_casings boolean not null default false;
alter table casing_details add column has_8_casings boolean not null default false;

alter table casing_details add column has_additional_cement boolean not null default false;
alter table casing_details add column has_cement_squeeze boolean not null default false;
alter table casing_details add column has_1_additional_cement boolean not null default false;
alter table casing_details add column has_2_additional_cement boolean not null default false;
alter table casing_details add column has_3_additional_cement boolean not null default false;
alter table casing_details add column has_4_additional_cement boolean not null default false;
alter table casing_details add column has_5_additional_cement boolean not null default false;
alter table casing_details add column has_6_additional_cement boolean not null default false;
alter table casing_details add column has_7_to_14_additional_cement boolean not null default false;

alter table casing_details add column possibly_remediated boolean not null default false;

alter table casing_details add column bradenhead_test_id integer;
alter table casing_details add column initial_bradenhead_psi integer;
alter table casing_details add column final_bradenhead_psi varchar(10);
alter table casing_details add column final_bradenhead_psi_integer integer;
alter table casing_details add column has_bradenhead_doc boolean not null default false;

update casing_details set planned_surf_casing_depth = (select casing_depth::integer from planned_casings where sidetrack_id = casing_details.sidetrack_id and casing_string_type = 'SURF' order by casing_depth::integer desc limit 1);

-- run casing details script 

update casing_details set surface_casing_depth = case when casing_2_string_type = 'SURF' and casing_3_string_type = 'SURF' then casing_3_depth::integer when casing_3_string_type = 'SURF' then casing_3_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_2_depth::integer > casing_1_depth::integer then casing_2_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_1_depth::integer > casing_2_depth::integer then casing_1_depth::integer when casing_1_string_type <> 'SURF' and casing_2_string_type = 'SURF' then casing_2_depth::integer when casing_1_string_type = 'SURF' then casing_1_depth::integer else null end;

update casing_details set has_surface_casing_check_doc = 'true' where well_id in (select distinct well_id from well_documents where document_name ilike '%surface casing check%');

update casing_details set has_sc_casing = 'true' where (casing_1_string_type ilike 's.c.%' or casing_2_string_type ilike 's.c.%' or casing_3_string_type ilike 's.c.%' or casing_4_string_type ilike 's.c.%' or casing_5_string_type ilike 's.c.%' or casing_6_string_type ilike 's.c.%' or casing_7_string_type ilike 's.c.%' or casing_8_string_type ilike 's.c.%');

update casing_details set has_st_casing = 'true' where (casing_1_string_type ilike 'stage%' or casing_2_string_type ilike 'stage%' or casing_3_string_type ilike 'stage%' or casing_4_string_type ilike 'stage%' or casing_5_string_type ilike 'stage%' or casing_6_string_type ilike 'stage%' or casing_7_string_type ilike 'stage%' or casing_8_string_type ilike 'stage%');

update casing_details set has_intermediate_casing = 'true' where (casing_1_string_type = '1ST' and casing_2_string_type = '2ND' and casing_1_size <> casing_2_size) or (casing_2_string_type = '1ST' and casing_3_string_type = '2ND' and casing_2_size <> casing_3_size) or (casing_3_string_type = '1ST' and casing_4_string_type = '2ND' and casing_3_size <> casing_4_size);

update casing_details set has_no_casings = 'true' where casing_1_string_type is null and casing_2_string_type is null and casing_3_string_type is null and casing_4_string_type is null and casing_5_string_type is null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_1_casing = 'true' where casing_1_string_type is not null and casing_2_string_type is null and casing_3_string_type is null and casing_4_string_type is null and casing_5_string_type is null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_2_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is null and casing_4_string_type is null and casing_5_string_type is null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_3_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is null and casing_5_string_type is null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_4_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is not null and casing_5_string_type is null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_5_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is not null and casing_5_string_type is not null and casing_6_string_type is null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_6_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is not null and casing_5_string_type is not null and casing_6_string_type is not null and casing_7_string_type is null and casing_8_string_type is null;

update casing_details set has_7_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is not null and casing_5_string_type is not null and casing_6_string_type is not null and casing_7_string_type is not null and casing_8_string_type is null;

update casing_details set has_8_casings = 'true' where casing_1_string_type is not null and casing_2_string_type is not null and casing_3_string_type is not null and casing_4_string_type is not null and casing_5_string_type is not null and casing_6_string_type is not null and casing_7_string_type is not null and casing_8_string_type is not null;

update casing_details set has_additional_cement = 'true' where (add_cement_1_string_type is not null or add_cement_2_string_type is not null or add_cement_3_string_type is not null or add_cement_4_string_type is not null or add_cement_5_string_type is not null or add_cement_6_string_type is not null or add_cement_7_string_type is not null or add_cement_8_string_type is not null or add_cement_9_string_type is not null or add_cement_10_string_type is not null or add_cement_11_string_type is not null or add_cement_12_string_type is not null or add_cement_13_string_type is not null or add_cement_14_string_type is not null);

update casing_details set has_cement_squeeze = 'true' where (add_cement_1_method_grade = 'SQUEEZE' or add_cement_1_method_grade = 'PERF & PUMP' or add_cement_2_method_grade = 'SQUEEZE' or add_cement_2_method_grade = 'PERF & PUMP' or add_cement_3_method_grade = 'SQUEEZE' or add_cement_3_method_grade = 'PERF & PUMP' or add_cement_4_method_grade = 'SQUEEZE' or add_cement_4_method_grade = 'PERF & PUMP' or add_cement_5_method_grade = 'SQUEEZE' or add_cement_5_method_grade = 'PERF & PUMP');

update casing_details set has_1_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is null and add_cement_3_string_type is null and add_cement_4_string_type is null and add_cement_5_string_type is null and add_cement_6_string_type is null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_2_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is null and add_cement_4_string_type is null and add_cement_5_string_type is null and add_cement_6_string_type is null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_3_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is not null and add_cement_4_string_type is null and add_cement_5_string_type is null and add_cement_6_string_type is null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_4_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is not null and add_cement_4_string_type is not null and add_cement_5_string_type is null and add_cement_6_string_type is null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_5_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is not null and add_cement_4_string_type is not null and add_cement_5_string_type is not null and add_cement_6_string_type is null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_6_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is not null and add_cement_4_string_type is not null and add_cement_5_string_type is not null and add_cement_6_string_type is not null and add_cement_7_string_type is null and add_cement_8_string_type is null and add_cement_9_string_type is null and add_cement_10_string_type is null and add_cement_11_string_type is null and add_cement_12_string_type is null and add_cement_13_string_type is null and add_cement_14_string_type is null;

update casing_details set has_7_to_14_additional_cement = 'true' where add_cement_1_string_type is not null and add_cement_2_string_type is not null and add_cement_3_string_type is not null and add_cement_4_string_type is not null and add_cement_5_string_type is not null and add_cement_6_string_type is not null and (add_cement_7_string_type is not null or add_cement_8_string_type is not null or add_cement_9_string_type is not null or add_cement_10_string_type is not null or add_cement_11_string_type is not null or add_cement_12_string_type is not null or add_cement_13_string_type is not null or add_cement_14_string_type is not null);

update casing_details set possibly_remediated = 'true' where has_surface_casing_check_doc is true or has_sc_casing is true or has_st_casing is true or has_additional_cement is true or has_cement_squeeze is true;

update casing_details set bradenhead_test_id = (select id from bradenhead_tests where well_id = casing_details.well_id order by surface_casing_psi desc limit 1);
update casing_details set initial_bradenhead_psi = (select surface_casing_psi from bradenhead_tests where id = casing_details.bradenhead_test_id), final_bradenhead_psi = (select end_of_test_psi from bradenhead_tests where id = casing_details.bradenhead_test_id), final_bradenhead_psi_integer = (select final_psi from bradenhead_tests where id = casing_details.bradenhead_test_id);

update casing_details set has_bradenhead_doc = 'true' where bradenhead_test_id is not null;

select case when casing_2_string_type = 'SURF' and casing_3_string_type = 'SURF' then casing_3_depth::integer when casing_3_string_type = 'SURF' then casing_3_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_2_depth::integer > casing_1_depth::integer then casing_2_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_1_depth::integer > casing_2_depth::integer then casing_1_depth::integer when casing_1_string_type <> 'SURF' and casing_2_string_type = 'SURF' then casing_2_depth::integer when casing_1_string_type = 'SURF' then casing_1_depth::integer else null end from casing_details where well_id = 106094;

alter table casing_details add surf_casing_cement_bottom integer;
alter table casing_details add prod_casing_cement_top integer;
alter table casing_details add cement_delta integer;

update casing_details set surf_casing_cement_bottom = case when casing_2_string_type = 'SURF' and casing_3_string_type = 'SURF' then casing_3_cement_bottom::integer when casing_3_string_type = 'SURF' then casing_3_cement_bottom::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_2_depth::integer > casing_1_depth::integer then casing_2_cement_bottom::integer when casing_1_string_type = 'SURF' and casing_2_string_type = 'SURF' and casing_1_depth::integer > casing_2_depth::integer then casing_1_cement_bottom::integer when casing_1_string_type <> 'SURF' and casing_2_string_type = 'SURF' then casing_2_cement_bottom::integer when casing_1_string_type = 'SURF' then casing_1_cement_bottom::integer else null end;

update casing_details set first_casing_cement_top = case when casing_1_string_type = '1ST' and casing_2_string_type = '2ND' then casing_2_cement_top::integer when casing_1_string_type = '1ST' and casing_3_string_type = '2ND' then casing_3_cement_top::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_top::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_4_string_type = '1ST' then casing_4_cement_top::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '1ST' then casing_2_cement_top::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '2ND' then casing_2_cement_top::integer when casing_1_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_top::integer else null end;


alter table casing_details add prod_casing_cement_top integer;
alter table casing_details add prod_casing_cement_bottom integer;

update casing_details set prod_casing_cement_top = case when casing_1_string_type = '1ST' and casing_2_string_type = '2ND' then casing_2_cement_top::integer when casing_1_string_type = '1ST' and casing_3_string_type = '2ND' then casing_3_cement_top::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_top::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_4_string_type = '1ST' then casing_4_cement_top::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '1ST' then casing_2_cement_top::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '2ND' then casing_2_cement_top::integer when casing_1_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_top::integer else null end;

update casing_details set prod_casing_cement_bottom = case when casing_1_string_type = '1ST' and casing_2_string_type = '2ND' then casing_2_cement_bottom::integer when casing_1_string_type = '1ST' and casing_3_string_type = '2ND' then casing_3_cement_bottom::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_bottom::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_4_string_type = '1ST' then casing_4_cement_bottom::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '1ST' then casing_2_cement_bottom::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '2ND' then casing_2_cement_bottom::integer when casing_1_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_cement_bottom::integer else null end;


alter table casing_details add first_casing_depth integer;
update casing_details set first_casing_depth = case when casing_1_string_type = '1ST' and casing_2_string_type = '2ND' then casing_2_depth::integer when casing_1_string_type = '1ST' and casing_3_string_type = '2ND' then casing_3_depth::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_depth::integer when casing_1_string_type = 'CONDUCTOR' and casing_2_string_type = 'SURF' and casing_4_string_type = '1ST' then casing_4_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '1ST' then casing_2_depth::integer when casing_1_string_type = 'SURF' and casing_2_string_type = '2ND' then casing_2_depth::integer when casing_1_string_type = 'SURF' and casing_3_string_type = '1ST' then casing_3_depth::integer else null end;




-- Greg Query

alter table wells add column is_piceance_basin boolean not null default false;
alter table wells add column is_raton_basin boolean not null default false;
update wells set is_piceance_basin = 'true' where id in (select well_id from import.wells where is_piceance_basin is true);
update wells set is_raton_basin = 'true' where  id in (select well_id from import.wells where is_raton_basin is true);

COPY (select w.api_number as api_well_num, w.api_number || '-' || s.sidetrack_number as api_sidetrack_num, s.sidetrack_number as st_num, w.status_code well_status_code, s.status_code as sidetrack_status_code, s.completion_date, w.longitude, w.latitude, w.usgs_elevation as surface_elevation, w.is_piceance_basin, w.is_denver_basin as is_dj_basin, w.is_san_juan_basin, w.is_raton_basin, c.initial_bradenhead_psi, c.final_bradenhead_psi, c.has_bradenhead_doc, c.has_surface_casing_check_doc, c.has_sc_casing, c.has_st_casing, c.has_additional_cement, c.has_cement_squeeze, 'http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid=' || lpad(w.id::varchar, 8, '0') || '&type=WELL' as scout_card_url from sidetracks s inner join wells w on s.well_id = w.id left outer join casing_details c on s.id = c.sidetrack_id order by api_sidetrack_num) TO '/Users/troyburke/Data/cogcc_query_database/exports/casing_details.csv' WITH CSV HEADER;

COPY (select * from mits order by well_id, test_date) TO '/Users/troyburke/Data/cogcc_query_database/exports/mits.csv' WITH CSV HEADER;




COPY (select w.api_number as api_well_num, w.api_number || '-' || s.sidetrack_number as api_sidetrack_num, s.sidetrack_number as st_num, w.status_code well_status_code, s.status_code as sidetrack_status_code, s.completion_date, c.surface_casing_depth, c.aquifer_bottom_elevation,  c.has_additional_cement, c.has_cement_squeeze, 'http://cogcc.state.co.us/cogis/FacilityDetail.asp?facid=' || lpad(w.id::varchar, 8, '0') || '&type=WELL' as scout_card_url from sidetracks s inner join wells w on s.well_id = w.id left outer join casing_details c on s.id = c.sidetrack_id where w.is_denver_basin is true and w.status_code not in ('AB','AC','AL','DA','IJ') and w.operator_number not in (10373,10514,10258,18600) and has_multiple_sidetracks is true and is_secondary is false order by api_sidetrack_num) TO '/Users/troyburke/Data/cogcc_query_database/exports/dj_casing_details.csv' WITH CSV HEADER;









---------------------------------------------------------------
------------------  WELL AQUIFER DEPTHS  ----------------------
---------------------------------------------------------------
set search_path to public;
drop table well_denver_aquifer_depths;
create table well_denver_aquifer_depths (
	id serial not null primary key, 
	well_id integer, 
	laramie_fox_hills_top integer, 
	laramie_fox_hills_bottom integer, 
	lower_arapahoe_top integer, 
	lower_arapahoe_bottom integer, 
	upper_arapahoe_top integer, 
	upper_arapahoe_bottom integer, 
	denver_top integer, 
	denver_bottom integer, 
	lower_dawson_top integer, 
	lower_dawson_bottom integer, 
	upper_dawson_top integer, 
	upper_dawson_bottom integer, 
	null_report boolean not null default false, 
	created_at timestamp, 
	updated_at timestamp
);

COPY (select id, well_id, laramie_fox_hills_top, laramie_fox_hills_bottom, lower_arapahoe_top, lower_arapahoe_bottom, upper_arapahoe_top, upper_arapahoe_bottom, denver_top, denver_bottom, lower_dawson_top, lower_dawson_bottom, upper_dawson_top, upper_dawson_bottom, null_report, now(), now() from cogcc_well_aquifer_depths order by well_id) TO '/Users/troyburke/Data/cogcc_query_database/table_dumps/denver_aquifer_depths.csv' WITH CSV;

copy well_denver_aquifer_depths from '/Users/troyburke/Data/cogcc_query_database/table_dumps/denver_aquifer_depths.csv' (format csv, delimiter ',', null '');

set search_path to import;
drop table denver_aquifer_depth_reports;
create table denver_aquifer_depth_reports (
	id serial not null primary key, 
	fac_id integer, 
	report_text text, 
	upper_dawson_row varchar(100);
	lower_dawson_row varchar(100);
	denver_row varchar(100);
	upper_arapahoe_row varchar(100);
	lower_arapahoe_row varchar(100);
	laramie_fox_hills_row varchar(100);
	upper_dawson_elevation_bottom integer, 
	upper_dawson_elevation_top integer, 
	upper_dawson_net_sand real, 
	upper_dawson_depth_bottom integer, 
	upper_dawson_depth_top integer, 
	upper_dawson_annual_aprprop real, 
	upper_dawson_status varchar(10), 
	lower_dawson_elevation_bottom integer, 
	lower_dawson_elevation_top integer, 
	lower_dawson_net_sand real, 
	lower_dawson_depth_bottom integer, 
	lower_dawson_depth_top integer, 
	lower_dawson_annual_aprprop real, 
	lower_dawson_status varchar(10), 
	denver_elevation_bottom integer, 
	denver_elevation_top integer, 
	denver_net_sand real, 
	denver_depth_bottom integer, 
	denver_depth_top integer, 
	denver_annual_aprprop real, 
	denver_status varchar(10), 
	upper_arapahoe_elevation_bottom integer, 
	upper_arapahoe_elevation_top integer, 
	upper_arapahoe_net_sand real, 
	upper_arapahoe_depth_bottom integer, 
	upper_arapahoe_depth_top integer, 
	upper_arapahoe_annual_aprprop real, 
	upper_arapahoe_status varchar(10), 
	lower_arapahoe_elevation_bottom integer, 
	lower_arapahoe_elevation_top integer, 
	lower_arapahoe_net_sand real, 
	lower_arapahoe_depth_bottom integer, 
	lower_arapahoe_depth_top integer, 
	lower_arapahoe_annual_aprprop real, 
	lower_arapahoe_status varchar(10), 
	laramie_fox_hills_elevation_bottom integer, 
	laramie_fox_hills_elevation_top integer, 
	laramie_fox_hills_net_sand real, 
	laramie_fox_hills_depth_bottom integer, 
	laramie_fox_hills_depth_top integer, 
	laramie_fox_hills_annual_aprprop real, 
	laramie_fox_hills_status varchar(10) 
);

insert into dwr_denver_aquifer_reports (fac_id, report_text) 
select fac_id, updated_denver_report_text 
from dwr_aquifer_wells 
where updated_denver_report_text is not null;







set search_path to import;
drop table facilities;
create table facilities (
	id serial not null primary key, 
	facility_type_id integer, 
	facility_type character varying(50), 
	facility_detail_url character varying(100), 
	facility_id integer, 
	facility_name character varying(100), 
	facility_number character varying(20), 
	operator_name character varying(100), 
	operator_number character varying(20), 
	status_code character varying(20), 
	field_name character varying(100), 
	field_number integer, 
	location_county character varying(100), 
	location_plss character varying(100), 
	related_facilities_url character varying(100), 
	created_at timestamp,  
	updated_at timestamp, 
	details_scraped boolean not null default false
);







---------------------------------------------------------------
---------------  ENVIRONMENTAL SAMPLE SITES  ------------------
---------------------------------------------------------------
set search_path to import;
drop table environmental_sample_sites;
create table environmental_sample_sites (
	id serial not null primary key, 
  sample_site_id integer, 
	facility_type varchar(30), 
	project_number varchar(100), 
	county varchar(100), 
	plss_location varchar(100), 
	elevation integer, 
	longitude varchar(20), 
	latitude varchar(20), 
	dwr_receipt_number varchar(30), 
	well_depth integer, 
	created_at timestamp,  
	updated_at timestamp
);

alter table environmental_sample_sites add column sample_results_imported boolean not null default false;


-- this table holds import of sample result csv files
set search_path to import;
drop table environmental_sample_results;
create table environmental_sample_results (
	id serial not null primary key,
	environmental_sample_site_id integer, 
	sample_site_id integer, -- aka facility_id
	sample_id integer, 
	sample_date date, 
	matrix varchar(10), 
	lab_id varchar(30), 
	lab_sample_id varchar(30), 
	sampler varchar(100), 
	method_code varchar(50), 
	parameter_name varchar(50), 
	parameter_description varchar(100), 
	result_value varchar(30), 
	units varchar(20), 
	detection_limit varchar(20), 
	qualifier varchar(10), 
	created_at timestamp,  
	updated_at timestamp
);



-- denormalize environmental sample data after import

set search_path to import;
drop table environmental_samples;
create table environmental_samples (
	id serial not null primary key,
	environmental_sample_site_id integer, 
	sample_site_id integer, 
	sample_id integer, 
	sample_date date, 
	matrix varchar(10), 
	lab_id varchar(30), 
	lab_sample_id varchar(30), 
	sampler varchar(100), 
	created_at timestamp,  
	updated_at timestamp
);

insert into environmental_samples (environmental_sample_site_id, sample_site_id, sample_id, sample_date, matrix, lab_id, lab_sample_id, sampler) 
select distinct environmental_sample_site_id, sample_site_id, sample_id, sample_date, matrix, lab_id, lab_sample_id, sampler from environmental_sample_results order by sample_id;

create index index_environmental_samples_on_sample_id on environmental_samples (sample_id);




set search_path to import;
drop table environmental_results;
create table environmental_results (
	id serial not null primary key,
	sample_id integer, 
	environmental_sample_id integer, 
	method_code varchar(50), 
	parameter_name varchar(50), 
	parameter_description varchar(100), 
	result_value varchar(30), 
	units varchar(20), 
	detection_limit varchar(20), 
	qualifier varchar(10), 
	created_at timestamp,  
	updated_at timestamp
);

insert into environmental_results (sample_id, method_code, parameter_name, parameter_description, result_value, units, detection_limit, qualifier) 
select sample_id, method_code, parameter_name, parameter_description, result_value, units, detection_limit, qualifier from environmental_sample_results order by sample_id;

update environmental_results set environmental_sample_id = (select id from environmental_samples where sample_id = environmental_results.sample_id);


set search_path to import;
drop table environmental_parameters;
create table environmental_parameters (
	id serial not null primary key,
	name varchar(50), 
	description varchar(100), 
	created_at timestamp,  
	updated_at timestamp
);

insert into environmental_parameters (name, description) select distinct parameter_name, parameter_description from environmental_sample_results order by parameter_name;









set search_path to import;
drop table accident_reports;
create table accident_reports (
	id serial not null primary key, 
	well_id integer, 
	well_link_id character varying(10), 
	document_id integer, 
	document_number integer, 
	document_name character varying(500), 
	document_date date, 
	download_url character varying(100), 
	doc_name_ucase character varying(65), 
	document_year smallint, 
	document_month smallint, 
	well_api_number character varying(12), 
	well_api_county character varying(3), 
	report_text text, 
	report_downloaded boolean not null default false, 
	text_imported boolean not null default false, 
	in_use boolean not null default false, 
	created_at timestamp,  
	updated_at timestamp
);

insert into accident_reports (well_id, well_link_id, document_id, document_number, document_name, document_date, download_url, doc_name_ucase, document_year, document_month, well_api_number, well_api_county, created_at, updated_at) 
select well_id, well_link_id, document_id, document_number, document_name, document_date, download_url, doc_name_ucase, document_year, document_month, well_api_number, well_api_county, now(), now() from well_documents where document_name ilike '%form 22%' or document_name ilike '%accident%report%' or document_name ilike '%report%accident%' order by document_date, well_id;
--444


set search_path to import;
drop table well_control_reports;
create table well_control_reports (
	id serial not null primary key, 
	well_id integer, 
	well_link_id character varying(10), 
	document_id integer, 
	document_number integer, 
	document_name character varying(500), 
	document_date date, 
	download_url character varying(100), 
	doc_name_ucase character varying(65), 
	document_year smallint, 
	document_month smallint, 
	well_api_number character varying(12), 
	well_api_county character varying(3), 
	report_text text, 
	report_downloaded boolean not null default false, 
	text_imported boolean not null default false, 
	in_use boolean not null default false, 
	created_at timestamp,  
	updated_at timestamp
);

insert into well_control_reports (well_id, well_link_id, document_id, document_number, document_name, document_date, download_url, doc_name_ucase, document_year, document_month, well_api_number, well_api_county, created_at, updated_at) 
select well_id, well_link_id, document_id, document_number, document_name, document_date, download_url, doc_name_ucase, document_year, document_month, well_api_number, well_api_county, now(), now() from well_documents where document_name ilike '%form 23%' or document_name ilike '%well%control%' order by document_date, well_id;
--498



-- COAs and BMPs



set search_path to import;
drop table coa_bmp_scrapes;
create table coa_bmp_scrapes (
	id serial not null primary key, 
	well_id integer, 
	facility_id integer, 
	status_code varchar(2), 
	api_county varchar(3), 
	in_use boolean not null default false, 
	scraped boolean not null default false
);

insert into coa_bmp_scrapes (well_id, facility_id, status_code, api_county) 
select well_id, facility_i, facility_s, api_county from wells order by well_id;



set search_path to import;
drop table approval_conditions;
create table approval_conditions (
	id serial not null primary key, 
	well_id integer, 
	facility_id integer, 
	source_document_form varchar(30),
	source_document_number integer, 
	source_document_date date, 
	conditions text, 
	created_at timestamp, 
	updated_at timestamp
);


set search_path to import;
drop table best_management_practices;
create table best_management_practices (
	id serial not null primary key, 
	well_id integer, 
	facility_id integer, 
	source_document_form varchar(30),
	source_document_number integer, 
	source_document_date date, 
	bmp_type varchar(250), 
	bmp_description text, 
	created_at timestamp, 
	updated_at timestamp
);



COPY (select id, well_id, facility_id, source_document_form, source_document_number, source_document_date, bmp_type, bmp_description from best_management_practices where well_id in (select well_id from wells where api_county = '067') order by well_id, source_document_date, bmp_type) TO '/Users/troyburke/Data/cogcc_query_database/exports/la_plata_bmps.csv' WITH CSV HEADER;

COPY (select id, well_id, facility_id, source_document_form, source_document_number, source_document_date, conditions from approval_conditions where well_id in (select well_id from wells where api_county = '067') order by well_id, source_document_date) TO '/Users/troyburke/Data/cogcc_query_database/exports/la_plata_coas.csv' WITH CSV HEADER;




 651 | SW8015                       | 8006-61-9                                                    |            |
 652 | SW8260                       | 100-41-4                                                     |            |
 653 | SW8260                       | 108-88-3                                                     |            |
 654 | SW8260                       | 1330-20-7                                                    |            |
 655 | SW8260                       | 71-43-2                                                      |            |

 675 | UnSpec                       | 100-41-4                                                     |            |
 676 | UnSpec                       | 100-42-5                                                     |            |
 677 | UnSpec                       | 10061-01-5                                                   |            |
 678 | UnSpec                       | 103-65-1                                                     |            |
 679 | UnSpec                       | 104-51-8                                                     |            |
 680 | UnSpec                       | 106-46-7                                                     |            |
 681 | UnSpec                       | 108-67-8                                                     |            |
 682 | UnSpec                       | 108-86-1                                                     |            |
 683 | UnSpec                       | 108-88-3                                                     |            |
 684 | UnSpec                       | 108-90-7                                                     |            |
 685 | UnSpec                       | 120-82-1                                                     |            |
 686 | UnSpec                       | 124-48-1                                                     |            |
 687 | UnSpec                       | 127-18-4                                                     |            |
 688 | UnSpec                       | 1330-20-7                                                    |            |
 689 | UnSpec                       | 135-98-8                                                     |            |
 690 | UnSpec                       | 156-59-2                                                     |            |
 691 | UnSpec                       | 156-60-5                                                     |            |
 692 | UnSpec                       | 1634-04-4                                                    |            |
 693 | UnSpec                       | 541-73-1                                                     |            |
 694 | UnSpec                       | 56-23-5                                                      |            |
 695 | UnSpec                       | 563-58-6                                                     |            |
 696 | UnSpec                       | 630-20-6                                                     |            |
 697 | UnSpec                       | 67-66-3                                                      |            |
 698 | UnSpec                       | 71-43-2                                                      |            |
 699 | UnSpec                       | 71-55-6                                                      |            |
 700 | UnSpec                       | 74-82-8                                                      |            |
 701 | UnSpec                       | 74-83-9                                                      |            |
 702 | UnSpec                       | 74-87-3                                                      |            |
 703 | UnSpec                       | 74-95-3                                                      |            |
 704 | UnSpec                       | 74-97-5                                                      |            |
 705 | UnSpec                       | 75-00-3                                                      |            |
 706 | UnSpec                       | 75-01-4                                                      |            |
 707 | UnSpec                       | 75-25-2                                                      |            |
 708 | UnSpec                       | 75-27-4                                                      |            |
 709 | UnSpec                       | 75-34-3                                                      |            |
 710 | UnSpec                       | 75-69-4                                                      |            |
 711 | UnSpec                       | 79-00-5                                                      |            |
 712 | UnSpec                       | 79-01-6                                                      |            |
 713 | UnSpec                       | 79-34-5                                                      |            |
 714 | UnSpec                       | 87-61-6                                                      |            |
 715 | UnSpec                       | 87-68-3                                                      |            |
 716 | UnSpec                       | 91-20-3                                                      |            |
 717 | UnSpec                       | 95-49-8                                                      |            |
 718 | UnSpec                       | 95-50-1                                                      |            |
 719 | UnSpec                       | 95-63-6                                                      |            |
 720 | UnSpec                       | 96-12-8                                                      |            |
 721 | UnSpec                       | 96-18-4                                                      |            |
 722 | UnSpec                       | 98-06-6                                                      |            |
 723 | UnSpec                       | 98-82-8                                                      |            |
 724 | UnSpec                       | 99-87-6                                                      |            |

-- OTHER DOCUMENTS (NON-WELL) --

-- IGNORE ?? http://ogccweblink.state.co.us/results.aspx?classid=01

-- COMPLAINTS http://ogccweblink.state.co.us/results.aspx?classid=02

-- FACILITIES (ie PITS) http://ogccweblink.state.co.us/results.aspx?classid=03
-- HEARINGS http://ogccweblink.state.co.us/results.aspx?classid=04
-- ?? http://ogccweblink.state.co.us/results.aspx?classid=05
-- REMEDIATION http://ogccweblink.state.co.us/results.aspx?classid=06
-- NOAVS http://ogccweblink.state.co.us/results.aspx?classid=07 (NOAVS also include classid 08)
-- INSPECTIONS http://ogccweblink.state.co.us/results.aspx?classid=08 (MITS??)
-- LOCATIONS (ie. MAPS) http://ogccweblink.state.co.us/results.aspx?classid=09
-- PRODUCTION http://ogccweblink.state.co.us/results.aspx?classid=10


-- 05 <option value="Business Documents">Business Documents</option>
<option value="Customers">Customers</option>
-- 03 <option value="Facilities">Facilities</option>
-- 04 <option value="Hearings">Hearings</option>
-- 09 <option value="Location">Location</option>
<option value="Operator">Operator</option>
-- 10 <option value="Production">Production</option>
-- 06 <option value="Projects">Projects</option> --Remediations??
-- 07 <option value="Well Logs">Well Logs</option>
--??<option value="Wells">Wells</option>




-- INDEXES
create index index_sidetracks_on_well_id on sidetracks (well_id);

create index index_well_documents_on_well_id on well_documents (well_id);

create index index_bradenhead_tests_on_well_id on bradenhead_tests (well_id);

create index index_completed_casings_on_well_id on completed_casings (well_id);
create index index_completed_casings_on_sidetrack_id on completed_casings (sidetrack_id);

update planned_casings set casing_depth = null where trim(casing_depth) = '';
create index index_planned_casings_on_well_id on planned_casings (well_id);
create index index_planned_casings_on_sidetrack_id on planned_casings (sidetrack_id);

create index index_casing_details_on_well_id on casing_details (well_id);
create index index_casing_details_on_sidetrack_id on casing_details (sidetrack_id);



