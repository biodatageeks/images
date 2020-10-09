#!/bin/bash -x
export TMP_HOME=/tmp/jovyan
cp -r $TMP_HOME/.sdkman $HOME
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "$@"

#prepare pysequila
PYSEQUILA_VERSION=${PYSEQUILA_VERSION:-0.1.4}
SEQUILA_VERSION=${SEQUILA_VERSION:-0.5.13}
BIODATAGEEKS_REPOS=${BIODATAGEEKS_REPOS:-"https://oss.sonatype.org/content/repositories/snapshots/"}

source /opt/conda/etc/profile.d/conda.sh
conda activate $HOME/venv/pysequila
pip install -U pysequila==$PYSEQUILA_VERSION
conda deactivate

export PYSPARK_SUBMIT_ARGS="--repositories ${BIODATAGEEKS_REPOS} --packages org.biodatageeks:sequila_2.11:${SEQUILA_VERSION} pyspark-shell"

#prepare notebooks
mkdir -p $HOME/work/git
cd $HOME/work/git
git clone https://github.com/biodatageeks/notebooks.git
cd $HOME

tini -g -- "$@"

