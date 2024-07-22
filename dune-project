(lang dune 3.16)

(name flycaml)

(license ISC)

(authors "Sora Morimoto <sora@morimoto.io>")

(maintainers "Sora Morimoto <sora@morimoto.io>")

(source
 (github smorimoto/flycaml))

(generate_opam_files true)

(package
 (name flycaml)
 (synopsis "OCaml + Fly.io")
 (depends
  ocaml
  dream
  lwt
  (ocaml-lsp-server :with-dev-setup)
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.26.2)))))
