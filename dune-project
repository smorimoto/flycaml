(lang dune 3.17)
(name flycaml)

(generate_opam_files true)

(maintainers "Sora Morimoto <sora@morimoto.io>")
(authors "Sora Morimoto <sora@morimoto.io>")
(license ISC)
(source (github smorimoto/flycaml))

(package
 (name flycaml)
 (synopsis "OCaml + Fly.io")
 (depends
  dream
  lwt
  (ocaml-lsp-server :with-dev-setup)
  (ocamlformat (and :with-dev-setup (= 0.27.0)))))
