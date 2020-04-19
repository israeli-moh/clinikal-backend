<?php

namespace FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\ValueSet;

use FhirAPI\FhirRestApiBuilder\Parts\Restful;
use FhirAPI\FhirRestApiBuilder\Parts\Strategy\Strategy;
use FhirAPI\FhirRestApiBuilder\Parts\Strategy\StrategyElement\ValueSet\FhirValueSetMapping;
use GenericTools\Model\ValueSetsTable;

class ValueSet Extends Restful implements  Strategy
{
    public function __construct($params=null)
    {
        if(!is_null($params))
        {
            $this->initParams($params);
        }
    }

    private function initParams($initials){
        $this->setOperations($initials['paramsFromUrl']);
        $this->setParamsFromUrl($initials['paramsFromUrl']);
        $this->setParamsFromBody($initials['paramsFromBody']);
        $this->setContainer($initials['container']);
        $this->setMapping($initials['container']);
    }

    public function doAlgorithm($arrParams)
    {
        $this->initParams($arrParams);

        $this->functionName = $arrParams['type'];
        $function = Restful::$data[$arrParams['strategyName']][self::$function][$this->functionName];
        return $this->$function();
    }


    private function setMapping($container)
    {
        $this->mapping = new FhirValueSetMapping($container);
    }

    public function read()
    {
        $fhirValueSetMapping =$this->mapping;
        $valueSetsTable = $this->container->get(ValueSetsTable::class);
        $ValueSetDataFromDb = $valueSetsTable->getValueSetById($this->paramsFromUrl[0]);
        if(!$ValueSetDataFromDb)
        {
            //not found
            return self::$errorCodes::http_response_code(204);
        }
        // pass codes, value set id, and operations, to method
        return $fhirValueSetMapping->DBToFhir($ValueSetDataFromDb, $this->operations);
    }
}
