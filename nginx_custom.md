### Create an index.html file:

Create an index.html file with your desired content. For example, you can create a file named index.html with the following content:

````html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to OpenShift</title>
</head>
<body>
    <h1>Hello from Nginx on OpenShift!</h1>
</body>
</html>
````

### Create a ConfigMap:

Create a ConfigMap in OpenShift to store the index.html file:

````shell
oc create configmap nginx-config --from-file=index.html
````

This command assumes that you are in the same directory as the index.html file. Adjust the command if your file is in a different location.

#### Create a Deployment with Nginx:

Create a simple Nginx Deployment configuration file (nginx-deployment.yaml):

````yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-config-volume
          mountPath: /usr/share/nginx/html
  volumes:
  - name: nginx-config-volume
    configMap:
      name: nginx-config
````

````shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: quay.io/jitesoft/nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-volume
          mountPath: /usr/local/nginx/html
      volumes:
      - name: nginx-volume
        persistentVolumeClaim:
           claimName: pvc-test-nfs
````

Apply the Deployment:

````shell
oc apply -f nginx-deployment.yaml
````

### Create a Service:

Create a Service to expose the Nginx Deployment:

````yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
````

Apply the Service:

````shell
oc apply -f nginx-service.yaml
````
