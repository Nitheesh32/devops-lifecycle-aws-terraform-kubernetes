[README.md](https://github.com/user-attachments/files/33289932/README.md)
# The DevOps Lifecycle: From Code to Observability

An end-to-end DevOps architecture demonstrating AWS infrastructure provisioning with Terraform, containerization with Docker, CI/CD automation, GitOps deployment using Argo CD, Kubernetes orchestration with K3s, and log monitoring using Grafana Alloy, Loki, and Grafana.

## Project Overview

This project demonstrates how cloud infrastructure, application deployment, GitOps, and observability can work together in a DevOps workflow.

Terraform is used to provision AWS infrastructure. Docker packages the Odoo 20 application into a container image, while Kubernetes manages the application and PostgreSQL workloads on an AWS EC2 instance. Argo CD monitors the Git repository and synchronizes Kubernetes manifests with the cluster. Grafana Alloy collects container logs, Loki stores and indexes them, and Grafana provides a dashboard for log analysis.

The objective is to build a repeatable, maintainable, and observable application deployment workflow.

## Architecture

![DevOps Lifecycle Architecture](odoo20-application.png)

### End-to-End Workflow

1. **Infrastructure Provisioning — Terraform**  
   Define and provision AWS resources, including VPC, EC2, IAM, S3, security groups, and Internet Gateway.

2. **Containerization — Docker**  
   Package the Odoo 20 application and its required environment into a Docker image using a Dockerfile.

3. **Version Control and CI/CD**  
   Store application code and deployment configurations in Git. The CI/CD pipeline builds the image, validates the required configurations, and publishes the image to a container registry. The deployment manifest is updated with the required image tag.

4. **GitOps — Argo CD**  
   Monitor the Git repository, detect changes to Kubernetes manifests, and synchronize the desired application configuration with the K3s cluster.

5. **Container Orchestration — Kubernetes (K3s)**  
   Deploy and manage Odoo 20 and PostgreSQL workloads on AWS EC2, using Kubernetes Deployments, Services, persistent storage, and Ingress.

6. **Log Collection — Grafana Alloy**  
   Discover Kubernetes workloads, collect container logs, and forward them to Loki.

7. **Log Aggregation — Grafana Loki**  
   Store and query application and Kubernetes logs using LogQL.

8. **Monitoring and Visualization — Grafana**  
   Explore collected logs, investigate errors, and create dashboards for application troubleshooting.

## Technology Stack

| Category | Technologies |
|---|---|
| Cloud Platform | AWS |
| Infrastructure as Code | Terraform |
| Compute | Amazon EC2 |
| Networking | VPC, Internet Gateway, Security Groups |
| Identity and Access Management | AWS IAM |
| Object Storage | Amazon S3 |
| Containerization | Docker |
| Application | Odoo 20 |
| Database | PostgreSQL |
| Container Orchestration | Kubernetes (K3s) |
| GitOps | Argo CD |
| CI/CD | Configured CI/CD pipeline |
| Log Collection | Grafana Alloy |
| Log Aggregation | Grafana Loki |
| Monitoring and Visualization | Grafana |
| Configuration Management | YAML, Kustomize |
| Version Control | Git |

## Repository Structure

```text
.
├── Dockerfile
├── Monitoring/
│   ├── alloy.yaml
│   ├── grafana_dashboard.png
│   ├── grafana_logs.png
│   └── loki-values.yaml
├── argocd/
│   ├── argocd-application.yaml
│   └── argocd_dashboard.png
├── k3s/
│   ├── kustomization.yaml
│   ├── odoo-deployment.yaml
│   ├── odoo-ingress.yaml
│   ├── odoo-service.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-pvc.yaml
│   └── postgres-service.yaml
├── odoo20-application.png
└── terraform/
    ├── data.tf
    ├── ec2.tf
    ├── iam.tf
    ├── main.tf
    ├── network.tf
    ├── provider.tf
    ├── s3.tf
    ├── security.tf
    ├── variables.tf
    └── version.tf
```

## Directory Overview

### `terraform/` — AWS Infrastructure

Contains the Terraform configuration files used to define and manage AWS resources.

- `main.tf` — Main infrastructure configuration and resource/module relationships.
- `provider.tf` — AWS provider configuration.
- `version.tf` — Terraform and provider version constraints.
- `data.tf` — Data sources used to look up existing AWS resources.
- `network.tf` — VPC and networking configuration.
- `ec2.tf` — EC2 instance configuration.
- `iam.tf` — IAM roles and permissions.
- `s3.tf` — S3 bucket configuration.
- `security.tf` — Security group configuration.
- `variables.tf` — Input variables for configurable infrastructure values.

### `Dockerfile` — Application Containerization

Defines how the custom Odoo container image is built. It provides the instructions used by the container build process to prepare the image for deployment.

### `k3s/` — Kubernetes Deployment

Contains the Kubernetes manifests required to deploy Odoo 20 and PostgreSQL.

- `kustomization.yaml` — Groups the Kubernetes manifests for Kustomize.
- `odoo-deployment.yaml` — Defines the Odoo application Deployment and image.
- `odoo-service.yaml` — Provides an internal network endpoint for Odoo.
- `odoo-ingress.yaml` — Defines routing rules for incoming application traffic.
- `postgres-deployment.yaml` — Defines the PostgreSQL workload.
- `postgres-pvc.yaml` — Requests persistent storage for PostgreSQL data.
- `postgres-service.yaml` — Provides a stable endpoint for database connectivity.

### `argocd/` — GitOps Configuration

Contains the Argo CD Application manifest, which defines the source repository, target revision, Kubernetes manifest path, destination cluster, and synchronization settings.

Argo CD uses this configuration to reconcile the desired state stored in Git with the live Kubernetes resources.

### `Monitoring/` — Logging and Visualization

Contains the configuration and screenshots for the observability stack.

- `alloy.yaml` — Configures Grafana Alloy for log collection and forwarding.
- `loki-values.yaml` — Contains Helm values for the Loki deployment.
- `grafana_dashboard.png` — Screenshot of the Grafana monitoring dashboard.
- `grafana_logs.png` — Screenshot showing log exploration or collected logs.

### `odoo20-application.png` — Application Overview

Provides a visual reference for the Odoo 20 application or the overall deployment architecture, depending on the image content.

## Infrastructure Provisioning with Terraform

Terraform enables infrastructure to be defined and managed through version-controlled configuration files.

The AWS infrastructure defined by this project includes:

- **Amazon VPC:** Provides an isolated network for the deployment.
- **EC2:** Hosts the K3s cluster and application workloads.
- **IAM:** Defines permissions for AWS resources and instance access.
- **S3:** Provides object storage for the configured use case, such as backups or artifacts.
- **Security Groups:** Control network traffic according to the required access rules.
- **Internet Gateway:** Provides internet connectivity for resources with the appropriate routing and public addressing.

### Terraform Workflow

Initialize the Terraform working directory:

```bash
cd terraform
terraform init
```

Format and validate the configuration:

```bash
terraform fmt -check
terraform validate
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

Apply the changes only after reviewing the plan and confirming the target AWS account and Region:

```bash
terraform apply
```

**Note:** Keep Terraform state files, credentials, and secret-bearing variable files out of the public repository. For shared environments, use a securely configured remote backend with appropriate access controls and state locking support.

## CI/CD and Container Image Delivery

The CI/CD pipeline automates the application delivery process.

### Stage 1 — Build

- Build the custom Odoo Docker image using the Dockerfile.
- Tag the image with an identifiable version, such as the Git commit SHA.

### Stage 2 — Test

- Validate the available application and deployment configurations.
- Run the tests configured for the project.
- Verify that the container image builds successfully.

### Stage 3 — Deploy

- Publish the image to the configured container registry.
- Update the Kubernetes Deployment manifest with the intended image tag.
- Commit and push the manifest change to Git so Argo CD can reconcile it.

Using versioned image tags helps identify which application revision is deployed and supports more controlled rollbacks.

## GitOps with Argo CD

Argo CD manages the synchronization of Kubernetes resources from the Git repository.

The deployment workflow is:

1. A change is committed and pushed to the Git repository.
2. The CI/CD pipeline builds and publishes the application image when required.
3. The desired image version is recorded in the Kubernetes manifest.
4. Argo CD detects the updated configuration.
5. Argo CD synchronizes the manifests according to the configured sync policy.
6. Kubernetes reconciles the resources and maintains the declared workloads.

Argo CD provides visibility into application synchronization status, resource health, deployment revisions, and synchronization history.

## Kubernetes Deployment on K3s

K3s provides a lightweight Kubernetes environment for running the Odoo application and PostgreSQL database on AWS EC2.

The Kubernetes configuration includes:

- **Odoo Deployment:** Manages the Odoo application pods.
- **PostgreSQL Deployment:** Runs the database workload.
- **Services:** Provide stable internal network endpoints.
- **PersistentVolumeClaim:** Requests persistent storage for PostgreSQL.
- **Ingress:** Configures application traffic routing.
- **Kustomize:** Organizes the Kubernetes manifests into a deployable configuration.

Argo CD monitors the configured Git repository and applies changes to the cluster according to the application's synchronization policy.

## Monitoring and Observability

The monitoring stack combines Grafana Alloy, Loki, and Grafana to provide a central place to investigate application logs.

### Grafana Alloy — Log Collection

Alloy discovers Kubernetes workloads, reads container logs using the configured collection method, and forwards the logs to Loki.

### Grafana Loki — Log Aggregation

Loki stores logs and makes them searchable using labels and LogQL queries. It helps investigate application errors, database connection issues, and other operational events.

### Grafana — Visualization

Grafana connects to Loki as a data source and provides an interface for exploring logs and creating dashboards.

### Monitoring Workflow

```text
Odoo / PostgreSQL Pods
          |
          v
     Grafana Alloy
          |
          v
      Grafana Loki
          |
          v
        Grafana
```

### Example LogQL Queries

View logs from the Odoo namespace:

```logql
{namespace="odoo"}
```

Search for error-related messages:

```logql
{namespace="odoo"} |~ "(?i)error|exception|traceback"
```

Count matching error-related log lines over rolling five-minute windows:

```logql
sum(count_over_time({namespace="odoo"} |~ "(?i)error|exception|traceback" [5m]))
```

These queries depend on Alloy collecting the relevant logs and Loki receiving streams with the expected labels.

## Screenshots

### Argo CD Dashboard

![Argo CD Dashboard](argocd/argocd_dashboard.png)

Shows the Argo CD interface for inspecting application synchronization and Kubernetes resource health.

### Grafana Monitoring Dashboard

![Grafana Dashboard](Monitoring/grafana_dashboard.png)

Shows the configured Grafana visualization dashboard.

### Grafana Logs

![Grafana Logs](Monitoring/grafana_logs.png)

Shows the log exploration interface used to search and investigate collected logs.

## Security Considerations

- Apply least-privilege IAM policies.
- Protect access to the Kubernetes API, Argo CD, and Grafana.
- Store credentials in an appropriate secrets-management mechanism rather than Git.
- Use appropriately scoped registry credentials for private container images.
- Restrict security group rules to the network access actually required.
- Never commit Terraform state files, AWS access keys, passwords, private keys, or secret-bearing configuration files.
- Configure persistent database storage and backups according to the required recovery objectives.

## Project Status

Update this checklist as each part of the implementation is verified.

- [ ] Terraform provisions the required AWS resources.
- [ ] The Odoo image builds successfully.
- [ ] The CI/CD pipeline validates and publishes the application image.
- [ ] Argo CD synchronizes the Kubernetes manifests.
- [ ] Odoo 20 and PostgreSQL run successfully on K3s.
- [ ] Alloy collects and forwards container logs.
- [ ] Loki receives and stores logs.
- [ ] Grafana queries Loki and displays the collected logs.

## Future Improvements

- Add automated Terraform validation, planning, and controlled apply workflows.
- Implement image vulnerability scanning.
- Configure automated PostgreSQL backups and verify restoration.
- Add Kubernetes resource metrics and alerting.
- Integrate AWS CloudWatch and CloudTrail for AWS observability.
- Implement documented deployment rollback and recovery procedures.

## Conclusion

This project brings together Infrastructure as Code, containerization, CI/CD, GitOps, Kubernetes orchestration, and observability in an end-to-end DevOps workflow.

By integrating Terraform, AWS, Docker, Argo CD, K3s, Loki, Grafana Alloy, and Grafana, the architecture aims to make infrastructure management repeatable, deployments traceable, and operational troubleshooting more effective.

---

**Author:** Nitheesh C

**LinkedIn:** https://www.linkedin.com/in/nitheesh1632
