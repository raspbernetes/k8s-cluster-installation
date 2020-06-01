# Cloudflare

To configure your load balancer monitoring healthchecks with authentication you should create a in cluster service account which has a clusterrolebinding to allow it to be able to hit the `/healthz/ping` endpoint.

First apply the following YAML files to create the kubernetes resources:

```bash
kubectl apply -f ./cloudflare
```

Get the TOKEN from the service account which will be provided to the load balancers

```bash
TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)
```

Validate the token provides adequate permissions to the service account:

```bash
curl -v -X GET https://api-server.raspbernetes.com/healthz/ping --header "Authorization: Bearer $TOKEN"
```

Finally copy the token and configure it through the cloudflare portal to be used on the load balancers healthcheck.

```bash
echo "$TOKEN" | pbcopy
```
