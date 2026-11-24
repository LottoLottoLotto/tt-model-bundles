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

Directory = branch slug (`lottolabs/<dir>-p150` in the three code repos).  All are listed in the tt-model community
catalog (`tt model list --community --include-unverified`, `tt model search Lottolabs --catalog`); none is
Tenstorrent-verified.

| dir | model | weights (pinned) | bundle | profiles (default first) |
|---|---|---|---|---|
| [inkling2-mini](inkling2-mini/tt-model.yaml) | Inkling-2-Mini (26.4B, 3.4B active) | [Lottolabs/Inkling-2-Mini-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/Inkling-2-Mini-TT-Mixed-BFP4-BFP8-P150) @4f2e262 | [Lottolabs/Inkling-2-Mini-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/Inkling-2-Mini-TT-Mixed-BFP4-BFP8-P150-tt-model) | fast (16 users, 64K), long, release-256k, native (1M), quality |
| [qwen3.8-27b](qwen3.8-27b/tt-model.yaml) | Qwen3.8-27B (+ vision, DFlash2) | [Lottolabs/Qwen3.8-27B-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/Qwen3.8-27B-TT-Mixed-BFP4-BFP8-P150) @dd18ba3 | [Lottolabs/Qwen3.8-27B-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/Qwen3.8-27B-TT-Mixed-BFP4-BFP8-P150-tt-model) | 8k, 8k-mtp, 8k-off, 8k-noprefix, 8k-users4/8/16, 128k, 128k-mtp, 128k-off, 128k-users4/8/16 (no 262K) |
| [qwen3.6-35b-a3b](qwen3.6-35b-a3b/tt-model.yaml) | Qwen3.6-35B-A3B, single sequence + MTP | [Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150) @c355c41 | [Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150-tt-model) | single, single-no-mtp |
| [qwen3.6-35b-a3b-batched](qwen3.6-35b-a3b-batched/tt-model.yaml) | Qwen3.6-35B-A3B, batched | same release @c355c41 | [Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150-batched-tt-model](https://huggingface.co/Lottolabs/Qwen3.6-35B-A3B-TT-Mixed-BFP4-BFP8-P150-batched-tt-model) | batched-16, batched-8, batched-4, batched-2 |
| [qwen3.8-flash-next-coder](qwen3.8-flash-next-coder/tt-model.yaml) | Qwen3.8-Flash-Next Coder IQ1_M (Strata server, `http-server` kind) | [Lottolabs/Qwen3.8-Flash-Next-Coder-P150](https://huggingface.co/Lottolabs/Qwen3.8-Flash-Next-Coder-P150) @69e738b | [Lottolabs/Qwen3.8-Flash-Next-Coder-P150-tt-model](https://huggingface.co/Lottolabs/Qwen3.8-Flash-Next-Coder-P150-tt-model) | mtp, plain |
| [qwen3.5-9b-mixed](qwen3.5-9b-mixed/tt-model.yaml) | Qwen3.5-9B mixed BFP4/BFP8 | [Lottolabs/Qwen3.5-9B-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/Qwen3.5-9B-TT-Mixed-BFP4-BFP8-P150) @a19cf94 | [Lottolabs/Qwen3.5-9B-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/Qwen3.5-9B-TT-Mixed-BFP4-BFP8-P150-tt-model) | mtp, no-mtp |
| [qwen3.5-9b-bfp4](qwen3.5-9b-bfp4/tt-model.yaml) | Qwen3.5-9B BFP4 | upstream [Qwen/Qwen3.5-9B](https://huggingface.co/Qwen/Qwen3.5-9B) (the release's runtime converts it; see the card) | [Lottolabs/Qwen3.5-9B-TT-BFP4-P150-tt-model](https://huggingface.co/Lottolabs/Qwen3.5-9B-TT-BFP4-P150-tt-model) | mtp |
| [gemma-4-12b-it](gemma-4-12b-it/tt-model.yaml) | Gemma 4 12B it (+ assistant drafter) | [Lottolabs/gemma-4-12B-it-TT-BFP8-P150](https://huggingface.co/Lottolabs/gemma-4-12B-it-TT-BFP8-P150) @906ccca | [Lottolabs/gemma-4-12B-it-TT-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/gemma-4-12B-it-TT-BFP8-P150-tt-model) | speculative, no-speculation, no-prefix-caching |
| [lfm2.5-24b-a2b](lfm2.5-24b-a2b/tt-model.yaml) | LFM2.5-24B-A2B | [Lottolabs/LFM2.5-24B-A2B-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/LFM2.5-24B-A2B-TT-Mixed-BFP4-BFP8-P150) @58f343e | [Lottolabs/LFM2.5-24B-A2B-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/LFM2.5-24B-A2B-TT-Mixed-BFP4-BFP8-P150-tt-model) | single, single-nospec, batch2, batch4, batch8, batch16 |
| [lfm3-1.7b](lfm3-1.7b/tt-model.yaml) | LFM3-1.7B (+ DFlash drafter) | [Lottolabs/LFM3-1.7B-TT-Mixed-BFP4-BFP8-P150](https://huggingface.co/Lottolabs/LFM3-1.7B-TT-Mixed-BFP4-BFP8-P150) @6219d70 | [Lottolabs/LFM3-1.7B-TT-Mixed-BFP4-BFP8-P150-tt-model](https://huggingface.co/Lottolabs/LFM3-1.7B-TT-Mixed-BFP4-BFP8-P150-tt-model) | single, batch4, batch16, lookup-only, agentic |

Every bundle was checked on a P150 from a clean consumer state (fresh `HOME` and Hugging Face cache, bundle image
pulled from the Hub, `tt serve <bundle>` with its default profile): an HTTP smoke test passes (the release's own where
it has one), a greedy request returns the same prompt and output token ids as the release's own runtime, and the
server stops cleanly on SIGTERM.  The Flash-Next-Coder bundle uses the `http-server` kind (Strata's own server, no
vLLM), so it needs no vLLM wheel.
Weights licences: Apache-2.0 (Inkling, Qwen3.8-27B, Qwen3.6, Qwen3.5-9B, Gemma 4), LFM Open License v1.0 (LFM2.5,
LFM3), Qwen Community License (Qwen3.8-Flash-Next-Coder) — see each card.

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
