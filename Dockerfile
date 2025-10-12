FROM ocaml/opam:debian-13-ocaml-5.4-flambda AS build
WORKDIR /usr/src/flycaml
RUN sudo ln -f /usr/bin/opam-2.4 /usr/bin/opam
RUN opam option solver=builtin-0install
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=bind,source=flycaml.opam,target=flycaml.opam \
  opam pin --no-action add flycaml.dev . \
  && opam update --depexts \
  && opam list --depext --resolve flycaml >depexts.txt \
  && opam install --deps-only .
COPY --chown=opam . .
RUN opam exec -- dune build --profile=release

FROM debian:13-slim
COPY --from=build /usr/src/flycaml/_build/default/bin/main.exe /usr/bin/flycaml
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=bind,source=/usr/src/flycaml/depexts.txt,target=depexts.txt,from=build \
  apt-get update \
  && apt-get --no-install-recommends --yes install netbase $(cat depexts.txt)
EXPOSE 8080
CMD ["/usr/bin/flycaml"]
