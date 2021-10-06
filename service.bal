import ballerina/http;

configurable int port = 8090;

listener http:Listener serviceListener = new (port);

isolated service /connectors on serviceListener {
    final Router router = new;
    
    isolated resource function get connections() {

    }

    isolated resource function post testConnection(@http:Payload ConnectionConfig payload) returns error? {
        return self.router.testConnection(payload);
    }

    isolated resource function post connect(@http:Payload ConnectionConfig payload) returns error? {
        return self.router.connect(payload);
    }

    isolated resource function post query(@http:Payload QueryDetails payload) returns json|error? {
        return self.router.query(payload);
    }

    isolated resource function get disconnect() returns error?{
        return self.router.close();
    }
}
