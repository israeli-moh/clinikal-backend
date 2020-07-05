<?php
/**
 * Date: 21/01/20
 * @author  eyal wolanowski <eyalvo@matrix.co.il>
 * This class MAPPING FOR Condition
 */

namespace FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\MedicationRequest;

use Exception;
use FhirAPI\FhirRestApiBuilder\Parts\ErrorCodes;
use FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\MappingData;
use FhirAPI\Service\FhirBaseMapping;
use GenericTools\Model\ListsOpenEmrTable;
use GenericTools\Model\ListsTable;
use Interop\Container\ContainerInterface;

/*include FHIR*/

use Laminas\Form\Annotation\Instance;
use OpenEMR\FHIR\R4\FHIRDomainResource\FHIRMedicationRequest;
use OpenEMR\FHIR\R4\FHIRElement\FHIRDateTime;

use OpenEMR\FHIR\R4\FHIRElement\FHIRMedicationRequestStatus;
use OpenEMR\FHIR\R4\FHIRResource\FHIRDosage;
use OpenEMR\FHIR\R4\FHIRResource\FHIRDosage\FHIRDosageDoseAndRate;
use phpDocumentor\Reflection\Types\Object_;
use function DeepCopy\deep_copy;

class FhirMedicationRequestMapping extends FhirBaseMapping  implements MappingData
{
    private $adapter = null;
    private $container = null;
    private $FHIRMedicationRequest = null;

    private $loincCodes= array();
    private $lonicDbMappig= array();

    CONST LONIC_ORG="loinc_org";
    CONST LONIC_SYSTEM="http://loinc.org";



    public function __construct(ContainerInterface $container)
    {
        parent::__construct($container);
        $this->container = $container;
        $this->adapter = $container->get('Laminas\Db\Adapter\Adapter');
        $this->FHIRMedicationRequest = new FHIRMedicationRequest;

        $ListsTable = $this->container->get(ListsTable::class);
        $listOutcome = $ListsTable->getList(self::LONIC_ORG);

        $this->setLonicDbMappig($listOutcome);
        $this->setLoincCodes($listOutcome);
    }


    /**
     * set fhir object
     */
    public function setFHIR($fhir=null)
    {
        if(is_null($fhir)){
            $this->FHIRMedicationRequest = new FHIRMedicationRequest;
            return $this->FHIRMedicationRequest;
        }
        try{
            $this->FHIRMedicationRequest = new FHIRMedicationRequest($fhir);
            return $this->FHIRMedicationRequest;
        }catch(Exception $e){
            return false;
        }
    }

    /**
     * return fhir object
     */
    public function getFHIR()
    {
        return $this->FHIRMedicationRequest;
    }

    public function setLonicDbMappig($list)
    {
        foreach($list as $code =>$dataArr){
            $this->lonicDbMappig[$code]=$dataArr['mapping'];
        }
        return $this->lonicDbMappig;
    }

    public function getLonicToDbMappig()
    {
        return $this->lonicDbMappig;
    }

    public function getDbToLonicMappig()
    {
        return array_flip($this->lonicDbMappig);
    }


    public function setLoincCodes($types)
    {
        $this->loincCodes=$types;
        return $this->loincCodes;
    }

    public function getLoincCodes()
    {
        return $this->loincCodes;
    }





    /**
     * convert FHIRMedicationRequest to db array
     *
     * @param FHIRMedicationRequest
     *
     * @return array;
     */
    public function fhirToDb($FHIRMedicationRequest)
    {
        $dbObservation = array();

        $dbObservation['id']=$FHIRMedicationRequest->getId()->getValue();

        $FHIRdate= $FHIRMedicationRequest->getIssued()->getValue();
        $dbObservation['date']= $this->convertToDateTime($FHIRdate);

        $pidRef=$FHIRMedicationRequest->getSubject()->getReference()->getValue();
        if (strpos($pidRef, self::PATIENT_URI) !== false ) {
            $dbObservation['pid']= (!empty($pidRef)) ? substr($pidRef,strlen(self::PATIENT_URI),20) : null;
        }else{
            $dbObservation['pid']=null;
        }

        $userRef=$FHIRMedicationRequest->getPerformer()[0]->getReference()->getValue();
        if (strpos($userRef, self::PRACTITIONER_URI) !== false ) {
            $dbObservation['user']= (!empty($userRef)) ? substr($userRef,strlen(self::PRACTITIONER_URI),20) : null;
        }else{
            $dbObservation['user']=null;
        }

        $eidRef=$FHIRMedicationRequest->getEncounter()->getReference()->getValue();
        if (strpos($eidRef, self::ENCOUNTER_URI) !== false ) {
            $dbObservation['eid']= (!empty($eidRef)) ? substr($eidRef,strlen(self::ENCOUNTER_URI),20) : null;
        }else{
            $dbObservation['eid'] = null;
        }

        $dbObservation['activity'] =  $FHIRMedicationRequest->getStatus()->getValue();
        $dbObservation['note'] = $FHIRMedicationRequest->getNote()[0]->getText()->getValue();
        $dbObservation['category'] = $FHIRMedicationRequest->getCategory()[0]->getText()->getValue();

        $components=$FHIRMedicationRequest->getComponent();

        $LonicToDbMappig=$this->getLonicToDbMappig();

        foreach($components as $index => $comp){

            $code=$comp->getValueCodeableConcept()->getCoding()[0];
            $codeVal=$code->getCode()->getValue();
            if(!is_null($codeVal)){
                $system=$code->getSystem()->getValue();
                $lonicCode=substr($system, strrpos($system, '/') + 1);
                $dbObservation[$LonicToDbMappig[$lonicCode]]=$codeVal;
            }

            $Quantity=$comp->getValueQuantity()->getValue();
            $QuantityVal=$Quantity->getValue();
            if(!is_null($QuantityVal)){
                $lonicCode=$comp->getValueQuantity()->getCode()->getValue();
                $dbObservation[$LonicToDbMappig[$lonicCode]]=$QuantityVal;
            }
        }

        return $dbObservation;
    }

    /**
     * create FHIRMedicationRequest
     *
     * @param  string
     * @return array
     * @throws
     */


    public function parsedJsonToDb($parsedData)
    {
        $dbObservation = array();
        return $dbObservation;
    }

    public function validateDb($data){
        $flag =true;
        return $flag;
    }

    public function initFhirObject(){

        $FHIRMedicationRequest = new FHIRMedicationRequest();
        $FhirId = $this->createFHIRId(null);
        $FHIRMedicationRequest->setId($FhirId);

        $FHIRReference=  $this->createFHIRReference(["reference" => null]);

        $FHIRMedicationRequest->setSubject(deep_copy($FHIRReference));
        $FHIRMedicationRequest->setEncounter(deep_copy($FHIRReference));

        $FHIRDosage= $this->createFHIRDosage(array());
        $FHIRMedicationRequest->addDosageInstruction($FHIRDosage);


        $this->FHIRMedicationRequest=$FHIRMedicationRequest;
        return $FHIRMedicationRequest;

    }

    public function DBToFhir(...$params)
    {
        $observationDataFromDb = $params[0];
        $FHIRMedicationRequest =$this->FHIRMedicationRequest;

        if(!empty($observationDataFromDb)){

            $FHIRMedicationRequest->getId()->setValue($observationDataFromDb['id']);

        }

        $this->FHIRMedicationRequest=$FHIRMedicationRequest;

        return $FHIRMedicationRequest;
    }

    public function parsedJsonToFHIR($data)

    {
        $FHIRMedicationRequest =$this->FHIRMedicationRequest;


        $this->FHIRMedicationRequest=$FHIRMedicationRequest;

        return $FHIRMedicationRequest;
    }

    public function getDbDataFromRequest($data)
    {
        $this->initFhirObject();
        $this->arrayToFhirObject($this->FHIRMedicationRequest,$data);
        $dBdata = $this->fhirToDb($this->FHIRMedicationRequest);
        return $dBdata;
    }

    public function updateDbData($data,$id)
    {
        $listsOpenEmrTable = $this->container->get(ListsOpenEmrTable::class);
        $flag=$this->validateDb($data);
        if($flag){
            $primaryKey='id';
            $primaryKeyValue=$id;
            unset($data[$primaryKey]);
            $rez=$listsOpenEmrTable->safeUpdate($data,array($primaryKey=>$primaryKeyValue));
            if(is_array($rez)){
                $this->initFhirObject();
                $patient=$this->DBToFhir($rez);
                return $patient;
            }else{ //insert failed
                ErrorCodes::http_response_code('500','insert object failed :'.$rez);
            }
        }else{ // object is not valid
            ErrorCodes::http_response_code('406','object is not valid');
        }
        //this never happens since ErrorCodes call to exit()
        return false;
    }


    /**
     * create FHIRMedicationRequestStatus
     *
     * @param string
     *
     * @return FHIRMedicationRequestStatus | null
     */
    public function createFHIRMedicationRequestStatus($code=null){
        $FHIRMedicationRequestStatus= new FHIRMedicationRequestStatus;
        if(!is_null($code)) {
            $codeVal=$this->createFHIRCode($code)->getValue();
            $FHIRMedicationRequestStatus->setValue($codeVal);
        }
        return $FHIRMedicationRequestStatus;

    }


    /**
     * @param $data
     * @return FHIRDosage
     */

    public function createFHIRDosage($data){

        $FHIRDosage= new FHIRDosage;
        $FHIRCodeableConcept= $this->createFHIRCodeableConcept(array("code"=>null,"text"=>"","system"=>""));

        $dataNotEmpty=!(empty($data));

        if($dataNotEmpty && isset($data['dosagedoseandrate']) && $this->checkFHIRType($data['dosagedoseandrate'],'FHIRDosageDoseAndRate')){
            $FHIRDosage->addDoseAndRate($data['dosagedoseandrate']);
        }else{
            $FHIRDosageDoseAndRate=$this->createFHIRDosageDoseAndRate(array());
            $FHIRDosage->addDoseAndRate($FHIRDosageDoseAndRate);
        }


        if($dataNotEmpty && isset($data['timing']) && $this->checkFHIRType($data['timing'],'timing')){
            $FHIRDosage->setTiming($data['timing']);
        }else{
            $FHIRTiming=$this->createFHIRTiming(array());
            $FHIRDosage->setTiming($FHIRTiming);
        }

        if($dataNotEmpty && isset($data['maxdoseperadministration']) && $this->checkFHIRType($data['maxdoseperadministration'],'FHIRQuantity')){
            $FHIRDosage->setMaxDosePerAdministration($data['maxdoseperadministration']);
        }else{
            $FHIRQuantity=$this->createFHIRQuantity(array());
            $FHIRDosage->setMaxDosePerAdministration($FHIRQuantity);
        }

        if($dataNotEmpty && isset($data['site']) && $this->checkFHIRType($data['site'],'FHIRCodeableConcept')){
            $FHIRDosage->setSite($data['site']);
        }else{
            $FHIRDosage->setSite(deep_copy($FHIRCodeableConcept));
        }

        if($dataNotEmpty && isset($data['method']) && $this->checkFHIRType($data['method'],'FHIRCodeableConcept')){
            $FHIRDosage->setMethod($data['method']);
        }else{
            $FHIRDosage->setMethod(deep_copy($FHIRCodeableConcept));
        }

        if($dataNotEmpty && isset($data['rote']) && $this->checkFHIRType($data['route'],'FHIRCodeableConcept')){
            $FHIRDosage->setRoute($data['rote']);
        }else{
            $FHIRDosage->setRoute(deep_copy($FHIRCodeableConcept));
        }

        return $FHIRDosage;
    }



    /**
     * @param $data
     * @return FHIRDosageDoseAndRate
     */

    public function createFHIRDosageDoseAndRate($data){

        $FHIRDosageDoseAndRate= new FHIRDosageDoseAndRate;


        if(is_array($data['quantity'])){
            $FHIRQuantity=$this->createFHIRQuantity($data['quantity']);
        }else{
            $FHIRQuantity=$this->createFHIRQuantity(array());
        }
        $FHIRDosageDoseAndRate->setDoseQuantity($FHIRQuantity);


        if(is_array($data['quantity'])){
            $FHIRCodeableConcept=$this->createFHIRCodeableConcept($data['type']);
        }else{
            $FHIRCodeableConcept=$this->createFHIRCodeableConcept(array("code"=>null,"text"=>"","system"=>""));
        }

        $FHIRDosageDoseAndRate->setType($FHIRCodeableConcept);


        return $FHIRDosageDoseAndRate;


    }



}








