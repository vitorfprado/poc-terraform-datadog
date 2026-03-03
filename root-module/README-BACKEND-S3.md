# Backend Terraform no S3

O state do Terraform está configurado para usar o backend **S3** (configuração parcial). Os parâmetros do bucket são passados na hora do `terraform init`.

## Uso local

1. Copie o exemplo e preencha com os dados do seu bucket:

   ```bash
   cp backend.s3.example.hcl backend.s3.hcl
   # Edite backend.s3.hcl com bucket, key e region
   ```

2. Inicialize o Terraform:

   ```bash
   terraform init -backend-config=backend.s3.hcl
   ```

3. Se você já tinha state local e quer migrar para o S3:

   ```bash
   terraform init -backend-config=backend.s3.hcl -migrate-state
   ```

Não commite o arquivo `backend.s3.hcl` (ele está no `.gitignore`).

## GitHub Actions

O workflow usa **secrets** do repositório para montar o backend. Configure no repositório (Settings → Secrets and variables → Actions):

| Secret | Descrição |
|--------|-----------|
| `AWS_ACCESS_KEY_ID` | Access key da IAM usada pelo workflow |
| `AWS_SECRET_ACCESS_KEY` | Secret key da IAM |
| `AWS_REGION` | Região do bucket (ex.: `us-east-1`) |
| `TF_STATE_BUCKET` | Nome do bucket S3 do state |
| `TF_STATE_KEY` | Caminho do state no bucket (ex.: `datadog/terraform.tfstate`) |

Depois de criar o bucket e configurar os secrets, o workflow passará a usar o state remoto no S3.

## Recursos na AWS

Antes de usar o backend, crie apenas o **bucket S3**:

- **Bucket S3**  
  - Versionamento habilitado (recomendado).  
  - Criptografia (ex.: AES-256).  
  - Bloqueio contra deleção acidental (opcional).

Exemplo com AWS CLI:

```bash
aws s3api create-bucket --bucket SEU-BUCKET --region us-east-1
aws s3api put-bucket-versioning --bucket SEU-BUCKET --versioning-configuration Status=Enabled
```

A IAM do usuário/role do workflow precisa de permissão apenas no bucket (s3:GetObject, s3:PutObject, s3:DeleteObject, s3:ListBucket). DynamoDB não é utilizado.
