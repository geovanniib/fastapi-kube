# Deployment

This folder contains the resources needed to deploy and load test the application in Kubernetes (k3s).

## What do you need to deploy?

- You need [OpenTofu](https://opentofu.org) & [K3S](https://k3s.io) locally & k6


## Description of directories

In the opentofu directory there are templates for the application to be deployed in a k3s, while in k6 there is a js script that using k6 can be used to test the behavior of the application at a certain amount of load.

### images

Contains images used in redme.md



### opentofu

```tree opentofu/
opentofu/
├── config
│   ├── config-file-here.txt
│   └── config-k3s
├── fastapi
│   ├── external.tf
│   ├── keda.tf
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── storage.tf
│   └── variables.tf
├── monitoring
│   ├── main.tf
│   ├── notes.txt
│   ├── output.tf
│   ├── provider.tf
│   └── variables.tf
└── requirements
    ├── main.tf
    └── provider.tf
```

In the "config" directory you need to store the KUBECONFIG of the local k3s for the correct operation of the implementation named "config-k3s" which is ignored in the gitignore.

In the "fastapi" directory the tofu templates used to implement the application are stored (api, worker, nginx external, keda, etc.).

In the "monitoring" directory the tofu templates to deploy grafana, loki and promtail are stored to have the ability to have the logs centralized in grafana.

In the "requirements" directory you can find the installation of the KEDA CDRs or others if necessary, with the help of helm.

### k6



```tree k6
k6
├── endpoints.txt
└── load-test.js
```

The load-test.js will perform a small load testing of the application testing the healthcheck APIs and testing the `${BASE_URL}/color/match?name=${name}` API with some correct values.

