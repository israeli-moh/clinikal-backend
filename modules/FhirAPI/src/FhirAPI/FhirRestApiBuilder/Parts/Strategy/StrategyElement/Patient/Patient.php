<?php
/**
 * Date: 29/01/20
 *  @author Eyal Wolanowski <eyalvo@matrix.co.il>
 * This class strategy Fhir  ORGANIZATION
 *
 *
 */


namespace FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\Patient;
/*must have use*/
use FhirAPI\FhirRestApiBuilder\Parts\ErrorCodes;
use FhirAPI\FhirRestApiBuilder\Parts\Patch\GenericPatch;
use FhirAPI\FhirRestApiBuilder\Parts\Restful;
use FhirAPI\FhirRestApiBuilder\Parts\Search\SearchContext;
use FhirAPI\FhirRestApiBuilder\Parts\Strategy\Strategy;
use FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\Patient\FhirPatientMapping;
/*************/

use FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\Practitioner\FhirPractitionerMapping;
use GenericTools\Model\PatientsTable;
use GenericTools\Model\UserTable;
use OpenEMR\FHIR\R4\FHIRDomainResource\FHIRPatient;
use OpenEMR\FHIR\R4\FHIRResource\FHIRBundle;
use OpenEMR\FHIR\R4\FHIRResourceContainer;
use OpenEMR\Common\Uuid\UuidRegistry;


class Patient Extends Restful implements  Strategy
{


/********************base internal functions***************************************************************************/

    public function __construct($params=null)
    {
        if(!is_null($params))
        {
            $this->initParams($params);
        }
    }

    private function initParams($initials){

        $this->setParamsFromUrl($initials['paramsFromUrl']);
        $this->setParamsFromBody($initials['paramsFromBody']);
        $this->setContainer($initials['container']);
        $this->setMapping($initials['container'],$initials['strategyName']);

    }

    public function doAlgorithm($arrParams)
    {
        $this->initParams($arrParams);

        $this->functionName = $arrParams['type'];
        $function = Restful::$data[$arrParams['strategyName']][self::$function][$this->functionName];
        return $this->$function();
    }

    public function setMapping($container,$strategyName)
    {
        $this->mapping = new FhirPatientMapping($container);
        $this->mapping->setSelfFHIRType($strategyName);
    }

/********************end of base internal functions********************************************************************/

    /**
     * create FHIRPatient
     *
     * @param  string
     * @return FHIRPatient
     * @throws
     */
    public function read()
    {
        $fhirPatientMapping = $this->mapping;
        $patientTable = $this->container->get(PatientsTable::class);
        $patientDataFromDb = $patientTable->buildGenericSelect(["pid"=>$this->paramsFromUrl[0]]);;

        if (!$patientDataFromDb[0]) {
            //not found
            return self::$errorCodes::http_response_code(204);
        }

        $this->mapping->initFhirObject();
        $patient=$fhirPatientMapping->DBToFhir($patientDataFromDb[0], []);
        $this->mapping->initFhirObject();
        return $patient;

    }

    /**
     * set FHIRAddress element
     *
     *
     * @return FHIRBundle
     */
    public function search()
    {
        $paramsToSearch = array(
            'tableToSearchOnOrm'=>$this->container->get(PatientsTable::class),
            'fhirObj'=>new FhirPatientMapping($this->container),
            'paramsToSearch'=>null,
            'container'=>$this->container,
            'paramsFromUrl'=>$this->paramsFromUrl,
            'paramsFromBody'=>$this->paramsFromBody,
            'buildThisSearch' => self::SEARCHSTRATEGYPATH . 'PatientSearch'
        );
        $searchContext = new SearchContext($paramsToSearch);
        return $searchContext->doSearch();
    }

    public function create()
    {
        $dbData = $this->mapping->getDbDataFromRequest($this->paramsFromBody['POST_PARSED_JSON']);

        $patientTable = $this->container->get(PatientsTable::class);

        if (class_exists('OpenEMR\Common\Uuid\UuidRegistry')) {
            $dbData['uuid'] = (new UuidRegistry(['table_name' => 'patient_data']))->createUuid();
        }

        /*********************************** validate *******************************/
        $allData=array('new'=>$dbData,'old'=>array());
        //$mainTable=$patientTable->getTableName();
        $isValid=$this->mapping->validateDb($allData,null);
        /***************************************************************************/
        if($isValid){
            $rez=$patientTable->safeInsert($dbData,'id','pid');
            if(is_array($rez)){
                $patient=$this->mapping->DBToFhir($rez);
                return $patient;
            }else{ //insert failed
                ErrorCodes::http_response_code('500','insert object failed :'.$rez);
            }
        }else{ // object is not valid
            ErrorCodes::http_response_code('406','failed validation');
        }
        //this never happens since ErrorCodes call to exit()
        return false;

    }

    public function update()
    {
        $dbData = $this->mapping->getDbDataFromRequest($this->paramsFromBody['POST_PARSED_JSON']);
        $eid =$this->paramsFromUrl[0];
        return $this->mapping->updateDbData($dbData,$eid);

    }

    /**
     * update Appointment data
     *
     * @param string
     * @return FHIRBundle | FHIRAppointment
     * @throws
     */
    public function patch()
    {
        $initPatch['paramsFromUrl']=$this->paramsFromUrl;
        $initPatch['paramsFromBody']=$this->paramsFromBody;
        $initPatch['container']=$this->container;
        $initPatch['mapping']=$this->mapping;
        $initPatch['selfApiCalls']=new Patient($initPatch);

        $patch = new GenericPatch($initPatch);
        return $patch->patch();

    }





}
