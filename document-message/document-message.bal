import ballerina/http;
import ballerina/mime;

type CsvRequest record {|
    string org;
    string filename;
|};

type ZohoResponse record {|
    string status;
    string code;
    string message;
    record {|
        string file_id;
        string created_time;
    |} details;
|};

final http:Client zohoClient = check new ("http://content.zohoapis.com.balmock.io");

service /crm on new http:Listener(8080) {
    resource function post bulkUploadLeads(CsvRequest csvRequest) returns ZohoResponse|error {
        http:Request request = new;
        request.addHeader("X-CRM_ORG", csvRequest.org);
        request.addHeader("feature", "bulk-write");
        request.setFileAsPayload("./ftpincoming/" + csvRequest.filename, contentType = mime:MULTIPART_FORM_DATA);
        return zohoClient->/crm/v5/upload.post(request);
    }
}
