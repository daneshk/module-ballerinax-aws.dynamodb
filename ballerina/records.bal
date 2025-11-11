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

import ballerinax/'client.config;

# Configuration for connecting to Amazon DynamoDB.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    *config:ConnectionConfig;
    # Auth credentials are ignored
    never auth?;
    # AWS credentials for authentication
    AwsCredentials|AwsTemporaryCredentials awsCredentials;
    # AWS region where DynamoDB tables are located
    string region;
|};

# AWS credentials for authentication.
#
# + accessKeyId - AWS access key ID
# + secretAccessKey - AWS secret access key
public type AwsCredentials record {
    string accessKeyId;
    @display {
        label: "",
        kind: "password"
    }
    string secretAccessKey;
};

# AWS temporary session credentials with security token.
public type AwsTemporaryCredentials record {
    # AWS access key ID
    string accessKeyId;
    # AWS secret access key
    @display {
        label: "",
        kind: "password"
    }
    string secretAccessKey;
    # AWS session token for temporary credentials
    @display {
        label: "",
        kind: "password"
    }
    string securityToken;
};

# Current provisioned capacity quotas for your AWS account in the region.
public type LimitDescription record {
    # Maximum total read capacity units allowed across all tables in this region
    int? AccountMaxReadCapacityUnits?;
    # Maximum total write capacity units allowed across all tables in this region
    int? AccountMaxWriteCapacityUnits?;
    # Maximum read capacity units allowed for a single new table in this region
    int? TableMaxReadCapacityUnits?;
    # Maximum write capacity units allowed for a single new table in this region, including capacity for global secondary indexes
    int? TableMaxWriteCapacityUnits?;
};

# Response from a batch write operation containing consumption metrics and unprocessed items.
public type BatchItemInsertOutput record {
    # Capacity units consumed by the entire batch write operation
    ConsumedCapacity[]? ConsumedCapacity?;
    # Information about item collections affected by the batch write, organized by table
    map<ItemCollectionMetrics[]>? ItemCollectionMetrics?;
    # Requests that were not processed and can be retried. Has the same structure as `RequestItems` in the input
    map<WriteRequest[]>? UnprocessedItems?;
};

# Input for batch write operations to create or delete multiple items across tables.
public type BatchItemInsertInput record {|
    # Map of table names to lists of put or delete requests
    map<WriteRequest[]> RequestItems;
    # Level of detail for provisioned throughput consumption in the response
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    # Whether to return item collection metrics in the response
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
|};

# Response from a batch get operation containing retrieved items and unprocessed keys.
type BatchGetItemsOutput record {
    # Read capacity units consumed by the entire batch get operation
    ConsumedCapacity[]? ConsumedCapacity?;
    # Retrieved items organized by table name
    map<map<AttributeValue>[]>? Responses?;
    # Keys that were not processed and can be retried. Has the same structure as `RequestItems` in the input
    map<KeysAndAttributes>? UnprocessedKeys?;
};

# Single item retrieved from a batch get operation with associated metadata.
public type BatchItem record {
    # Read capacity units consumed for this item
    ConsumedCapacity? ConsumedCapacity?;
    # Name of the table containing this item
    string? TableName?;
    # Retrieved item attributes
    map<AttributeValue>? Item?;
};

# Input for batch get operations to retrieve multiple items from one or more tables.
public type BatchItemGetInput record {|
    # Map of table names to the keys and attributes to retrieve
    map<KeysAndAttributes> RequestItems;
    # Level of detail for provisioned throughput consumption in the response
    ReturnConsumedCapacity ReturnConsumedCapacity?;
|};

# Input for scan operations to retrieve all items from a table or index.
public type ScanInput record {|
    # Name of the table or the table that owns the index
    string TableName;
    # Specific attributes to retrieve (consider using `ProjectionExpression` for newer implementations)
    string[] AttributesToGet?;
    # Logical operator to combine multiple filter conditions
    ConditionalOperator ConditionalOperator?;
    # Whether to use strongly consistent reads instead of eventually consistent reads
    boolean ConsistentRead?;
    # Primary key of the first item to evaluate. Use the value from `LastEvaluatedKey` in the previous operation for pagination
    map<AttributeValue>? ExclusiveStartKey?;
    # Substitution tokens for attribute names in filter and projection expressions
    map<string> ExpressionAttributeNames?;
    # Substitution values for filter expressions
    map<AttributeValue> ExpressionAttributeValues?;
    # Filter condition applied after scanning but before returning results. Items that do not satisfy this condition are not returned
    string FilterExpression?;
    # Name of a secondary index to scan instead of the base table
    string IndexName?;
    # Maximum number of items to evaluate
    int Limit?;
    # Expression specifying which attributes to retrieve from the table or index
    string ProjectionExpression?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    # Alternative filter conditions (use `FilterExpression` for newer implementations)
    map<Condition> ScanFilter?;
    # Segment identifier for parallel scan operations
    int Segment?;
    # Which attributes to return in the results. Valid Values: ALL_ATTRIBUTES | ALL_PROJECTED_ATTRIBUTES | SPECIFIC_ATTRIBUTES | COUNT
    Select Select?;
    # Total number of segments for parallel scan operations
    int TotalSegments?;
|};

# Single item from a query operation with consumption metrics.
public type QueryOutput record {
    # Capacity units consumed by the query
    ConsumedCapacity? ConsumedCapacity?;
    # Item that matches the query criteria with its attribute names and values
    map<AttributeValue>? Item?;
};

# Single item from a scan operation with consumption metrics.
public type ScanOutput record {
    # Capacity units consumed by the scan
    ConsumedCapacity? ConsumedCapacity?;
    # Item that matches the scan criteria with its attribute names and values
    map<AttributeValue>? Item?;
};

type QueryOrScanOutput record {
    ConsumedCapacity? ConsumedCapacity?;
    int? Count?;
    map<AttributeValue>[]? Items?;
    map<AttributeValue>? LastEvaluatedKey?;
    int? ScannedCount?;
};

# Input for query operations to find items based on primary key values.
public type QueryInput record {|
    # Name of the table containing the requested items
    string TableName;
    # Specific attributes to retrieve (consider using `ProjectionExpression` for newer implementations)
    string[] AttributesToGet?;
    # Logical operator to combine multiple filter conditions. Valid Values: AND | OR
    ConditionalOperator ConditionalOperator?;
    # Whether to use strongly consistent reads instead of eventually consistent reads
    boolean ConsistentRead?;
    # Primary key of the first item to evaluate for pagination
    map<AttributeValue>? ExclusiveStartKey?;
    # Substitution tokens for attribute names in filter and projection expressions
    map<string> ExpressionAttributeNames?;
    # Substitution values for filter and key condition expressions
    map<AttributeValue> ExpressionAttributeValues?;
    # Filter condition applied after querying but before returning results. Items that do not satisfy this condition are not returned
    string FilterExpression?;
    # Name of an index to query instead of the base table
    string IndexName?;
    # Condition that specifies the key values for items to retrieve
    string KeyConditionExpression?;
    # Alternative key conditions (use `KeyConditionExpression` for newer implementations)
    map<Condition> KeyConditions?;
    # Maximum number of items to evaluate
    int Limit?;
    # Expression specifying which attributes to retrieve from the table
    string ProjectionExpression?;
    # Alternative filter conditions (use `FilterExpression` for newer implementations)
    map<Condition> QueryFilter?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    # Order for index traversal: true for ascending order, false for descending order
    boolean ScanIndexForward?;
    # Which attributes to return in the results. Valid Values: ALL_ATTRIBUTES | ALL_PROJECTED_ATTRIBUTES | SPECIFIC_ATTRIBUTES | COUNT
    Select Select?;
|};

# Input for update operations to modify item attributes.
public type ItemUpdateInput record {|
    # Primary key of the item to update with attribute names and values
    map<AttributeValue> Key;
    # Name of the table containing the item
    string TableName;
    # Alternative attribute update specifications (use `UpdateExpression` for newer implementations)
    map<AttributeValueUpdate> AttributeUpdates?;
    # Logical operator to combine multiple conditions. Valid Values: AND | OR
    ConditionalOperator ConditionalOperator?;
    # Condition that must be satisfied for the update to proceed
    string ConditionExpression?;
    # Alternative expected attribute conditions (use `ConditionExpression` for newer implementations)
    map<ExpectedAttributeValue> Expected?;
    # Substitution tokens for attribute names in update and condition expressions
    map<string> ExpressionAttributeNames?;
    # Substitution values for update and condition expressions
    map<AttributeValue> ExpressionAttributeValues?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    # Whether to return item collection metrics in the response. Valid Values: SIZE | NONE
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
    # Which item attributes to return. Valid Values: NONE | ALL_OLD | UPDATED_OLD | ALL_NEW | UPDATED_NEW
    ReturnValues ReturnValues?;
    # Expression defining which attributes to update, the actions to perform, and new values
    string UpdateExpression?;
|};

# Input for delete operations to remove an item from a table.
public type ItemDeleteInput record {|
    # Primary key of the item to delete with attribute names and values
    map<AttributeValue> Key;
    # Name of the table from which to delete the item
    string TableName;
    # Logical operator to combine multiple conditions. Valid Values: AND | OR
    ConditionalOperator ConditionalOperator?;
    # Condition that must be satisfied for the delete to proceed
    string ConditionExpression?;
    # Alternative expected attribute conditions (use `ConditionExpression` for newer implementations)
    map<ExpectedAttributeValue> Expected?;
    # Substitution tokens for attribute names in condition expressions
    map<string> ExpressionAttributeNames?;
    # Substitution values for condition expressions
    map<AttributeValue> ExpressionAttributeValues?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    # Whether to return item collection metrics in the response. Valid Values: SIZE | NONE
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
    # Which item attributes to return before deletion. Valid Values: NONE | ALL_OLD
    ReturnValues ReturnValues?;
|};

# Response from a get item operation containing the retrieved item.
public type ItemGetOutput record {
    # Capacity units consumed by the get operation
    ConsumedCapacity? ConsumedCapacity?;
    # Retrieved item with attribute names and values as specified by `ProjectionExpression`
    map<AttributeValue>? Item?;
};

# Input for get operations to retrieve a single item by primary key.
public type ItemGetInput record {|
    # Primary key of the item to retrieve with attribute names and values
    map<AttributeValue> Key;
    # Name of the table containing the requested item
    string TableName;
    # Specific attributes to retrieve (consider using `ProjectionExpression` for newer implementations)
    string[] AttributesToGet?;
    # Whether to use strongly consistent reads instead of eventually consistent reads
    boolean ConsistentRead?;
    # Substitution tokens for attribute names in projection expressions
    map<string> ExpressionAttributeNames?;
    # Expression specifying which attributes to retrieve from the table
    string ProjectionExpression?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity ReturnConsumedCapacity?;
|};

# Response from put, update, or delete item operations.
public type ItemDescription record {
    # Attribute values before the operation, included only if `ReturnValues` was specified in the request
    map<AttributeValue>? Attributes?;
    # Capacity units consumed by the operation
    ConsumedCapacity? ConsumedCapacity?;
    # Information about item collections affected by the operation
    ItemCollectionMetrics? ItemCollectionMetrics?;
};

# Input for put operations to create or replace an item.
public type ItemCreateInput record {|
    # Item attributes as name-value pairs. Primary key attributes are required; other attributes are optional
    map<AttributeValue> Item;
    # Name of the table to contain the item
    string TableName;
    # Logical operator to combine multiple conditions. Valid Values: AND | OR
    ConditionalOperator? ConditionalOperator?;
    # Condition that must be satisfied for the put to proceed
    string? ConditionExpression?;
    # Alternative expected attribute conditions (use `ConditionExpression` for newer implementations)
    map<ExpectedAttributeValue>? Expected?;
    # Substitution tokens for attribute names in condition expressions
    map<string>? ExpressionAttributeNames?;
    # Substitution values for condition expressions
    map<AttributeValue>? ExpressionAttributeValues?;
    # Level of detail for provisioned throughput consumption in the response. Valid Values: INDEXES | TOTAL | NONE
    ReturnConsumedCapacity? ReturnConsumedCapacity?;
    # Whether to return item collection metrics in the response. Valid Values: SIZE | NONE
    ReturnItemCollectionMetrics? ReturnItemCollectionMetrics?;
    # Which item attributes to return before the operation. Valid Values: NONE | ALL_OLD
    ReturnValues? ReturnValues?;
|};

# Input for table update operations to modify table settings.
public type TableUpdateInput record {|
    # Name of the table to update
    string TableName;
    # Attribute definitions for the table and indexes. Required when adding new global secondary indexes
    AttributeDefinition[] AttributeDefinitions?;
    # Billing mode controlling how you are charged for read and write throughput
    BillingMode BillingMode?;
    # Global secondary index updates to create, update, or delete indexes
    GlobalSecondaryIndexUpdate[] GlobalSecondaryIndexUpdates?;
    # New provisioned throughput settings for the table or index
    ProvisionedThroughput ProvisionedThroughput?;
    # Replica update actions for global tables
    ReplicationGroupUpdate[] ReplicaUpdates?;
    # New server-side encryption settings for the table
    SSESpecification SSESpecification?;
    # DynamoDB Streams configuration for the table
    StreamSpecification StreamSpecification?;
|};

type TableListRequest record {
    string? ExclusiveStartTableName?;
    int? Limit?;
};

# Paginated list of table names.
public type TableList record {
    # Last table name in the current page. Use as `ExclusiveStartTableName` in the next request for pagination
    string LastEvaluatedTableName?;
    # Names of tables in the current account and endpoint. Maximum of 100 table names per page
    string[] TableNames?;
};

# Input for table creation operations.
public type TableCreateInput record {|
    # Attribute definitions for the table and indexes
    AttributeDefinition[] AttributeDefinitions;
    # Primary key schema for the table. Attributes must also be defined in `AttributeDefinitions`
    KeySchemaElement[] KeySchema;
    # Name of the table to create
    string TableName;
    # Billing mode controlling how you are charged for throughput. Valid Values: PROVISIONED | PAY_PER_REQUEST
    BillingMode BillingMode?;
    # Global secondary indexes to create on the table. Maximum of 20 indexes
    GlobalSecondaryIndex[] GlobalSecondaryIndexes?;
    # Local secondary indexes to create on the table. Maximum of 5 indexes
    LocalSecondaryIndex[] LocalSecondaryIndexes?;
    # Provisioned throughput settings for the table or index
    ProvisionedThroughput ProvisionedThroughput?;
    # Server-side encryption settings
    SSESpecification SSESpecification?;
    # DynamoDB Streams settings for the table
    StreamSpecification StreamSpecification?;
    # Key-value pairs to label the table
    Tag[] Tags?;
|};

# Attribute definition for table and index key schemas.
public type AttributeDefinition record {
    # Name of the attribute
    string AttributeName;
    # Data type of the attribute. Valid values: S (String), N (Number), B (Binary)
    AttributeType AttributeType;
};

# Single element of a key schema defining partition or sort keys.
public type KeySchemaElement record {
    # Name of the key attribute
    string AttributeName;
    # Role of the key attribute: HASH (partition key) or RANGE (sort key)
    KeyType KeyType;
};

# Attributes projected from the table into a secondary index.
public type Projection record {
    # Non-key attribute names to project into the index
    string[]? NonKeyAttributes?;
    # Which attributes to project: KEYS_ONLY (only keys), INCLUDE (keys plus specified attributes), ALL (all attributes)
    ProjectionType? ProjectionType?;
};

# Provisioned throughput settings for a table or index.
public type ProvisionedThroughput record {
    # Maximum strongly consistent reads per second before throttling occurs
    int ReadCapacityUnits;
    # Maximum writes per second before throttling occurs
    int WriteCapacityUnits;
};

# Configuration for a local secondary index on a table.
public type LocalSecondaryIndex record {
    # Name of the local secondary index. Must be unique among all other indexes on this table
    string IndexName;
    # Complete key schema for the local secondary index, consisting of one or more pairs of attribute
    # names and key types: HASH - partition key, RANGE - sort key
    KeySchemaElement[] KeySchema;
    # Attributes that are copied (projected) from the table into the local secondary index. These
    # are in addition to the primary key attributes and index key attributes, which are automatically projected
    Projection Projection;
};

# Configuration for a global secondary index on a table.
public type GlobalSecondaryIndex record {
    *LocalSecondaryIndex;
    # Provisioned throughput settings for the specified global secondary index
    ProvisionedThroughput ProvisionedThroughput;
};

# Server-side encryption settings for a table.
public type SSESpecification record {
    # Whether server-side encryption is enabled. If enabled (true), server-side encryption type is set to KMS
    # and an AWS managed CMK is used (AWS KMS charges apply). If disabled (false) or not specified,
    # server-side encryption is set to AWS owned CMK
    boolean? Enabled?;
    # AWS KMS customer master key (CMK) to use for encryption. Specify using key ID, Amazon Resource Name (ARN),
    # alias name, or alias ARN. Only provide this parameter if the key is different from the default DynamoDB
    # customer master key `alias/aws/dynamodb`
    string? KMSMasterKeyId?;
    # Server-side encryption type. The only supported value is KMS - Server-side encryption that uses AWS Key
    # Management Service. The key is stored in your account and is managed by AWS KMS (AWS KMS charges apply)
    SSEType? SSEType?;
};

# DynamoDB Streams configuration for change data capture on a table.
public type StreamSpecification record {
    # Whether DynamoDB Streams is enabled (true) or disabled (false) on the table
    boolean StreamEnabled;
    # Determines what information is written to the stream when an item in the table is modified.
    # Valid values: KEYS_ONLY - Only the key attributes of the modified item are written to the stream.
    # NEW_IMAGE - The entire item, as it appears after it was modified, is written to the stream.
    # OLD_IMAGE - The entire item, as it appeared before it was modified, is written to the stream.
    # NEW_AND_OLD_IMAGES - Both the new and the old item images are written to the stream
    StreamViewType? StreamViewType?;
};

# Key-value pair for labeling and organizing tables. You can add up to 50 tags to a single DynamoDB table.
public type Tag record {
    # Key of the tag. Tag keys are case sensitive. Each DynamoDB table can only have up to one tag with the same
    # key. If you try to add an existing tag (same key), the existing tag value will be updated to the new value
    string Key;
    # Value of the tag. Tag values are case-sensitive and can be null
    string? Value;
};

# Details of a table archival operation.
public type ArchivalSummary record {
    # Amazon Resource Name (ARN) of the backup the table was archived to, when applicable in the
    # archival reason. If you wish to restore this backup to the same table name, you will need to
    # delete the original table
    string? ArchivalBackupArn?;
    # Date and time when table archival was initiated by DynamoDB, in UNIX epoch time format
    int? ArchivalDateTime?;
    # Reason DynamoDB archived the table. Currently, the only possible value is
    # INACCESSIBLE_ENCRYPTION_CREDENTIALS - The table was archived due to the table's AWS KMS key being
    # inaccessible for more than seven days. An On-Demand backup was created at the archival time
    string? ArchivalReason?;
};

# Details for the read/write capacity billing mode.
public type BillingModeSummary record {
    # Controls how you are charged for read and write throughput and how you manage capacity. This setting
    # can be changed later.
    # PROVISIONED - Sets the read/write capacity mode to PROVISIONED. Recommended for predictable workloads.
    # PAY_PER_REQUEST - Sets the read/write capacity mode to PAY_PER_REQUEST. Recommended for unpredictable workloads
    BillingMode? BillingMode?;
    # Time when PAY_PER_REQUEST was last set as the read/write capacity mode
    int? LastUpdateToPayPerRequestDateTime?;
};

# Current state and configuration of a global secondary index.
public type GlobalSecondaryIndexDescription record {
    *LocalSecondaryIndexDescription;
    # Whether the index is currently backfilling data
    boolean? Backfilling?;
    # Current state of the global secondary index. Values: CREATING (being created), UPDATING (being updated),
    # DELETING (being deleted), ACTIVE (ready for use)
    IndexStatus? IndexStatus?;
    # Provisioned throughput settings for the specified global secondary index
    ProvisionedThroughput? ProvisionedThroughput?;
};

# Current state and configuration of a local secondary index.
public type LocalSecondaryIndexDescription record {
    # Amazon Resource Name (ARN) that uniquely identifies the index
    string? IndexArn?;
    # Name of the local secondary index
    string? IndexName?;
    # Total size of the specified index, in bytes. DynamoDB updates this value approximately every
    # six hours. Recent changes might not be reflected in this value
    int? IndexSizeBytes?;
    # Number of items in the specified index. DynamoDB updates this value approximately every six hours.
    # Recent changes might not be reflected in this value
    int? ItemCount?;
    # Complete key schema for the local secondary index, consisting of one or more pairs of attribute
    # names and key types: HASH - partition key, RANGE - sort key
    KeySchemaElement[]? KeySchema?;
    # Attributes that are copied (projected) from the table into the global secondary index. These
    # are in addition to the primary key attributes and index key attributes, which are automatically projected
    Projection? Projection?;
};

# Provisioned throughput settings for a table, including read and write capacity units and modification history.
public type ProvisionedThroughputDescription record {
    # Date and time of the last provisioned throughput decrease for this table
    int? LastDecreaseDateTime?;
    # Date and time of the last provisioned throughput increase for this table
    int? LastIncreaseDateTime?;
    # Number of provisioned throughput decreases for this table during this UTC calendar day
    int? NumberOfDecreasesToday?;
    # Maximum number of strongly consistent reads consumed per second before DynamoDB returns a `ThrottlingException`
    int? ReadCapacityUnits?;
    # Maximum number of writes consumed per second before DynamoDB returns a `ThrottlingException`
    int? WriteCapacityUnits?;
};

# Replica-specific provisioned throughput settings. If not specified, uses the source table's provisioned throughput settings.
public type ProvisionedThroughputOverride record {
    # Replica-specific read capacity units. If not specified, uses the source table's read capacity settings
    int? ReadCapacityUnits?;
};

# Configuration of a replica global secondary index.
public type ReplicaGlobalSecondaryIndexDescription record {
    # Name of the global secondary index
    string? IndexName?;
    # Provisioned throughput override for this replica index. If not specified, uses the source table GSI's read capacity settings
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};

# Details of a table replica in a global table.
public type ReplicaDescription record {
    # Replica-specific global secondary index settings
    ReplicaGlobalSecondaryIndexDescription[]? GlobalSecondaryIndexes?;
    # AWS KMS customer master key (CMK) of the replica that will be used for AWS KMS encryption
    string? KMSMasterKeyArn?;
    # Replica-specific provisioned throughput. If not specified, uses the source table's provisioned throughput settings
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
    # Name of the AWS Region where the replica is located
    string? RegionName?;
    # Time at which the replica was first detected as inaccessible. To determine cause of inaccessibility check the `ReplicaStatus` field
    int? ReplicaInaccessibleDateTime?;
    # Current state of the replica. Valid Values: CREATING | CREATION_FAILED | UPDATING | DELETING |
    # ACTIVE | REGION_DISABLED | INACCESSIBLE_ENCRYPTION_CREDENTIALS
    ReplicaStatus? ReplicaStatus?;
    # Detailed information about the replica status
    string? ReplicaStatusDescription?;
    # Progress of a Create, Update, or Delete action on the replica as a percentage
    string? ReplicaStatusPercentProgress?;
};

# Details of a table restore operation.
public type RestoreSummary record {
    # Point in time or source backup time
    int RestoreDateTime;
    # Whether a restore operation is currently in progress
    boolean RestoreInProgress;
    # Amazon Resource Name (ARN) of the backup from which the table was restored
    string? SourceBackupArn?;
    # ARN of the source table of the backup that is being restored
    string? SourceTableArn?;
};

# Server-side encryption status and configuration for a table.
public type SSEDescription record {
    # Time, in UNIX epoch date format, when DynamoDB detected that the table's AWS KMS key was inaccessible
    int? InaccessibleEncryptionDateTime?;
    # AWS KMS customer master key (CMK) ARN used for the AWS KMS encryption
    string? KMSMasterKeyArn?;
    # Server-side encryption type. The only supported value is KMS - Server-side encryption that uses AWS Key
    # Management Service. The key is stored in your account and is managed by AWS KMS (AWS KMS charges apply)
    SSEType? SSEType?;
    # Current state of server-side encryption. Supported values:
    # ENABLED - Server-side encryption is enabled, UPDATING - Server-side encryption is being updated
    Status? Status?;
};

# Complete description of a table including its schema, indexes, and current state.
public type TableDescription record {
    # Information about the table archive
    ArchivalSummary? ArchivalSummary?;
    # Array of attribute definitions describing attributes in the table and index key schema
    AttributeDefinition[]? AttributeDefinitions?;
    # Details for the read/write capacity billing mode
    BillingModeSummary? BillingModeSummary?;
    # Date and time when the table was created, in UNIX epoch time format
    int? CreationDateTime?;
    # Global secondary indexes on the table. Each index is scoped to a given partition key value
    GlobalSecondaryIndexDescription[]? GlobalSecondaryIndexes?;
    # Version of global tables in use, if the table is replicated across AWS Regions
    string? GlobalTableVersion?;
    # Number of items in the specified table
    int? ItemCount?;
    # Primary key structure for the table
    KeySchemaElement[]? KeySchema?;
    # Amazon Resource Name (ARN) that uniquely identifies the latest stream for this table
    string? LastDecreaseDateTimeatestStreamArn?;
    # Timestamp, in ISO 8601 format, for this stream
    string? LatestStreamLabel?;
    # Local secondary indexes on the table
    LocalSecondaryIndexDescription[]? LocalSecondaryIndexes?;
    # Provisioned throughput settings for the table, including read and write capacity
    # units and modification history
    ProvisionedThroughputDescription? ProvisionedThroughput?;
    # Replicas of the table in other regions for global tables
    ReplicaDescription[]? Replicas?;
    # Details of the restore operation if the table was restored from a backup
    RestoreSummary? RestoreSummary?;
    # Server-side encryption status for the table
    SSEDescription? SSEDescription?;
    # Current DynamoDB Streams configuration for the table
    StreamSpecification? StreamSpecification?;
    # Amazon Resource Name (ARN) that uniquely identifies the table
    string? TableArn?;
    # Unique identifier for the table
    string? TableId?;
    # Name of the table
    string? TableName?;
    # Total size of the specified table, in bytes
    int? TableSizeBytes?;
    # Current state of the table. Valid Values: CREATING | UPDATING | DELETING | ACTIVE |
    # INACCESSIBLE_ENCRYPTION_CREDENTIALS | ARCHIVING | ARCHIVED
    TableStatus? TableStatus?;
};

# Action to create a new global secondary index on an existing table.
public type CreateGlobalSecondaryIndexAction record {
    # Name of the global secondary index to create
    string IndexName;
    # Key schema for the global secondary index
    KeySchemaElement[] KeySchema;
    # Attributes to project from the table into the index
    Projection Projection;
    # Provisioned throughput settings for the global secondary index
    ProvisionedThroughput? ProvisionedThroughput?;
};

# Action to delete a global secondary index from an existing table.
public type DeleteGlobalSecondaryIndexAction record {
    # Name of the global secondary index to delete
    string IndexName;
};

# Action to update provisioned throughput settings for a global secondary index.
public type UpdateGlobalSecondaryIndexAction record {
    # Name of the global secondary index to update
    string IndexName;
    # New provisioned throughput settings for the global secondary index
    ProvisionedThroughput ProvisionedThroughput;
};

# Update operation for a global secondary index: create, update, or delete.
public type GlobalSecondaryIndexUpdate record {
    # Parameters for creating a new global secondary index
    CreateGlobalSecondaryIndexAction? Create?;
    # Parameters for deleting an existing global secondary index
    DeleteGlobalSecondaryIndexAction? Delete?;
    # Parameters for updating an existing global secondary index
    UpdateGlobalSecondaryIndexAction? Update?;
};

# Configuration for a replica global secondary index.
public type ReplicaGlobalSecondaryIndex record {
    # Name of the global secondary index
    string IndexName;
    # Replica-specific provisioned throughput for this index. If not specified, uses the source
    # table GSI's read capacity settings
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};

# Action to create a new replica in a global table.
public type CreateReplicationGroupMemberAction record {
    # AWS Region where the new replica will be created
    string RegionName;
    # Replica-specific global secondary index settings
    ReplicaGlobalSecondaryIndex[]? GlobalSecondaryIndexes?;
    # AWS KMS customer master key (CMK) to use for AWS KMS encryption in the new replica
    string? KMSMasterKeyId?;
    # Replica-specific provisioned throughput. If not specified, uses the source table's
    # provisioned throughput settings
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};

# Action to delete a replica from a global table.
public type DeleteReplicationGroupMemberAction record {
    # AWS Region where the replica exists
    string RegionName;
};

# Action to modify an existing replica in a global table.
public type UpdateReplicationGroupMemberAction record {
    *CreateReplicationGroupMemberAction;
};

# Update operation for a global table replica: create, update, or delete.
public type ReplicationGroupUpdate record {
    # Parameters for creating a new replica
    CreateReplicationGroupMemberAction? Create?;
    # Parameters for deleting an existing replica
    DeleteReplicationGroupMemberAction? Delete?;
    # Parameters for updating an existing replica
    UpdateReplicationGroupMemberAction? Update?;
};

# Data for an attribute with its type and value.
public type AttributeValue record {
    # Attribute of type Binary
    string? B?;
    # Attribute of type Boolean
    boolean? BOOL?;
    # Attribute of type Binary Set
    string[]? BS?;
    # Attribute of type List
    AttributeValue[]? L?;
    # Attribute of type Map
    map<AttributeValue>? M?;
    # Attribute of type Number
    string? N?;
    # Attribute of type Number Set
    string[]? NS?;
    # Attribute of type Null
    boolean? NULL?;
    # Attribute of type String
    string? S?;
    # Attribute of type String Set
    string[]? SS?;
};

# Expected attribute value condition for conditional operations.
public type ExpectedAttributeValue record {
    # Values to compare against the attribute
    AttributeValue[]? AttributeValueList?;
    # Comparison operator for evaluating attributes. Valid Values: EQ | NE | IN |
    # LE | LT | GE | GT | BETWEEN | NOT_NULL | NULL | CONTAINS | NOT_CONTAINS | BEGINS_WITH
    ComparisonOperator? ComparisonOperator?;
    # Whether DynamoDB should evaluate the value before attempting a conditional operation
    boolean? Exists?;
    # Expected data for the attribute
    AttributeValue? Value?;
};

# Provisioned throughput capacity consumed on a table or index.
public type Capacity record {
    # Total capacity units consumed
    float? CapacityUnits?;
    # Total read capacity units consumed
    float? ReadCapacityUnits?;
    # Total write capacity units consumed
    float? WriteCapacityUnits?;
};

# Capacity units consumed by an operation on a table and its indexes.
public type ConsumedCapacity record {
    # Total capacity units consumed by the operation
    float? CapacityUnits?;
    # Throughput consumed on each global secondary index affected by the operation
    map<Capacity>? GlobalSecondaryIndexes?;
    # Throughput consumed on each local secondary index affected by the operation
    map<Capacity>? LocalSecondaryIndexes?;
    # Total read capacity units consumed by the operation
    float? ReadCapacityUnits?;
    # Throughput consumed on the table affected by the operation
    Capacity? Table?;
    # Name of the table that was affected by the operation
    string? TableName?;
    # Total write capacity units consumed by the operation
    float? WriteCapacityUnits?;
};

# Information about item collections affected by write operations.
public type ItemCollectionMetrics record {
    # Partition key value of the item collection. This value is the same as the partition key value of the item
    map<AttributeValue>? ItemCollectionKey?;
    # Estimate of item collection size, in gigabytes. This is a two-element array containing a lower bound
    # and an upper bound for the estimate. The estimate includes the size of all items in the table plus the
    # size of all attributes projected into all local secondary indexes. Use this estimate to measure whether
    # a local secondary index is approaching its size limit
    float[]? SizeEstimateRangeGB?;
};

# Attribute modification specification for update operations.
public type AttributeValueUpdate record {
    # How to perform the update. Valid values: PUT (default), DELETE, ADD. The behavior depends
    # on whether the specified primary key already exists in the table
    Action? Action?;
    # Data for the attribute
    AttributeValue? Value?;
};

# Selection criteria for query or scan operations.
public type Condition record {
    # Comparison operator for evaluating attributes. Valid Values: EQ | NE | IN | LE | LT | GE | GT |
    # BETWEEN | NOT_NULL | NULL | CONTAINS | NOT_CONTAINS | BEGINS_WITH
    ComparisonOperator ComparisonOperator;
    # Values to compare against the attribute. The number of values depends on the `ComparisonOperator` being used
    AttributeValue[]? AttributeValueList?;
};

# Primary keys and attributes to retrieve in a batch get operation.
public type KeysAndAttributes record {
    # Primary key attribute values that define the items to retrieve
    map<AttributeValue>[] Keys;
    # Specific attributes to retrieve (consider using `ProjectionExpression` for newer implementations)
    string[]? AttributesToGet?;
    # Whether to use strongly consistent reads instead of eventually consistent reads
    boolean? ConsistentRead?;
    # Substitution tokens for attribute names in projection expressions
    map<string>? ExpressionAttributeNames?;
    # Expression specifying which attributes to retrieve from the table
    string? ProjectionExpression?;
};

# Request to delete an item in a batch write operation.
public type DeleteRequest record {
    # Primary key of the item to delete with attribute names and values. All of the table's primary key
    # attributes must be specified, and their data types must match the table's key schema
    map<AttributeValue> Key;
};

# Request to create an item in a batch write operation.
public type PutRequest record {
    # Item attributes as name-value pairs. All of the table's primary key attributes must be specified,
    # and their data types must match the table's key schema. If any attributes are part of an index key
    # schema, their types must match the index key schema
    map<AttributeValue> Item;
};

# Write operation for batch requests: either put or delete.
public type WriteRequest record {
    # Delete operation for an item
    DeleteRequest? DeleteRequest?;
    # Put operation for an item
    PutRequest? PutRequest?;
};

# Input for creating a backup of a table.
public type BackupCreateInput record {|
    # Name for the backup
    string BackupName;
    # Name of the table to back up
    string TableName;
|};

# Details of a backup created for a table.
public type BackupDetails record {
    # ARN associated with the backup
    string BackupArn;
    # Time at which the backup was created, in UNIX epoch time format. This is the request time of the backup
    decimal BackupCreationDateTime;
    # Name of the backup
    string BackupName;
    # Current state of the backup: CREATING, ACTIVE, or DELETED
    string BackupStatus;
    # Type of backup: USER, SYSTEM, or AWS_BACKUP
    string BackupType;
    # Time at which automatic on-demand backups created by DynamoDB will expire. SYSTEM backups
    # expire automatically 35 days after creation
    decimal BackupExpiryDateTime?;
    # Size of the backup in bytes. DynamoDB updates this value approximately every six hours.
    # Recent changes might not be reflected in this value
    decimal BackupSizeBytes?;
};

# Response from a backup creation operation.
public type BackupDescription record {
    # Details of the backup that was created
    BackupDetails BackupDetails?;
    # Details of the table when the backup was created
    SourceTableDetails SourceTableDetails?;
    # Details of the features enabled on the table when the backup was created
    SourceTableFeatureDetails SourceTableFeatureDetails?;
};

# Details of the source table when a backup was created.
public type SourceTableDetails record {
    # Key schema of the table
    KeySchemaElement[] KeySchema?;
    # Provisioned throughput settings when the backup was created
    ProvisionedThroughput ProvisionedThroughput?;
    # Time when the source table was created, in UNIX epoch time format
    decimal TableCreationDateTime?;
    # Unique identifier for the table
    string TableId?;
    # Name of the table for which the backup was created
    string TableName?;
    # Billing mode of the table when the backup was created
    BillingMode BillingMode?;
    # Approximate number of items in the table
    float ItemCount?;
    # ARN of the table for which backup was created
    string TableArn?;
    # Approximate size of the table in bytes
    float TableSizeBytes?;
};

# Configuration of a global secondary index at the time a backup was created.
public type GlobalSecondaryIndexInfo record {
    # Name of the global secondary index
    string IndexName?;
    # Complete key schema for the index with partition and sort key definitions
    KeySchemaElement[] KeySchema?;
    # Attributes projected from the table into the global secondary index
    Projection Projection?;
    # Provisioned throughput settings for the global secondary index
    ProvisionedThroughput ProvisionedThroughput?;
};

# Configuration of a local secondary index at the time a backup was created.
public type LocalSecondaryIndexInfo record {
    # Name of the local secondary index
    string IndexName?;
    # Complete key schema for the index with partition and sort key definitions
    KeySchemaElement[] KeySchema?;
    # Attributes projected from the table into the local secondary index
    Projection Projection?;
};

# Time to Live configuration for automatic item expiration.
public type TTLDescription record {
    # Name of the TTL attribute for items in the table
    string AttributeName?;
    # Current TTL status for the table
    TimeToLiveStatus TimeToLiveStatus?;
};

# Features enabled on the table when a backup was created (indexes, streams, TTL, encryption).
public type SourceTableFeatureDetails record {
    # Global secondary index properties at the time of backup
    GlobalSecondaryIndexInfo GlobalSecondaryIndexInfo?;
    # Local secondary index properties at the time of backup
    LocalSecondaryIndexInfo LocalSecondaryIndexInfo?;
    # Server-side encryption status when the backup was created
    SSEDescription SSEDescription?;
    # Stream settings when the backup was created
    StreamSpecification StreamSpecification?;
    # Time to Live settings when the backup was created
    TTLDescription TimeToLiveDescription?;
};
