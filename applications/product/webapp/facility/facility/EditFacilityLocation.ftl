<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#assign menuContent>
  <@menu type="section" inlineItems=true>
  <#if facilityId?? && locationSeqId??>
    <@menuitem type="link" href=makeOfbizUrl("EditFacility") text="${uiLabelMap.ProductNewFacility}" />
    <@menuitem type="link" href=makeOfbizUrl("EditFacilityLocation?facilityId=${facilityId!}") text="${uiLabelMap.ProductNewFacilityLocation}" />
    <@menuitem type="link" href=makeOfbizUrl("EditInventoryItem?facilityId=${facilityId}&amp;locationSeqId=${locationSeqId}") text="${uiLabelMap.ProductNewInventoryItem}" />
    <#assign latestGeoPoint= Static["org.ofbiz.common.geo.GeoWorker"].findLatestGeoPoint(delegator, "FacilityLocationAndGeoPoint", "facilityId", facilityId, "locationSeqId", locationSeqId)!/>
    <#if latestGeoPoint?has_content>
      <@menuitem type="link" href=makeOfbizUrl("FacilityLocationGeoLocation?facilityId=${facilityId}&amp;locationSeqId=${locationSeqId}") text="${uiLabelMap.CommonGeoLocation}" />
    </#if>
  </#if>
  </@menu>
</#assign>
<@section menuContent=menuContent>

<#if facilityId?? && !(facilityLocation??)>
  <form action="<@ofbizUrl>CreateFacilityLocation</@ofbizUrl>" method="post">
    <input type="hidden" name="facilityId" value="${facilityId}" />
<#elseif facilityLocation??>
  <form action="<@ofbizUrl>UpdateFacilityLocation</@ofbizUrl>" method="post">
    <input type="hidden" name="facilityId" value="${facilityId!}" />
    <input type="hidden" name="locationSeqId" value="${locationSeqId}" />
<#else>
    <@alert type="error">${uiLabelMap.ProductNotCreateLocationFacilityId}</@alert>
</#if>

<#if facilityId?? || facilityLocation??>

<#if facilityLocation??>
    <@field type="generic" label="${uiLabelMap.ProductFacilityId}">
        ${facilityId!}
    </@field>
    <@field type="generic" label="${uiLabelMap.ProductLocationSeqId}">
        ${locationSeqId}
    </@field>
</#if>

    <@field type="generic" label="${uiLabelMap.ProductType}">
        <select name="locationTypeEnumId">
                <#if (facilityLocation.locationTypeEnumId)?has_content>
                    <#assign locationTypeEnum = facilityLocation.getRelatedOne("TypeEnumeration", true)!>
                    <option value="${facilityLocation.locationTypeEnumId}">${(locationTypeEnum.get("description",locale))?default(facilityLocation.locationTypeEnumId)}</option>
                    <option value="${facilityLocation.locationTypeEnumId}">----</option>
                </#if>
                <#list locationTypeEnums as locationTypeEnum>
                    <option value="${locationTypeEnum.enumId}">${locationTypeEnum.get("description",locale)}</option>
                </#list>
            </select>
    </@field>
    <@field type="generic" label="${uiLabelMap.CommonArea}">
        <input type="text" name="areaId" value="${(facilityLocation.areaId)!}" size="19" maxlength="20" />
    </@field>
    <@field type="generic" label="${uiLabelMap.ProductAisle}">
        <input type="text" name="aisleId" value="${(facilityLocation.aisleId)!}" size="19" maxlength="20" />
    </@field>
    <@field type="generic" label="${uiLabelMap.ProductSection}">
        <input type="text" name="sectionId" value="${(facilityLocation.sectionId)!}" size="19" maxlength="20" />
    </@field>
    <@field type="generic" label="${uiLabelMap.ProductLevel}">
        <input type="text" name="levelId" value="${(facilityLocation.levelId)!}" size="19" maxlength="20" />
    </@field>
    <@field type="generic" label="${uiLabelMap.ProductPosition}">
        <input type="text" name="positionId" value="${(facilityLocation.positionId)!}" size="19" maxlength="20" />
    </@field>
    <@field type="submitarea">
        <#if locationSeqId??>
          <input type="submit" value="${uiLabelMap.CommonUpdate}" />
        <#else>
          <input type="submit" value="${uiLabelMap.CommonSave}" />
        </#if>
    </@field>
  </form>
  
  <#if locationSeqId??>

  <#assign sectionTitle>${uiLabelMap.ProductLocationProduct}</#assign>
  <@section title=sectionTitle>
        <#-- ProductFacilityLocation stuff -->
        <@table type="data-list" class="+hover-bar" cellspacing="0"> <#-- orig: class="basic-table hover-bar" -->
        <@thead>
        <@tr class="header-row">
            <@th>${uiLabelMap.ProductProduct}</@th>
            <@th>${uiLabelMap.ProductMinimumStockAndMoveQuantity}</@th>
        </@tr>
        </@thead>
        <#list productFacilityLocations! as productFacilityLocation>
            <#assign product = productFacilityLocation.getRelatedOne("Product", false)!>
            <@tr>
                <@td><#if product??>${(product.internalName)!}</#if>[${productFacilityLocation.productId}]</@td>
                <@td>
                    <form method="post" action="<@ofbizUrl>updateProductFacilityLocation</@ofbizUrl>" id="lineForm${productFacilityLocation_index}">
                        <input type="hidden" name="productId" value="${(productFacilityLocation.productId)!}"/>
                        <input type="hidden" name="facilityId" value="${(productFacilityLocation.facilityId)!}"/>
                        <input type="hidden" name="locationSeqId" value="${(productFacilityLocation.locationSeqId)!}"/>
                        <input type="text" size="10" name="minimumStock" value="${(productFacilityLocation.minimumStock)!}"/>
                        <input type="text" size="10" name="moveQuantity" value="${(productFacilityLocation.moveQuantity)!}"/>
                        <input type="submit" value="${uiLabelMap.CommonUpdate}"/>
                        <a href="javascript:document.getElementById('lineForm${productFacilityLocation_index}').action='<@ofbizUrl>deleteProductFacilityLocation</@ofbizUrl>';document.getElementById('lineForm${productFacilityLocation_index}').submit();" class="${styles.button_default!}">${uiLabelMap.CommonDelete}</a>
                    </form>
                </@td>
            </@tr>
        </#list>
        </@table>
  </@section>

  <#assign sectionTitle>${uiLabelMap.ProductAddProduct}</#assign>
  <@section title=sectionTitle>
        <form method="post" action="<@ofbizUrl>createProductFacilityLocation</@ofbizUrl>" name="createProductFacilityLocationForm">
            <input type="hidden" name="facilityId" value="${facilityId!}" />
            <input type="hidden" name="locationSeqId" value="${locationSeqId!}" />
            <input type="hidden" name="useValues" value="true" />
            <@field type="generic" label="${uiLabelMap.ProductProductId}"><input type="text" size="10" name="productId" /></@field>
            <@field type="generic" label="${uiLabelMap.ProductMinimumStock}"><input type="text" size="10" name="minimumStock" /></@field>
            <@field type="generic" label="${uiLabelMap.ProductMoveQuantity}"><input type="text" size="10" name="moveQuantity" /></@field>
            <@field type="submitarea"><input type="submit" value="${uiLabelMap.CommonAdd}" /></@field>
        </form>
  </@section>
  
  </#if>
  
</#if>

</@section>