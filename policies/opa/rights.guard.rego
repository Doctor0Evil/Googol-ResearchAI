package rights.guard

default deny = false

deny[msg] {
  input.meta.purpose != "research-internal-only"
  msg := "Use not permitted: external research is prohibited under license and policy."
}

deny[msg] {
  input.component == "qpu_training"
  not input.controls.human_oversight_approved
  msg := "QPU training requires prior human oversight approval."
}

deny[msg] {
  not input.provenance.sigstore_verified
  msg := "Artifact lacks verified Sigstore provenance in Rekor."
}
