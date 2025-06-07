global:
  telegram_api_url: 'https://api.telegram.org'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'stardata-telegram'

receivers:
- name: 'stardata-telegram'
  telegram_configs:
  - bot_token: ${TELEGRAM_TOKEN_API}
    api_url: https://api.telegram.org
    chat_id: ${TELEGRAM_CHAT_ID}
    parse_mode: ''
    send_resolved: true
    message: |
    
        🚨 *{{ .Status | toUpper }}* ‼️  
        {{ if eq .Status "firing" }}🔥 *Alert Triggered* 🔥{{ else }}✅ *Alert Resolved* ✅{{ end }} 
        ====================================  

        {{ range .Alerts }}
        *📌 Summary:*  
        {{ .Annotations.summary }}  

        *🌐 Instance Affected:*  
        `{{ .Labels.instance }}`  

        *🕒 Triggered At:*  
        {{ .StartsAt.Format "2006-01-02 15:04:05 UTC" }}  

        {{ if .Annotations.description }}
        *📝 Details:*  
        {{ .Annotations.description }}  
        {{ end }}
        ====================================  
        {{ end }}
