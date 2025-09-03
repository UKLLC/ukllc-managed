 ** 19.03.2025 **
** Rachel Calkin
** OVER-ARCHING DO FILE TO RUN SELF-REPORT HARMONISATION IN A SINGLE SWEEP


*******************************
** STEP 1: RUN ALL LPS DO FILES
*******************************

do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\ALSPAC_M_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\ALSPAC_YP_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\BCS70_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\BIB_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\ELSA_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\EPICN_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\EXCEED_demog.do" 
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\FENLAND_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\GENSCOT_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\GLAD_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\MCS_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\NCDS58_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\NEXTSTEP_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\NICOLA_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\NIHRBIO_COPING_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\NSHD46_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\SABRE_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\TEDS_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\TRACKC19_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\TWINSUK_demog.do"
do "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_do_files\UKHLS_demog.do"

**********************************
** STEP 2: APPEND ALL LPS DATASETS
**********************************

cd "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_harmonised"
clear
use          ALSPAC_M.dta
append using ALSPAC_YP.dta
append using BCS70.dta
append using BIB.dta
append using ELSA.dta
append using EPICN.dta
append using EXCEED.dta 
append using FENLAND.dta
append using GENSCOT.dta
append using GLAD.dta
append using MCS.dta
append using NCDS58.dta
append using NEXTSTEP.dta
append using NICOLA.dta
append using NIHRBIO_COPING.dta
append using NSHD46.dta
append using SABRE.dta
append using TEDS.dta
append using TRACKC19.dta
append using TWINSUK.dta
append using UKHLS.dta

save all_files_v1, replace

***********************************
** STEP 3: CLEAN DATES & ADD LABELS
***********************************

* a) DOBs 
tab value if object=="llc_dob" // this will need checking after updates
replace value=. if object=="llc_dob" & (value >=9999 | value <1900) // these values may need changing when new files are added

* BLANK TIMESTAMPS
replace day=. if (day <1 | day >31)
replace day=01 if day==.
replace month=. if (month <1 | month >12)
replace month=01 if month==.
replace year=. if year <1900
replace year=1900 if year==.
generate llc_timestamp=mdy(month,day,year)
format llc_timestamp %td
tab year if month==2 & day>=29 // leap year check (should be divisble by 4!)
tab year if day==31 & (month==4 | month==6 | month==9 | month==11) // should be 'no observations' as these are the months with 30 days
drop month day year

* save all_files_v2, replace

* drop missing dates of birth
drop if value==. & object=="llc_dob"


** LABEL OBJECTS
gen     label= "0=Male, 1=Female, 3=Don't know, 4=Prefer not to answer, 99=Not answered" if object=="llc_sex"
replace label= "0=Male, 1=Female, 2=Non-binary, 3=Prefer to self-define" if object=="llc_gender_a"
replace label= "0=Male, 1=Female, 5=Other, 6=Prefer not to answer, 7=Answer unclear" if object=="llc_gender_b"

replace label= "0=White, 1=Black, 2=South Asian, 3=Other Asian, 4=Mixed, 5=Other, 97=Refused to answer, 98=Don't know, 99=Not answered" if object=="llc_ethnic6"
replace  label= "0=White, 1=Black, 4=Mixed, 5=Other, 6=Asian(inc. Chinese), 97=Refused to answer, 98=Don't know, 99=Not answered" if object=="llc_ethnic5"
replace label= "0=White, 7=All other ethnic groups, 97=Refused to answer, 98=Don't know, 99=Not answered" if object=="llc_ethnic2"

save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_full_harmonised_20250604.dta", replace // UPDATE * this is the FULL version to be surfaced in "UKLLC managed datasets"

**************************************************************
** STEP 4: REDUCED FILE WITH ONLY THE MOST RECENT, VALID VALUE
**************************************************************

clear
use "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_full_harmonised_20250604.dta" // UPDATE

* REMOVE ALL MISSING VALUES
drop if value==. // all completely missing values
drop if object=="llc_sex" & value >=3
drop if object=="llc_gender_b" & value>=6
drop if object=="llc_ethnic6" & (value==97 | value==98 | value==99)
drop if object=="llc_ethnic5" & value==99
drop if object=="llc_ethnic2" & value==99
save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta", replace

* GENSCOT ONLY: remove ethnic5 if participant also has ethnic6 (year of collection: ethnic6 == 2020, ethnic5 == 2006-2011)
gen temp=0
replace temp=6 if cohort=="GENSCOT" & object=="llc_ethnic6"
replace temp=5 if cohort=="GENSCOT" & object=="llc_ethnic5"
gsort study_id_e -temp
bysort study_id_e : gen order= _n
drop if temp==5 & order==2 // n=4283 dropped 21.05.2025
drop temp order
save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta", replace

* CALC ETHNICITY 5 AND 2 FROM 6 WHERE AVAILABLE
keep if object=="llc_ethnic6"
replace value=6 if value==2|value==3
replace object="llc_ethnic5"
* replace label= "0=White, 1=Black, 4=Mixed, 5=Other, 6=Asian(inc. Chinese), 99=NA" if object=="llc_ethnic5"
append using "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta"
save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta", replace

keep if object=="llc_ethnic5"
replace value=7 if value!=0
replace object="llc_ethnic2"
* replace label= "0=White, 7=All other ethnic groups, 99=NA" if object=="llc_ethnic2"
append using "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta"
save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta", replace

* CALC GENDER_B FROM GENDER_A WHERE AVAILABLE
keep if object=="llc_gender_a"
replace value=5 if (value==2 | value==3)
replace object="llc_gender_b"
* replace label= "0=Male, 1=Female, 5=Other, 6=Prefer not to answer, 7=Answer unclear" if object=="llc_gender_b"
append using "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_interim.dta"

* KEEP ONLY MOST RECENT ROW PER PARTICIPANT PER OBJECT
bysort study_id_e object: egen rank=rank(-llc_timestamp), unique
keep if rank==1
drop rank
* this file is the 'reduced' version in UK LLC managed data
save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_reduced_harmonised_20250604.dta", replace // UPDATE

* fix LABELS so no longer refer to missing
drop label
gen     label= "0=Male, 1=Female" if object=="llc_sex"
replace label= "0=Male, 1=Female, 2=Non-binary, 3=Prefer to self-define" if object=="llc_gender_a"
replace label= "0=Male, 1=Female, 5=Other" if object=="llc_gender_b"

replace label= "0=White, 1=Black, 2=South Asian, 3=Other Asian, 4=Mixed, 5=Other" if object=="llc_ethnic6"
replace  label= "0=White, 1=Black, 4=Mixed, 5=Other, 6=Asian(inc. Chinese)" if object=="llc_ethnic5"
replace label= "0=White, 7=All other ethnic groups" if object=="llc_ethnic2"

save "S:\UKLLC - UKLLC Databank\misc\dataset_creation\harmonisation_demog\LPS_data\lps_final_datasets\LPS_reduced_harmonised_20250604.dta", replace 

*** ENDS ***














