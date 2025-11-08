# destination: /scripts/notarize_manifest.py
import hashlib
import datetime
import json

def hash_file(file_path):
    with open(file_path, "rb") as f:
        return hashlib.sha3_512(f.read()).hexdigest()

manifest_path = "manifest/indestructible-governance.sai"
with open(manifest_path) as f:
    manifest = f.read()
manifest_hash = hashlib.sha3_512(manifest.encode()).hexdigest()
timestamp = datetime.datetime.utcnow().isoformat()

log_entry = {
    "manifest_hash": manifest_hash,
    "timestamp": timestamp,
    "files": []
}

linked_files = [
    "configs/sai-mai.yaml",
    "src/backend/payment_stripe.py",
    ".github/workflows/security-lock.yml",
    "fragments/core-legal-compliance.sai",
    "fragments/onboarding-consent.sai",
    "fragments/safety-case.sai",
    "docs/EULA.md",
    "policies/reward-function.tracking.sai"
]

for file_path in linked_files:
    log_entry["files"].append({
        "file": file_path,
        "hash": hash_file(file_path)
    })

with open("manifest/notarized-log.json", "a") as f:
    f.write(json.dumps(log_entry) + "\n")
