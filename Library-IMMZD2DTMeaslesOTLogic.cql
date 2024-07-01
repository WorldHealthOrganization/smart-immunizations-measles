/*
@DecisionID: IMMZ.D2.DT.Measles.Ongoing transmission
@BusinessRule: Determine if the client is due for a measles vaccination according to the national immunization schedule
@Trigger: IMMZ.D2 Determine required vaccination(s) if any
@Description: Countries with ongoing transmission in which the risk of measles mortality remains high (countries that provide first dose of MCV at 9 months and second dose of MCV at 15 months)
*/
library IMMZD2DTMeaslesOTLogic

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include WHOCommon called WC
include IMMZD2DTMeaslesLogic called Logic

parameter Today default Today()

context Patient

/*
PlanDefinition Applicability Expressions
*/

define "Measles Routine Immunization Schedule Incomplete":
  Logic."Measles Routine Immunization Schedule Incomplete"

define "No Primary Series Doses Administered":
  Logic."Number Of Primary Series Doses Administered" = 0

define "One Primary Series Dose Administered":
  Logic."Number Of Primary Series Doses Administered" = 1

define "Two Primary Series Doses Administered":
  Logic."Number Of Primary Series Doses Administered" = 2

define "Client Age Less Than 9 Months":
  AgeInMonthsAt(Today) < 9

define "Client Age Less Than 15 Months":
  AgeInMonthsAt(Today) < 15

define "Last Live Vaccine Administered Within 4 Weeks":
  Logic."Date Last Live Vaccine Administered" + 4 weeks on or before Today

define "Client Is Due For MCV1":
  "MCV1 Status" = 'Needed'
    and "MCV1 Due Date" on or before Today

define "Client Is Due For MCV2":
  "MCV2 Status" = 'Needed'
    and "MCV2 Due Date" on or before Today

/*
Supporting Logic
*/

define "MCV1 Status":
  if Logic."Number Of Primary Series Doses Administered" = 0 then 
    'Needed'
  else
    'Complete'

define "MCV1 Schedule Date":
  Patient.birthDate + 9 months

define "MCV1 Expiration Date":
  Patient.birthDate + 15 months

define "MCV1 Due Date":
  if "MCV1 Status" = 'Needed' then
    WC.LatestOf({
        "MCV1 Schedule Date",
        Logic."Date Last Live Vaccine Administered" + 4 weeks,
        Today
    })
  else
    null

define "MCV2 Status":
  if Logic."Number Of Primary Series Doses Administered" = 1 then
    'Needed'
  else
    'Complete'

define "MCV2 Schedule Date":
  Patient.birthDate + 15 months

define "MCV2 Expiration Date":
  null as Date

define "MCV2 Due Date":
  if "MCV2 Status" = 'Needed' then
    WC.LatestOf({
        "MCV2 Schedule Date",
        Logic."Date Last Live Vaccine Administered" + 4 weeks,
        Today
    })
  else
    null
