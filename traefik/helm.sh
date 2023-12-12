REPO_URL=https://traefik.github.io/charts
REPO_NAME=traefik

if ! helm repo list | grep -q "^$REPO_NAME"; then
  helm repo add $REPO_NAME $REPO_URL
fi

helm repo update
helm repo update
helm upgrade --install traefik traefik/traefik
