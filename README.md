# images

##How to run the image
```
export TAG=''
docker run --rm -it -p 8889:8888 \
-e SEQUILA_VERSION=0.5.12 \
-e PYSEQUILA_VERSION=0.1.4 \
biodatageeks/pysequila-notebook:$TAG \
jupyter-lab --ip='*' --NotebookApp.token='' --NotebookApp.password=''
```