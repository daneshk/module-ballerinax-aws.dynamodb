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

const string AWS_HOST = "amazonaws.com";
const string AWS_SERVICE = "dynamodb";
const string VERSION = "DynamoDB_20120810";

const string UTF_8 = "UTF-8";
const string HOST = "host";
const string CONTENT_TYPE = "content-type";
const string APPLICATION_JSON = "application/json";
const string X_AMZ_DATE = "x-amz-date";
const string X_AMZ_TARGET = "x-amz-target";
const string AWS4_REQUEST = "aws4_request";
const string AWS4_HMAC_SHA256 = "AWS4-HMAC-SHA256";
const string CREDENTIAL = "Credential";
const string SIGNED_HEADER = "SignedHeaders";
const string SIGNATURE = "Signature";
const string AWS4 = "AWS4";
const string ISO8601_BASIC_DATE_FORMAT = "yyyyMMdd'T'HHmmss'Z'";
const string SHORT_DATE_FORMAT = "yyyyMMdd";
const string ENCODED_SLASH = "%2F";
const string SLASH = "/";
const string EMPTY_STRING = "";
const string NEW_LINE = "\n";
const string COLON = ":";
const string SEMICOLON = ";";
const string EQUAL = "=";
const string SPACE = " ";
const string COMMA = ",";
const string DOT = ".";
const string Z = "Z";

// HTTP.
const string POST = "POST";
const string HTTPS = "https://";

// Constants to refer the headers.
const string HEADER_CONTENT_TYPE = "Content-Type";
const string HEADER_X_AMZ_CONTENT_SHA256 = "X-Amz-Content-Sha256";
const string HEADER_X_AMZ_DATE = "X-Amz-Date";
const string HEADER_X_AMZ_TARGET = "X-Amz-Target";
const string HEADER_HOST = "Host";
const string HEADER_AUTHORIZATION = "Authorization";

const string GENERATE_SIGNED_REQUEST_HEADERS_FAILED_MSG = "Error occurred while generating signed request headers.";

# Attribute data types supported by DynamoDB.
# S - String data type
# N - Number data type
# B - Binary data type
public enum AttributeType {
    S, N, B
}

# Key type for table and index schemas.
# HASH - Partition key
# RANGE - Sort key
public enum KeyType {
    HASH, RANGE
}

# Types of attribute projections for secondary indexes.
# KEYS_ONLY - Only the index and primary keys are projected
# ALL - All of the item attributes are projected
# INCLUDE - Index and primary keys plus specified non-key attributes are projected
# EXCLUDE - All item attributes are projected except for specified attributes
public enum ProjectionType {
    KEYS_ONLY, ALL, INCLUDE, EXCLUDE
}

# Types of server-side encryption supported by DynamoDB.
# AES256 - AES-256 encryption
# KMS - AWS Key Management Service encryption
public enum SSEType {
    AES256, KMS
}

# Information to include in stream records when items are modified.
# NEW_IMAGE - Item attributes as they appear after modification
# OLD_IMAGE - Item attributes as they appeared before modification
# NEW_AND_OLD_IMAGES - Both new and old item attributes
# KEYS_ONLY - Only key attributes of the item
public enum StreamViewType {
    NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY
}

# Billing mode for read and write throughput.
# PROVISIONED - Provisioned throughput mode with specified capacity units
# PAY_PER_REQUEST - Pay-per-request billing for unpredictable workloads
public enum BillingMode {
    PROVISIONED, PAY_PER_REQUEST
}

# Current status of a global secondary index.
# CREATING - Index is being created
# UPDATING - Index is being updated
# DELETING - Index is being deleted
# ACTIVE - Index is ready for use
public enum IndexStatus {
    CREATING, UPDATING, DELETING, ACTIVE
}

# Current status of a table replica in a global table.
# CREATING - Replica is being created
# CREATION_FAILED - Replica creation failed
# UPDATING - Replica is being updated
# DELETING - Replica is being deleted
# ACTIVE - Replica is active and available
# REGION_DISABLED - Replica's region is disabled
# INACCESSIBLE_ENCRYPTION_CREDENTIALS - Replica's encryption credentials are inaccessible
public enum ReplicaStatus {
    CREATING, CREATION_FAILED, UPDATING, DELETING, ACTIVE, REGION_DISABLED, INACCESSIBLE_ENCRYPTION_CREDENTIALS
}

# Status of server-side encryption or other table features.
# ENABLING - Feature is being enabled
# ENABLED - Feature is enabled
# DISABLING - Feature is being disabled
# DISABLED - Feature is disabled
# UPDATING - Feature is being updated
public enum Status {
    ENABLING, ENABLED, DISABLING, DISABLED, UPDATING
}

# Current status of a DynamoDB table.
# CREATING - Table is being created
# UPDATING - Table is being updated
# DELETING - Table is being deleted
# ACTIVE - Table is active and available
# INACCESSIBLE_ENCRYPTION_CREDENTIALS - Table's encryption credentials are inaccessible
# ARCHIVING - Table is being archived
# ARCHIVED - Table has been archived
public enum TableStatus {
    CREATING, UPDATING, DELETING, ACTIVE, INACCESSIBLE_ENCRYPTION_CREDENTIALS, ARCHIVING, ARCHIVED
}

# Comparison operators for query and scan filter conditions.
# EQ - Equal to
# NE - Not equal to
# IN - Matches any value in a list
# LE - Less than or equal to
# LT - Less than
# GE - Greater than or equal to
# GT - Greater than
# BETWEEN - Value is between two bounds
# NOT_NULL - Attribute exists and is not null
# NULL - Attribute does not exist or is null
# CONTAINS - String or set contains a substring or element
# NOT_CONTAINS - String or set does not contain a substring or element
# BEGINS_WITH - String begins with a substring
public enum ComparisonOperator {
    EQ, NE, IN, LE, LT, GE, GT, BETWEEN, NOT_NULL, NULL, CONTAINS, NOT_CONTAINS, BEGINS_WITH
}

# Logical operator to combine multiple conditions in filter or key expressions.
# AND - All conditions must be true
# OR - At least one condition must be true
public enum ConditionalOperator {
    AND, OR
}

# Level of detail for provisioned throughput consumption metrics in responses.
# INDEXES - Return consumption for table and indexes
# TOTAL - Return total consumption across all table and indexes
# NONE - Do not return consumption metrics
public enum ReturnConsumedCapacity {
    INDEXES, TOTAL, NONE
}

# Whether to return item collection size metrics in write operation responses.
# SIZE - Return item collection size metrics
# NONE - Do not return item collection metrics
public enum ReturnItemCollectionMetrics {
    SIZE, NONE
}

# Which item attributes to return in write operation responses.
# NONE - Return no attributes
# ALL_OLD - Return all attributes as they were before the operation
# UPDATED_OLD - Return only updated attributes as they were before the operation
# ALL_NEW - Return all attributes as they are after the operation
# UPDATED_NEW - Return only updated attributes as they are after the operation
public enum ReturnValues {
    NONE, ALL_OLD, UPDATED_OLD, ALL_NEW, UPDATED_NEW
}

# Actions to perform when updating item attributes.
# ADD - Add a value to a number attribute or add an element to a set
# PUT - Set or replace an attribute value
# DELETE - Delete an attribute or remove an element from a set
public enum Action {
    ADD, PUT, DELETE
}

# Which attributes to return in query or scan results.
# ALL_ATTRIBUTES - Return all attributes
# ALL_PROJECTED_ATTRIBUTES - Return all attributes projected into the index
# SPECIFIC_ATTRIBUTES - Return only specified attributes
# COUNT - Return only the count of matching items
public enum Select {
    ALL_ATTRIBUTES, ALL_PROJECTED_ATTRIBUTES, SPECIFIC_ATTRIBUTES, COUNT
}

# Status of a DynamoDB stream.
# ENABLING - Stream is being enabled
# ENABLED - Stream is enabled
# DISABLING - Stream is being disabled
# DISABLED - Stream is disabled
public enum StreamStatus {
    ENABLING, ENABLED, DISABLING, DISABLED
}

# Type of modification event in a DynamoDB stream.
# INSERT - New item was inserted
# MODIFY - Existing item was modified
# REMOVE - Item was removed
public enum eventName {
    INSERT, MODIFY, REMOVE
}

# Starting position for reading from a DynamoDB stream shard.
# TRIM_HORIZON - Start at the oldest untrimmed record (stream records older than 24 hours are subject to removal)
# LATEST - Start just after the most recent stream record to always read the latest data
# AT_SEQUENCE_NUMBER - Start at the exact position of a specific sequence number
# AFTER_SEQUENCE_NUMBER - Start immediately after a specific sequence number
public enum ShardIteratorType {
    TRIM_HORIZON, LATEST, AT_SEQUENCE_NUMBER, AFTER_SEQUENCE_NUMBER
}

# Status of Time to Live feature for automatic item expiration.
# ENABLING - TTL is being enabled
# DISABLING - TTL is being disabled
# ENABLED - TTL is enabled
# DISABLED - TTL is disabled
public enum TimeToLiveStatus {
    ENABLING, DISABLING, ENABLED, DISABLED
}
