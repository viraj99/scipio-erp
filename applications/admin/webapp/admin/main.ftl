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
<#assign color = 0/>

<@grid type="tiles">
<#list allApps as display>
    <#assign thisApp = display.getContextRoot()>
        <#assign servletPath = Static["org.ofbiz.webapp.WebAppUtil"].getControlServletPath(display)>
        <#assign thisURL = StringUtil.wrapString(servletPath)>
        <#if thisApp != "/">
          <#assign thisURL = thisURL + "main">
        </#if>
        <#assign tileIcon ="${getLabel('AdminTileIcon'+display.name)!}"/>
        <#assign tileBackground = "${getLabel('AdminTileBackground'+display.name)!}"/>
        <@tile size="large" color=color title="${display.title}" link="${thisURL!}?${StringUtil.wrapString(externalKeyParam)!}" icon="${tileIcon!}" image="${tileBackground!}"><#rt>
            <#if getLabel(display.description)?has_content && uiLabelMap[display.description]!=uiLabelMap[display.title]>${getLabel(display.description)}</#if><#t>
        </@tile><#lt>
        <#if color+1 gt 8>
            <#assign color = 0/>
        <#else>
             <#assign color = color+1/>
        </#if>
</#list>
</@grid> 