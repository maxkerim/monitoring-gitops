# Monitoring GitOps Stack for Rails App

Репозиторий содержит конфигурацию для развёртывания Rails-приложения в Kubernetes и GitOps-управления им через Argo CD. В комплект входят Helm-чарты приложения и компонентов мониторинга, а также конфигурация сбора метрик и логов.

Ранее репозиторий назывался [Oshtuk/monitoring-gitops](https://github.com/Oshtuk/monitoring-gitops). Текущий репозиторий: [maxkerim/monitoring-gitops](https://github.com/maxkerim/monitoring-gitops).

---

## Стек технологий

| Компонент        | Назначение                                   |
|------------------|-----------------------------------------------|
| **Kubernetes**   | Платформа оркестрации                        |
| **ArgoCD**       | GitOps для автоматической синхронизации      |
| **Helm**         | Пакетный менеджер для K8s приложений         |
| **Grafana**      | Визуализация метрик                          |
| **VictoriaMetrics** | Хранение и сбор метрик                    |
| **Fluent Bit**   | Сбор и пересылка логов                       |
| **Rails**        | Основное приложение                          |

---

## Структура репозитория

```text
.
├── argo-apps/            # ArgoCD приложения
│   └── rails-app.yaml    # Application CRD для Rails
├── charts/               # Helm-чарты
│   ├── rails-app/        # Helm-чарт для Rails
│   ├── grafana/
│   ├── fluent-bit/
│   └── ...
├── apps/                 # Kustomize директории
│   └── rails-app/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── kustomization.yaml
└── README.md             # Этот файл
