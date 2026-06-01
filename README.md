# Cloud Image App

## Projektname

`cloud-image-app`

## Ziel von Part I

Part I erstellt die Basis-Infrastruktur fuer eine Cloud Image App in Azure mit Terraform.

Der aktuelle Stand erstellt:

- eine Azure Resource Group
- einen Azure Storage Account
- einen privaten Blob Container fuer Bilder
- einen privaten Blob Container fuer Terraform Remote State
- einen Azure Key Vault
- RBAC-Rollen fuer die aktuell angemeldete Azure Identity

App Service Ressourcen sind noch nicht erstellt. `terraform/appservice.tf` ist aktuell leer und kann in einem spaeteren Teil ergaenzt werden.

## Ordnerstruktur

```text
.
|-- docs/
|   |-- 1-description.md
|   |-- 2-approach-and-why.md
|   |-- 3-connections-between-resources.md
|   |-- 4-authentication-identity-context.md
|   |-- 5-repository-content.md
|   |-- 6-terraform-definition.md
|   `-- 7-remote-state-explanation.md
|-- scripts/
|   |-- init.ps1
|   |-- plan.ps1
|   |-- apply.ps1
|   `-- set-path.ps1
|-- terraform/
|   |-- backend.tf
|   |-- provider.tf
|   |-- variables.tf
|   |-- main.tfvars.example
|   |-- locals.tf
|   |-- rg.tf
|   |-- storage.tf
|   |-- container.tf
|   |-- keyvault.tf
|   |-- random.tf
|   |-- outputs.tf
|   `-- appservice.tf
|-- .gitignore
`-- README.md
```

## Voraussetzungen

Vor dem Ausfuehren der Terraform-Definition muessen diese Voraussetzungen erfuellt sein:

- Azure Account oder Azure for Students Subscription
- Azure CLI installiert
- Terraform installiert
- PowerShell oder VS Code Terminal
- Azure Login wurde mit `az login` ausgefuehrt
- `terraform/main.tfvars` wurde lokal aus `terraform/main.tfvars.example` erstellt

Der Azure Login muss vor Terraform ausgefuehrt werden:


```powershell
az login
```

Danach sollte die richtige Subscription ausgewaehlt sein:

```powershell
az account show
```

Falls noetig, kann die Subscription gesetzt werden:

```powershell
az account set --subscription "<subscription-id>"
```

## Lokale Variablen

Die Datei `terraform/main.tfvars` enthaelt lokale Werte wie Subscription ID und Tenant ID. Diese Datei soll nicht ins Git Repository committed werden.

Deshalb gibt es die Vorlage `terraform/main.tfvars.example`. Eine neue Person erstellt daraus lokal ihre eigene `main.tfvars`:

```powershell
Copy-Item .\terraform\main.tfvars.example .\terraform\main.tfvars
```

Danach muessen in `terraform/main.tfvars` mindestens diese Werte angepasst werden:

- `subscription_id`
- `tenant_id`

`main.tfvars` ist in `.gitignore` ausgeschlossen und soll nicht committed werden, weil die Datei lokale und umgebungsspezifische Werte enthaelt.

## Terraform ausfuehren

Die Terraform-Befehle werden ueber PowerShell-Skripte im `scripts` Ordner ausgefuehrt. Die Befehle werden aus dem Hauptordner des Projekts gestartet.

Reihenfolge:

1. Bei Azure anmelden:

```powershell
az login
```

2. Terraform initialisieren:


```powershell
.\scripts\init.ps1
```

3. Terraform Plan pruefen:

```powershell
.\scripts\plan.ps1
```

4. Terraform Deployment ausfuehren:

```powershell
.\scripts\apply.ps1
```

Die Skripte wechseln automatisch in den `terraform` Ordner und fuehren dort die Terraform-Befehle aus.

## Remote State

Das Projekt verwendet Terraform Remote State in Azure Blob Storage. Die Backend-Konfiguration steht in `terraform/backend.tf`.

Der State wird im Container `tfstate` als Blob `cloud-image-app.tfstate` gespeichert. Der Backend-Zugriff verwendet Azure AD Authentifizierung:

```hcl
use_azuread_auth = true
```

Wichtig: Der Storage Account und der Container fuer den Remote State muessen vorhanden sein, bevor `terraform init` erfolgreich laufen kann. Falls das Backend noch nicht existiert, muss es einmalig vorbereitet oder gebootstrapped werden.

Weitere Details stehen in `docs/7-remote-state-explanation.md`.
