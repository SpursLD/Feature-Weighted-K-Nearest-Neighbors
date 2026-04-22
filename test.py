# -*- coding: utf-8 -*-
"""
Created on Thu Mar 12 12:27:07 2026

@author: 123
"""

import pandas as pd
import numpy as np
import joblib
import os
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error
from datetime import datetime

# ==================== User Configuration Area ====================
model_path = 'knn_model10_weighted.pkl'
scaler_path = 'scaler10_weighted.pkl'
weights_path = 'feature10_weights.npy'  # New: Weight file

new_data_file = 'sizethresholds10.xlsx'
output_file = 'sizethresholds10_evaluation_report_weighted.xlsx'

input_cols = ['resolution', 'std']          # 2 inputs
output_cols = ['d', 'g', 'b', 'v'] # 4 outputs
# ====================================================

def calculate_metrics(y_true, y_pred, col_names):
    print(f"\n{'Variable':<10} | {'R²':<8} | {'RMSE':<10} | {'MAE':<10}")
    print("-" * 45)
    metrics = []
    for i, name in enumerate(col_names):
        r2 = r2_score(y_true[:, i], y_pred[:, i])
        rmse = np.sqrt(mean_squared_error(y_true[:, i], y_pred[:, i]))
        mae = mean_absolute_error(y_true[:, i], y_pred[:, i])
        metrics.append({'Feature': name, 'R2': r2, 'RMSE': rmse, 'MAE': mae})
        print(f"{name:<10} | {r2:.4f}   | {rmse:.4f}     | {mae:.4f}")
    
    avg_r2 = np.mean([m['R2'] for m in metrics])
    print("-" * 45)
    print(f"{'Average':<10} | {avg_r2:.4f}")
    return metrics

def main():
    print("="*70)
    print("KNN Prediction System (Load Weighted Model)")
    print("="*70)

    # 1. Check files
    for f in [model_path, scaler_path, weights_path, new_data_file]:
        if not os.path.exists(f):
            print(f"❌ File not found: {f}")
            return

    # 2. Load Model, Scaler, and Weights
    print("🔄 Loading model components...")
    model = joblib.load(model_path)
    scaler = joblib.load(scaler_path)
    weights_array = np.load(weights_path) # Load weights
    
    print(f"✅ Load successful. Feature weights: {weights_array.flatten()}")

    # 3. Read Data
    df_new = pd.read_excel(new_data_file)
    
    # Verify columns
    missing_in = [c for c in input_cols if c not in df_new.columns]
    missing_out = [c for c in output_cols if c not in df_new.columns]
    if missing_in or missing_out:
        print(f"❌ Missing columns. Missing Input:{missing_in}, Missing Output:{missing_out}")
        return

    X_new = df_new[input_cols].values
    y_true = df_new[output_cols].values

    # Remove NaN
    mask = ~np.isnan(X_new).any(axis=1) & ~np.isnan(y_true).any(axis=1)
    X_clean = X_new[mask]
    y_clean = y_true[mask]
    df_valid = df_new[mask].reset_index(drop=True)

    # 4. Preprocessing: Standardization -> Weighting
    print("🔄 Executing standardization and weighting...")
    X_scaled = scaler.transform(X_clean)
    X_weighted = X_scaled * weights_array  # [Key] Apply same weights as training

    # 5. Predict
    y_pred = model.predict(X_weighted)

    # 6. Evaluate
    print("\n📊 New Data Evaluation Results:")
    metrics_list = calculate_metrics(y_clean, y_pred, output_cols)

    # 7. Export
    df_result = df_valid.copy()
    for i, col in enumerate(output_cols):
        df_result[f'{col}_Pred'] = y_pred[:, i]
        df_result[f'{col}_Error'] = np.abs(df_result[col] - df_result[f'{col}_Pred'])

    try:
        with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
            df_result.to_excel(writer, index=False, sheet_name='Results')
            pd.DataFrame(metrics_list).to_excel(writer, index=False, sheet_name='Metrics')
            
            # Record used weights
            info = pd.DataFrame({
                'Item': ['Weight_' + c for c in input_cols] + ['Date'],
                'Value': list(weights_array.flatten()) + [datetime.now().strftime("%Y-%m-%d")]
            })
            info.to_excel(writer, index=False, sheet_name='Config_Info')
            
        print(f"\n✅ Report saved: {output_file}")
    except Exception as e:
        print(f"❌ Save failed: {e}")

if __name__ == "__main__":
    main()

