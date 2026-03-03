# Copie este arquivo para backend.s3.hcl e preencha com os valores do seu bucket.
# Não commite backend.s3.hcl (ele está no .gitignore).
#
# Uso local:
#   terraform init -backend-config=backend.s3.hcl
#
# No GitHub Actions, o workflow usa os secrets para montar essa config automaticamente.

bucket  = "SEU-BUCKET-TERRAFORM-STATE"
key     = "datadog/terraform.tfstate"
region  = "us-east-1"
encrypt = true
