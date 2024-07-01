/*
@Description: Common logic used in all the measles decisions
*/
library IMMZD2DTMeaslesLogic

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include WHOCommon called WC
include IMMZConcepts called Concepts
include IMMZCommon called Common
include IMMZConfig called Config
include IMMZEncounterElements called Elements

parameter Today default Today()

// TODO: Should these be data elements?
parameter "Individual is at high risk of contracting measles" Boolean default false
parameter "Individual is travelling to a country experiencing measles outbreaks" Boolean default false
parameter "Individual is known to be HIV-infected or exposed" Boolean default false
parameter "Immune reconstitution was achieved" Boolean default false

context Patient

define "Most Recent Live Vaccine Dose":
  Elements."Live vaccine dose".mostRecent()

define "Date Last Live Vaccine Administered":
  date from start of "Most Recent Live Vaccine Dose".occurrence.toInterval()

define "No Live Vaccine Administered":
  "Date Last Live Vaccine Administered" is null

define "Number Of MCV0 Doses Administered":
  Count(Elements."MCV Dose 0 Dose")

define "Number Of Primary Series Doses Administered":
  Count(Elements."MCV Primary Series Dose")

define "Measles Routine Immunization Schedule Complete":
  "Number Of Primary Series Doses Administered" >= 2

define "Measles Routine Immunization Schedule Incomplete":
  not "Measles Routine Immunization Schedule Complete"

define "Number Of Supplementary Doses Administered":
  Count(Elements."MCV Supplementary Dose")

define "Draft Medication Request ID for MCV dose":
  Elements."Most Recent MCV Immunization Proposal".id
