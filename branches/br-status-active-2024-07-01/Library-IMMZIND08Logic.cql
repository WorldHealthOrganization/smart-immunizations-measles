/*
 * Library: IMMZ.IND.08 Logic
 * Immunization coverage for Measles containing vaccine (Estimated Denominator) 
 * Compares the administered doses of measles containing vaccines (MCV) with the estimated number of surviving infants (if dose 1) or a country supplied denominator (if dose 2) expressed as a percentage. 
 * 
 * Numerator: Number of administrations of vaccinations containing a Measles component during reporting period 
 * Numerator Computation: COUNT immunization events WHERE administered product is a Measles vaccine (IMMZ.A1.DE9) during reporting period
 * Denominator: Estimated number of surviving infants (for dose 1) and country supplied denominator for dose sequence 2 (see comments)
 * Denominator Computation: PARAMETER number of surviving infants (if Dose Sequence = 1) or PARAMETER of country supplied denominator (if Dose Sequence = 2)
 * 
 * Disaggregation:
 *   - Dose Sequence (1, 2)
 *   - Age Group (< 1 year or > 1 year)
 *   - Geographic Region
 *   - Administrative Gender (or Biological Sex)
 * 
 * References: WHO Immunization Facility Analysis Guide (1), WHO / UNICEF Joint Reporting Form (3 - elements 4240 and 4260 )
 */
library IMMZIND08Logic

/*
NOTE: This is an estimated denominator measure, meaning that all we are contributing from the site perspective is a count
towards the numerator, actual processing of this data to determine a proportion measure would be done by downstream analytics

For this reason, this measure is modeled as a continuous variable measure where the contribution from each patient is the count of events (1)
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
 * As defined by Member States
 */
define "Initial Population":
  true

define "Measure Population":
  exists Elements."MCV Doses Administered to Patient During Measurement Period"

/*
 * Numerator: Number of administrations of vaccinations containing a Measles component during reporting period
 * Numerator Computation: COUNT immunization events WHERE administered product is a Measles vaccine (IMMZ.A1.DE9) during reporting period
 * NOTE: Modeled as a Continuous Variable measure because this is an estimated denominator proportion measure
 */
define function "Measure Observation"(Patient "Patient"):
  1

/*
 * Disaggregator: Dose Sequence (1, 2)
 */
define "Dose Sequence Stratifier":
	Elements."MCV Doses Administered to Patient During Measurement Period" I
	return (singleton from I.protocolApplied).doseNumber

/*
 * Disaggregator: Age Group (<24H of Birth, < 2 weeks)
 */
define "Age Group Stratifier":
	Elements."Infant By Age Stratifier"

/*
 * Disaggregator: Geographic Region
 */
define "Geographic Region Stratifier":
	Elements."By Geographic Region Stratifier"

/*
 * Disaggregator: Administrative Gender (or Biological Sex)
 */
define "Administrative Gender Stratifier":
	Elements."By Administrative Gender Stratifier"

/*
 * Combined stratifiers
 */
define "Stratification":
  Elements."By Administrative Gender Stratifier".code 
    + ':' + Elements."Toddler By Age Stratifier".code 
	+ ':' + Elements."By Geographic Region Stratifier"

/* End of IMMZ.IND.08 */
