/*******************************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/
package org.ofbiz.minilang.method.callops;

import java.io.Serializable;

import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilXml;
import org.ofbiz.base.util.string.FlexibleStringExpander;
import org.ofbiz.minilang.MiniLangValidate;
import org.ofbiz.minilang.method.MethodContext;
import org.w3c.dom.Element;

/**
 * Simple class to wrap messages that come either from a straight string or a properties file
 */
@SuppressWarnings("serial")
public final class FlexibleMessage implements Serializable {

    private final FlexibleStringExpander messageFse;
    private final String propertykey;
    private final String propertyResource;

    public FlexibleMessage(Element element, String defaultProperty) {
        if (element != null) {
            String message = UtilXml.elementValue(element);
            if (message != null) {
                messageFse = FlexibleStringExpander.getInstance(message);
                propertykey = null;
                propertyResource = null;
            } else {
                messageFse = null;
                propertykey = MiniLangValidate.checkAttribute(element.getAttribute("property"), defaultProperty);
                propertyResource = MiniLangValidate.checkAttribute(element.getAttribute("resource"), "DefaultMessages");
            }
        } else {
            messageFse = null;
            propertykey = defaultProperty;
            propertyResource = "DefaultMessages";
        }
    }

    public String getMessage(ClassLoader loader, MethodContext methodContext) {
        if (messageFse != null) {
            return messageFse.expandString(methodContext.getEnvMap());
        } else {
            // Scipio: FIXME?: These getMessage calls trim the string, so space delimiter is impossible...
            // but may not be safe to fix until further testing. Could change to getMessageNoTrim.
            return UtilProperties.getMessage(propertyResource, propertykey, methodContext.getEnvMap(), methodContext.getLocale());
        }
    }
}
