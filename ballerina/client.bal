// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerinax/'client.config;

# Client for Amazon DynamoDB, enabling table and item management operations.
# Supports creating, reading, updating, and deleting tables and items, as well as querying, scanning,
# and batch operations on DynamoDB tables.
#
@display {label: "Amazon DynamoDB", iconPath: "icon.png"}
public isolated client class Client {
    private final http:Client awsDynamoDb;
    private final string accessKeyId;
    private final string secretAccessKey;
    private final string? securityToken;
    private final string region;
    private final string awsHost;
    private final string uri = SLASH;

    # Initializes the connector. During initialization you have to pass access key id, secret access key, and region.
    # Create an AWS account and obtain tokens following
    # [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html).
    #
    # + awsDynamoDBConfig - Configuration required to initialize the client
    # + httpConfig - HTTP configuration
    # + return - An error on failure of initialization or else `()`
    public isolated function init(ConnectionConfig config) returns error? {
        self.accessKeyId = config.awsCredentials.accessKeyId;
        self.secretAccessKey = config.awsCredentials.secretAccessKey;
        self.securityToken = config.awsCredentials?.securityToken;
        self.region = config.region;
        self.awsHost = AWS_SERVICE + DOT + self.region + DOT + AWS_HOST;
        string endpoint = HTTPS + self.awsHost;

        http:ClientConfiguration httpClientConfig = check config:constructHTTPClientConfig(config);
        self.awsDynamoDb = check new (endpoint, httpClientConfig);
    }

    # Creates a new table in the AWS account. Table names must be unique within each region.
    #
    # + tableCreationInput - Table creation configuration including name, key schema, and attributes
    # + return - Table description if successful, or else an error
    remote isolated function createTable(TableCreateInput tableCreationInput) returns TableDescription|error {
        string target = VERSION + DOT + "CreateTable";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, tableCreationInput.toJson());
        map<json> response = check self.awsDynamoDb->post(self.uri, tableCreationInput, signedRequestHeaders);
        json tableDescription = check response.TableDescription;
        return tableDescription.fromJsonWithType();
    }

    # Deletes an existing table and all of its items.
    #
    # + tableName - Name of the table to delete
    # + return - Table description if successful, or else an error
    remote isolated function deleteTable(string tableName) returns TableDescription|error {
        string target = VERSION + DOT + "DeleteTable";
        json payload = {
            "TableName": tableName
        };

        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, payload);
        json response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        json tableDescription = check response.TableDescription;
        return tableDescription.fromJsonWithType();
    }

    # Retrieves information about a table including schema, provisioned throughput, and status.
    #
    # + tableName - Name of the table to describe
    # + return - Table description if successful, or else an error
    remote isolated function describeTable(string tableName) returns TableDescription|error {
        string target = VERSION + DOT + "DescribeTable";
        json payload = {
            "TableName": tableName
        };

        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, payload);
        json response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        json 'table = check response.Table;
        return 'table.fromJsonWithType();
    }

    # Retrieves a list of all table names in the current region.
    #
    # + return - Stream of table names if successful, or else an error
    remote isolated function listTables() returns stream<string, error?>|error {
        TableStream tableStream = check new TableStream(self.awsDynamoDb, self.awsHost, self.accessKeyId,
            self.secretAccessKey, self.region
        );
        return new stream<string, error?>(tableStream);
    }

    # Updates table settings such as provisioned throughput, global secondary indexes, or streams.
    #
    # + tableUpdateInput - Table update configuration
    # + return - Updated table description if successful, or else an error
    remote isolated function updateTable(TableUpdateInput tableUpdateInput) returns TableDescription|error {
        string target = VERSION + DOT + "UpdateTable";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, tableUpdateInput.toJson());
        json response = check self.awsDynamoDb->post(self.uri, tableUpdateInput, signedRequestHeaders);
        json tableDescription = check response.TableDescription;
        return tableDescription.fromJsonWithType();
    }

    # Creates a new item or replaces an existing item with the same primary key.
    # Supports conditional operations to prevent overwrites.
    #
    # + itemCreateInput - Item data and table name
    # + return - Item operation details if successful, or else an error
    remote isolated function createItem(ItemCreateInput itemCreateInput) returns ItemDescription|error {
        string target = VERSION + DOT + "PutItem";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, itemCreateInput.toJson());
        json response = check self.awsDynamoDb->post(self.uri, itemCreateInput, signedRequestHeaders);
        return response.fromJsonWithType();
    }

    # Retrieves a single item from a table by its primary key.
    #
    # + itemGetInput - Primary key and table name, with optional projection expression
    # + return - Item data if successful, or else an error
    remote isolated function getItem(ItemGetInput itemGetInput) returns ItemGetOutput|error {
        string target = VERSION + DOT + "GetItem";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, itemGetInput.toJson());
        json response = check self.awsDynamoDb->post(self.uri, itemGetInput, signedRequestHeaders);
        return response.fromJsonWithType();
    }

    # Deletes a single item from a table by its primary key.
    # Supports conditional deletes to prevent accidental deletions.
    #
    # + itemDeleteInput - Primary key, table name, and optional conditions
    # + return - Item operation details if successful, or else an error
    remote isolated function deleteItem(ItemDeleteInput itemDeleteInput) returns ItemDescription|error {
        string target = VERSION + DOT + "DeleteItem";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, itemDeleteInput.toJson());
        ItemDescription response = check self.awsDynamoDb->post(self.uri, itemDeleteInput, signedRequestHeaders);
        return response;
    }

    # Updates attributes of an existing item, or creates a new item if it doesn't exist.
    # Supports conditional updates and atomic counters.
    #
    # + itemUpdateInput - Primary key, table name, and update expressions
    # + return - Item operation details if successful, or else an error
    remote isolated function updateItem(ItemUpdateInput itemUpdateInput) returns ItemDescription|error {
        string target = VERSION + DOT + "UpdateItem";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, itemUpdateInput.toJson());
        json response = check self.awsDynamoDb->post(self.uri, itemUpdateInput, signedRequestHeaders);
        return response.fromJsonWithType();
    }

    # Finds items based on primary key values. Supports filtering, sorting, and pagination.
    # More efficient than scan for retrieving items with known partition key.
    #
    # + queryInput - Query parameters including table name, key conditions, and optional filters
    # + return - Stream of query results if successful, or else an error
    remote isolated function query(QueryInput queryInput) returns stream<QueryOutput, error?>|error {

        QueryStream queryStream = check new QueryStream(self.awsDynamoDb, self.awsHost, self.accessKeyId,
            self.secretAccessKey, self.region, queryInput
        );
        return new stream<QueryOutput, error?>(queryStream);
    }

    # Retrieves all items from a table or secondary index by examining every item.
    # Supports filtering and parallel scanning for large datasets.
    #
    # + scanInput - Scan parameters including table name and optional filter expressions
    # + return - Stream of scan results if successful, or else an error
    remote isolated function scan(ScanInput scanInput) returns stream<ScanOutput, error?>|error {

        ScanStream scanStream = check new ScanStream(self.awsDynamoDb, self.awsHost, self.accessKeyId,
            self.secretAccessKey, self.region, scanInput
        );
        return new stream<ScanOutput, error?>(scanStream);
    }

    # Retrieves multiple items from one or more tables in a single request.
    # More efficient than multiple individual get operations.
    #
    # + batchItemGetInput - Batch get parameters with table names and primary keys
    # + return - Stream of retrieved items if successful, or else an error
    remote isolated function getBatchItems(BatchItemGetInput batchItemGetInput) returns stream<BatchItem, error?>|error {
        ItemsBatchGetStream itemsBatchGetStream = check new ItemsBatchGetStream(self.awsDynamoDb, self.awsHost,
            self.accessKeyId, self.secretAccessKey,
            self.region, batchItemGetInput
        );
        return new stream<BatchItem, error?>(itemsBatchGetStream);
    }

    # Creates or deletes multiple items across one or more tables in a single request.
    # More efficient than multiple individual write operations.
    #
    # + batchItemInsertInput - Batch write parameters with put and delete requests
    # + return - Batch operation results if successful, or else an error
    remote isolated function writeBatchItems(BatchItemInsertInput batchItemInsertInput) returns BatchItemInsertOutput|error {
        string target = VERSION + DOT + "BatchWriteItem";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, batchItemInsertInput.toJson());
        json response = check self.awsDynamoDb->post(self.uri, batchItemInsertInput, signedRequestHeaders);
        return response.fromJsonWithType();
    }

    # Retrieves the current provisioned capacity limits for your AWS account in the region.
    # Includes both account-level and per-table capacity quotas.
    #
    # + return - Capacity limit information if successful, or else an error
    remote isolated function describeLimits() returns LimitDescription|error {
        string target = VERSION + DOT + "DescribeLimits";
        json payload = {};
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, payload);
        json response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response.fromJsonWithType();
    }

    # Creates an on-demand backup of a table for data protection and archival.
    #
    # + backupCreateInput - Backup configuration including table name and backup name
    # + return - Backup details if successful, or else an error
    remote isolated function createBackup(BackupCreateInput backupCreateInput) returns BackupDetails|error {
        string target = VERSION + DOT + "CreateBackup";
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, backupCreateInput);
        json response = check self.awsDynamoDb->post(self.uri, backupCreateInput, signedRequestHeaders);
        json backUpDetails = check response.BackupDetails;
        return backUpDetails.fromJsonWithType();
    }

    # Deletes an existing backup. The backup can no longer be used for restoration after deletion.
    #
    # + backupArn - Amazon Resource Name of the backup to delete
    # + return - Backup description if successful, or else an error
    remote isolated function deleteBackup(string backupArn) returns BackupDescription|error {
        string target = VERSION + DOT + "DeleteBackup";
        json payload = {
            "BackupArn": backupArn
        };
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                        self.secretAccessKey, self.region,
                                                                        POST, self.uri, target, payload);
        json response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        json backUpDetails = check response.BackupDescription;
        return backUpDetails.fromJsonWithType();
    }

    # Retrieves Time to Live settings for automatic item expiration on the table.
    #
    # + tableName - Name of the table
    # + return - TTL configuration details if successful, or else an error
    remote isolated function getTTL(string tableName) returns TTLDescription|error {
        string target = VERSION + DOT + "DescribeTimeToLive";
        json payload = {
            "TableName": tableName
        };
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                    self.secretAccessKey, self.region,
                                                                    POST, self.uri, target, payload);
        json timeToLiveResponse = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        json timeToLiveDescription = check timeToLiveResponse.TimeToLiveDescription;
        return timeToLiveDescription.fromJsonWithType();
    }
}
