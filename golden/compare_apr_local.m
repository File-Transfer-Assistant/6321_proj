function compare_apr_local()
% Local-folder version: reads from project's results/ only.
% Files needed in results/:
%   - golden_output_q97.txt
%   - apr_output_q97.txt
% Outputs:
%   - results/apr_compare/apr_block_*.png
%   - results/apr_compare/apr_nrmse_all_blocks.png

    N           = 1024;
    NUM_BLOCKS  = 10;
    SCALE       = 128;
    root        = fileparts(fileparts(mfilename('fullpath')));
    hw_path     = fullfile(root,'results','apr_output_q97.txt');
    gold_path   = fullfile(root,'results','golden_output_q97.txt');
    out_dir     = fullfile(root,'results','apr_compare');
    if ~exist(out_dir,'dir'); mkdir(out_dir); end

    fprintf('HW   : %s\n', hw_path);
    fprintf('Gold : %s\n', gold_path);

    hw     = read_q97(hw_path,    NUM_BLOCKS*N);
    golden = read_q97(gold_path,  NUM_BLOCKS*N);

    nrmse_all = zeros(NUM_BLOCKS,1);
    rmse_all  = zeros(NUM_BLOCKS,1);
    exact     = 0;  mismatch = 0;

    for b = 0:NUM_BLOCKS-1
        idx = (b*N + 1) : (b+1)*N;
        gQ = golden(idx,:);   hQ = hw(idx,:);
        gC = (gQ(:,1) + 1j*gQ(:,2)) / SCALE;
        hC = (hQ(:,1) + 1j*hQ(:,2)) / SCALE;
        rmse  = sqrt(mean(abs(gC-hC).^2));
        rng   = max(abs(gC)) - min(abs(gC));
        if rng==0; rng=1; end
        nrmse_all(b+1) = rmse / rng;
        rmse_all(b+1)  = rmse;
        eq = (gQ(:,1)==hQ(:,1)) & (gQ(:,2)==hQ(:,2));
        exact    = exact    + sum(eq);
        mismatch = mismatch + sum(~eq);

        fig = figure('Visible','off','Position',[100 100 1400 900]);
        subplot(2,2,1); plot(0:N-1,abs(gC),'b-','LineWidth',1.2); hold on;
                        plot(0:N-1,abs(hC),'r--','LineWidth',1.2);
                        xlabel('Frequency Bin'); ylabel('Magnitude');
                        title(sprintf('Block %d Magnitude',b));
                        legend('Golden Q9.7','Hardware Q9.7'); grid on;
        subplot(2,2,2); plot(0:N-1,angle(gC),'b-'); hold on;
                        plot(0:N-1,angle(hC),'r--');
                        xlabel('Frequency Bin'); ylabel('Phase (rad)');
                        title(sprintf('Block %d Phase',b));
                        legend('Golden Q9.7','Hardware Q9.7'); grid on;
        subplot(2,2,3); plot(0:N-1,gQ(:,1)-hQ(:,1),'b-'); hold on;
                        plot(0:N-1,gQ(:,2)-hQ(:,2),'r-');
                        xlabel('Frequency Bin'); ylabel('LSB Error');
                        title('Integer Error in Q9.7');
                        legend('Real Error','Imag Error'); grid on;
        subplot(2,2,4); stem(0:N-1, abs(gQ(:,1)-hQ(:,1))+abs(gQ(:,2)-hQ(:,2)),...
                             'filled','MarkerSize',2);
                        xlabel('Frequency Bin'); ylabel('Total LSB Error');
                        title(sprintf('RMSE=%.4g, NRMSE=%.4g',...
                              rmse_all(b+1), nrmse_all(b+1))); grid on;
        sgtitle(sprintf('FFT Output Comparison (post-layout), Block %d',b));
        saveas(fig, fullfile(out_dir, sprintf('apr_block_%d_compare.png',b)));
        close(fig);
        fprintf('Block %d : NRMSE=%.4g, mismatches=%d\n', b, nrmse_all(b+1), sum(~eq));
    end

    fig = figure('Visible','off','Position',[100 100 1100 500]);
    bar(0:NUM_BLOCKS-1, nrmse_all,'FaceColor',[0 0.45 0.74]);
    xlabel('Block ID'); ylabel('NRMSE');
    title('NRMSE for 10 FFT Blocks (post-layout)'); grid on;
    saveas(fig, fullfile(out_dir,'apr_nrmse_all_blocks.png'));
    close(fig);

    fprintf('\nExact match: %d / %d\n', exact, NUM_BLOCKS*N);
    fprintf('Mismatch   : %d / %d\n', mismatch, NUM_BLOCKS*N);
    fprintf('Avg  NRMSE : %.6f%%\n', mean(nrmse_all)*100);
    fprintf('Worst NRMSE: %.6f%% (Block %d)\n',...
            max(nrmse_all)*100, find(nrmse_all==max(nrmse_all),1)-1);
end

function v = read_q97(path, expected_lines)
    fid = fopen(path,'r');
    if fid<0; error('Cannot open %s', path); end
    C = textscan(fid,'%d %d');
    fclose(fid);
    v = double([C{1} C{2}]);
    if size(v,1) ~= expected_lines
        warning('%s has %d lines, expected %d', path, size(v,1), expected_lines);
    end
end

