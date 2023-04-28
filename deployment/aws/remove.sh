# Install Dapr
# dapr init -k

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Delete services
for f in $SCRIPT_PATH/services/*.yaml; do kubectl delete -f $f; done

# Delete components
for f in $SCRIPT_PATH/dapr/components/*.yaml; do kubectl delete -f $f; done

# Delete Dapr configuration
kubectl delete -f $SCRIPT_PATH/infrastructure/dapr-config.yaml

# Delete MailDev
kubectl delete -f $SCRIPT_PATH/infrastructure/maildev.yaml

# Delete ZipKin
kubectl delete -f $SCRIPT_PATH/infrastructure/zipkin.yaml

# Delete secrets
kubectl delete -f $SCRIPT_PATH/infrastructure/secrets.yaml

# Delete namespace
kubectl delete -f $SCRIPT_PATH/infrastructure/namespace.yaml
