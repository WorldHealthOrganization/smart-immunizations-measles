/*
@DecisionID: IMMZ.D2.DT.Measles.MCV dose 0
@BusinessRule: Determine if the client is due for a measles vaccination according to the national immunization schedule
@Trigger: IMMZ.D2 Determine required vaccination(s) if any
@Description: MCV dose 0 (MCV0) administration
*/
library IMMZD2DTMeaslesDose0Logic

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

define "No MCV0 Doses Administered":
  Logic."Number Of MCV0 Doses Administered" = 0

define "MCV0 Dose Administered":
  Logic."Number Of MCV0 Doses Administered" = 1

define "Client Age Less Than 6 Months":
  AgeInMonthsAt(Today) < 6

define "Client Age 9 Months Or More":
  AgeInMonthsAt(Today) >= 9

define "Last Live Vaccine Administered Within 4 Weeks":
  Logic."Date Last Live Vaccine Administered" + 4 weeks on or before Today

define "Client Is Due For MCV0":
  "MCV0 Status" = 'Needed'
    and "MCV0 Due Date" on or before Today

/*
Supporting Logic
*/

define "MCV0 Status":
  if Logic."Number Of MCV0 Doses Administered" = 0 and AgeInMonthsAt(Today) between 6 and 9 then
    'Needed'
  else
    'Complete'

define "MCV0 Schedule Date":
  Patient.birthDate + 6 months

define "MCV0 Expiration Date":
  Patient.birthDate + 9 months

define "MCV0 Due Date":
  if "MCV0 Status" = 'Needed' then
    WC.LatestOf({
        "MCV0 Schedule Date",
        Logic."Date Last Live Vaccine Administered" + 4 weeks,
        Today
    })
  else
    null
