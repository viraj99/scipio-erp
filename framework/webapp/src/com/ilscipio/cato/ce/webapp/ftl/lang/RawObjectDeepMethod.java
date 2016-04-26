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
package com.ilscipio.cato.ce.webapp.ftl.lang;

import java.util.List;

import com.ilscipio.cato.ce.webapp.ftl.CommonFtlUtil;

import freemarker.core.Environment;
import freemarker.template.ObjectWrapper;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateModelException;

/**
 * Cato: RawObjectDeepMethod - Deep-unwraps an object, bypassing escaping
 */
public class RawObjectDeepMethod implements TemplateMethodModelEx {

    public static final String module = RawObjectDeepMethod.class.getName();

    /*
     * @see freemarker.template.TemplateMethodModel#exec(java.util.List)
     */
    @SuppressWarnings("unchecked")
    @Override
    public Object exec(List args) throws TemplateModelException {
        if (args == null || args.size() != 1) {
            throw new TemplateModelException("Invalid number of arguments (expected: 1)");
        }
        Environment env = CommonFtlUtil.getCurrentEnvironment();
        TemplateModel object = (TemplateModel) args.get(0);
        
        Object unwrapped = LangFtlUtil.unwrapAlways(object);
        
        // Return non-escaping wrapper so we get raw values
        ObjectWrapper objectWrapper = LangFtlUtil.getNonEscapingObjectWrapper(env);
        return LangFtlUtil.wrap(unwrapped, objectWrapper);
    }
    
}