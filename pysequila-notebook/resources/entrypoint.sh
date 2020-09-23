#!/bin/bash -x
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "$@"

#prepare pysequila
PYSEQUILA_VERSION=${PYSEQUILA_VERSION:-0.1.4}
SEQUILA_VERSION=${SEQUILA_VERSION:-0.5.12}


source /opt/conda/etc/profile.d/conda.sh
conda create python=3.7 -p $HOME/venv/pysequila -y
conda activate $HOME/venv/pysequila

pip install -U pysequila==$PYSEQUILA_VERSION ipykernel
python -m ipykernel install --user --name pysequila --display-name pysequila
conda deactivate
#temporary workardound
export BIODATAGEEKS_REPOS="http://zsibio.ii.pw.edu.pl/nexus/repository/maven-snapshots/,https://oss.sonatype.org/content/repositories/snapshots/"
export PYSPARK_SUBMIT_ARGS="--repositories ${BIODATAGEEKS_REPOS} --packages org.biodatageeks:sequila_2.11:${SEQUILA_VERSION} pyspark-shell"

#prepare notebooks
mkdir -p $HOME/work/git
cd $HOME/work/git
git clone https://github.com/biodatageeks/notebooks.git
cd $HOME

tini -g -- "$@"

