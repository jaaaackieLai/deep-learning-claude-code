# 程式碼風格規範

此文件定義本專案的程式碼撰寫規範與最佳實踐。

## 環境設定規範

### Python 環境要求

本專案必須在 **jackie_GCN** conda 環境中執行。在執行任何 Python 程式前，必須先確認環境設定正確。如果當前不在此環境中，執行：
```bash
conda activate jackie_GCN
```


## GPU 使用規範

程式應該預設支援 GPU 加速，設置方式如下，同時應確保 args 有 gpu 參數的設置:

```python
device = torch.device(f'cuda:{args.gpu}' if torch.cuda.is_available() else 'cpu')
```

## 程式碼風格要求

### 基本原則

- **添加適當的類型提示**：為函數參數和返回值添加型別標註
- **保持與現有架構的相容性**：修改前先了解現有設計模式
- **考慮 GPU 支援和記憶體效率**：避免不必要的記憶體複製和 CPU-GPU 傳輸

### 1. 簡單判斷測試使用 assert

對於簡單的條件檢查（如參數驗證、路徑存在性），使用 `assert condition, "message"` 而非 `if not condition: raise Error("message")`，避免不必要的縮排與行數。

✅ **正確寫法**:
```python
assert os.path.exists(path), f"Path not found: {path}"
assert dataset in ['freqshape', 'seqcomb-uv'], f"Unknown dataset: {dataset}"
```

❌ **錯誤寫法**:
```python
if not os.path.exists(path):
    raise FileNotFoundError(f"Path not found: {path}")
```

### 2. torch.load 參數要求

使用 `torch.load` 時必須加上 `weights_only=False` 參數。

✅ **正確寫法**:
```python
torch.load(load_path, weights_only=False, map_location=device)
```

❌ **錯誤寫法**:
```python
torch.load(load_path)
```

### 3. 多選項選擇寫法規範

當有 3 個（含）以上獨立且單獨的選項需要選擇時，優先使用 `match` 語句而非多層 `if-elif` 鏈。

✅ **正確寫法**（使用 match）:
```python
match model_type:
    case "lstm":
        model = LSTMModel()
    case "cnn":
        model = CNNModel()
    case "transformer":
        model = TransformerModel()
    case _:
        raise ValueError(f"Unknown model: {model_type}")
```

❌ **錯誤寫法**（使用 if-elif 鏈）:
```python
if model_type == "lstm":
    model = LSTMModel()
elif model_type == "cnn":
    model = CNNModel()
elif model_type == "transformer":
    model = TransformerModel()
else:
    raise ValueError(f"Unknown model: {model_type}")
```

**原因**：match 語句保持美觀且淺顯易懂，減少重複的比較運算，意圖更明確

**注意**：需要 Python 3.10+ 才支援 match 語句

### 4. ArgumentParser 寫法規範

所有 `parser.add_argument()` 必須在**單行內完成**，不可拆成多行。

✅ **正確寫法**（單行）:
```python
parser.add_argument("--mode", type=str, default="train", choices=["train", "test", "eval"], help="Execution mode")
```

❌ **錯誤寫法**（多行）:
```python
parser.add_argument('--mode', type=str, default='train',
                    choices=['train', 'test', 'eval'],
                    help='Execution mode')
```

### 5. 訓練進度顯示規範

所有訓練流程必須使用 `tqdm` 顯示進度，而非 `print` 語句，並且加上`dynamic_ncols=True` 以自動適應終端機寬度。

✅ **正確寫法**（使用 tqdm）:
```python
from tqdm import tqdm

epoch_pbar = tqdm(range(num_epochs), desc='Training', unit='epoch', dynamic_ncols=True)
for epoch in epoch_pbar:
    # ... training code ...
    epoch_pbar.set_postfix({'Loss': f'{loss:.4f}', 'F1': f'{f1:.4f}'})
```

❌ **錯誤寫法**（使用 print）:
```python
for epoch in range(num_epochs):
    # ... training code ...
    if (epoch + 1) % print_freq == 0:
        print(f'Epoch {epoch}, Loss = {loss:.4f}')
```
**原因**：tqdm 提供即時進度條與預估剩餘時間，對長時間訓練更友好

### 6. 函數呼叫換行規範

當函數傳入的參數過多需要換行時，保留**第一個參數**在呼叫行的同一行，其餘參數換行並對齊第一個參數的起始位置。

✅ **正確寫法**（首參數留原行，其餘對齊）:
```python
ans = compute(first_arg,
              second_arg,
              third_arg)
```

❌ **錯誤寫法**（首參數換行，或縮排不對齊）:
```python
ans = compute(
    first_arg,
    second_arg,
    third_arg)
```

**原因**：保留第一個參數於呼叫行，讓讀者一眼看到函數與其第一個參數的關聯；後續參數垂直對齊，方便逐行比對各參數值。

### 7. Ray Tune 使用 subprocess 呼叫訓練腳本

使用 Ray Tune 進行超參數搜尋時，**禁止在 trainable 函數內重新實作訓練迴圈**。必須透過 `subprocess` 呼叫主訓練腳本（如 `main.py`），確保搜尋行為與正式訓練完全一致。

**設計原則**：
- **單一真相來源**：訓練邏輯只存在於 `main.py` / `epoch_train.py`，trainable 只負責組裝 CLI 參數、啟動 subprocess、讀取結果
- **config-to-CLI 轉換函數**：在 `tune_config.py` 中維護 `config_to_cli_args()`，負責將 Ray Tune config dict 轉為 CLI 參數列表
- **結果讀取**：subprocess 結束後，從 `summary.json` 讀取指標（如 `clf_F1_mean`），回報給 Ray Tune
- **GPU 隔離**：Ray 設定 `CUDA_VISIBLE_DEVICES`，subprocess 繼承環境，`main.py --gpu 0` 即可

✅ **正確寫法**（subprocess 模式）:
```python
def trainable(config: dict) -> None:
    cli_args = config_to_cli_args(config, dataset=dataset, ...)
    cmd = [sys.executable, "main.py"] + cli_args
    result = subprocess.run(cmd, cwd=project_root, capture_output=True, text=True)
    summary = json.load(open(summary_path))
    train.report({'clf_F1_mean': summary['clf_F1_mean']})
```

❌ **錯誤寫法**（重新實作訓練迴圈）:
```python
def trainable(config: dict) -> None:
    clf = build_model(config)
    for epoch in range(config['rounds']):
        for batch in train_loader:
            # ... 重複 epoch_train.py 的邏輯 ...
        train.report({'val_f1': val_f1})
```

**原因**：避免訓練邏輯重複維護，確保超參數搜尋與正式訓練行為完全一致，減少隱性 bug
