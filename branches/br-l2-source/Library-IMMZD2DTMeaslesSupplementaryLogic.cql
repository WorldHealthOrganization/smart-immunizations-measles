/*
@DecisionID: IMMZ.D2.DT.Measles.Supplementary dose
@BusinessRule: Determine if the client is due for a measles vaccination according to the national immunization schedule
@Trigger: IMMZ.D2 Determine required vaccination(s) if any
@Description: Measles supplementary dose administration
*/
library IMMZD2DTMeaslesSupplementaryLogic

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include WHOCommon called WC
include IMMZD2DTMeaslesLogic called Logic

parameter Today default Today()

context Patient

/*
PlanDefinition Applicability Expressions
*/

define "Measles Routine Immunization Schedule Complete":
  Logic."Number Of Primary Series Doses Administered" >= 2

define "No Supplementary Dose Administered":
  Logic."Number Of Supplementary Doses Administered" = 0

define "Supplementary Dose Administered":
  Logic."Number Of Supplementary Doses Administered" = 1

define "Last Live Vaccine Administered Within 4 Weeks":
  Logic."Date Last Live Vaccine Administered" + 4 weeks on or before Today

define "Client Is Due For MCV Supplementary Dose":
  "MCV Supplementary Dose Status" = 'Eligible'
    and "MCV Supplementary Dose Due Date" on or before Today

/*
Supporting Logic
*/

// TODO: Define these
define "Patient Is HIV-infected And Immune Reconstitution Has Been Achieved Or 6 To 12 Months Have Passed Since HAART Initiation":
  false

define "MCV Supplementary Dose Status":
  if "No Supplementary Dose Administered" and "Measles Routine Immunization Schedule Complete"
    and "Patient Is HIV-infected And Immune Reconstitution Has Been Achieved Or 6 To 12 Months Have Passed Since HAART Initiation" then
    'Eligible'
  else
    'Complete'

define "MCV Supplementary Schedule Date":
  null as Date

define "MCV Supplementary Expiration Date":
  null as Date

define "MCV Supplementary Dose Due Date":
  if "MCV Supplementary Dose Status" = 'Eligible' then
    WC.LatestOf({
        Logic."Date Last Live Vaccine Administered" + 4 weeks,
        Today
    })
  else
    null
