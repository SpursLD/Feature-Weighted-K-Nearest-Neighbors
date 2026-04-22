# -*- coding: utf-8 -*-
"""
Created on Wed Apr 22 10:57:10 2026

@author: 123
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Mar 12 12:24:50 2026

@author: 123
"""

import pandas as pd
import numpy as np
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error
import joblib
import os
from datetime import datetime

# ==================== User Configuration Area ====================
input_excel = 'sizethresholds10.xlsx'
model_save_path = 'knn_model10_weighted.pkl'   # Note filename change
scaler_save_path = 'scaler10_weighted.pkl'
weights_save_path = 'feature10_weights.npy'    # New: save weight vector

input_cols = ['resolution', 'std']          # 2 inputs
output_cols = ['d', 'g', 'b', 'v'] # 4 outputs

# [Core Feature] Feature Weight Settings
# Order must match input_cols
# 1.0 means standard importance
# >1.0 means increase weight (e.g., 2.0 means double importance)
# <1.0 means decrease weight (e.g., 0.5 means half importance)
# Example: If Input1 is very important, Input2 is less important:
feature_weights = [7, 1] 

test_size = 0.2
random_state = 42
do_cv = True
default_k = 5
# ====================================================

def main():
    print("="*70)
    print("KNN Training System (Supports Feature Weights)")
    print("="*70)

    # 1. Check weight length
    if len(feature_weights) != len(input_cols):
        print(f"❌ Error: Number of weights ({len(feature_weights)}) must equal number of input features ({len(input_cols)})")
        return

    # 2. Load Data
    if not os.path.exists(input_excel):
        print(f"❌ File not found: {input_excel}")
        return
    df = pd.read_excel(input_excel)
    
    X = df[input_cols].values
    y = df[output_cols].values
    
    # Remove NaN
    mask = ~np.isnan(X).any(axis=1) & ~np.isnan(y).any(axis=1)
    X, y = X[mask], y[mask]
    
    if len(X) < 5:
        print("❌ Insufficient data")
        return

    # 3. Split and Standardize
    indices = np.arange(len(X))
    X_train, X_test, y_train, y_test, idx_train, idx_test = train_test_split(
        X, y, indices, test_size=test_size, random_state=random_state
    )

    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # 4. [Core Step] Apply Feature Weights
    print(f"🚀 Applying feature weights: {feature_weights}")
    weights_array = np.array(feature_weights).reshape(1, -1)
    
    X_train_weighted = X_train_scaled * weights_array
    X_test_weighted = X_test_scaled * weights_array

    # 5. Model Training
    best_k = default_k
    if do_cv:
        print("🔄 Cross-validation optimization...")
        k_range = list(range(1, min(31, len(X_train)//2)))
        if not k_range: k_range = [1]
        grid = GridSearchCV(
            KNeighborsRegressor(weights='distance'),
            {'n_neighbors': k_range},
            cv=5, scoring='neg_mean_squared_error', n_jobs=-1
        )
        grid.fit(X_train_weighted, y_train)
        best_k = grid.best_params_['n_neighbors']
        print(f"✅ Best K = {best_k}")

    model = KNeighborsRegressor(n_neighbors=best_k, weights='distance')
    model.fit(X_train_weighted, y_train)

    # 6. Evaluation
    y_pred = model.predict(X_test_weighted)
    print("\n📊 Test Set Evaluation (Weighted):")
    for i, name in enumerate(output_cols):
        r2 = r2_score(y_test[:, i], y_pred[:, i])
        rmse = np.sqrt(mean_squared_error(y_test[:, i], y_pred[:, i]))
        print(f"{name}: R²={r2:.4f}, RMSE={rmse:.4f}")

    # 7. Save Files (Model + Scaler + Weights)
    joblib.dump(model, model_save_path)
    joblib.dump(scaler, scaler_save_path)
    np.save(weights_save_path, weights_array) # Save weights
    
    print(f"\n💾 Saved successfully:")
    print(f"   - Model: {model_save_path}")
    print(f"   - Scaler: {scaler_save_path}")
    print(f"   - Feature Weights: {weights_save_path}")

if __name__ == "__main__":
    main()