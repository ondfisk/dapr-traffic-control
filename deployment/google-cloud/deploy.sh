# Note:
# Deploy GKE cluster with minimal settings using console

# Sign in
gcloud container clusters get-credentials trafficcontrol --region=europe-west3-c

# Install Dapr
dapr init -k

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Create namespace
kubectl apply -f $SCRIPT_PATH/infrastructure/namespace.yaml

# Deploy MailDev
kubectl apply -f $SCRIPT_PATH/infrastructure/maildev.yaml

# Deploy ZipKin
kubectl apply -f $SCRIPT_PATH/infrastructure/zipkin.yaml

# Configure Dapr
kubectl apply -f $SCRIPT_PATH/infrastructure/dapr-config.yaml

# Configure internal secrets for component authentication
kubectl apply -f $SCRIPT_PATH/infrastructure/secrets.yaml

# Deploy components
for f in $SCRIPT_PATH/dapr/components/*.yaml; do kubectl apply -f $f; done

# Deploy services
for f in $SCRIPT_PATH/services/*.yaml; do kubectl apply -f $f; done
