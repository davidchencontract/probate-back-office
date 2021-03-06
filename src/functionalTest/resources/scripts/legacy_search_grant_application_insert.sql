INSERT INTO GRANT_APPLICATIONS_FLAT(
ID,
PROBATE_NUMBER,
PROBATE_VERSION,
DECEASED_ID,
DECEASED_FORENAMES,
DECEASED_SURNAME,
DATE_OF_BIRTH,
DATE_OF_DEATH1,
DATE_OF_DEATH2,
DECEASED_ADDRESS,
DECEASED_TEXT,
ALIAS_NAMES,
GRANT_APPLICATION_TEXT,
APPLICATION_EVENT_TEXT,
OATH_TEXT,
EXECUTOR_TEXT,
OTHER_INFORMATION_TEXT,
LINKED_DECEASED_IDS,
CCD_CASE_NO,
DNM_IND,
DECEASED_AGE_AT_DEATH,
DECEASED_DEATH_TYPE,
DECEASED_DOMICILE,
DECEASED_DOMICILE_IN_WELSH,
DECEASED_DOMICILE_WELSH,
DECEASED_HONOURS,
DECEASED_SEX,
DECEASED_TITLE,
APP_ADMIN_CLAUSE_LIMITATION,
APP_ADMIN_CLAUSE_LIMITN_WELSH,
APP_CASE_TYPE,
APP_EXECUTOR_LIMITATION,
APP_EXECUTOR_LIMITATION_WELSH,
APP_RECEIVED_DATE,
APPLICANT_ADDRESS,
APPLICANT_DX_EXCHANGE,
APPLICANT_DX_NUMBER,
APPLICANT_FORENAMES,
APPLICANT_HONOURS,
APPLICANT_SURNAME,
APPLICANT_TITLE,
GRANT_WELSH_LANGUAGE_IND,
GRANT_WILL_TYPE,
GRANT_WILL_TYPE_WELSH,
EXCEPTED_ESTATE_IND,
FILESLIP_SIGNAL,
GRANT_APPLICANT_TYPE,
GRANT_CONFIRMED_DATE,
GRANT_ISSUED_DATE,
GRANT_ISSUED_SIGNAL,
GRANT_LIMITATION,
GRANT_LIMITATION_WELSH,
GRANT_POWER_RESERVED,
GRANT_SOL_ID,
GRANT_TYPE,
GRANT_VERSION_DATE,
GRANTEE1_ADDRESS,
GRANTEE1_FORENAMES,
GRANTEE1_HONOURS,
GRANTEE1_SURNAME,
GRANTEE1_TITLE,
GRANTEE2_ADDRESS,
GRANTEE2_FORENAMES,
GRANTEE2_HONOURS,
GRANTEE2_SURNAME,
GRANTEE2_TITLE,
GRANTEE3_ADDRESS,
GRANTEE3_FORENAMES,
GRANTEE3_HONOURS,
GRANTEE3_SURNAME,
GRANTEE3_TITLE,
GRANTEE4_ADDRESS,
GRANTEE4_FORENAMES,
GRANTEE4_HONOURS,
GRANTEE4_SURNAME,
GRANTEE4_TITLE,
GROSS_ESTATE_VALUE,
NET_ESTATE_VALUE,
PLACE_OF_ORIGINAL_GRANT,
PLACE_OF_ORIGINAL_GRANT_WELSH,
POWER_RESERVED_WELSH,
RESEAL_DATE,
SOLICITOR_REFERENCE,
LAST_MODIFIED
)
VALUES (
nextval('GRANT_APPLICATIONS_FLAT_SEQ'),
'Pro123456',
1,
1,
'[FORENAME_REPLACE]',
'[SURNAME_REPLACE]',
'01/01/1900',
'01/01/2018',
'02/02/2018',
'DeadAddL1, DeadAddL2, DeadAddL3, DeadCity, DeadCountry, DeadPC',
'DECEASED_TEXT',
'[ALIAS_REPLACE]',
'GRANT_APPLICATION_TEXT',
'APPLICATION_EVENT_TEXT',
'OATH_TEXT',
'EXECUTOR_TEXT',
'OTHER_INFORMATION_TEXT',
'LINKED_DECEASED_IDS',
null,
'N',
'99',
'DECEASED_DEATH_TYPE',
'United Kingdon',
'WELSH_TOWN',
'DECEASED_DOMICILE_WELSH',
'Sir',
'M',
'Mr',
'APP_ADMIN_CLAUSE_LIMITATION',
'APP_ADMIN_CLAUSE_LIMITN_WELSH',
'APP_CASE_TYPE',
'APP_EXECUTOR_LIMITATION',
'APP_EXECUTOR_LIMITATION_WELSH',
'01/01/2018',
'AppAddL1, AppAddL2, AppAddL3, AppCity, AppCountry, AppPC',
'APPLICANT_DX_EXCHANGE',
'APP_DX_NUM',
'AppFN1 AppFN2',
'AppHon',
'AppSN',
'Mrs',
false,
'GRANT_WILL_TYPE',
'GRANT_WILL_TYPE_WELSH',
'Y',
true,
'P',
'01/01/2018',
'02/01/2018',
false,
'GRANT_LIMITATION',
'GRANT_LIMITATION_WELSH',
'Y',
'G_SOL_ID',
'PRO',
'03/01/2018',
'Gr1AddL1, Gr1AddL2, Gr1AddL3, Gr1City, Gr1Country, Gr1PC',
'Gr1FN1 Gr1FN2',
'Gr1Hons',
'Gr1SN',
'Gr1Mr',
'Gr2AddL1, Gr2AddL2, Gr2AddL3, Gr2City, Gr2Country, Gr2PC',
'Gr2FN1 Gr2FN2',
'Gr2Hons',
'Gr2SN',
'Gr2Mr',
'Gr3AddL1, Gr43ddL2, Gr3AddL3, Gr3City, Gr3Country, Gr3PC',
'Gr3FN1 Gr3FN2',
'Gr3Hons',
'Gr3SN',
'Gr3Mr',
'Gr4AddL1, Gr4AddL2, Gr4AddL3, Gr4City, Gr4Country, Gr4PC',
'Gr4FN1 Gr4FN2',
'Gr4Hons',
'Gr4SN',
'Gr4Mr',
100000,
80000,
'PLACE_OF_ORIGINAL_GRANT',
'PLACE_OF_ORIGINAL_GRANT_WELSH',
'Y',
'04/01/2018',
'SOLICITOR_REFERENCE',
NOW()
);