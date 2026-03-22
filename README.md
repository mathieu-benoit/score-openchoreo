# score-openchoreo

You need to [install the `score-k8s` CLI](https://docs.score.dev/docs/score-implementation/score-k8s/installation/) to run these commands below.

You can also open the `.devcontainer` in your VS Code where `score-k8s` is already installed. You can also [open this repository in GitHub Codespaces](https://codespaces.new/mathieu-benoit/score-openchoreo) to use this `.devcontainer`.

```bash
score-k8s init --no-sample \
    --patch-templates ./score-k8s/patchers/openchoreo.tpl \
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