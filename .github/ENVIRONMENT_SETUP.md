# Configuração do Environment para Aprovação Manual

Este documento explica como configurar o environment `destroy-approval` no GitHub para habilitar aprovação manual antes de executar o destroy do Terraform.

**Nota**: Este projeto usa **Reusable Workflows** para os templates Terraform. O environment é configurado no workflow principal (`terraform-deploy.yml`) no job `destroy-apply`.

## Por que usar aprovação manual?

A aprovação manual adiciona uma camada extra de segurança ao processo de destruição de recursos. Após o `terraform plan -destroy` ser executado, um revisor deve aprovar manualmente antes que o `terraform apply` seja executado para destruir os recursos.

## Passo a Passo

### 1. Acessar as configurações do repositório

1. No seu repositório GitHub, vá em **Settings**
2. No menu lateral, clique em **Environments** (ou **Ambientes**)

### 2. Criar o Environment

1. Clique em **New environment**
2. Digite o nome: `destroy-approval`
3. Clique em **Configure environment**

### 3. Configurar Aprovadores

1. Em **Required reviewers**, clique em **Add reviewer**
2. Selecione os usuários ou equipes que devem aprovar o destroy
   - Você pode adicionar múltiplos revisores
   - Todos os revisores devem aprovar (padrão) ou configure para apenas um aprovar
3. (Opcional) Configure um **Wait timer** se desejar um tempo mínimo antes da aprovação
4. Clique em **Save protection rules**

### 4. Configurações Adicionais (Opcional)

Você também pode configurar:

- **Deployment branches**: Restringir quais branches podem usar este environment
- **Environment secrets**: Secrets específicos para este environment
- **Environment variables**: Variáveis específicas para este environment

## Como Funciona

1. Quando o workflow `terraform-deploy.yml` é executado com `destroy: true`:
   - O job `destroy-plan` executa automaticamente
   - O job `destroy-apply` **pausa** aguardando aprovação

2. O GitHub enviará notificações para os revisores configurados

3. Os revisores podem:
   - Ver o plano de destruição nos logs do `destroy-plan`
   - Aprovar ou rejeitar o destroy
   - Adicionar comentários

4. Após a aprovação:
   - O job `destroy-apply` continua automaticamente
   - Os recursos são destruídos conforme o plano

## Visualizando a Aprovação Pendente

Quando um workflow está aguardando aprovação:

1. Vá em **Actions** no GitHub
2. Clique no workflow em execução
3. Você verá o job `destroy-apply` com status **"Waiting"**
4. Os revisores verão um botão **"Review deployments"** para aprovar ou rejeitar

## Exemplo de Configuração

```
Environment: destroy-approval
Required reviewers:
  - @seu-usuario
  - @equipe-devops
Wait timer: 0 minutes
Deployment branches: All branches
```

## Troubleshooting

### O workflow falha com erro de environment não encontrado

**Solução**: Certifique-se de que o environment `destroy-approval` foi criado exatamente com esse nome no repositório.

### Não recebo notificações de aprovação

**Solução**: Verifique suas configurações de notificação do GitHub e certifique-se de que você está nos revisores do environment.

### Quero remover a aprovação manual temporariamente

**Solução**: Você pode comentar a seção `environment` no workflow ou criar um environment sem revisores obrigatórios. **Não recomendado para produção!**

## Segurança

⚠️ **Importante**: 
- Sempre revise o plano de destruição antes de aprovar
- Configure múltiplos revisores para ambientes críticos
- Use deployment branches para restringir quais branches podem destruir recursos
- Considere usar wait timers para evitar destruições acidentais
