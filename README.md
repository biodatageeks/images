# images

## How to run the image
```
export TAG=''
docker run --rm -it -p 8889:8888 \
-e SEQUILA_VERSION=0.5.16 \
-e PYSEQUILA_VERSION=0.1.6 \
-e HOME=/tmp/jovyan \
biodatageeks/pysequila-notebook:$TAG \
jupyter-lab --ip='*' --NotebookApp.token='' --NotebookApp.password=''
```