
results = evaluate_recovery(S_HR, S_LR, S_pred);


%% =========================
%  Microstructure Recovery Evaluation
%  Compute: R2, RMSE, MAE, RCE, Recovery Ratio
% ==========================

function results = evaluate_recovery(S_HR, S_LR, S_pred)

% ---------- Parameter checking ----------
if ~isequal(size(S_HR), size(S_pred))
    error('The shapes of S_HR and S_pred do not match');
end

if ~isequal(size(S_HR), size(S_LR))
    error(The shapes of S_HR and S_LR do not match');
end

[n, m] = size(S_HR);

% ---------- Initialisation ----------
R2   = zeros(1,m);
RMSE = zeros(1,m);
MAE  = zeros(1,m);
RCE  = zeros(1,m);
RR   = zeros(1,m);

epsilon = 1e-8;   %Preventing the Δ≈0 explosion

% ---------- Loop through each statistic ----------
for j = 1:m
    
    y_true = S_HR(:,j);
    y_pred = S_pred(:,j);
    y_lr   = S_LR(:,j);
    
    % ---- Basis error ----
    SSres = sum((y_true - y_pred).^2);
    SStot = sum((y_true - mean(y_true)).^2);
    
    R2(j)   = 1 - SSres / SStot;
    RMSE(j) = sqrt(mean((y_true - y_pred).^2));
    MAE(j)  = mean(abs(y_true - y_pred));
    
    % ---- Change recovery metrics ----
    delta_true = y_true - y_lr;
    delta_pred = y_pred - y_lr;
    
    threshold = 0.0001 ;

    valid_idx = abs(delta_true) > threshold;
    % Relative Change Error
%     RCE(j) =  mean(abs(delta_true - delta_pred) ./ ...
%                   (abs(delta_true) + epsilon) );
    RCE = mean( abs(delta_true(valid_idx) - delta_pred(valid_idx)) ...
           ./ abs(delta_true(valid_idx)) )
    % Recovery Ratio
    RR(j) = mean( delta_pred(valid_idx) ./ ...
                 (delta_true(valid_idx) + epsilon) );
end

% ---------- Output ----------
results.R2   = R2;
results.RMSE = RMSE;
results.MAE  = MAE;
results.RCE  = RCE;
results.RR   = RR;

% 平均值
results.mean_R2   = mean(R2);
results.mean_RMSE = mean(RMSE);
results.mean_MAE  = mean(MAE);
results.mean_RCE  = mean(RCE);
results.mean_RR   = mean(RR);

% ---------- Print ----------
fprintf('\n===== Evaluation Results =====\n');
fprintf('Mean R2   = %.4f\n', results.mean_R2);
fprintf('Mean RMSE = %.6f\n', results.mean_RMSE);
fprintf('Mean MAE  = %.6f\n', results.mean_MAE);
fprintf('Mean RCE  = %.4f\n', results.mean_RCE);
fprintf('Mean RR   = %.4f\n', results.mean_RR);

end