/*
@DecisionID: IMMZ.D5.DT.Measles contraindications
@BusinessRule: Check for contraindications before administering the vaccine(s) due					
@Trigger: IMMZ.D5 Determine vaccine(s) to be administered based on contraindications
*/
library IMMZD5DTMeaslesCILogic

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include IMMZEncounterElements called Elements

parameter Today default Today()

context Patient

/*
PlanDefinition Applicability Expressions
*/

define "MCV Dose Contraindicated":
  "Measles Vaccination Contraindicated"
    or "Measles Vaccination Could Be Contraindicated"

// TODO: Define this
define "Contraindication Evaluation of the MCV Dose":
  false

/*
IMMZ.D5.DT.Measles contraindications
*/
define "Measles Vaccination Could Be Contraindicated":
  Elements."History Of Anaphylactic Reactions"
    or Elements."Severe Allergic Reactions"
    or Elements."Symptomatic HIV Infection"

define "Measles Vaccination Contraindicated":
  Elements."Currently Pregnant"
    or Elements."Severely Immunosuppressed"





