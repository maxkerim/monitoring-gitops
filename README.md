# Monitoring GitOps

GitOps-конфигурация Kubernetes для Rails-приложения и стека мониторинга. Argo CD управляет приложениями, Helm — их релизами; метрики хранятся в VictoriaMetrics, логи собирает Fluent Bit.

## Структура

```text
.
├── argo-apps/
│   ├── monitoring.yaml       # корневое Argo CD Application (App of Apps)
│   └── apps/                 # дочерние Argo CD Applications
├── charts/                   # локальные Helm-чарты
│   ├── rails-app/
│   └── vmagent/
├── apps/rails-app/            # Rails приложение и исходные Kubernetes manifests
└── .github/workflows/         # CI: helm lint и kubeconform
```

Grafana, Fluent Bit, VictoriaLogs и VictoriaMetrics используют upstream Helm charts. Их Argo CD Applications находятся в `argo-apps/apps/` рядом с приложениями, использующими локальные charts. В `charts/` находятся только локальные Helm charts.

## Развёртывание

Требуются Kubernetes, Argo CD с установленным namespace `argocd` и `kubectl` с доступом к кластеру. Создайте namespace и Secret Grafana до установки приложений:

```sh
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
read -rsp 'Rails master key: ' RAILS_MASTER_KEY && echo
kubectl -n monitoring create secret generic rails-app-master-key \
	--from-literal=master-key="$RAILS_MASTER_KEY" \
	--dry-run=client -o yaml | kubectl apply -f -
unset RAILS_MASTER_KEY
read -rsp 'Grafana admin password: ' GRAFANA_ADMIN_PASSWORD && echo
kubectl -n monitoring create secret generic grafana-admin \
	--from-literal=admin-user=admin \
	--from-literal=admin-password="$GRAFANA_ADMIN_PASSWORD" \
	--dry-run=client -o yaml | kubectl apply -f -
unset GRAFANA_ADMIN_PASSWORD
kubectl apply -f argo-apps/monitoring.yaml
```

Корневое приложение синхронизирует manifests из `argo-apps/apps/`. Оно создаёт дочерние Argo CD Applications; те разворачивают локальные charts из `charts/` или upstream charts. Измените namespace, адрес репозитория, версии upstream charts и values под свой кластер перед production-развёртыванием.

## Секреты

`apps/rails-app/config/master.key` не хранится в Git. Зашифрованный `apps/rails-app/config/credentials.yml.enc` хранится в Git и может быть расшифрован только соответствующим ключом. Для production задайте отдельный `RAILS_MASTER_KEY` через Kubernetes Secret или внешний secret manager и не используйте ключ разработки. Если ключ был опубликован, считайте credentials скомпрометированными: замените ключ, повторно зашифруйте файл и отзовите содержащиеся в нём значения.

Grafana получает пароль из Secret `grafana-admin`; секретные значения не должны храниться в values-файлах или Git. Для production предпочтителен внешний secret manager или зашифрованный Kubernetes Secret.

## Проверки

GitHub Actions запускает `helm lint` для локальных charts и upstream Grafana, а `kubeconform` проверяет отрендеренные Kubernetes manifests и Argo CD Applications. Для локального запуска нужны Helm и kubeconform:

```sh
for chart in charts/*; do
	[ -f "$chart/Chart.yaml" ] && helm lint "$chart"
done
```

## Лицензия

Проект распространяется по лицензии MIT. См. [LICENSE](LICENSE).
