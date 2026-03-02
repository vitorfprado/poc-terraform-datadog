# GitHub Actions - Terraform Pipelines

Este diretório contém os templates de pipeline reutilizáveis (reusable workflows) para deploy do Terraform usando GitHub Actions.

## Estrutura

```
.github/
├── workflows/
│   ├── templates/
│   │   ├── terraform-plan.yml          # Reusable workflow para Terraform Plan
│   │   ├── terraform-apply.yml         # Reusable workflow para Terraform Apply
│   │   ├── terraform-destroy-plan.yml  # Reusable workflow para Terraform Destroy Plan
│   │   └── terraform-destroy-apply.yml # Reusable workflow para Terraform Destroy Apply
│   └── terraform-deploy.yml            # Workflow principal que consome os templates
└── README.md                            # Este arquivo
```

## Reusable Workflows (Templates)

Os reusable workflows são independentes e podem ser reutilizados em outros projetos. Cada workflow aceita os seguintes inputs:

### Inputs Comuns

- `terraform_version`: Versão do Terraform a ser instalada (ex.: '1.6.0')
- `working_directory`: Diretório onde o Terraform será executado (ex.: 'root-module')

### Secrets Obrigatórios

Todos os templates requerem os seguintes secrets (repasse no workflow que chama o template):

- `DATADOG_API_KEY`, `DATADOG_APP_KEY`: Datadog
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`: AWS (backend S3 e credenciais)
- `TF_STATE_BUCKET`, `TF_STATE_KEY`: Bucket e chave do state no S3

### Workflows Específicos

#### terraform-plan.yml
Executa `terraform plan` e publica o plano como artefato.

**Outputs:**
- `plan_artifact_name`: Nome do artefato do plano (valor: 'terraform-plan')

#### terraform-apply.yml
Baixa o plano do artefato e executa `terraform apply -auto-approve`. A aprovação manual é feita pelo environment no workflow chamador (ex.: `apply-approval`).

#### terraform-destroy-plan.yml
Executa `terraform plan -destroy` e publica o plano de destruição como artefato.

**Outputs:**
- `destroy_plan_artifact_name`: Nome do artefato do plano de destruição (valor: 'terraform-destroy-plan')

#### terraform-destroy-apply.yml
Baixa o plano de destruição do artefato e executa `terraform apply` para destruir recursos. A aprovação manual é feita pelo environment no workflow chamador (ex.: `destroy-approval`).

## Workflow Principal

O workflow principal (`terraform-deploy.yml`) **consome os templates** (reusable workflows) e orquestra os jobs:

1. **plan**: Executa `terraform plan` em todas as branches e pull requests
2. **apply**: Executa `terraform apply` após o plan bem-sucedido **com aprovação manual no environment `apply-approval`**
3. **destroy-plan**: Executa `terraform plan -destroy` quando acionado manualmente com `destroy: true`
4. **destroy-apply**: Executa o apply do destroy após destroy-plan bem-sucedido **com aprovação manual no environment `destroy-approval`**

## Configuração

### Secrets do GitHub

Configure os seguintes secrets no GitHub (Settings > Secrets and variables > Actions):

- `DATADOG_API_KEY`: Chave da API do Datadog
- `DATADOG_APP_KEY`: Chave da aplicação do Datadog
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`: Credenciais do usuário de serviço para S3 (state) e uso nos templates
- `TF_STATE_BUCKET`, `TF_STATE_KEY`: Nome do bucket e chave do state no S3

**Importante**: O workflow principal (`terraform-deploy.yml`) chama os reusable workflows (templates); os secrets são repassados explicitamente em cada job via `secrets:`.

### Variáveis de Ambiente

O workflow usa as seguintes variáveis de ambiente (podem ser sobrescritas):

- `TERRAFORM_VERSION`: Versão do Terraform (padrão: '1.6.0')
- `WORKING_DIRECTORY`: Diretório de trabalho (padrão: 'root-module')

### Configuração dos Environments para Aprovação Manual

O workflow usa dois environments para exigir aprovação antes de aplicar mudanças:

| Environment        | Quando é usado | Descrição                          |
|--------------------|----------------|------------------------------------|
| `apply-approval`   | Após o **plan** (deploy normal) | Pausa até aprovação antes do `terraform apply` |
| `destroy-approval` | Após o **destroy-plan**         | Pausa até aprovação antes do destroy apply     |

**Como configurar cada environment:**

1. Vá em **Settings** > **Environments** no seu repositório
2. Clique em **New environment**
3. Crie os dois environments com os nomes exatos: `apply-approval` e `destroy-approval`
4. Em cada um, em **Required reviewers**, adicione os usuários ou equipes que devem aprovar
5. (Opcional) Configure tempo de espera para aprovação
6. Salve

**Importante**: Sem criar os environments com esses nomes, o workflow falhará ao tentar executar o job **apply** ou **destroy-apply**.

### Acionamento Manual e Aprovação

**Fluxo normal (plan → apply):**
1. Dispare o workflow (manual ou push na `main`)
2. O **plan** roda e gera o plano
3. O workflow **pausa** no environment `apply-approval`
4. Um revisor aprovado deve clicar em **Review deployments** e aprovar
5. Após aprovação, o **apply** é executado

**Para executar o destroy workflow:**

1. Vá para **Actions** no GitHub
2. Selecione o workflow "Terraform Deploy"
3. Clique em **Run workflow**
4. Marque a opção **"Execute destroy workflow"**
5. No campo **"destroy_confirmation"**, digite exatamente **`DESTROY`** (em maiúsculas) para confirmar que você tem certeza — o destroy remove recursos de forma permanente
6. Execute o workflow

**Fluxo de Aprovação do Destroy:**
1. O workflow executará o `destroy-plan` automaticamente
2. Após o plan ser concluído, o workflow **pausará** aguardando aprovação no environment `destroy-approval`
3. Um revisor configurado deve **aprovar manualmente** (Review deployments)
4. Após a aprovação, o `destroy-apply` será executado

## Uso em Outros Projetos

Para usar estes reusable workflows em outros projetos:

### Opção 1: Copiar para o novo projeto

1. Copie a pasta `.github/workflows/templates/` para o novo projeto
2. Crie um workflow que consuma os templates:

```yaml
name: Deploy Infrastructure

on:
  push:
    branches: [main]

jobs:
  plan:
    uses: ./.github/workflows/templates/terraform-plan.yml
    with:
      terraform_version: '1.6.0'
      working_directory: 'infrastructure'
    secrets:
      DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
      DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_STATE_BUCKET: ${{ secrets.TF_STATE_BUCKET }}
      TF_STATE_KEY: ${{ secrets.TF_STATE_KEY }}

  apply:
    needs: plan
    uses: ./.github/workflows/templates/terraform-apply.yml
    with:
      terraform_version: '1.6.0'
      working_directory: 'infrastructure'
    secrets:
      DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
      DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_STATE_BUCKET: ${{ secrets.TF_STATE_BUCKET }}
      TF_STATE_KEY: ${{ secrets.TF_STATE_KEY }}
```

### Opção 2: Usar de um repositório remoto

Se você publicar os workflows em um repositório separado:

```yaml
jobs:
  plan:
    uses: seu-org/terraform-workflows/.github/workflows/templates/terraform-plan.yml@main
    with:
      terraform_version: '1.6.0'
      working_directory: 'infrastructure'
    secrets:
      DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
      DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_STATE_BUCKET: ${{ secrets.TF_STATE_BUCKET }}
      TF_STATE_KEY: ${{ secrets.TF_STATE_KEY }}
```

## Exemplo Completo de Uso

```yaml
name: Deploy Infrastructure

on:
  push:
    branches: [main]

env:
  TERRAFORM_VERSION: '1.6.0'
  WORKING_DIRECTORY: 'infrastructure'

jobs:
  plan:
    uses: ./.github/workflows/templates/terraform-plan.yml
    with:
      terraform_version: ${{ env.TERRAFORM_VERSION }}
      working_directory: ${{ env.WORKING_DIRECTORY }}
    secrets:
      DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
      DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_STATE_BUCKET: ${{ secrets.TF_STATE_BUCKET }}
      TF_STATE_KEY: ${{ secrets.TF_STATE_KEY }}

  apply:
    needs: plan
    if: github.ref == 'refs/heads/main'
    uses: ./.github/workflows/templates/terraform-apply.yml
    with:
      terraform_version: ${{ env.TERRAFORM_VERSION }}
      working_directory: ${{ env.WORKING_DIRECTORY }}
    secrets:
      DATADOG_API_KEY: ${{ secrets.DATADOG_API_KEY }}
      DATADOG_APP_KEY: ${{ secrets.DATADOG_APP_KEY }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_STATE_BUCKET: ${{ secrets.TF_STATE_BUCKET }}
      TF_STATE_KEY: ${{ secrets.TF_STATE_KEY }}
```

## Vantagens dos Reusable Workflows

- **Encapsulamento completo**: Cada workflow é um job completo com seu próprio `runs-on`
- **Melhor para templates**: Ideal para reutilização entre projetos diferentes
- **Secrets explícitos**: Controle total sobre quais secrets são passados
- **Outputs entre workflows**: Possibilidade de passar outputs entre workflows chamados
- **Environments**: Suporte completo a environments e aprovações manuais

## Notas

- Os reusable workflows executam em runners separados (cada um tem seu próprio `runs-on`)
- As variáveis do Datadog são automaticamente configuradas via secrets passados explicitamente
- Os planos são mantidos por 5 dias como artefatos
- O workflow valida e formata o código Terraform antes de executar o plan
- **Importante**: Sempre passe os secrets explicitamente usando `secrets:` ao chamar reusable workflows
