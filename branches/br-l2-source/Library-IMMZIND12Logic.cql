/*
 * Library: IMMZ.IND.12 Logic
 * Immunization coverage for Measles and rubella containing vaccine, 1st dose 
 * The percentage in the target population who have received one dose of measles and rubella vaccine during reporting period
 * 
 * Numerator: Number of measles and rubella doses (1st dose) administered through routine services during reporting period
 * Numerator Computation: COUNT of immunization events WHERE "Vaccine type" = "Measles and rubella containing vaccines"  for the first dose in the primary series AND "Date and time of vaccination" is during the reporting period
 * Denominator: Number in target group
 * Denominator Computation: As defined by the Member States
 * 
 * Disaggregation:
 *   - Administrative area
 *   - Sex
 *   - Age in years
 *   - Age group (depending on schedule) 
 * 
 * References: WHO Immunization facility analysis guide;WHO Handbook on immunization data
 */
library IMMZIND12Logic

/*
NOTE: This is an estimated denominator measure, meaning that all we are contributing from the site perspective is a count
towards the numerator, actual processing of this data to determine a proportion measure would be done by downstream analytics

For this reason, this measure is modeled as a cohort measure where membership in the cohort is determine by administration of
a measles containing vaccine.
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include IMMZCommon called Common
include IMMZConcepts called Concepts
include IMMZConfig called Config
include IMMZIndicatorElements called Elements
include IMMZVaccineLibrary called VaccineLibrary

parameter "Measurement Period" Interval<Date>

context Patient

/*
 * As defined by Member State
 */
define "Initial Population":
  true

/*
 * As defined by Member State
 */
define "Denominator":
  true

/*
 * Numerator: Number of measles and rubella doses (1st dose) administered through routine services during reporting period
 * Numerator Computation: COUNT of immunization events WHERE "Vaccine type" = "Measles and rubella containing vaccines"  for the first dose in the primary series AND "Date and time of vaccination" is during the reporting period
 */
define "Numerator":
  exists (
	Elements."MCV Doses Administered to Patient During Measurement Period" I
	  where I.protocolApplied.only().doseNumber = 1
  )
