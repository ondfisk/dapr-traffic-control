echo "Running cloc for AWS"
cloc deployment/aws

echo "Running cloc for Azure"
cloc deployment/azure --force-lang="HCL",bicep

echo "Running cloc for Google Cloud"
cloc deployment/google-cloud

echo "Running cloc for Kubernetes (on-prem)"
cloc deployment/k8s

echo "Running cloc for local (Docker)"
cloc deployment/local

echo "Running cloc for src"
cloc src --exclude-dir=bin,obj
