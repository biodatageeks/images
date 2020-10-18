# images

## How to run the image
```
export TAG='test'
docker run --rm -it -p 8889:8888 \
-e SEQUILA_VERSION=0.5.16 \
-e PYSEQUILA_VERSION=0.1.6 \
-e HOME=/tmp/jovyan \
biodatageeks/pysequila-notebook:$TAG \
jupyter-lab --ip='*' --NotebookApp.token='' --NotebookApp.password=''
```

## How to build image locally
```
docker build \
--build-arg BASE_IMAGE=jupyter/minimal-notebook:612aa5710bf9 \
--build-arg SPARK_VERSION=2.4.3 \
--build-arg SEQUILA_VERSION=0.5.16 \
-t biodatageeks/pysequila-notebook:test .
```