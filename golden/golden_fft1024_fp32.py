from __future__ import annotations

import math
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
N = 1024


def f32_from_hex(h: str) -> float:
    return struct.unpack("!f", bytes.fromhex(h))[0]


def hex_from_f32(x: float) -> str:
    return struct.pack("!f", float(x)).hex().upper()


def quantize_q15(x: float) -> int:
    x = max(-1.0, min(0.999969482421875, x))
    q = int(round(x * 32768.0))
    return max(-32768, min(32767, q))


def q15_hex(v: int) -> str:
    return f"{(v & 0xFFFF):04X}"


def bitrev_idx(n: int) -> list[int]:
    bits = int(math.log2(n))
    out: list[int] = []
    for i in range(n):
        r = 0
        x = i
        for _ in range(bits):
            r = (r << 1) | (x & 1)
            x >>= 1
        out.append(r)
    return out


def fft_dit_real_input(x: list[float], tw: list[complex]) -> list[complex]:
    rev = bitrev_idx(len(x))
    a = [complex(x[rev[i]], 0.0) for i in range(len(x))]
    m = 2
    while m <= len(x):
        half = m // 2
        stride = len(x) // m
        for s in range(0, len(x), m):
            for k in range(half):
                w = tw[k * stride]
                t = w * a[s + k + half]
                u = a[s + k]
                a[s + k] = u + t
                a[s + k + half] = u - t
        m <<= 1
    return a


def main() -> None:
    inp = ROOT / "input" / "input_fp32_v3.hex"
    twf = ROOT / "input" / "twiddle_fp32.hex"
    out_dir = ROOT / "results"
    out_dir.mkdir(exist_ok=True)

    samples = [f32_from_hex(s.strip()) for s in inp.read_text(encoding="utf-8").splitlines() if s.strip()]
    tw = []
    for line in twf.read_text(encoding="utf-8").splitlines():
        t = line.strip()
        if not t:
            continue
        tw.append(complex(f32_from_hex(t[:8]), f32_from_hex(t[8:])))

    blocks = len(samples) // N
    all_fft: list[complex] = []
    for b in range(blocks):
        blk = samples[b * N : (b + 1) * N]
        all_fft.extend(fft_dit_real_input(blk, tw))

    fp32_lines = [hex_from_f32(v.real) + hex_from_f32(v.imag) for v in all_fft]
    (out_dir / "golden_output_fp32.hex").write_text("\n".join(fp32_lines) + "\n", encoding="utf-8")

    q15_scaled_lines = []
    for v in all_fft:
        r = quantize_q15(v.real / 1024.0)
        i = quantize_q15(v.imag / 1024.0)
        q15_scaled_lines.append(q15_hex(r) + q15_hex(i))
    (out_dir / "golden_output_q15_scaled.hex").write_text("\n".join(q15_scaled_lines) + "\n", encoding="utf-8")
    print(f"Generated {len(all_fft)} FFT outputs")


if __name__ == "__main__":
    main()

