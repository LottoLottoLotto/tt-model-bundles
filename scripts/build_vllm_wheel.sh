#!/usr/bin/env bash
# SPDX-FileCopyrightText: © 2026 Lottolabs
# SPDX-License-Identifier: Apache-2.0
#
# build_vllm_wheel.sh REF OUT_DIR [REPO_URL] [IMAGE]
#
# Builds the empty-target (VLLM_TARGET_DEVICE=empty) vLLM wheel a bundle's tt-model.yaml installs through
# `runtime.vllm: {wheel: wheels/vllm-*.whl}`.  tt-model's vllm-plugin kind cannot build vLLM itself here: it accepts
# no {repo, ref} for vLLM, and a {path} is staged without .git, so vLLM's setup.py fails in setuptools-scm.
#
#   REF       branch, tag or sha of the vLLM fork, e.g. lottolabs/inkling2-mini-p150
#   OUT_DIR   where the wheel is written (created; an older vllm-*.whl there is removed first)
#   REPO_URL  default https://github.com/LottoLottoLotto/vllm (fork of tenstorrent/vllm)
#   IMAGE     build environment, default the public tt-inference-server image the releases are built on
#             (its tt-metal python_env: Python 3.10, setuptools 80, torch 2.11.0+cpu)
#
# Needs git and docker.  The wheel is pure Python; its version is setuptools-scm's (0.1.devN+g<sha>.empty).
set -euo pipefail
REF=${1:?usage: build_vllm_wheel.sh REF OUT_DIR [REPO_URL] [IMAGE]}
OUT=${2:?usage: build_vllm_wheel.sh REF OUT_DIR [REPO_URL] [IMAGE]}
REPO=${3:-https://github.com/LottoLottoLotto/vllm}
IMAGE=${4:-ghcr.io/tenstorrent/tt-inference-server/vllm-tt-metal-src-release-ubuntu-22.04-amd64:0.20.0-de59f8a-03fa3af}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --filter=blob:none --no-checkout "$REPO" "$tmp/vllm"
git -C "$tmp/vllm" checkout -q "$REF"
echo "vLLM $(git -C "$tmp/vllm" rev-parse HEAD) ($REF)"
mkdir -p "$OUT"
rm -f "$OUT"/vllm-*.whl
docker run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp \
  -v "$tmp/vllm:/src:ro" -v "$(cd "$OUT" && pwd):/out" --entrypoint bash "$IMAGE" -c '
    set -e
    P=/home/container_app_user/tt-metal/python_env/bin/python
    $P -m pip install -q --no-deps --target /tmp/scm "setuptools-scm>=8,<10"
    cp -a /src /tmp/v && cd /tmp/v
    git config --global --add safe.directory "*"
    PYTHONPATH=/tmp/scm VLLM_TARGET_DEVICE=empty $P -m pip wheel -q --no-build-isolation --no-deps -w /out .'
ls -l "$OUT"/vllm-*.whl
