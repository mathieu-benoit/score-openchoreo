# score-openchoreo

```bash
score-k8s init --no-sample \
    --provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-k8s/10-service.provisioners.yaml

score-k8s generate \
    ad/score.yaml \
    cart/score.yaml \
    currency/score.yaml \
    email/score.yaml \
    payment/score.yaml \
    productcatalog/score.yaml \
    recommendation/score.yaml \
    shipping/score.yaml \
    checkout/score.yaml \
    frontend/score.yaml \
    loadgenerator/score.yaml \
    --namespace onlineboutique \
    --generate-namespace
```