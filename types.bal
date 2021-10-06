import ballerina/sql;
import ballerinax/java.jdbc;

public type Error record {|
    string 'error;
    error? cause;
|};

public type ConnectionConfig record {|
    string url;
    string user?;
    string password?;
    jdbc:Options options?;
    sql:ConnectionPool connectionPool?;
|};

public type QueryDetails record {|
    string queryString;
    int 'limit = 200;
    int offset = 0;
|};

