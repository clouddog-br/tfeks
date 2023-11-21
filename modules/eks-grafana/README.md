# Get grafana password

Run this command on cli to get admin password:

```
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
