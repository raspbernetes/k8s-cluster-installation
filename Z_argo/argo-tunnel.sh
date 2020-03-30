apt install -y golang-go
git clone https://github.com/xunholy/cloudflared.git && cd cloudflared
make cloudflared && mv cloudflared /usr/local/bin


# To configure a user ssh access to the host machine have them follow these setup instructions:
# https://developers.cloudflare.com/access/ssh/connect-ssh/

# Tunnel Ingress Controler
helm template raspbernetes \
    --namespace default \
    --set rbac.create=true \
    --set controller.ingressClass=argo-tunnel \
    --set controller.logLevel=6 \
    cloudflare/argo-tunnel > output.yml