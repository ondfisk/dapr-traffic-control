# Install Dapr
# dapr init -k

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TABLE_NAME=vehicles
QUEUE_NAME=speedingviolations

# Create SQS queue
aws sqs create-queue --queue-name $QUEUE_NAME

# Create DynamoDB table
aws dynamodb create-table --table-name $TABLE_NAME --attribute-definitions AttributeName=Id,AttributeType=S --key-schema AttributeName=Id,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Create namespace
kubectl apply -f $SCRIPT_PATH/infrastructure/namespace.yaml

# Deploy MailDev
kubectl apply -f $SCRIPT_PATH/infrastructure/maildev.yaml

# Deploy ZipKin
kubectl apply -f $SCRIPT_PATH/infrastructure/zipkin.yaml

# Configure Dapr
kubectl apply -f $SCRIPT_PATH/infrastructure/dapr-config.yaml

# Setup secrets
kubectl apply -f $SCRIPT_PATH/infrastructure/secrets.yaml

# Deploy components
for f in $SCRIPT_PATH/dapr/components/*.yaml; do kubectl apply -f $f; done

# Deploy services
for f in $SCRIPT_PATH/services/*.yaml; do kubectl apply -f $f; done
