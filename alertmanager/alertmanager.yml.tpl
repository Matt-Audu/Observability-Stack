global:
  resolve_timeout: 5m
  telegram_api_url: 'https://api.telegram.org'

templates:
  - '/etc/alertmanager/templates/*.tmpl'

route:
  group_by: ['alertname', 'severity']
  group_wait: 10s
  group_interval: 30s
  repeat_interval: 3h
  receiver: 'telegram-all-alerts'

receivers:
- name: 'telegram-all-alerts'
  telegram_configs:
  - bot_token: ${TELEGRAM_TOKEN_API}
    api_url: https://api.telegram.org
    chat_id: ${TELEGRAM_CHAT_ID}
    parse_mode: 'HTML'
    send_resolved: true
    message: '{{ template "telegram.unified.message" . }}'
