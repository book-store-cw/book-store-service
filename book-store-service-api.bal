import ballerina/http;
import ballerina/log;
import ballerina/os;

final string shippingServiceUrl = os:getEnv("SHIPPING_SERVICE_URL");
final string paymentServiceUrl = os:getEnv("PAYMENT_SERVICE_URL");
final string catalogServiceUrl = os:getEnv("CATALOG_SERVICE_URL");

service / on new http:Listener(9093) {

    resource function get shippingDetails(http:Caller caller, http:Request req) returns error? {
        http:Client shippingService = check new (shippingServiceUrl);

        http:Response shippingServiceResponse = <http:Response>check shippingService->get("/sayHello");

        json|error responseData = shippingServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from shipping service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            var result = caller->respond("Shipping Details: " + responseData.toString());

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }

    }

    resource function get paymentDetails(http:Caller caller, http:Request req) returns error? {
        http:Client paymentService = check new (paymentServiceUrl);

        http:Response paymentServiceResponse = <http:Response>check paymentService->get("/sayHello");
        
        json|error responseData = paymentServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from payment service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            var result = caller->respond("Payment Details: " + responseData.toString());

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }

    }

    resource function get catalogDetails(http:Caller caller, http:Request req) returns error? {
        http:Client catalogService = check new (catalogServiceUrl);

        http:Response catalogServiceResponse = <http:Response>check catalogService->get("/");
        
        json|error responseData = catalogServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from catalog service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            var result = caller->respond("Catalog Details: " + responseData.toString());

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }

    }
}
