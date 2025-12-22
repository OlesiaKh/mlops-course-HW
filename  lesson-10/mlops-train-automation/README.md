
# MLOps Train Automation (AWS Step Functions)

Цей проєкт демонструє автоматизований запуск ML-пайплайна через AWS Step Functions,
який викликає кілька Lambda-функцій послідовно.

## Архітектура
Step Function:
- ValidateData → LogMetrics

Кожен етап реалізований як окрема AWS Lambda-функція.

---
## Step Function

State Machine створена через Terraform і складається з двох послідовних кроків:
1. ValidateData — викликає Lambda-функцію для умовної валідації вхідних даних
2. LogMetrics — викликає Lambda-функцію для логування умовних метрик

Step Function приймає JSON-вхідні параметри, які передаються між кроками.

Pipeline GitLab CI запускається автоматично при кожному `git push`.
Job `train-model` використовує офіційний Docker-образ AWS CLI та
викликає AWS Step Function через команду `aws stepfunctions start-execution`.

## Структура проєкту
mlops-train-automation/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── lambda/
│       ├── validate.py
│       ├── log_metrics.py
│       ├── validate.zip
│       └── log_metrics.zip
├── .gitlab-ci.yml
└── README.md

---

## Збірка Lambda-архівів

```bash
cd terraform/lambda
zip validate.zip validate.py
zip log_metrics.zip log_metrics.py


## Розгортання інфраструктури (Terraform)
cd terraform
terraform init
terraform apply

## Ручний запуск Step Function

aws stepfunctions start-execution \
  --state-machine-arn <STATE_MACHINE_ARN> \
  --name "manual-$(date +%s)" \
  --input '{"source":"manual","commit":"test"}'

## Команда, яка виконується в CI:

aws stepfunctions start-execution \
  --state-machine-arn "$STATE_MACHINE_ARN" \
  --name "train-$CI_PIPELINE_ID-$CI_COMMIT_SHORT_SHA" \
  --input "{\"source\":\"gitlab-ci\",\"commit\":\"$CI_COMMIT_SHORT_SHA\",\"pipeline_id\":\"$CI_PIPELINE_ID\"}"


Необхідні змінні в GitLab CI:

STATE_MACHINE_ARN

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

(опційно) AWS_DEFAULT_REGION=eu-north-1