// import ballerina/sql;
import ballerinax/java.jdbc;
import ballerina/sql;

public isolated client class Client {
    final jdbc:Client dbClient;

    public isolated function init(ConnectionConfig con) returns error?{
        self.dbClient = check new(con.url, con?.user, con?.password, con?.options, con?.connectionPool);
    }

    remote isolated function query(QueryDetails queryDetails) returns json & readonly|error {
        record{}[] results = [];
        stream <record{}, sql:Error?> resultStream = self.dbClient->query(queryDetails.queryString);        
        boolean hasNext = false;
        int count = 0;
        int startIndex = queryDetails.offset;
        int endIndex = queryDetails.'limit + queryDetails.offset;

        while count < endIndex {
            if (count < startIndex) {
                record {}|sql:Error? next = resultStream.next();
                count = count + 1;
                continue;
            }

            record {| record {| anydata...; |} value; |}? next = check resultStream.next();
            if next is record {| record {| anydata...; |} value; |} {
                results.push(next.value);
                count = count + 1;
            } else {
                break;
            }
        }
        return results.toJson().cloneReadOnly();
    }

    remote isolated function close() returns error?{
        check self.dbClient.close();
    }
}




