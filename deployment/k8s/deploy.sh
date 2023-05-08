SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Initialize Dapr if script was called with --init
if [ "$1" == "--init" ]; then
    echo "Initializing Dapr..."
    dapr init -k
fi

# Create namespace
kubectl apply -f $SCRIPT_PATH/infrastructure/namespace.yaml

# Deploy Redis
kubectl apply -f $SCRIPT_PATH/infrastructure/redis.yaml

# Deploy RabbitMQ
kubectl apply -f $SCRIPT_PATH/infrastructure/rabbitmq.yaml

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

# Set default namespace to dapr-trafficcontrol
kubectl config set-context --current --namespace=dapr-trafficcontrol
