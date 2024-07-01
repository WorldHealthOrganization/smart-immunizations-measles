library IMMZEncounterElements

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include WHOConcepts
include WHOCommon called WC
include WHOEncounterElements called WE

include IMMZConcepts called Concepts
include IMMZCommon called Common
include IMMZElements called Elements

parameter Today Date default Today()
parameter EncounterId String

context Patient

/*
 * Measles elements
 */
define "MCV Dose":
  Elements."MCV Dose" MCV
    where MCV.occurrence.toInterval() on or before Today

define "MCV Primary Series Dose":
  Elements."MCV Primary Series Dose" MCV
    where MCV.occurrence.toInterval() on or before Today

define "MCV Supplementary Dose":
  Elements."MCV Supplementary Dose" MCV
    where MCV.occurrence.toInterval() on or before Today

define "MCV Dose 0 Dose":
  Elements."MCV Dose 0 Dose" MCV
    where MCV.occurrence.toInterval() on or before Today

define "MCV Immunization Proposal":
  Elements."MCV Immunization Proposal" MCV
    where MCV.authoredOn on or before Today

define "Most Recent MCV Immunization Proposal":
  "MCV Immunization Proposal".mostRecent()

/*
 * Contraindications
 */
define "Potential Contraindications":
  "Currently Pregnant"
    or "Severely Immunosuppressed"
    or "History Of Anaphylactic Reactions"
    or "Severe Allergic Reactions"
    or "Symptomatic HIV Infection"

define "Currently Pregnant": 
  exists "Currently Pregnant Observation"
    or exists "Currently Pregnant Condition"
    or exists WE."Pregnant Observation"

define "Currently Pregnant Observation":
  Elements."Currently Pregnant Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts 9 months on or before day of Today

define "Currently Pregnant Condition":
  Elements."Currently Pregnant Condition" C
    where C.prevalenceInterval() includes Today

// TODO: Should this be related to the mother's record?
//Total number of births including abortions, stillbirths and live births.
define "Patient Mother's Pregnancy Outcome Observation":
  [Observation: code ~ Concepts."[#] Births total"] O
    where O.status in { 'final', 'amended', 'corrected' }

define "Patient Mother's Pregnancy Outcome Observation Value":
  Last(
    "Patient Mother's Pregnancy Outcome Observation" O
      sort by start of effective.toInterval()
  ).value

// TODO: Should this be related to the mother's record
// Total number of children whose birth occurred through the end of the last day of the 37th week (259th day) 
// following onset of the last menstrual period
define "Preterm Births Observation":
  Elements."Preterm Births Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() on or before Today

define "Preterm":
  Last(
    "Preterm Births Observation" O
      sort by start of effective.toInterval()
  ).value

// TODO: This does not seem right, what is the code of the observation?
//Observed Preterm birth
define "Preterm Birth":
  Elements."Preterm Birth" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() on or before Today

// TODO: How does/should this relate to the encounter?
//@dataElement Adverse Event:
define "Adverse Event":
  from [Immunization] I, [Observation] O
    where I.reaction.detail.references(O)
    return O

/* 
 * @dataElement Allergy = True
 */
define "Allergy = True":
  exists "Active Confirmed Allergy"

define "Active Confirmed Allergy":
  Elements."Active Confirmed Allergy" A
    where A.onset.toInterval() starts on or before Today

/* 
 * @dataElement Immunocompromised = True
 */
define "Immunocompromised = True":
	exists "Immunocompromised Condition"

define "Immunocompromised Condition":
  Elements."Immunocompromised Condition" C
    where C.prevalenceInterval() starts on or before Today

/**
 * @dataElement All Doses Administered to Patient to patient ordered newest to oldest
 */
define "Doses Administered to Patient":
  Elements."Doses Administered to Patient"

/**
 * Contraindications 
 */
define "Severely Immunosuppressed":
  exists "Severely Immunosuppressed Observation"
    or exists "Severely Immunosuppressed Condition"

define "Severely Immunosuppressed Observation":
  Elements."Severely Immunosuppressed Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts on or before Today

define "Severely Immunosuppressed Condition":
  Elements."Severely Immunosuppressed Condition" C
    where C.prevalenceInterval() starts on or before Today

define "History Of Anaphylactic Reactions":
  exists "History Of Anaphylactic Reactions Condition"

define "History Of Anaphylactic Reactions Observation":
  Elements."History Of Anaphylactic Reactions Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts on or before Today

define "History Of Anaphylactic Reactions Condition":
  Elements."History Of Anaphylactic Reactions Condition" C
    where C.prevalenceInterval() starts on or before Today

define "Severe Allergic Reactions":
  exists "Severe Allergic Reactions Observation"
    or exists "Severe Allergic Reactions Condition"

define "Severe Allergic Reactions Observation":
  Elements."Severe Allergic Reactions Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts on or before Today

define "Severe Allergic Reactions Condition":
  Elements."Severe Allergic Reactions Condition" C
    where C.prevalenceInterval() starts on or before Today

define "Symptomatic HIV Infection":
  exists "Symptomatic HIV Infection Observation"
    or exists "Symptomatic HIV Infection Condition"

define "Symptomatic HIV Infection Observation":
  Elements."Symptomatic HIV Infection Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts on or before Today

define "Symptomatic HIV Infection Condition":
  Elements."Symptomatic HIV Infection Condition" C
    where C.prevalenceInterval() starts on or before Today

/******************************
 * Test Results
 */

define "Patient Birth Weight Observation":
  Elements."Patient Birth Weight Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() on or before Today

define "Patient Birth Weight Observation Value":
  Last(
    "Patient Birth Weight Observation" O
      sort by start of effective.toInterval()
  ).value as FHIR.Quantity

/** 
 * @dataElement Patient age in years
 */
define "Current Patient Age In Years":
  AgeInYearsAt(Today)

/** 
 * @dataElement Patient age in weeks
 */
define "Current Patient Age In Weeks":
  AgeInWeeksAt(Today)

/** 
 * @dataElement Patient age in months
 */
define "Current Patient Age In Months":
  AgeInMonthsAt(Today)

/** 
 * @dataElement Patient biological sex used for deciding vaccine eligibility
 * TODO: "Gender" of patient in FHIR is the administrative gender - or can we expect that this will be biological sex and administrative
 *        gender identity will be captured using the gender identity extension?
 */
define "Patient Biological Sex":
  Patient.gender

define "HAART Medication Administration":
  Elements."HAART Medication Administration" A
    where A.effective.toInterval() starts less than 12 months before Today
  
define "Patient HAART Treatment Start Date":
  Last(
      "HAART Medication Administration" A
        sort by start of effective.toInterval()
  ).effective.toInterval().low

define "Patient HAART Treatment Started 6 to 12 Months Ago":
  "Patient HAART Treatment Start Date" between Today - 12 months and Today - 6 months

/**
 * @dataElement The patient has a medication record which indicates that they are receiving ARV
 */
define "Patient is receiving HAART":
  Elements."Patient is receiving HAART"

/*
  @dataElement HIV Status observations of the patient most recent first
*/
define "HIV Status":
  Last(
    "HIV Status Observation" O
      sort by start of effective.toInterval()
  ).value as FHIR.CodeableConcept

define "HIV Status Observation":
  Elements."HIV Status Observation" O
    where O.encounter.references(EncounterId)
      or O.effective.toInterval() starts on or before Today

define "Live vaccine dose":
  Elements."Live vaccine dose" V
    where V.occurrence.toInterval() starts on or before Today

/*
  @dataElement Date and time of last live attenuated vaccine
*/
define "Live Attenuated Vaccines":
  Elements."Live Attenuated Vaccines"

define "Date of Latest Live Attenuated Vaccine":
  Last(
    "Live Attenuated Vaccines" V
      where V.occurrence.toInterval() starts on or before Today
      sort by start of occurrence.toInterval()
  ).occurrence as FHIR.dateTime

