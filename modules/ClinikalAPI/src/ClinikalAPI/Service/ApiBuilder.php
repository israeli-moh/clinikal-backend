<?php
/**
 * Date: 05/01/20
 * @author  Eyal Wolanowski <eyal.wolanowski@gmail.com>
 * This class creates acl filtered default/api calls array
 */

namespace ClinikalAPI\Service;

use Exception;
use GenericTools\Model\LangLanguagesTable;
use OpenEMR\Common\Acl\AclMain;
use PHPUnit\Framework\Assert;
use RestConfig;
use ClinikalAPI\Model\TranslationTables;
use OpenEMR\RestControllers\AuthRestController;
use ClinikalAPI\Service\Settings;
use Interop\Container\ContainerInterface;
use FhirAPI\Service\FhirApiBuilder;
use GenericTools\Model\ListsTable;
use Laminas\Db\TableGateway\TableGateway;

class ApiBuilder
{
    private $adapter=null;
    private $container=null;

    CONST MOH_COUNTRY="moh country";
    CONST MOH_CITIES="mh_cities";
    CONST MOH_STREETS="mh_streets";
    CONST LIONIC_CODES="loinc_org";

    use LoadFormsService;
    use FormTemplatesService;
    use IndicatorSettingsService;
    use ManageTemplatesLettersService;

    public function __construct(ContainerInterface $container)
    {
          $this->container = $container;
          $this->adapter = $container->get('Laminas\Db\Adapter\Adapter');
    }


    /**
     * return array with all default/api calls
     * the array is filtered by acl
     *
     * @return array
     */
    public function getApi()
    {
        $langLanguagesTable= $this->container->get(LangLanguagesTable::class);
        $this->langParameter = $langLanguagesTable->getLanguageSettings();

        $extend_route_map = [
            "GET /api/translation/:lid" => function ($lid) {
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "general_settings");
                $transTable = new TranslationTables($this->adapter);
                return $transTable->getAllTranslationByLangId($lid);
            },
            "GET /api/settings/globals/:uname" => function ($uname) {
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "general_settings");
                return (new Settings($this->container))->getGlobalsSettings($uname);
            },
            "GET /api/settings/menu/:menu_name" => function ($menu_name) {
                $this->checkAcl("clinikal_api", "general_settings");
                return (new Settings($this->container))->getMenuSettings($menu_name);

            },
            "GET /api/lists/cities" => function () {
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "lists");
                $listsTable=$this->container->get(ListsTable::class);
                return $listsTable->getListNormalized(self::MOH_CITIES,null,null,null,false);
            },
            "GET /api/lists/streets/:city_id" => function ($city_id) {
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "lists");
                $listsTable=$this->container->get(ListsTable::class);
                return $listsTable->getListNormalized(self::MOH_STREETS,'notes',$city_id,null,null,false);
            },
            "GET /api/sse/patients-tracking/check-refresh/:facility_id" => function ($facility_id) {
                //exit php or return 401 if not authorized
                //$this->checkAcl("clinikal_api", "sse");
                return $this->patientsTrackingCheckRefresh($facility_id);
            },
            "GET /api/load-forms" => function () {
                $service_type=$_GET['service_type'];
                $reason_code=$_GET['reason_code'];
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "general_settings");
                return $this->loadForms($service_type,$reason_code);
            },
            "GET /api/templates/search" => function () {
                $service_type=$_GET['service-type'];
                $reason_code=$_GET['reason-code'];
                $form_id=$_GET['form'];
                $form_field=$_GET['form-field'];
                //exit php or return 401 if not authorized
                $this->checkAcl("clinikal_api", "general_settings");

                return $this->getTemplatesForForm($form_id,$form_field,$service_type,$reason_code);
            },
            "GET /api/indicator-settings" => function () {
                //exit php or return 401 if not authorized

                $this->checkAcl("clinikal_api", "general_settings");
                return $this->getIndicatorSettings(self::LIONIC_CODES);
            },
            "GET /api/letters/list" => function () {
                $this->checkAcl("clinikal_api", "general_settings");
                return $this->getLetterList();
            },
            "POST /api/letters/:letter_name" => function ($letter_name) {
                $this->checkAcl("clinikal_api", "general_settings");
                $fileData=null;
                if(Assert::isJson(file_get_contents('php://input'))){  // $_POST is empty here
                    $fileData=json_decode(file_get_contents('php://input'),true);
                }
                return $this->createLetter($letter_name,$fileData);
            },

        ];

        return $extend_route_map;
    }
}

