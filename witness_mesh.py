import asyncio
import hashlib
import json
from pathlib import Path

LEDGER = Path("Matrix-Ledger/MATRIX_JURY_LOGS.json")

MODULES = [
    "llama.cpp",
    "proxmark3",
    "sherlock",
    "sqlmap",
    "thc-hydra"
]

async def hash_file_async(file_path: Path) -> bytes:
    loop = asyncio.get_running_loop()
    h = hashlib.sha256()

    try:
        def read_sync():
            with open(file_path, "rb") as f:
                while chunk := f.read(65536):
                    h.update(chunk)

        await loop.run_in_executor(None, read_sync)

    except (OSError, PermissionError):
        pass

    return h.digest()

async def hash_dir_modern(path: Path) -> str:
    if not path.is_dir():
        return hashlib.sha256().hexdigest()

    tasks = []

    for root, _, files in path.walk():
        for f in sorted(files):
            tasks.append(hash_file_async(root / f))

    file_hashes = await asyncio.gather(*tasks)

    master_hash = hashlib.sha256()
    for fh in file_hashes:
        master_hash.update(fh)

    return master_hash.hexdigest()

async def bind_mesh():
    fingerprints = await asyncio.gather(
        *(hash_dir_modern(Path(m)) for m in MODULES)
    )

    witness_data = {
        module: {
            "fingerprint": fp,
            "GENESIS": f"{module}-GENESIS",
            "SEAL": f"{module}-SEAL-2026-07-30T09-56"
        }
        for module, fp in zip(MODULES, fingerprints)
    }

    LEDGER.parent.mkdir(parents=True, exist_ok=True)

    # --- FIX: Normalize ledger into a dict ---
    if LEDGER.exists():
        try:
            raw = LEDGER.read_text(encoding="utf-8")
            ledger = json.loads(raw)

            # If ledger is a list, convert to dict
            if isinstance(ledger, list):
                ledger = {"legacy": ledger}

        except json.JSONDecodeError:
            ledger = {}
    else:
        ledger = {}

    ledger["witness_mesh"] = witness_data

    LEDGER.write_text(json.dumps(ledger, indent=4), encoding="utf-8")
    print("Witness mesh bound successfully.")

if __name__ == "__main__":
    asyncio.run(bind_mesh())
