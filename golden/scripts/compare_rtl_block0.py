from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def s16(hex4: str) -> int:
    v = int(hex4, 16)
    return v - 0x10000 if v >= 0x8000 else v


def load_complex_q15(path: Path) -> list[tuple[int, int]]:
    out: list[tuple[int, int]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        t = line.strip()
        if not t:
            continue
        out.append((s16(t[:4]), s16(t[4:])))
    return out


def main() -> None:
    ref_path = ROOT / "results" / "golden_output_q15_scaled.hex"
    rtl_path = ROOT / "results" / "hardware_rtl_output_block0_q15.hex"

    if not ref_path.exists():
        raise SystemExit(f"Missing reference: {ref_path}. Run golden module first.")
    if not rtl_path.exists():
        raise SystemExit(f"Missing RTL output: {rtl_path}. Run TB simulation first.")

    ref_all = load_complex_q15(ref_path)
    rtl = load_complex_q15(rtl_path)
    ref = ref_all[: len(rtl)]

    max_r = 0
    max_i = 0
    idx_r = -1
    idx_i = -1
    for i, ((rr, ri), (hr, hi)) in enumerate(zip(ref, rtl)):
        dr = abs(hr - rr)
        di = abs(hi - ri)
        if dr > max_r:
            max_r = dr
            idx_r = i
        if di > max_i:
            max_i = di
            idx_i = i

    threshold = 10
    passed = (max_r <= threshold) and (max_i <= threshold)
    text = "\n".join(
        [
            f"Compared points: {len(rtl)}",
            f"Max abs error real: {max_r} @ {idx_r}",
            f"Max abs error imag: {max_i} @ {idx_i}",
            f"Threshold: {threshold}",
            f"PASS: {passed}",
        ]
    )
    out = ROOT / "results" / "rtl_compare_report.txt"
    out.write_text(text + "\n", encoding="utf-8")
    print(text)
    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()


