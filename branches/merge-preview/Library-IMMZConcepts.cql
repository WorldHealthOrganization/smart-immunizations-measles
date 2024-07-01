library IMMZConcepts

// Code Systems
//Probably can delete these once imported WHOConcepts
codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "LOINC": 'http://loinc.org'
codesystem "RxNorm": 'http://www.nlm.nih.gov/research/umls/rxnorm'
codesystem "CIEL": 'http://hl7.org/fhir/sid/ciel'
codesystem "ICD-11": 'http://id.who.int/icd/release/11/mms'
codesystem "ICHI": 'https://mitel.dimi.uniud.it/ichi/#http://id.who.int/ichi'
codesystem "ICF": 'http://hl7.org/fhir/sid/icf-nl'
codesystem "Extended Codes CodeSystem codes": 'http://fhir.org/guides/who/anc-cds/CodeSystem/anc-custom-codes'

codesystem "IMMZConcepts": 'http://smart.who.int/immunizations-measles/CodeSystem/IMMZConcepts'

//WHO ATC IPS Valueset
valueset "WHO ATC": 'http://hl7.org/fhir/uv/ips/ValueSet/whoatc-uv-ips'

// General use ValueSets 
valueset "Negative Result": 'http://smart.who.int/immunizations-measles/ValueSet/Negativetestresult-values'
valueset "Positive Result": 'http://smart.who.int/immunizations-measles/ValueSet/PositiveTestResult-values'
valueset "Immunocompromised": 'http://smart.who.int/immunizations-measles/ValueSet/Immunocompromised-values'
valueset "Patient birth weight observation": 'http://smart.who.int/immunizations-measles/ValueSet/Birthweight-values'
valueset "PretermBirth": 'http://smart.who.int/immunizations-measles/ValueSet/Preterm-values'
valueset "Live Attenuated": 'http://smart.who.int/immunizations-measles/ValueSet/LiveAttenduatedVaccines'

//valueset "Target Disease": 'http://hl7.org/fhir/ValueSet/immunization-target-disease'

valueset "HIV status": 'http://smart.who.int/immunizations-measles/ValueSet/HIVstatus-values'
valueset "HIV status - HIV positive Choices": 'http://fhir.org/guides/who/anc-cds/ValueSet/anc-b9-de46'
valueset "HIV status - HIV negative Choices": 'http://fhir.org/guides/who/anc-cds/ValueSet/anc-b9-de47'

valueset "ARV Drugs": 'http://smart.who.int/immunizations-measles/ValueSet/ARVDrugs-values'

// Vaccine Value Sets

valueset "MCV Vaccine": 'http://smart.who.int/immunizations-measles/ValueSet/IMMZ.Z.DE9'

// Plugin is complaining about not finding these so that should be resolved, but here until it can be fixed
valueset "BCG Vaccine": 'http://smart.who.int/immunizations-measles/ValueSet/IMMZ.Z.DE1'
valueset "Cholera Vaccine": 'http://smart.who.int/immunizations-measles/ValueSet/IMMZ.Z.DE2'

code "Adverse Event Severity": '246112005' from "SNOMED-CT" display 'Severity (attribute)'
code "Adverse Event Manifestation": '246112005' from "SNOMED-CT" display 'Severity (attribute)'

code "Potential contraindications": 'D4.DE161' from "IMMZConcepts" display 'Potential contraindications'
code "Currently pregnant": 'D4.DE162' from "IMMZConcepts" display 'Currently pregnant'
code "Severely immunosuppressed": 'D4.DE165' from "IMMZConcepts" display 'Severely immunosuppressed' 
code "History of anaphylactic reactions": 'D4.DE166' from "IMMZConcepts" display 'History of anaphylactic reactions'
code "Severe allergic reactions": 'D4.DE167' from "IMMZConcepts" display 'Severe allergic reactions'
code "Symptomatic HIV infection": 'D4.DE168' from "IMMZConcepts" display 'Symptomatic HIV infection'

code "[#] Births total": '11640-0' from "LOINC" display 'Pregnancy outcome'
code "[#] Births.preterm": '11637-6' from "LOINC" display 'Preterm'

