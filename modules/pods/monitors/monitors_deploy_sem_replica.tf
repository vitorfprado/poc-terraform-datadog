terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.88.0"
    }
  }
}

resource "datadog_monitor" "Monitor_Deploy_Sem_Replicas" {
  name = var.monitor_name
  type = "query alert"
  query = <<EOT
max(last_2m):(min:kubernetes_state.deployment.replicas_ready{kube_namespace:${var.namespace}, kube_deployment:${var.deployment}} by {kube_cluster_name,kube_namespace,kube_deployment} / avg:kubernetes_state.deployment.replicas_desired{kube_namespace:${var.namespace} , kube_deployment:${var.deployment}} by {kube_cluster_name,kube_namespace,kube_deployment}) * 100 < 40
EOT
  message = <<EOT
{{#is_warning}}

⚠️ *COMUNICADO TÉCNICO — Deploy com poucas réplicas - ${var.deployment}*  

;*Produto:* ${var.product_name},  

*Data/Hora:* {{local_time 'first_triggered_at' 'America/Sao_Paulo'}},  

*Descrição Técnica:* Nosso sistema de monitoramento identificou que o deploy ${var.deployment} está com poucas réplicas, o que pode causar instabilidade e falhas parciais no consumo de mensagens pelos serviços do ${var.product_name}.  

*Acionamento:* O Time de Produção já foi acionado e acompanha em tempo real o comportamento dos recursos para mitigar o risco de impacto aos serviços e ao deploy com poucas réplicas.  

*Ações em andamento:*  
- Monitoramento contínuo do deploy em tempo real (Datadog)  
- Ajustes preventivos de recursos e priorização de workloads críticos  

*Impacto esperado:* Risco de instabilidade ou falhas parciais no consumo de mensagens pelos serviços do ${var.product_name}.  

*Próxima atualização:* Novo comunicado será emitido caso haja evolução no cenário ou necessidade de ação operacional pelos PDVs.  

*Link do alerta:* [https://app.datadoghq.com/monitors/{{monitor_id}}],  

Operações Tech — CRMBonus  
Monitoramento & Observabilidade  
Atuando de forma preditiva para garantir disponibilidade e performance,  

@teams-NOC-Dataside  
@googlechat-OperaçãoTech-CriseGiftback  

{{/is_warning}}


{{#is_alert}} 

🚨 *COMUNICADO TÉCNICO — Deploy sem réplicas - ${var.deployment}*  

;*Produto:* ${var.product_name},  

*Data/Hora:* {{local_time 'last_triggered_at' 'America/Sao_Paulo'}},  

*Descrição Técnica:* Nosso sistema de monitoramento identificou que o deploy ${var.deployment} está sem réplicas, o que pode impedir o consumo de mensagens pelos serviços do ${var.product_name}.  

*Acionamento:* O Time de Produção já foi acionado e acompanha em tempo real o comportamento dos recursos para mitigar o risco de impacto aos serviços e ao deploy sem réplicas.  

*Ações em andamento:*  
- Monitoramento contínuo do deploy em tempo real (Datadog)  
- Ajustes preventivos de recursos e priorização de workloads críticos  

*Impacto esperado:* Falha no consumo de mensagens pelos serviços do ${var.product_name}, com risco de indisponibilidade parcial ou total.  

*Próxima atualização:* Novo comunicado será emitido caso haja evolução no cenário ou necessidade de ação operacional pelos PDVs.  

*Link do alerta:* [https://app.datadoghq.com/monitors/{{monitor_id}}],  

Operações Tech — CRMBonus  
Monitoramento & Observabilidade  
Atuando de forma preditiva para garantir disponibilidade e performance;  

@opsgenie-TI-N1-NOC  
@teams-NOC-Dataside  
@hangouts-OperaçãoTech-CriseGiftback  
@webhook-WhatsApp  

{{/is_alert}}


{{#is_alert_recovery}}

✅ *COMUNICADO TÉCNICO — Normalização do deploy do ${var.deployment}.*  

;*Produto:* Giftback,  

*Data/Hora:* {{local_time 'last_triggered_at' 'America/Sao_Paulo'}},  
 
*Tempo de duração:* {{eval "int(triggered_duration_sec / 60)"}} min,  

*Descrição Técnica:* Nosso sistema de monitoramento identificou a normalização do deploy do prod-giftback-consumers-webserver, com réplicas restabelecidas e funcionamento dentro dos parâmetros esperados.  

*Situação Atual:* O comportamento do recurso encontra-se estável e dentro dos limites operacionais definidos, não havendo risco de impacto aos serviços.  

*Ações realizadas:*  
- Monitoramento contínuo do deploy em tempo real (Datadog)  
- Ajustes aplicados e workloads críticos estabilizados  

*Impacto esperado:* Não há risco de falha ou indisponibilidade no consumo de mensagens pelos serviços do ${var.product_name}.  

*Próxima atualização:* Não há necessidade de novas comunicações, salvo ocorrência de novos eventos.  

*Link do alerta:* [https://app.datadoghq.com/monitors/{{monitor_id}}],  

Operações Tech — CRMBonus  
Monitoramento & Observabilidade  
Atuando de forma preditiva para garantir disponibilidade e performance,  

@opsgenie-TI-N1-NOC  
@teams-NOC-Dataside  
@hangouts-OperaçãoTech-CriseGiftback  
@webhook-WhatsApp  

{{/is_alert_recovery}}
EOT
  tags = ["team:${var.team}", "service:${var.product_name}"]
  priority = 1
  draft_status = "draft"
  new_group_delay = 60
  on_missing_data = "resolve"
  require_full_window = false
  monitor_thresholds {
    critical = 40
    warning = 50
  }
}