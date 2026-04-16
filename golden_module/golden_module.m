function golden_module()
% GOLDEN_MODULE
% MATLAB golden reference for the 1024-point radix-2 FFT coursework.
%
% This script reads the course-provided Q1.15 input and twiddle HEX files,
% runs 10 blocks of 1024-point FFT in double precision, and writes:
%   1) floating-point FFT outputs
%   2) Q9.7 quantized FFT outputs
%
% Directory assumptions:
%   code/
%     golden_module/golden_module.m
%     input/input_q1_15_v3.hex
%     input/twiddle_q15.hex
%
% Output directory:
%   code/golden_module/golden_out/

    FFT_N = 1024;
    NUM_TOTAL_SAMPLES = 10240;
    NUM_BLOCKS = NUM_TOTAL_SAMPLES / FFT_N;
    TWIDDLE_N = FFT_N / 2;

    this_dir = fileparts(mfilename('fullpath'));
    code_dir = fileparts(this_dir);
    input_dir = fullfile(code_dir, 'input');
    out_dir = fullfile(this_dir, 'golden_out');

    input_q15_path = fullfile(input_dir, 'input_q1_15_v3.hex');
    twiddle_q15_path = fullfile(input_dir, 'twiddle_q15.hex');

    input_q15 = read_q15_hex_file(input_q15_path, NUM_TOTAL_SAMPLES);
    input_float = double(input_q15) / 2^15;

    twiddle_q15 = read_twiddle_q15_hex_file(twiddle_q15_path, TWIDDLE_N);
    fprintf('Loaded %d Q1.15 input samples from %s\n', numel(input_q15), input_q15_path);
    fprintf('Loaded %d Q1.15 twiddle entries from %s\n', numel(twiddle_q15), twiddle_q15_path);

    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end

    for blk = 0:(NUM_BLOCKS - 1)
        start_idx = blk * FFT_N + 1;
        end_idx = start_idx + FFT_N - 1;

        x_blk = input_float(start_idx:end_idx);
        X_blk = fft(x_blk, FFT_N);

        float_out_path = fullfile(out_dir, sprintf('fft_block_%02d_float.txt', blk));
        q97_out_path = fullfile(out_dir, sprintf('fft_block_%02d_q97.txt', blk));

        write_float_output(float_out_path, X_blk);
        write_q97_output(q97_out_path, X_blk);
    end

    fprintf('Golden FFT generation complete.\n');
end


function x_q15 = read_q15_hex_file(filepath, expected_count)
    lines = read_nonempty_lines(filepath);

    if numel(lines) ~= expected_count
        error('Expected %d Q1.15 input samples, got %d.', expected_count, numel(lines));
    end

    x_q15 = zeros(expected_count, 1, 'int16');
    for idx = 1:expected_count
        x_q15(idx) = int16(hex_to_signed(lines{idx}, 16));
    end
end


function twiddle = read_twiddle_q15_hex_file(filepath, expected_count)
    lines = read_nonempty_lines(filepath);

    if numel(lines) ~= expected_count
        error('Expected %d twiddle entries, got %d.', expected_count, numel(lines));
    end

    twiddle = complex(zeros(expected_count, 1), zeros(expected_count, 1));
    for idx = 1:expected_count
        token = upper(strtrim(lines{idx}));
        if strlength(token) ~= 8
            error('Twiddle line %d must be 8 hex characters, got "%s".', idx, token);
        end

        re_hex = extractBetween(token, 1, 4);
        im_hex = extractBetween(token, 5, 8);
        re_q15 = double(int16(hex_to_signed(re_hex{1}, 16))) / 2^15;
        im_q15 = double(int16(hex_to_signed(im_hex{1}, 16))) / 2^15;
        twiddle(idx) = complex(re_q15, im_q15);
    end
end


function lines = read_nonempty_lines(filepath)
    if ~exist(filepath, 'file')
        error('File not found: %s', filepath);
    end

    raw = fileread(filepath);
    split_lines = regexp(raw, '\r\n|\n|\r', 'split');
    mask = ~cellfun(@isempty, split_lines);
    lines = split_lines(mask);
end


function value = hex_to_signed(hex_str, width_bits)
    unsigned_value = uint64(hex2dec(char(hex_str)));
    sign_bit = bitshift(uint64(1), width_bits - 1);
    full_scale = bitshift(uint64(1), width_bits);

    if bitand(unsigned_value, sign_bit) ~= 0
        value = int64(unsigned_value) - int64(full_scale);
    else
        value = int64(unsigned_value);
    end
end


function write_float_output(filepath, X_blk)
    fid = fopen(filepath, 'w');
    if fid < 0
        error('Cannot open output file: %s', filepath);
    end

    cleanup_obj = onCleanup(@() fclose(fid));
    fprintf(fid, 'real imag\n');
    for idx = 1:numel(X_blk)
        fprintf(fid, '%.10f %.10f\n', real(X_blk(idx)), imag(X_blk(idx)));
    end
    clear cleanup_obj;
end


function write_q97_output(filepath, X_blk)
    real_q97 = float_to_q97(real(X_blk));
    imag_q97 = float_to_q97(imag(X_blk));

    fid = fopen(filepath, 'w');
    if fid < 0
        error('Cannot open output file: %s', filepath);
    end

    cleanup_obj = onCleanup(@() fclose(fid));
    fprintf(fid, 'real_q97 imag_q97\n');
    for idx = 1:numel(X_blk)
        fprintf(fid, '%d %d\n', real_q97(idx), imag_q97(idx));
    end
    clear cleanup_obj;
end


function q97 = float_to_q97(x)
    scaled = round(double(x) * 2^7);
    scaled = min(max(scaled, -32768), 32767);
    q97 = int16(scaled);
end
