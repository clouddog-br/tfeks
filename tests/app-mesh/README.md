yelb service based on
https://github.com/aws/aws-app-mesh-examples/tree/main/walkthroughs/eks-getting-started/infrastructure
https://aws.amazon.com/pt/blogs/aws-brasil/introducao-ao-aws-app-mesh-e-amazon-eks/

Create kub8s pods
kubectl apply -f tests/app-mesh/yelb_initial_deployment.yaml

Configure appmesh
kubectl apply -f tests/app-mesh/appmesh-yelb-redis.yaml
kubectl apply -f tests/app-mesh/appmesh-yelb-db.yaml
kubectl apply -f tests/app-mesh/appmesh-yelb-appserver.yaml
kubectl apply -f tests/app-mesh/appmesh-yelb-ui.yaml


