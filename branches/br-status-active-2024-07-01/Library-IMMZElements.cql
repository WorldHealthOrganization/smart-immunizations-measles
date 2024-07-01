library IMMZElements

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include fhir.cqf.common.FHIRCommon called FC

include WHOConcepts
include WHOCommon called WC
include WHOElements called WE

include IMMZConcepts called Concepts
include IMMZCommon called IC

context Patient

/*
 * Measles elements
 */
define "MCV Dose":
  [Immunization: Concepts."MCV Vaccine"] MCV
    where MCV.status = 'completed'
      and MCV.isSubpotent is not true

define "MCV Primary Series Dose":
  "MCV Dose" MCV
    where exists (
      MCV.protocolApplied Protocol
        where Protocol.series = 'primary'
    )

define "MCV Supplementary Dose":
  "MCV Dose" MCV
    where exists (
      MCV.protocolApplied Protocol
        where Protocol.series = 'supplementary'
    )

define "MCV Dose 0 Dose":
  "MCV Dose" MCV
    where exists (
      MCV.protocolApplied Protocol
        where Protocol.series = 'dose 0'
    )

define "MCV Immunization Proposal":
  [MedicationRequest: medication in Concepts."MCV Vaccine"] MCV
    where MCV.intent = 'proposal'

//TODO: Check patient is alive

// Givens:
// "Currently Pregnant" Data Element
// Modeled as part of
// IMMZ.D.DE161: Potential contraindications
  // D.DE162: Currently pregnant
  // D.DE165: Severly immunosuppressed
  // D.DE166: History of anaphylactic reactions
  // D.DE168: Sympotmatic HIV infection
// ANC.B4.DE1: Pregnancy confirmed
// UV.IPS.PregnancyStatus:
  // LOINC#82810-3 Pregnancy status
    // LOINC#LA15173-0 Pregnant
    // LOINC#LA26683-5 Not pregnant
    // LOINC#LA4489-6 Unknown
// "Pregnancy Status" Observations in IPS

/*
@dataElement: IMMZConcepts#D4.DE161
*/
define "Potential Contraindications":
  "Currently Pregnant"
    or "Severely Immunosuppressed"
    or "History Of Anaphylactic Reactions"
    or "Severe Allergic Reactions"
    or "Symptomatic HIV Infection"

/*
@dataElement: IMMZConcepts#D4.DE162
*/
define "Currently Pregnant": 
  exists "Currently Pregnant Observation"
    or exists "Currently Pregnant Condition"
    or exists WE."Pregnant Observation"

// TODO: Should this be related to the mother's record?
define "Currently Pregnant Observation":
  [Observation: Concepts."Potential contraindications"] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value ~ Concepts."Currently pregnant"

// TODO: Should this be related to the mother's record?
define "Currently Pregnant Condition":
  [Condition: Concepts."Currently pregnant"] C

/*
define "Patient Has Active Sickle-cell disease":
  exists([Condition: code = Concepts."Sickle-cell Disease Condition"] C
  where C.clinicalStatus in FC."Active Condition"
  and C.abatement is null)
*/

//Seronegative. Relevant for Dengue 
/*
define "Individual is Seronegative for Dengue":
  [Observation] O
    where (O.value as CodeableConcept) in Concepts.Seronegative
*/

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
  [Observation: code ~ Concepts."[#] Births.preterm"] O
    where O.status in { 'final', 'amended', 'corrected' }

define "Preterm":
  Last(
    "Preterm Births Observation" O
      sort by start of effective.toInterval()
  ).value

// TODO: This does not seem right, what is the code of the observation?
//Observed Preterm birth
define "Preterm Birth":
  [Observation] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value in Concepts.PretermBirth

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
	[AllergyIntolerance] A
    where A.clinicalStatus ~ FC."allergy-active"
      and	A.verificationStatus ~ FC."allergy-confirmed"

/* 
 * @dataElement Immunocompromised = True
 */
define "Immunocompromised = True":
	exists "Immunocompromised Condition"

define "Immunocompromised Condition":
  [Condition: Concepts."Immunocompromised"] C 
    where C.clinicalStatus in FC."Active Condition"
      and	C.verificationStatus ~ FC."confirmed"

/**
 * @dataElement All Doses Administered to Patient to patient ordered newest to oldest
 */
define "Doses Administered to Patient":
  [Immunization] I
    where I.status = 'completed'
    sort by start of occurrence.toInterval() desc

/**
 * Contraindications 
 */
define "Severely Immunosuppressed":
  exists "Severely Immunosuppressed Observation"
    or exists "Severely Immunosuppressed Condition"

define "Severely Immunosuppressed Observation":
  [Observation: Concepts."Potential contraindications"] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value ~ Concepts."Severely immunosuppressed"

define "Severely Immunosuppressed Condition":
  [Condition: Concepts."Severely immunosuppressed"]

define "History Of Anaphylactic Reactions":
  exists "History Of Anaphylactic Reactions Condition"

define "History Of Anaphylactic Reactions Observation":
  [Observation: Concepts."Potential contraindications"] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value ~ Concepts."History of anaphylactic reactions"

define "History Of Anaphylactic Reactions Condition":
  [Condition: Concepts."History of anaphylactic reactions"]

define "Severe Allergic Reactions":
  exists "Severe Allergic Reactions Observation"
    or exists "Severe Allergic Reactions Condition"

define "Severe Allergic Reactions Observation":
  [Observation: Concepts."Potential contraindications"] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value ~ Concepts."Severe allergic reactions"

define "Severe Allergic Reactions Condition":
  [Condition: Concepts."Severe allergic reactions"]

define "Symptomatic HIV Infection":
  exists "Symptomatic HIV Infection Observation"
    or exists "Symptomatic HIV Infection Condition"

define "Symptomatic HIV Infection Observation":
  [Observation: Concepts."Potential contraindications"] O
    where O.status in { 'final', 'amended', 'corrected' }
      and O.value ~ Concepts."Symptomatic HIV infection"

define "Symptomatic HIV Infection Condition":
  [Condition: Concepts."Symptomatic HIV infection"]

/******************************
 * Test Results
 */

define "Patient Birth Weight Observation":
  [Observation: Concepts."Patient birth weight observation"] O
    where O.status in { 'final', 'amended', 'corrected' }

define "Patient Birth Weight Observation Value":
  Last(
    "Patient Birth Weight Observation" O
      sort by start of effective.toInterval()
  ).value as FHIR.Quantity

/** 
 * @dataElement Patient age in years
 */
define "Current Patient Age In Years":
  AgeInYearsAt(Today())

/** 
 * @dataElement Patient age in weeks
 */
define "Current Patient Age In Weeks":
  AgeInWeeksAt(Today())

/** 
 * @dataElement Patient age in months
 */
define "Current Patient Age In Months":
  AgeInMonthsAt(Today())

/** 
 * @dataElement Patient biological sex used for deciding vaccine eligibility
 * TODO: "Gender" of patient in FHIR is the administrative gender - or can we expect that this will be biological sex and administrative
 *        gender identity will be captured using the gender identity extension?
 */
define "Patient Biological Sex":
  Patient.gender

define "HAART Medication Administration":
  [MedicationAdministration] A 
    where IC.ExtractMedicationCode(A.medication) in Concepts."ARV Drugs" 
      and A.status in { 'active', 'complete' }
  
define "Patient HAART Treatment Start Date":
  Last(
      "HAART Medication Administration" A
        sort by start of effective.toInterval()
  ).effective.toInterval().low

define "Patient HAART Treatment Started 6 to 12 Months Ago":
  "Patient HAART Treatment Start Date" between Now() - 12 months and Now() - 6 months

/**
 * @dataElement The patient has a medication record which indicates that they are receiving ARV
 */
define "Patient is receiving HAART":
  exists(
    [MedicationAdministration] A 
      where IC.ExtractMedicationCode(A.medication) in Concepts."ARV Drugs" 
        and A.status = 'in-progress'
  )

/*
  @dataElement HIV Status observations of the patient most recent first
*/
define "HIV Status":
  Last(
    "HIV Status Observation" O
      sort by start of effective.toInterval()
  ).value as FHIR.CodeableConcept

define "HIV Status Observation":
  [Observation: Concepts."HIV status"] O
    where O.status in { 'final', 'amended', 'corrected' }

define "Live vaccine dose":
  [Immunization: Concepts."Live Attenuated"] LV
    where LV.status = 'completed'
      and LV.isSubpotent is not true

/*
  @dataElement Date and time of last live attenuated vaccine
*/
define "Live Attenuated Vaccines":
  "Doses Administered to Patient" I where I.vaccineCode in Concepts."Live Attenuated"

define "Date of Latest Live Attenuated Vaccine":
  Last(
    "Live Attenuated Vaccines" V
      sort by start of occurrence.toInterval()
  ).occurrence as FHIR.dateTime

