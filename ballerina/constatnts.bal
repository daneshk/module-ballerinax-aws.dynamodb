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
public enum AttributeType {
    # String data type
    S,
    # Number data type
    N,
    # Binary data type
    B
}

# Key type for table and index schemas.
public enum KeyType {
    # Partition key (hash key)
    HASH,
    # Sort key (range key)
    RANGE
}

# Types of attribute projections for secondary indexes.
public enum ProjectionType {
    # Only the index and primary keys are projected
    KEYS_ONLY,
    # All of the item attributes are projected
    ALL,
    # Index and primary keys plus specified non-key attributes are projected
    INCLUDE,
    # All item attributes are projected except for specified attributes
    EXCLUDE
}

# Types of server-side encryption supported by DynamoDB.
public enum SSEType {
    # AES-256 encryption
    AES256,
    # AWS Key Management Service encryption
    KMS
}

# Information to include in stream records when items are modified.
public enum StreamViewType {
    # Item attributes as they appear after modification
    NEW_IMAGE,
    # Item attributes as they appeared before modification
    OLD_IMAGE,
    # Both new and old item attributes
    NEW_AND_OLD_IMAGES,
    # Only key attributes of the item
    KEYS_ONLY
}

# Billing mode for read and write throughput.
public enum BillingMode {
    # Provisioned throughput mode with specified capacity units
    PROVISIONED,
    # Pay-per-request billing for unpredictable workloads
    PAY_PER_REQUEST
}

# Current status of a global secondary index.
public enum IndexStatus {
    # Index is being created
    CREATING,
    # Index is being updated
    UPDATING,
    # Index is being deleted
    DELETING,
    # Index is ready for use
    ACTIVE
}

# Current status of a table replica in a global table.
public enum ReplicaStatus {
    # Replica is being created
    CREATING,
    # Replica creation failed
    CREATION_FAILED,
    # Replica is being updated
    UPDATING,
    # Replica is being deleted
    DELETING,
    # Replica is active and available
    ACTIVE,
    # Replica's region is disabled
    REGION_DISABLED,
    # Replica's encryption credentials are inaccessible
    INACCESSIBLE_ENCRYPTION_CREDENTIALS
}

# Status of server-side encryption or other table features.
public enum Status {
    # Feature is being enabled
    ENABLING,
    # Feature is enabled
    ENABLED,
    # Feature is being disabled
    DISABLING,
    # Feature is disabled
    DISABLED,
    # Feature is being updated
    UPDATING
}

# Current status of a DynamoDB table.
public enum TableStatus {
    # Table is being created
    CREATING,
    # Table is being updated
    UPDATING,
    # Table is being deleted
    DELETING,
    # Table is active and available
    ACTIVE,
    # Table's encryption credentials are inaccessible
    INACCESSIBLE_ENCRYPTION_CREDENTIALS,
    # Table is being archived
    ARCHIVING,
    # Table has been archived
    ARCHIVED
}

# Comparison operators for query and scan filter conditions.
public enum ComparisonOperator {
    # Equal to
    EQ,
    # Not equal to
    NE,
    # Matches any value in a list
    IN,
    # Less than or equal to
    LE,
    # Less than
    LT,
    # Greater than or equal to
    GE,
    # Greater than
    GT,
    # Value is between two bounds
    BETWEEN,
    # Attribute exists and is not null
    NOT_NULL,
    # Attribute does not exist or is null
    NULL,
    # String or set contains a substring or element
    CONTAINS,
    # String or set does not contain a substring or element
    NOT_CONTAINS,
    # String begins with a substring
    BEGINS_WITH
}

# Logical operator to combine multiple conditions in filter or key expressions.
public enum ConditionalOperator {
    # All conditions must be true
    AND,
    # At least one condition must be true
    OR
}

# Level of detail for provisioned throughput consumption metrics in responses.
public enum ReturnConsumedCapacity {
    # Return consumption for table and indexes
    INDEXES,
    # Return total consumption across all table and indexes
    TOTAL,
    # Do not return consumption metrics
    NONE
}

# Whether to return item collection size metrics in write operation responses.
public enum ReturnItemCollectionMetrics {
    # Return item collection size metrics
    SIZE,
    # Do not return item collection metrics
    NONE
}

# Which item attributes to return in write operation responses.
public enum ReturnValues {
    # Return no attributes
    NONE,
    # Return all attributes as they were before the operation
    ALL_OLD,
    # Return only updated attributes as they were before the operation
    UPDATED_OLD,
    # Return all attributes as they are after the operation
    ALL_NEW,
    # Return only updated attributes as they are after the operation
    UPDATED_NEW
}

# Actions to perform when updating item attributes.
public enum Action {
    # Add a value to a number attribute or add an element to a set
    ADD,
    # Set or replace an attribute value
    PUT,
    # Delete an attribute or remove an element from a set
    DELETE
}

# Which attributes to return in query or scan results.
public enum Select {
    # Return all attributes
    ALL_ATTRIBUTES,
    # Return all attributes projected into the index
    ALL_PROJECTED_ATTRIBUTES,
    # Return only specified attributes
    SPECIFIC_ATTRIBUTES,
    # Return only the count of matching items
    COUNT
}

# Status of a DynamoDB stream.
public enum StreamStatus {
    # Stream is being enabled
    ENABLING,
    # Stream is enabled
    ENABLED,
    # Stream is being disabled
    DISABLING,
    # Stream is disabled
    DISABLED
}

# Type of modification event in a DynamoDB stream.
public enum eventName {
    # New item was inserted
    INSERT,
    # Existing item was modified
    MODIFY,
    # Item was removed
    REMOVE
}

# Starting position for reading from a DynamoDB stream shard.
public enum ShardIteratorType {
    # Start at the oldest untrimmed record in the shard. Stream records older than 24 hours
    # are subject to removal (trimming)
    TRIM_HORIZON,
    # Start just after the most recent stream record to always read the latest data
    LATEST,
    # Start at the exact position of a specific sequence number
    AT_SEQUENCE_NUMBER,
    # Start immediately after a specific sequence number
    AFTER_SEQUENCE_NUMBER
}

# Status of Time to Live feature for automatic item expiration.
public enum TimeToLiveStatus {
    # TTL is being enabled
    ENABLING,
    # TTL is being disabled
    DISABLING,
    # TTL is enabled
    ENABLED,
    # TTL is disabled
    DISABLED
}
