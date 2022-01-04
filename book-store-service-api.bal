import ballerina/http;
import ballerina/log;
import ballerina/os;

final string paymentServiceUrl = os:getEnv("PAYMENT_SERVICE_URL");
final string catalogServiceUrl = os:getEnv("CATALOG_SERVICE_URL");

float paymentTotal = 0;

service / on new http:Listener(9093) {

    resource function get orderBook/[string bookId](http:Caller caller, http:Request req) returns error? {
        http:Client paymentService = check new (paymentServiceUrl);

        http:Response paymentServiceResponse = <http:Response>check paymentService->get("payment/purchaseBook/" + bookId);
        
        json|error responseData = paymentServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from payment service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            float price = <float>check responseData.price;
            paymentTotal = paymentTotal + price;
            var result = caller->respond("Book Order Details: " + responseData.toString());

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }

    }

    resource function get checkout/[string city](http:Caller caller, http:Request req) returns error? {
        http:Client paymentService = check new (paymentServiceUrl);

        http:Response paymentServiceResponse = <http:Response>check paymentService->get("payment/finalizePurchase/" + city);
        
        json|error responseData = paymentServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from payment service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            float shippingPrice = <float>check responseData.shippingPrice;
            paymentTotal = paymentTotal + shippingPrice;
            var result = caller->respond("Payment Details: RS " + paymentTotal.toString());

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }

    }

    resource function get listBooks(http:Caller caller, http:Request req) returns error? {
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
