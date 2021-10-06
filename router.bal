import ballerinax/java.jdbc;

public isolated class Router {
    private  Client? dbClient = ();

    isolated function testConnection(ConnectionConfig config) returns error? {
        jdbc:Client dbClient = check new(config.url, config?.user, config?.password, config?.options, config?.connectionPool);
    }

    isolated function connect(ConnectionConfig config) returns error? {
        lock {
            self.dbClient = check new Client(config.cloneReadOnly());
            // need to handle errors. Only returns 500 in failure 
        }
    }
    isolated function query(QueryDetails queryDetails) returns json & readonly|error{
        lock {
            if (self.dbClient is Client) {
                Client dbManager = <Client>self.dbClient;
                return dbManager->query(queryDetails.cloneReadOnly());
            } else {
                return error("Please connect to the database first");
            }
        }        
    }

    isolated function close() returns error? {
        lock {
            if (self.dbClient is Client) {
                Client dbManager = <Client>self.dbClient;
                return dbManager->close();
            } 
        }
    }
}