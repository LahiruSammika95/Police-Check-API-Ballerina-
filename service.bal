import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/http;
import ballerina/sql;

configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string database = ?;

type Person record {|
    string nic;
    string firstName;
    string lastName;
    string address;
    string dob;
    string telno;

|};

type CrimeRecord record {|
    int crimeRecordID;
    string crimeRecord;
    string nic;

|};

// type isValid record {
//     boolean valid;
// };

final mysql:Client mysqlEndpoint = check new (host = host, user = user, password = password, database = database);

service /api on new http:Listener(9090) {

    // isolated resource function get personDetails(string nic) returns isValid|error? {

    //     Person|error queryRowResponse = mysqlEndpoint->queryRow(`select * from peopleRecords where nic=${nic}`);
    //     if queryRowResponse is error {
    //         isValid result = {
    //             valid: false
    //         };
    //         return result;
    //     }
    //     if queryRowResponse is Person {
    //         isValid result = {
    //             valid: true
    //         };
    //         return result;
    //     }

    // }

    isolated resource function get personCrimeRecords(string nic) returns json|error? {

        sql:ParameterizedQuery selectQuery = `select * from crimeRecords where nic=${nic}`;
        stream<CrimeRecord, sql:Error?> resultStream = mysqlEndpoint->query(selectQuery);
        CrimeRecord[] crimeRecords = [];

        check from CrimeRecord crimeRecord in resultStream
            do {
                crimeRecords.push(crimeRecord);
            };
        return crimeRecords;

    }

}
