// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerinax/health.hl7v2 as hl7;

final string msg = "MSH|^~\\&|ADT1|GOOD HEALTH HOSPITAL|GHH LAB, INC.|GOOD HEALTH HOSPITAL|" +
"198808181126|SECURITY|ADT^A01^ADT_A01|MSG00001|P|2.7.1||\rEVN|A01|200708181123||" +
"\rPID|1||PATID1234^5^M11^ADT1^MR^GOOD HEALTH HOSPITAL~123456789^^^USSSA^SS||" +
"BATMAN^ADAM^A^III||19610615|M||C|2222 HOME STREET^^GREENSBORO^NC^27401-1020|GL|" +
"(555) 555-2004|(555)555-2004||S||PATID12345001^2^M10^ADT1^AN^A|444333333|987654^NC|" +
"\rNK1|1|NUCLEAR^NELDA^W|SPO^SPOUSE||||NK^NEXT OF KIN$\rPV1|1|I|2000^2012^01||||" +
"004777^ATTEND^AARON^A|||SUR||||ADM|A0|";

@test:Config {}
function parseHl7Message() {
    hl7:Message|hl7:HL7Error parseResult = hl7:parse(msg);
    if parseResult is hl7:Message {
        test:assertEquals(parseResult.name, "ADT_A01", "Parsing issue occurred with the message");
    } 
}

@test:Config {}
function testEncodeHl7Message() returns error? {
    ORU_R01 oru_r01 = {
        msh: {
            msh3: {hd1: "ADT1"},
            msh4: {hd1: "MCM"},
            msh5: {hd1: "LABADT"},
            msh6: {hd1: "MCM"},
            msh8: "SECURITY",
            msh9: {msg1: "ORU", msg2: "R01"},
            msh10: "MSG00001",
            msh11: {pt1: "P"},
            msh12: {
                vid1: "2.7.1"
            }
        }
    };
    byte[] encodedQRYA19 = check hl7:encode(VERSION, oru_r01);
    test:assertEquals(encodedQRYA19[0], hl7:HL7_MSG_START_BLOCK, "HL7 Message start block is not correct");
}