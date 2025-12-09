Homework 5 — Terraform VPC & EKS

Мета роботи
- Створити VPC за допомогою Terraform
- Розгорнути EKS кластер
- Підключитися до кластера через kubectl
- Перевірити доступність нод

Структура проєкту
- lesson-5-6-terraform-eks
  - eks
     - main.tf
     - variables.tf
     - outputs.tf
  - vpc
     - main.tf
     - variables.tf
     - outputs.tf
     - root
 - main.tf
 - variables.tf
 - outputs.tf
 - backend.tf
 - terraform.tf
 - README.md

Запуск Terraform
Виконані команди:
- terraform init
- terraform plan
- terraform apply

Результат terraform apply
- Створено 61 ресурс
- EKS кластер успішно створений
- Назва кластера: mlops-eks-eks
- Статус кластера: ACTIVE


Перевірка доступу до кластера
Виконано команду:
kubectl get nodes

Результат:
2 ноди у статусі Ready
Версія Kubernetes: v1.29.15

---

terraform plan — виконано
terraform apply — виконано успішно
AWS EKS кластер у статусі ACTIVE
kubectl get nodes — ноди у статусі Ready
Скріншоти додані .

---


Після перевірки виконано:

terraform destroy