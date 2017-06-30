# twemproxy-gcsfuse

[![Docker Build Status](https://img.shields.io/docker/build/xaviiic/twemproxy-gcsfuse.svg)]()
[![Docker Automated Build](https://img.shields.io/docker/automated/xaviiic/twemproxy-gcsfuse.svg)]()

Docker image for running twemproxy with gcsfuse.  Gcsfuse allows you to mount a Google Cloud Storage(GCS) bucket 
into container file system while running on Google Compute Engine(GCE) or Google Container Engine(GKE).

## Usages

### Prerequisites

First put your twemproxy configuration file to a GCS bucket.

```yaml
# nutcraker.yml
redis-pool:
    listen:               0.0.0.0:22121
    hash:                 fnv1a_64
    distribution:         ketama
    auto_eject_hosts:     true
    redis:                true
    server_retry_timeout: 2000
    server_failure_limit: 1
    servers:
        - <redis-addr>:6379:1
```

### Directly running on GCE

You can choose to run the container upon GCE directly.

```bash
# Pull the image.
$ docker pull xaviiic/twemproxy-gcsfuse

# Mount bucket to /etc/config and run.
$ docker run -it xaviiic/twemproxy-gcsfuse mkdir -p /etc/config \
  && gcsfuse <bucket_name> /etc/config && nutcracker -c /etc/config/nutcracker.yml
```

### Using Kubernetes deployment

Or to deploy with k8s deployment script,

```yaml
# twemproxy-gcsfuse-example.yaml
apiVersion: extensions/v1beta1
kind: Deployment
spec:
  replicas: 1
  template:
    spec:
      containers:
        - name: example
          image: xaviiic/twemproxy-gcsfuse:latest
          securityContext:
            privileged: true
          command:
            - "/bin/sh"
            - "-c"
            - "mkdir -p /etc/config && gcsfuse <bucket_name> /etc/config && nutcracker -c /etc/config/nutcraker.yml"
```

then apply to your cluster.

```bash
$ kubectl apply -f twemproxy-gcsfuse-example.yaml
```

Credits
-------

* [chiaen/docker-gcsfuse](https://github.com/chiaen/docker-gcsfuse): For the gcsfuse binary.
