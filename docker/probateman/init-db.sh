#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 --username postgres --set USERNAME=probate_man --set PASSWORD=probate_man --set DATABASE=probate_man <<-EOSQL
  CREATE USER :USERNAME WITH PASSWORD ':PASSWORD';
  CREATE DATABASE :DATABASE WITH OWNER = :USERNAME ENCODING = 'UTF-8' CONNECTION LIMIT = -1;
  CREATE SCHEMA AUTHORIZATION probate_man;


EOSQL

psql -U probate_man -d probate_man  <<-EOSQL
CREATE TABLE STANDING_SEARCHES_FLAT
(
ID	bigint	,
SS_NUMBER   	varchar(11)	,
PROBATE_NUMBER   	varchar(11)	,
PROBATE_VERSION 	int	,
DECEASED_ID          	bigint,
DECEASED_FORENAMES	varchar(50)	,
DECEASED_SURNAME	varchar(50)	,
DATE_OF_BIRTH	date	,
DATE_OF_DEATH1	date	,
CCD_CASE_NO	varchar(20)	,
DECEASED_ADDRESS     	varchar(500)	,
APPLICANT_ADDRESS	varchar(500)	,
REGISTRY_REG_LOCATION_CODE	int	,
SS_APPLICANT_FORENAME 	varchar(30)	,
SS_APPLICANT_SURNAME  	varchar(50)	,
SS_APPLICANT_HONOURS	varchar(100)	,
SS_APPLICANT_TITLE	varchar(35)	,
SS_DATE_LAST_EXTENDED	date	,
SS_DATE_OF_ENTRY	date	,
SS_DATE_OF_EXPIRY	date	,
SS_WITHDRAWN_DATE	date	,
STANDING_SEARCH_TEXT	varchar(32000)	,
DNM_IND	varchar(1)	,
ALIAS_NAMES	varchar(32000),
LAST_MODIFIED timestamptz
);
CREATE INDEX IDX_LAST_MODIFIED ON STANDING_SEARCHES_FLAT(LAST_MODIFIED);

CREATE TABLE WILLS_FLAT
(
ID	bigint	,
RK_NUMBER   	varchar(11)	,
PROBATE_NUMBER   	varchar(11)	,
PROBATE_VERSION 	int	,
DECEASED_ID	bigint,
DECEASED_FORENAMES	varchar(50)	,
DECEASED_SURNAME	varchar(30)	,
DATE_OF_BIRTH	date	,
DATE_OF_DEATH1	date	,
ALIAS_NAMES	varchar(32000)	,
RECORD_KEEPERS_TEXT	varchar(32000)	,
CCD_CASE_NO	varchar(20)	,
DNM_IND	varchar(1),
LAST_MODIFIED timestamptz
);
CREATE INDEX IDX_LAST_MODIFIED ON WILLS_FLAT(LAST_MODIFIED);

CREATE TABLE CAVEATS_FLAT
(
ID	bigint	,
CAVEAT_NUMBER   	varchar(11)	,
PROBATE_NUMBER   	varchar(11)	,
PROBATE_VERSION 	int	,
DECEASED_ID          	bigint,
DECEASED_FORENAMES	varchar(50)	,
DECEASED_SURNAME	varchar(50)	,
DATE_OF_BIRTH	date	,
DATE_OF_DEATH1	date	,
ALIAS_NAMES	varchar(32000)	,
CCD_CASE_NO	varchar(20)	,
CAVEAT_TYPE          	varchar(20)     ,
CAVEAT_DATE_OF_ENTRY       	date  	,
CAV_DATE_LAST_EXTENDED     	date 	,
CAV_EXPIRY_DATE            	date  	,
CAV_WITHDRAWN_DATE         	date  	,
CAVEATOR_TITLE         	varchar(35)     ,
CAVEATOR_HONOURS       	varchar(100)    ,
CAVEATOR_FORENAMES     	varchar(50)     ,
CAVEATOR_SURNAME       	varchar(50)     ,
CAV_SOLICITOR_NAME     	varchar(50)     ,
CAV_SERVICE_ADDRESS     	varchar(500)	,
CAV_DX_NUMBER              	varchar(10)     ,
CAV_DX_EXCHANGE            	varchar(25)     ,
CAVEAT_TEXT	varchar(32000)	,
CAVEAT_EVENT_TEXT	varchar(32000)	,
DNM_IND	varchar(1),
LAST_MODIFIED timestamptz
 );
CREATE INDEX IDX_LAST_MODIFIED ON CAVEATS_FLAT(LAST_MODIFIED);

CREATE TABLE GRANT_APPLICATIONS_FLAT
(
ID	bigint	,
PROBATE_NUMBER   	varchar(11)	,
PROBATE_VERSION 	int	,
DECEASED_ID          	bigint,
DECEASED_FORENAMES	varchar(50)	,
DECEASED_SURNAME	varchar(50)	,
DATE_OF_BIRTH	date	,
DATE_OF_DEATH1	date	,
DECEASED_ADDRESS	varchar(500)	,
DECEASED_TEXT	varchar(32000)	,
ALIAS_NAMES	varchar(32000)	,
GRANT_APPLICATION_TEXT	varchar(32000)	,
APPLICATION_EVENT_TEXT	varchar(32000)	,
OATH_TEXT 	varchar(32000)	,
EXECUTOR_TEXT	varchar(32000)	,
OTHER_INFORMATION_TEXT 	varchar(32000)	,
LINKED_DECEASED_IDS	varchar(32000)	,
CCD_CASE_NO	varchar(20)	,
DNM_IND	varchar(1)	,
DECEASED_AGE_AT_DEATH	int	,
DECEASED_DEATH_TYPE	varchar(40)	,
DECEASED_DOMICILE	varchar(60)	,
DECEASED_DOMICILE_IN_WELSH	varchar(10)	,
DECEASED_DOMICILE_WELSH	varchar(60)	,
DECEASED_HONOURS	varchar(100)	,
DECEASED_SEX	varchar(1)	,
DECEASED_TITLE	varchar(35)	,
APP_ADMIN_CLAUSE_LIMITATION	varchar(100)	,
APP_ADMIN_CLAUSE_LIMITN_WELSH 	varchar(100)	,
APP_CASE_TYPE	varchar(20)	,
APP_EXECUTOR_LIMITATION 	varchar(100)	,
APP_EXECUTOR_LIMITATION_WELSH 	varchar(100)	,
APP_RECEIVED_DATE	date	,
APPLICANT_ADDRESS 	varchar(500)	,
APPLICANT_DX_EXCHANGE 	varchar(25)	,
APPLICANT_DX_NUMBER 	varchar(10)	,
APPLICANT_FORENAMES 	varchar(50)	,
APPLICANT_HONOURS	varchar(100)	,
APPLICANT_SURNAME 	varchar(50)	,
APPLICANT_TITLE	varchar(35)	,
GRANT_WELSH_LANGUAGE_IND 	boolean	,
GRANT_WILL_TYPE 	varchar(200)	,
GRANT_WILL_TYPE_WELSH	varchar(200)	,
EXCEPTED_ESTATE_IND varchar(1),
FILESLIP_SIGNAL boolean,
GRANT_APPLICANT_TYPE varchar(1),
GRANT_CONFIRMED_DATE date,
GRANT_ISSUED_DATE date,
GRANT_ISSUED_SIGNAL boolean,
GRANT_LIMITATION varchar(800),
GRANT_LIMITATION_WELSH varchar(800),
GRANT_POWER_RESERVED varchar(1),
GRANT_SOL_ID varchar(10),
GRANT_TYPE varchar(3),
GRANT_VERSION_DATE date,
GRANTEE1_ADDRESS 	varchar(500)	,
GRANTEE1_FORENAMES 	varchar(50)	,
GRANTEE1_HONOURS 	varchar(100)	,
GRANTEE1_SURNAME 	varchar(50)	,
GRANTEE1_TITLE 	varchar(35)	,
GRANTEE2_ADDRESS 	varchar(500)	,
GRANTEE2_FORENAMES 	varchar(50)	,
GRANTEE2_HONOURS 	varchar(100)	,
GRANTEE2_SURNAME 	varchar(50)	,
GRANTEE2_TITLE 	varchar(35)	,
GRANTEE3_ADDRESS 	varchar(500)	,
GRANTEE3_FORENAMES 	varchar(50)	,
GRANTEE3_HONOURS 	varchar(100)	,
GRANTEE3_SURNAME 	varchar(50)	,
GRANTEE3_TITLE 	varchar(35)	,
GRANTEE4_ADDRESS 	varchar(500)	,
GRANTEE4_FORENAMES 	varchar(50)	,
GRANTEE4_HONOURS 	varchar(100)	,
GRANTEE4_SURNAME 	varchar(50)	,
GRANTEE4_TITLE 	varchar(35)	,
GROSS_ESTATE_VALUE	bigint	,
NET_ESTATE_VALUE 	bigint	,
PLACE_OF_ORIGINAL_GRANT 	varchar(60)	,
PLACE_OF_ORIGINAL_GRANT_WELSH varchar(60),
POWER_RESERVED_WELSH	varchar(1)	,
RESEAL_DATE	date	,
SOLICITOR_REFERENCE	varchar(30),
LAST_MODIFIED timestamptz
);
CREATE INDEX IDX_LAST_MODIFIED ON GRANT_APPLICATIONS_FLAT(LAST_MODIFIED);

CREATE TABLE GRANT_APPLICATIONS_DERIVED_FLAT
(
ID	bigint	,
PROBATE_NUMBER   	varchar(11)	,
PROBATE_VERSION 	int	,
DECEASED_ID          	bigint,
DECEASED_FORENAMES	varchar(50)	,
DECEASED_SURNAME	varchar(50)	,
DATE_OF_BIRTH	date	,
DATE_OF_DEATH1	date	,
DECEASED_ADDRESS	varchar(500)	,
DECEASED_TEXT	varchar(32000)	,
ALIAS_NAMES	varchar(32000)	,
GRANT_APPLICATION_TEXT	varchar(32000)	,
APPLICATION_EVENT_TEXT	varchar(32000)	,
OATH_TEXT 	varchar(32000)	,
EXECUTOR_TEXT	varchar(32000)	,
OTHER_INFORMATION_TEXT 	varchar(32000)	,
LINKED_DECEASED_IDS	varchar(32000)	,
CCD_CASE_NO	varchar(20)	,
DNM_IND	varchar(1)	,
DECEASED_AGE_AT_DEATH	int	,
DECEASED_DEATH_TYPE	varchar(40)	,
DECEASED_DOMICILE	varchar(60)	,
DECEASED_DOMICILE_IN_WELSH	varchar(10)	,
DECEASED_DOMICILE_WELSH	varchar(60)	,
DECEASED_HONOURS	varchar(100)	,
DECEASED_SEX	varchar(1)	,
DECEASED_TITLE	varchar(35)	,
APP_ADMIN_CLAUSE_LIMITATION	varchar(100)	,
APP_ADMIN_CLAUSE_LIMITN_WELSH 	varchar(100)	,
APP_CASE_TYPE	varchar(20)	,
APP_EXECUTOR_LIMITATION 	varchar(100)	,
APP_EXECUTOR_LIMITATION_WELSH 	varchar(100)	,
APP_RECEIVED_DATE	date	,
APPLICANT_ADDRESS 	varchar(500)	,
APPLICANT_DX_EXCHANGE 	varchar(25)	,
APPLICANT_DX_NUMBER 	varchar(10)	,
APPLICANT_FORENAMES 	varchar(50)	,
APPLICANT_HONOURS	varchar(100)	,
APPLICANT_SURNAME 	varchar(50)	,
APPLICANT_TITLE	varchar(35)	,
GRANT_WELSH_LANGUAGE_IND 	boolean	,
GRANT_WILL_TYPE 	varchar(200)	,
GRANT_WILL_TYPE_WELSH	varchar(200)	,
EXCEPTED_ESTATE_IND varchar(1),
FILESLIP_SIGNAL boolean,
GRANT_APPLICANT_TYPE varchar(1),
GRANT_CONFIRMED_DATE date,
GRANT_ISSUED_DATE date,
GRANT_ISSUED_SIGNAL boolean,
GRANT_LIMITATION varchar(800),
GRANT_LIMITATION_WELSH varchar(800),
GRANT_POWER_RESERVED varchar(1),
GRANT_SOL_ID varchar(10),
GRANT_TYPE varchar(3),
GRANT_VERSION_DATE date,
GRANTEE1_ADDRESS 	varchar(500)	,
GRANTEE1_FORENAMES 	varchar(50)	,
GRANTEE1_HONOURS 	varchar(100)	,
GRANTEE1_SURNAME 	varchar(50)	,
GRANTEE1_TITLE 	varchar(35)	,
GRANTEE2_ADDRESS 	varchar(500)	,
GRANTEE2_FORENAMES 	varchar(50)	,
GRANTEE2_HONOURS 	varchar(100)	,
GRANTEE2_SURNAME 	varchar(50)	,
GRANTEE2_TITLE 	varchar(35)	,
GRANTEE3_ADDRESS 	varchar(500)	,
GRANTEE3_FORENAMES 	varchar(50)	,
GRANTEE3_HONOURS 	varchar(100)	,
GRANTEE3_SURNAME 	varchar(50)	,
GRANTEE3_TITLE 	varchar(35)	,
GRANTEE4_ADDRESS 	varchar(500)	,
GRANTEE4_FORENAMES 	varchar(50)	,
GRANTEE4_HONOURS 	varchar(100)	,
GRANTEE4_SURNAME 	varchar(50)	,
GRANTEE4_TITLE 	varchar(35)	,
GROSS_ESTATE_VALUE	bigint	,
NET_ESTATE_VALUE 	bigint	,
PLACE_OF_ORIGINAL_GRANT 	varchar(60)	,
PLACE_OF_ORIGINAL_GRANT_WELSH varchar(60),
POWER_RESERVED_WELSH	varchar(1)	,
RESEAL_DATE	date	,
SOLICITOR_REFERENCE	varchar(30),
LAST_MODIFIED timestamptz
);
CREATE INDEX IDX_LAST_MODIFIED ON GRANT_APPLICATIONS_DERIVED_FLAT(LAST_MODIFIED);


INSERT INTO GRANT_APPLICATIONS_FLAT( ID, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID, DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1,
DECEASED_ADDRESS, DECEASED_TEXT, ALIAS_NAMES, GRANT_APPLICATION_TEXT, APPLICATION_EVENT_TEXT, OATH_TEXT, EXECUTOR_TEXT, OTHER_INFORMATION_TEXT,
LINKED_DECEASED_IDS, CCD_CASE_NO, DNM_IND, DECEASED_AGE_AT_DEATH, DECEASED_DEATH_TYPE, DECEASED_DOMICILE, DECEASED_DOMICILE_IN_WELSH, DECEASED_DOMICILE_WELSH,
DECEASED_HONOURS, DECEASED_SEX, DECEASED_TITLE, APP_ADMIN_CLAUSE_LIMITATION, APP_ADMIN_CLAUSE_LIMITN_WELSH, APP_CASE_TYPE, APP_EXECUTOR_LIMITATION,
APP_EXECUTOR_LIMITATION_WELSH, APP_RECEIVED_DATE, APPLICANT_ADDRESS, APPLICANT_DX_EXCHANGE, APPLICANT_DX_NUMBER, APPLICANT_FORENAMES, APPLICANT_HONOURS,
APPLICANT_SURNAME, APPLICANT_TITLE, GRANT_WELSH_LANGUAGE_IND, GRANT_WILL_TYPE, GRANT_WILL_TYPE_WELSH, EXCEPTED_ESTATE_IND, FILESLIP_SIGNAL, GRANT_APPLICANT_TYPE,
GRANT_CONFIRMED_DATE, GRANT_ISSUED_DATE, GRANT_ISSUED_SIGNAL, GRANT_LIMITATION, GRANT_LIMITATION_WELSH, GRANT_POWER_RESERVED, GRANT_SOL_ID, GRANT_TYPE, GRANT_VERSION_DATE,
GRANTEE1_ADDRESS, GRANTEE1_FORENAMES, GRANTEE1_HONOURS, GRANTEE1_SURNAME, GRANTEE1_TITLE,
GRANTEE2_ADDRESS, GRANTEE2_FORENAMES, GRANTEE2_HONOURS, GRANTEE2_SURNAME, GRANTEE2_TITLE,
GRANTEE3_ADDRESS, GRANTEE3_FORENAMES, GRANTEE3_HONOURS, GRANTEE3_SURNAME, GRANTEE3_TITLE,
GRANTEE4_ADDRESS, GRANTEE4_FORENAMES, GRANTEE4_HONOURS, GRANTEE4_SURNAME, GRANTEE4_TITLE,
GROSS_ESTATE_VALUE, NET_ESTATE_VALUE, PLACE_OF_ORIGINAL_GRANT, PLACE_OF_ORIGINAL_GRANT_WELSH, POWER_RESERVED_WELSH, RESEAL_DATE, SOLICITOR_REFERENCE, LAST_MODIFIED
) VALUES (
1, 'Pro1', 1, 1, 'DeadFN1 DeadFN2', 'DeadSN', '01/01/1900', '01/01/2018',
'DeadAddL1, DeadAddL2, DeadAddL3, DeadCity, DeadCountry, DeadPC', 'DECEASED_TEXT', 'DeadAN1 DeadAN2Grant', 'GRANT_APPLICATION_TEXT', 'APPLICATION_EVENT_TEXT', 'OATH_TEXT', 'EXECUTOR_TEXT', 'OTHER_INFORMATION_TEXT',
'LINKED_DECEASED_IDS', '1111222233334444', 'N', '99', 'DECEASED_DEATH_TYPE', 'United Kingdon', 'WELSH_TOWN', 'DECEASED_DOMICILE_WELSH',
'Sir', 'M', 'Mr', 'APP_ADMIN_CLAUSE_LIMITATION', 'APP_ADMIN_CLAUSE_LIMITN_WELSH', 'Personal', 'APP_EXECUTOR_LIMITATION',
'APP_EXECUTOR_LIMITATION_WELSH', '01/01/2018', 'AppAddL1, AppAddL2, AppAddL3, AppCity, AppCountry, AppPC', 'APPLICANT_DX_EXCHANGE', 'APP_DX_NUM', 'AppFN1 AppFN2', 'AppHon',
'AppSN', 'Mrs', false, 'GRANT_WILL_TYPE', 'GRANT_WILL_TYPE_WELSH', 'Y', true, 'P', '01/01/2018', '02/01/2018', false, 'GRANT_LIMITATION', 'GRANT_LIMITATION_WELSH', 'Y', 'G_SOL_ID', 'PRO', '03/01/2018',
'Gr1AddL1, Gr1AddL2, Gr1AddL3, Gr1City, Gr1Country, Gr1PC', 'Gr1FN1 Gr1FN2', 'Gr1Hons', 'Gr1SN', 'Gr1Mr',
'Gr2AddL1, Gr2AddL2, Gr2AddL3, Gr2City, Gr2Country, Gr2PC', 'Gr2FN1 Gr2FN2', 'Gr2Hons', 'Gr2SN', 'Gr2Mr',
'Gr3AddL1, Gr43ddL2, Gr3AddL3, Gr3City, Gr3Country, Gr3PC', 'Gr3FN1 Gr3FN2', 'Gr3Hons', 'Gr3SN', 'Gr3Mr',
'Gr4AddL1, Gr4AddL2, Gr4AddL3, Gr4City, Gr4Country, Gr4PC', 'Gr4FN1 Gr4FN2', 'Gr4Hons', 'Gr4SN', 'Gr4Mr',
100000, 80000, 'PLACE_OF_ORIGINAL_GRANT', 'PLACE_OF_ORIGINAL_GRANT_WELSH', 'Y', '04/01/2018', 'SOLICITOR_REFERENCE', NOW() );

INSERT INTO GRANT_APPLICATIONS_FLAT( ID, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID, DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1,
DECEASED_ADDRESS, DECEASED_TEXT, ALIAS_NAMES, GRANT_APPLICATION_TEXT, APPLICATION_EVENT_TEXT, OATH_TEXT, EXECUTOR_TEXT, OTHER_INFORMATION_TEXT,
LINKED_DECEASED_IDS, CCD_CASE_NO, DNM_IND, DECEASED_AGE_AT_DEATH, DECEASED_DEATH_TYPE, DECEASED_DOMICILE, DECEASED_DOMICILE_IN_WELSH, DECEASED_DOMICILE_WELSH,
DECEASED_HONOURS, DECEASED_SEX, DECEASED_TITLE, APP_ADMIN_CLAUSE_LIMITATION, APP_ADMIN_CLAUSE_LIMITN_WELSH, APP_CASE_TYPE, APP_EXECUTOR_LIMITATION,
APP_EXECUTOR_LIMITATION_WELSH, APP_RECEIVED_DATE, APPLICANT_ADDRESS, APPLICANT_DX_EXCHANGE, APPLICANT_DX_NUMBER, APPLICANT_FORENAMES, APPLICANT_HONOURS,
APPLICANT_SURNAME, APPLICANT_TITLE, GRANT_WELSH_LANGUAGE_IND, GRANT_WILL_TYPE, GRANT_WILL_TYPE_WELSH, EXCEPTED_ESTATE_IND, FILESLIP_SIGNAL, GRANT_APPLICANT_TYPE,
GRANT_CONFIRMED_DATE, GRANT_ISSUED_DATE, GRANT_ISSUED_SIGNAL, GRANT_LIMITATION, GRANT_LIMITATION_WELSH, GRANT_POWER_RESERVED, GRANT_SOL_ID, GRANT_TYPE, GRANT_VERSION_DATE,
GRANTEE1_ADDRESS, GRANTEE1_FORENAMES, GRANTEE1_HONOURS, GRANTEE1_SURNAME, GRANTEE1_TITLE,
GRANTEE2_ADDRESS, GRANTEE2_FORENAMES, GRANTEE2_HONOURS, GRANTEE2_SURNAME, GRANTEE2_TITLE,
GRANTEE3_ADDRESS, GRANTEE3_FORENAMES, GRANTEE3_HONOURS, GRANTEE3_SURNAME, GRANTEE3_TITLE,
GRANTEE4_ADDRESS, GRANTEE4_FORENAMES, GRANTEE4_HONOURS, GRANTEE4_SURNAME, GRANTEE4_TITLE,
GROSS_ESTATE_VALUE, NET_ESTATE_VALUE, PLACE_OF_ORIGINAL_GRANT, PLACE_OF_ORIGINAL_GRANT_WELSH, POWER_RESERVED_WELSH, RESEAL_DATE, SOLICITOR_REFERENCE, LAST_MODIFIED
) VALUES (
2, 'Pro1', 1, 1, 'Dead2FN1 Dead2FN2', 'Dead2SN', '01/01/1901', '01/01/2019',
'Dead2AddL1, Dead2AddL2, Dead2AddL3, Dead2City, Dead2Country, Dead2PC', 'DECEASED_TEXT', 'Dead2AN1 Dead2AN2Grant', 'GRANT_APPLICATION_TEXT', 'APPLICATION_EVENT_TEXT', 'OATH_TEXT', 'EXECUTOR_TEXT', 'OTHER_INFORMATION_TEXT',
'LINKED_DECEASED_IDS', '1111222233334444', 'N', '99', 'DECEASED_DEATH_TYPE', 'United Kingdon', 'WELSH_TOWN', 'DECEASED_DOMICILE_WELSH',
'Sir', 'M', 'Mr', 'APP_ADMIN_CLAUSE_LIMITATION', 'APP_ADMIN_CLAUSE_LIMITN_WELSH', 'Personal', 'APP_EXECUTOR_LIMITATION',
'APP_EXECUTOR_LIMITATION_WELSH', '01/01/2018', 'AppAddL1, AppAddL2, AppAddL3, AppCity, AppCountry, AppPC', 'APPLICANT_DX_EXCHANGE', 'APP_DX_NUM', 'AppFN1 AppFN2', 'AppHon',
'AppSN', 'Mrs', false, 'GRANT_WILL_TYPE', 'GRANT_WILL_TYPE_WELSH', 'Y', true, 'P', '01/01/2018', '02/01/2018', false, 'GRANT_LIMITATION', 'GRANT_LIMITATION_WELSH', 'Y', 'G_SOL_ID', 'PRO', '03/01/2018',
'Gr1AddL1, Gr1AddL2, Gr1AddL3, Gr1City, Gr1Country, Gr1PC', 'Gr1FN1 Gr1FN2', 'Gr1Hons', 'Gr1SN', 'Gr1Mr',
'Gr2AddL1, Gr2AddL2, Gr2AddL3, Gr2City, Gr2Country, Gr2PC', 'Gr2FN1 Gr2FN2', 'Gr2Hons', 'Gr2SN', 'Gr2Mr',
'Gr3AddL1, Gr43ddL2, Gr3AddL3, Gr3City, Gr3Country, Gr3PC', 'Gr3FN1 Gr3FN2', 'Gr3Hons', 'Gr3SN', 'Gr3Mr',
'Gr4AddL1, Gr4AddL2, Gr4AddL3, Gr4City, Gr4Country, Gr4PC', 'Gr4FN1 Gr4FN2', 'Gr4Hons', 'Gr4SN', 'Gr4Mr',
100000, 80000, 'PLACE_OF_ORIGINAL_GRANT', 'PLACE_OF_ORIGINAL_GRANT_WELSH', 'Y', '04/01/2018', 'SOLICITOR_REFERENCE', NOW() );

INSERT INTO CAVEATS_FLAT
(ID, CAVEAT_NUMBER, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID,
DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, ALIAS_NAMES, CCD_CASE_NO,
CAVEAT_TYPE, CAVEAT_DATE_OF_ENTRY, CAV_DATE_LAST_EXTENDED, CAV_EXPIRY_DATE, CAV_WITHDRAWN_DATE,
CAVEATOR_TITLE, CAVEATOR_HONOURS, CAVEATOR_FORENAMES, CAVEATOR_SURNAME, CAV_SOLICITOR_NAME, CAV_SERVICE_ADDRESS, CAV_DX_NUMBER, CAV_DX_EXCHANGE, CAVEAT_TEXT, CAVEAT_EVENT_TEXT,
DNM_IND, LAST_MODIFIED
) VALUES (
3, 'CAV_01', 'PRO_01', 1, 1,
'DeadFN1 DeadFN2', 'DeadSN', '01/01/1900', '01/01/2018', 'DeadAN1 DeadAN2Caveat', '1111222233334444',
'CAV_TYPE_1', '01/01/2018', '01/01/2018', '01/01/2019', '02/01/2018', 'Mr',
'Sir', 'CavFN1 CavFN2', 'CavSN', 'CavSolName', 'CavServiceAddress', 'DX-1', 'DX-EX-1', 'Caveat Text', 'Caveat Event Text',
'N', NOW() );

INSERT INTO CAVEATS_FLAT
(ID, CAVEAT_NUMBER, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID,
DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, ALIAS_NAMES, CCD_CASE_NO,
CAVEAT_TYPE, CAVEAT_DATE_OF_ENTRY, CAV_DATE_LAST_EXTENDED, CAV_EXPIRY_DATE, CAV_WITHDRAWN_DATE,
CAVEATOR_TITLE, CAVEATOR_HONOURS, CAVEATOR_FORENAMES, CAVEATOR_SURNAME, CAV_SOLICITOR_NAME, CAV_SERVICE_ADDRESS, CAV_DX_NUMBER, CAV_DX_EXCHANGE, CAVEAT_TEXT, CAVEAT_EVENT_TEXT,
DNM_IND, LAST_MODIFIED
) VALUES (
4, 'CAV_01', 'PRO_01', 1, 1,
'Dead2FN1 Dead2FN2', 'Dead2SN', '01/01/1901', '01/01/2019', 'Dead2AN1 Dead2AN2Caveat', '1111222233334444',
'CAV_TYPE_1', '01/01/2018', '01/01/2018', '01/01/2019', '02/01/2018', 'Mr',
'Sir', 'CavFN1 CavFN2', 'CavSN', 'CavSolName', 'CavServiceAddress', 'DX-1', 'DX-EX-1', 'Caveat Text', 'Caveat Event Text',
'N', NOW() );

INSERT INTO STANDING_SEARCHES_FLAT
(ID, SS_NUMBER, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID,
DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, CCD_CASE_NO, DECEASED_ADDRESS, APPLICANT_ADDRESS,
REGISTRY_REG_LOCATION_CODE, SS_APPLICANT_FORENAME, SS_APPLICANT_SURNAME, SS_APPLICANT_HONOURS, SS_APPLICANT_TITLE, SS_DATE_LAST_EXTENDED, SS_DATE_OF_ENTRY, SS_DATE_OF_EXPIRY, SS_WITHDRAWN_DATE, STANDING_SEARCH_TEXT, DNM_IND, ALIAS_NAMES, LAST_MODIFIED
) VALUES (
5,'SS-01','PRO-01', 1, 1,
'DeadFN1 DeadFN2', 'DeadSN', '01/01/1900', '01/01/2018', '1111222233334444', 'DeadAddL1, DeadAddL2, DeadAddL3, DeadCity, DeadCountry, DeadPC','AppAddL1, AppAddL2, AppAddL3, AppCity, AppCountry, AppPC',
1, 'SSFN', 'SSSN', 'Sir', 'Mr','01/01/2018', '01/01/2018', '01/01/2018', '01/01/2018', 'SS-Text', 'N', 'DeadAN1 DeadAN2StandingSearch', NOW());

INSERT INTO STANDING_SEARCHES_FLAT
(ID, SS_NUMBER, PROBATE_NUMBER, PROBATE_VERSION, DECEASED_ID,
DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, CCD_CASE_NO, DECEASED_ADDRESS, APPLICANT_ADDRESS,
REGISTRY_REG_LOCATION_CODE, SS_APPLICANT_FORENAME, SS_APPLICANT_SURNAME, SS_APPLICANT_HONOURS, SS_APPLICANT_TITLE, SS_DATE_LAST_EXTENDED, SS_DATE_OF_ENTRY, SS_DATE_OF_EXPIRY, SS_WITHDRAWN_DATE, STANDING_SEARCH_TEXT, DNM_IND, ALIAS_NAMES, LAST_MODIFIED
) VALUES (
6,'SS-01','PRO-01', 1, 1,
'Dead2FN1 Dead2FN2', 'Dead2SN', '01/01/1901', '01/01/2019', '1111222233334444', 'Dead2AddL1, Dead2AddL2, Dead2AddL3, Dead2City, Dead2Country, Dead2PC','App2AddL1, App2AddL2, App2AddL3, App2City, App2Country, App2PC',
1, 'SS2FN', 'SS2SN', 'Sir', 'Mr','01/01/2018', '01/01/2018', '01/01/2018', '01/01/2018', 'SS-Text', 'N', 'Dead2AN1 Dead2AN2StandingSearch', NOW());


INSERT INTO WILLS_FLAT (
ID, RK_NUMBER, PROBATE_NUMBER, PROBATE_VERSION,
DECEASED_ID, DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, ALIAS_NAMES,
RECORD_KEEPERS_TEXT, CCD_CASE_NO, DNM_IND, LAST_MODIFIED
) VALUES (
7,'RK-1', 'PRO-01', 1, 1,
'DeadFN1 DeadFN2', 'DeadSN', '01/01/1900', '01/01/2018', 'DeadAN1 DeadAN2Will',
'RK-Text', '1111222233334444', 'N', NOW()
);

ID, RK_NUMBER, PROBATE_NUMBER, PROBATE_VERSION,
DECEASED_ID, DECEASED_FORENAMES, DECEASED_SURNAME, DATE_OF_BIRTH, DATE_OF_DEATH1, ALIAS_NAMES,
RECORD_KEEPERS_TEXT, CCD_CASE_NO, DNM_IND, LAST_MODIFIED
) VALUES (
8,'RK-1', 'PRO-01', 1, 1,
'Dead2FN1 Dead2FN2', 'Dead2SN', '01/01/1901', '01/01/2019', 'Dead2AN1 Dead2AN2Will',
'RK-Text', '1111222233334444', 'N', NOW()
);

EOSQL