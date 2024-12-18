<!-- PROJECT SHIELDS -->
<!--
*** declarations on the bottom of this document
managed within the footer file
-->

<div id="top"></div>
<!-- PROJECT LOGO -->
<br />
<div align="center">
  </a>
  <h1 align="center"><strong>Terraform Deploy Applications in Multi-Cluster with ArgoCD</strong></h1>
  <p align="center">
    🌩️ How to deploy applications in an multi-cluster environment distributed across multiple clouds using ArgoCd and its native operators.🌩️
    <br/>
    <br/>
    <br/>
  </p>
</div>


![image](https://github.com/user-attachments/assets/a0b8f050-e127-4a5c-84df-2aa0be4f6e89)

# Introduction

Before diving into the repository, it's important to understand the following concepts:

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/): A declarative, GitOps continuous delivery tool for Kubernetes.
- [ArgoCD ApplicationSets](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/): An Argo CD extension which adds support for new and innovative ways to automatically create Argo CD Applications.
- [ApplicationSet Generators](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators/): Generators create a list of Argo CD Applications, based on of parameters that they are provided.

## Directory Structure

The repository is organized as follows:

```bash
├── argocd                              ## rooot argocd directory
│   ├── bootstrap                       ## bootstrap configs ( secrets , projects etc.)
│   │   └── secrets
│   │       ├── clusters                ## clusters as secrets in argocd management cluster
│   │       └── repositories            ## repositories as secrets in argocd management cluster
│   ├── common                          ## common directory for all applications need to be deployed through all clusters
│   │   ├── README.md
│   │   ├── cert-manager
│   │   │   └── applicationset.yaml
│   │   ├── demo-app
│   │   │   └── applicationset.yaml
│   │   ├── external-dns
│   │   │   └── applicationset.yaml
│   │   ├── external-secrets-operator
│   │   │   └── applicationset.yaml
│   │   └── nginx-ingress-controller
│   │       └── applicationset.yaml
│   ├── envs                                              ## deployment environments( dev, stage , prod etc.) have same structure.
│   │   ├── stage                                         ## dev/playground environment clusters directory configuration.
│   │   │   ├── aws                                       ## AWS cloud clusters directory configuration.
│   │       │   ├── globals                               ## Global Env. values for AWS cloud per app ::risk:: impacts all aws clusters in dev env.(disabled)
│   │   │   │   │   ├── cert-manager                      ## Cert Manager ( Any Application holding global values for aws cloud ) (feature disabled in repo)
│   │   │   │   │   │   └── values.yaml                   ## Global app Values , will be merged with regional values. (feature disabled in repo)
│   │   │   │   ├── eu-central-01                         ## AWS region specific clusters configuration.
│   │   │   │   │   ├── cert-manager                      ## example app also used as namespace value in the applicationn set
│   │   │   │   │   │   ├── git-generator-overides.json   ## git file generator for config management of appset, such as chart version
│   │   │   │   │   │   └── values.yaml                   ## regional, cloud ,and environment specific values file
│   │   │   │   │   └── demo-app
│   │   │   │   │       ├── git-generator-overides.json
│   │   │   │   │       ├── kustomization.yaml
│   │   │   │   │       └── sample-app.yaml
│   │   │   │   └── us-east-01
│   │   │   ├── azure                                     ## Azure cloud clusters directory
│   │   │   └── gcp                                       ## GCP cloud clusters directory
│   │   │   └── globals                                   ## Global dev env values per app ::risk:: impacts all clusters in dev env.(feature disabled in repo)
│   │   │       └── cert-manager                          ## Cert Manager ( Any Application holding global values )  (feature disabled in repo)
|   │   │           └── values.yaml                       ## Global app Values , will be merged with regional values. (feature disabled in repo)
│   │   └── dev
│   │       ├── aws
│   │       │   ├── eu-central-01
│   │       │   └── us-east-01
│   │       │       ├── README.md
│   │       │       └── cert-manager
│   │       │           ├── git-generator-overides.json
│   │       │           └── values.yaml
│   │       ├── azure
│   │       │   ├── globals
│   │       │   │   └── README.md
│   │       │   ├── north-europe
│   │       │   │   ├── cert-manager
│   │       │   │   │   ├── git-generator-overides.json
│   │       │   │   │   └── values.yaml
│   │       │   │   ├── demo-app
│   │       │   │   │   ├── git-generator-overides.json
│   │       │   │   │   ├── ingress.yaml
│   │       │   │   │   ├── kustomization.yaml
│   │       │   │   │   ├── sample-app.yaml
│   │       │   │   │   └── service.yaml
│   │       │   │   ├── external-dns
│   │       │   │   │   ├── git-generator-overides.json
│   │       │   │   │   └── values.yaml
│   │       │   │   ├── external-secrets
│   │       │   │   │   ├── git-generator-overides.json
│   │       │   │   │   └── values.yaml
│   │       │   │   └── ingress-nginx-controller
│   │       │   │       ├── git-generator-overides.json
│   │       │   │       └── values.yaml
│   │       │   └── west-europe
│   │       ├── gcp
│   │       │   ├── asia-east1
│   │       │   └── europe-west1
│   │       └── globals
│   │           └── README.md
│   │
│   └── yamls
├── charts                            ## local charts , in case umbrella or custom chart is needed
│   ├── external-secrets-operator
│   │   ├── charts
│   │   └── templates
└── terraform                         ## just for this repo context , terraform configs for the infra provisioning
```

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have any suggestion that would make this project better, feel free to  fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement" with your suggestion.

