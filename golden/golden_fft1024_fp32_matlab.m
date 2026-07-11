function golden_fft1024_fp32_matlab()
% Golden FFT (1024-point radix-2 DIT) in MATLAB
% Input:
%   input/input_fp32_v3.hex
%   input/twiddle_fp32.hex
% Output:
%   results/golden_output_fp32.hex
%   results/golden_output_q15_scaled.hex

    root = fileparts(fileparts(mfilename('fullpath')));
    in_fp = fullfile(root, 'input', 'input_fp32_v3.hex');
    tw_fp = fullfile(root, 'input', 'twiddle_fp32.hex');
    out_dir = fullfile(root, 'results');
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end

    N = 1024;
    x = read_fp32_hex_lines(in_fp);
    tw = read_twiddle_fp32_hex(tw_fp);

    if mod(numel(x), N) ~= 0
        error('Input sample count (%d) is not divisible by N=%d.', numel(x), N);
    end
    if numel(tw) < N/2
        error('Twiddle count (%d) < N/2.', numel(tw));
    end

    num_blocks = numel(x) / N;
    y_all = complex(zeros(numel(x), 1, 'single'));
    for b = 1:num_blocks
        idx0 = (b-1)*N + 1;
        blk = x(idx0:idx0+N-1);
        y = fft_dit_fp32(blk, tw);
        y_all(idx0:idx0+N-1) = y;
    end

    write_complex_fp32_hex(fullfile(out_dir, 'golden_output_fp32.hex'), y_all);
    write_complex_q15_scaled_hex(fullfile(out_dir, 'golden_output_q15_scaled.hex'), y_all, N);

    fprintf('Golden done. N=%d, blocks=%d, samples=%d\n', N, num_blocks, numel(x));
end

function y = fft_dit_fp32(x_real, tw)
    n = numel(x_real);
    r = bit_reverse_indices(n);
    y = complex(zeros(n,1,'single'));
    for i = 1:n
        y(i) = complex(single(x_real(r(i)+1)), single(0));
    end

    m = 2;
    while m <= n
        half = m / 2;
        stride = n / m;
        for s = 1:m:n
            for k = 0:half-1
                w = tw(k*stride + 1);
                t = w * y(s + k + half);
                u = y(s + k);
                y(s + k) = u + t;
                y(s + k + half) = u - t;
            end
        end
        m = m * 2;
    end
end

function r = bit_reverse_indices(n)
    bits = round(log2(n));
    r = zeros(n,1);
    for i = 0:n-1
        v = i;
        rev = uint32(0);
        for b = 1:bits
            rev = bitshift(rev, 1) + uint32(bitand(v, 1));
            v = bitshift(v, -1);
        end
        r(i+1) = double(rev);
    end
end

function v = read_fp32_hex_lines(path)
    lines = read_nonempty_lines(path);
    n = numel(lines);
    v = zeros(n,1,'single');
    for i = 1:n
        u = uint32(hex2dec(lines{i}));
        v(i) = typecast(u, 'single');
    end
end

function tw = read_twiddle_fp32_hex(path)
    lines = read_nonempty_lines(path);
    n = numel(lines);
    tw = complex(zeros(n,1,'single'));
    for i = 1:n
        s = lines{i};
        ur = uint32(hex2dec(s(1:8)));
        ui = uint32(hex2dec(s(9:16)));
        r = typecast(ur, 'single');
        im = typecast(ui, 'single');
        tw(i) = complex(r, im);
    end
end

function write_complex_fp32_hex(path, y)
    fid = fopen(path, 'w');
    if fid < 0
        error('Cannot open output file: %s', path);
    end
    c = onCleanup(@() fclose(fid));
    for i = 1:numel(y)
        ur = typecast(single(real(y(i))), 'uint32');
        ui = typecast(single(imag(y(i))), 'uint32');
        fprintf(fid, '%08X%08X\n', ur, ui);
    end
end

function write_complex_q15_scaled_hex(path, y, nscale)
    fid = fopen(path, 'w');
    if fid < 0
        error('Cannot open output file: %s', path);
    end
    c = onCleanup(@() fclose(fid));
    for i = 1:numel(y)
        r = q15_quantize(double(real(y(i))) / double(nscale));
        im = q15_quantize(double(imag(y(i))) / double(nscale));
        fprintf(fid, '%04X%04X\n', uint16(typecast(int16(r), 'uint16')), uint16(typecast(int16(im), 'uint16')));
    end
end

function q = q15_quantize(x)
    if x > 0.999969482421875
        x = 0.999969482421875;
    elseif x < -1.0
        x = -1.0;
    end
    q = round(x * 32768.0);
    if q > 32767
        q = 32767;
    elseif q < -32768
        q = -32768;
    end
end

function lines = read_nonempty_lines(path)
    raw = fileread(path);
    parts = regexp(raw, '\r\n|\n|\r', 'split');
    mask = ~cellfun(@(s) isempty(strtrim(s)), parts);
    lines = cellfun(@strtrim, parts(mask), 'UniformOutput', false);
end

