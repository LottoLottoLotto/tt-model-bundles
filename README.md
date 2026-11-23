# Lottolabs P150 tt-model bundles

[tt-model-manager](https://github.com/tenstorrent/tt-model-manager) v5.1 container manifests for the Lottolabs
model releases on one Tenstorrent **P150** (Blackhole).  Each directory holds the `tt-model.yaml` a bundle was built
from; the bundles themselves are Hugging Face repos that `tt serve` runs directly:

```bash
tt serve Lottolabs/<bundle>              # pulls the image + the pinned weights, serves an OpenAI-compatible API
tt model profiles Lottolabs/<bundle>     # the serve profiles (context / concurrency / precision)
tt serve Lottolabs/<bundle> --profile <name>
```

Weights are never embedded: every bundle points at its release repo at a pinned commit, downloaded into your own
Hugging Face cache.  The code is public: each bundle builds public `tenstorrent/tt-metal`, `tenstorrent/vllm` and the
vLLM TT plugin plus one branch per model:

| repo | branches |
|---|---|
| [LottoLottoLotto/tt-metal](https://github.com/LottoLottoLotto/tt-metal) (fork of tenstorrent/tt-metal) | `lottolabs/<model>-p150`: the model runtime (Python, JIT kernels and any host C++ it needs) on the release's public base commit |
| [LottoLottoLotto/vllm](https://github.com/LottoLottoLotto/vllm) (fork of tenstorrent/vllm) | `lottolabs/<model>-p150`: vLLM core / serving patches + the validated dependency pins |
| [LottoLottoLotto/tt-model-plugins](https://github.com/LottoLottoLotto/tt-model-plugins) | `main`: `plugins/vllm-tt-plugin` of tenstorrent/vllm@03fa3af; `lottolabs/<model>-p150`: the plugin each release runs |

## Bundles

<!-- index: one row per release -->
| model | release (weights) | bundle | profiles (default first) | status |
|---|---|---|---|---|

## Building a bundle

```bash
cd <model>
../scripts/build_vllm_wheel.sh lottolabs/<model>-p150 wheels   # vLLM empty-target wheel from the fork branch
tt-model package --container tt-model.yaml --out build         # builds the image, runs the manifest's verify lines
tt-model serve build/<name>/tt_kernel_manifest.json            # local check on a P150
tt-model push build/<name>                                     # push the staged bundle
```

`tt-model`'s `vllm-plugin` kind accepts no `{repo, ref}` for vLLM and stages a `{path}` without `.git` (vLLM's
setup.py then fails in setuptools-scm), so vLLM ships as a wheel built from the fork branch by
[`scripts/build_vllm_wheel.sh`](scripts/build_vllm_wheel.sh).  The wheel's metadata pins the dependency set each
release was validated with (tt-model ignores `runtime.lock` for wheel installs).

## Compatibility

All bundles were built and tested on one P150 with firmware 19.15.0 and tt-kmd 2.11.0; the tt-cli golden set
(firmware 19.17.1) is untested.  The runtimes are built on the tt-metal commits of their releases (not the golden
tt-metal).  See each bundle card's *Limitations*.

## Licence

The manifests and scripts here are Apache-2.0.  The weights keep their own licences (stated on each bundle card and
in each release repo).
