FROM ocaml/opam:debian-12-ocaml-5.2-flambda AS build
WORKDIR /usr/src/flycaml
RUN sudo ln -f /usr/bin/opam-2.2 /usr/bin/opam
COPY --chown=opam flycaml.opam .
RUN opam repository set-url default git+https://github.com/ocaml/opam-repository.git \
  && opam pin add flycaml.dev . --no-action \
  && opam list --depext --resolve flycaml >depexts.txt \
  && opam install . --deps-only
COPY --chown=opam . .
RUN opam exec -- dune build --profile=release

FROM debian:12-slim
WORKDIR /flycaml
COPY --from=build /usr/src/flycaml/depexts.txt depexts.txt
COPY --from=build /usr/src/flycaml/_build/default/bin/main.exe /usr/bin/flycaml
RUN apt-get update \
  && apt-get --no-install-recommends --yes install netbase $(cat depexts.txt) \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm depexts.txt
EXPOSE 8080
CMD ["/usr/bin/flycaml"]
