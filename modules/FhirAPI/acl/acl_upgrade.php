<?php

use OpenEMR\Common\Acl\AclExtended;


return $ACL_UPGRADE = array(

    '0.2.0' => function () {

        AclExtended::addObjectSectionAcl('fhir_api', 'FHIR API');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'patient','Patient');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'appointment','Appointment');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'encounter','Encounter');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'practitioner','Practitioner');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'organization','Organization');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'healthcareservice','Healthcareb Service');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'valueset','Value Set');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'relatedperson','Related Person');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'documentreference','Document Reference');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'questionnaire','Questionnaire');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'questionnaireresponse','Questionnaire Response');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'condition','Condition');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'medicationstatement','Medication Statement');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'observation','Observation');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'medicationrequest','MedicationRequest');
        AclExtended::addObjectAcl('fhir_api', 'FHIR API', 'servicerequest','ServiceRequest');

    }
);
