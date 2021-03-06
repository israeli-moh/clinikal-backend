<?php
/* +-----------------------------------------------------------------------------+
*    OpenEMR - Open Source Electronic Medical Record
*    Copyright (C) 2013 Z&H Consultancy Services Private Limited <sam@zhservices.com>
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU Affero General Public License as
*    published by the Free Software Foundation, either version 3 of the
*    License, or (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU Affero General Public License for more details.
*
*    You should have received a copy of the GNU Affero General Public License
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*    @author  Basil PT <basil@zhservices.com>
* +------------------------------------------------------------------------------+
*/
namespace Inheritance\Plugin;

use Laminas\Mvc\Controller\Plugin\AbstractPlugin;
use Application\Model\ApplicationTable;




class Transactionwrapper extends AbstractPlugin
{

    public static function wrap($sql){
        $Transaction = "SET autocommit=0; START TRANSACTION;SET NAMES 'utf8';";
        $Transaction .= $sql;
        $Transaction .= "COMMIT; SET autocommit=1;";

        return $Transaction;
    }







}

