# Model Deployment with PyTorch

This reference covers saving, loading, and deploying PyTorch models for production.

## Model Saving and Loading

### Save and Load State Dict (Recommended)

```python
# Save
torch.save(model.state_dict(), 'model.pth')

# Load
model = MyModel()  # Must create model instance first
model.load_state_dict(torch.load('model.pth'))
model.eval()

# Load on different device
model.load_state_dict(torch.load('model.pth', map_location='cpu'))
```

### Save Complete Model

```python
# Save entire model (not recommended for production)
torch.save(model, 'complete_model.pth')

# Load
model = torch.load('complete_model.pth')
model.eval()
```

### Save Training Checkpoint

```python
# Save checkpoint with additional info
checkpoint = {
    'epoch': epoch,
    'model_state_dict': model.state_dict(),
    'optimizer_state_dict': optimizer.state_dict(),
    'scheduler_state_dict': scheduler.state_dict(),
    'loss': loss,
    'accuracy': accuracy
}
torch.save(checkpoint, 'checkpoint.pth')

# Load checkpoint
checkpoint = torch.load('checkpoint.pth')
model.load_state_dict(checkpoint['model_state_dict'])
optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
scheduler.load_state_dict(checkpoint['scheduler_state_dict'])
epoch = checkpoint['epoch']
loss = checkpoint['loss']
```

### Save for Inference Only

```python
# Remove unnecessary training parameters
model.eval()
torch.save({
    'model_state_dict': model.state_dict(),
    'input_size': input_size,
    'num_classes': num_classes
}, 'model_inference.pth')

# Load for inference
checkpoint = torch.load('model_inference.pth')
model = MyModel(checkpoint['input_size'], checkpoint['num_classes'])
model.load_state_dict(checkpoint['model_state_dict'])
model.eval()
```

## TorchScript

TorchScript allows you to serialize PyTorch models for deployment in production environments.

### Tracing

```python
import torch.jit

# Create model and example input
model = MyModel()
model.eval()
example_input = torch.randn(1, 3, 224, 224)

# Trace the model
traced_model = torch.jit.trace(model, example_input)

# Save
traced_model.save('model_traced.pt')

# Load and use
loaded_model = torch.jit.load('model_traced.pt')
loaded_model.eval()

output = loaded_model(input_tensor)
```

### Scripting

```python
# Script the model (better for control flow)
scripted_model = torch.jit.script(model)

# Save
scripted_model.save('model_scripted.pt')

# Load
loaded_model = torch.jit.load('model_scripted.pt')
```

### Freezing for Inference

```python
# Freeze for optimized inference
model.eval()
scripted_model = torch.jit.script(model)
frozen_model = torch.jit.freeze(scripted_model)

# Save
frozen_model.save('model_frozen.pt')
```

### Mobile Optimization

```python
from torch.utils.mobile_optimizer import optimize_for_mobile

# Trace and optimize
traced_model = torch.jit.trace(model, example_input)
optimized_model = optimize_for_mobile(traced_model)

# Save for mobile
optimized_model._save_for_lite_interpreter('model_mobile.ptl')
```

## ONNX Export

ONNX (Open Neural Network Exchange) allows models to run on different frameworks and platforms.

### Basic Export

```python
import torch.onnx

# Prepare model and dummy input
model = MyModel()
model.eval()
dummy_input = torch.randn(1, 3, 224, 224)

# Export
torch.onnx.export(
    model,
    dummy_input,
    'model.onnx',
    export_params=True,
    opset_version=11,
    do_constant_folding=True,
    input_names=['input'],
    output_names=['output'],
    dynamic_axes={
        'input': {0: 'batch_size'},
        'output': {0: 'batch_size'}
    }
)
```

### Verify ONNX Model

```python
import onnx
import onnxruntime as ort

# Check ONNX model
onnx_model = onnx.load('model.onnx')
onnx.checker.check_model(onnx_model)

# Run with ONNX Runtime
session = ort.InferenceSession('model.onnx')

# Prepare input
input_data = np.random.randn(1, 3, 224, 224).astype(np.float32)

# Run inference
outputs = session.run(None, {'input': input_data})
```

### Compare PyTorch and ONNX Outputs

```python
# PyTorch output
with torch.no_grad():
    torch_output = model(dummy_input)

# ONNX output
ort_inputs = {session.get_inputs()[0].name: dummy_input.numpy()}
ort_output = session.run(None, ort_inputs)[0]

# Compare
np.testing.assert_allclose(
    torch_output.numpy(),
    ort_output,
    rtol=1e-03,
    atol=1e-05
)
```

## Model Quantization

Quantization reduces model size and improves inference speed.

### Dynamic Quantization

```python
import torch.quantization

# Quantize model (weights only)
quantized_model = torch.quantization.quantize_dynamic(
    model,
    {torch.nn.Linear},  # Layers to quantize
    dtype=torch.qint8
)

# Save
torch.save(quantized_model.state_dict(), 'model_quantized.pth')
```

### Static Quantization

```python
# Prepare model
model.qconfig = torch.quantization.get_default_qconfig('fbgemm')
model_prepared = torch.quantization.prepare(model)

# Calibrate with representative data
model_prepared.eval()
with torch.no_grad():
    for data, _ in calibration_loader:
        model_prepared(data)

# Convert to quantized model
model_quantized = torch.quantization.convert(model_prepared)
```

### Quantization Aware Training

```python
# Prepare model for QAT
model.qconfig = torch.quantization.get_default_qat_qconfig('fbgemm')
model_prepared = torch.quantization.prepare_qat(model)

# Train normally
for epoch in range(num_epochs):
    train(model_prepared, train_loader, optimizer)

# Convert to quantized model
model_prepared.eval()
model_quantized = torch.quantization.convert(model_prepared)
```

## TorchServe

TorchServe is PyTorch's official model serving framework.

### Create Model Archive

```bash
# Install torch-model-archiver
pip install torch-model-archiver

# Archive model
torch-model-archiver \
    --model-name my_model \
    --version 1.0 \
    --model-file model.py \
    --serialized-file model.pth \
    --handler image_classifier \
    --extra-files index_to_name.json
```

### Custom Handler

```python
# custom_handler.py
from ts.torch_handler.base_handler import BaseHandler
import torch
import io
from PIL import Image
from torchvision import transforms

class CustomHandler(BaseHandler):
    def __init__(self):
        super().__init__()
        self.transform = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406],
                               std=[0.229, 0.224, 0.225])
        ])
    
    def initialize(self, context):
        self.manifest = context.manifest
        properties = context.system_properties
        model_dir = properties.get('model_dir')
        
        # Load model
        self.model = torch.jit.load(f'{model_dir}/model.pt')
        self.model.eval()
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model.to(self.device)
    
    def preprocess(self, data):
        images = []
        for row in data:
            image_data = row.get('data') or row.get('body')
            if isinstance(image_data, (bytearray, bytes)):
                image = Image.open(io.BytesIO(image_data))
                image = self.transform(image)
                images.append(image)
        
        return torch.stack(images).to(self.device)
    
    def inference(self, data):
        with torch.no_grad():
            return self.model(data)
    
    def postprocess(self, data):
        return data.cpu().tolist()
```

### Start TorchServe

```bash
# Start server
torchserve --start --model-store model_store --models my_model=my_model.mar

# Stop server
torchserve --stop

# Make prediction
curl -X POST http://localhost:8080/predictions/my_model -T input.jpg
```

## REST API Deployment

### Flask API

```python
from flask import Flask, request, jsonify
import torch
from PIL import Image
import io

app = Flask(__name__)

# Load model
model = torch.jit.load('model.pt')
model.eval()

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    img = Image.open(io.BytesIO(file.read()))
    
    # Preprocess
    img_tensor = transform(img).unsqueeze(0)
    
    # Inference
    with torch.no_grad():
        output = model(img_tensor)
        prediction = output.argmax(dim=1).item()
    
    return jsonify({'prediction': prediction})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### FastAPI

```python
from fastapi import FastAPI, File, UploadFile
import torch
from PIL import Image
import io

app = FastAPI()

model = torch.jit.load('model.pt')
model.eval()

@app.post('/predict')
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    img = Image.open(io.BytesIO(contents))
    
    img_tensor = transform(img).unsqueeze(0)
    
    with torch.no_grad():
        output = model(img_tensor)
        prediction = output.argmax(dim=1).item()
    
    return {'prediction': prediction}

# Run with: uvicorn main:app --host 0.0.0.0 --port 8000
```

## Docker Deployment

### Dockerfile

```dockerfile
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY model.pt .
COPY app.py .

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Build and Run

```bash
# Build image
docker build -t pytorch-model:latest .

# Run container
docker run -p 8000:8000 pytorch-model:latest

# With GPU
docker run --gpus all -p 8000:8000 pytorch-model:latest
```

## Cloud Deployment

### AWS SageMaker

```python
import sagemaker
from sagemaker.pytorch import PyTorchModel

# Create model
pytorch_model = PyTorchModel(
    model_data='s3://bucket/model.tar.gz',
    role=role,
    entry_point='inference.py',
    framework_version='2.0',
    py_version='py3'
)

# Deploy
predictor = pytorch_model.deploy(
    initial_instance_count=1,
    instance_type='ml.m5.xlarge'
)

# Predict
result = predictor.predict(data)
```

### Google Cloud AI Platform

```bash
# Upload model
gsutil cp model.pt gs://bucket/models/

# Deploy
gcloud ai-platform models create my_model
gcloud ai-platform versions create v1 \
    --model my_model \
    --origin gs://bucket/models/ \
    --runtime-version 2.0 \
    --python-version 3.8
```

## Performance Optimization

### Batch Inference

```python
def batch_inference(model, dataloader, device):
    model.eval()
    all_predictions = []
    
    with torch.no_grad():
        for batch in dataloader:
            batch = batch.to(device)
            outputs = model(batch)
            predictions = outputs.argmax(dim=1)
            all_predictions.extend(predictions.cpu().numpy())
    
    return all_predictions
```

### Mixed Precision Inference

```python
from torch.cuda.amp import autocast

model.eval()
with torch.no_grad(), autocast():
    output = model(input_tensor.half())
```

### Model Compilation (PyTorch 2.0+)

```python
# Compile model for faster inference
compiled_model = torch.compile(model)

# Use as normal
with torch.no_grad():
    output = compiled_model(input_tensor)
```

### TensorRT Optimization

```python
import torch_tensorrt

# Convert to TensorRT
trt_model = torch_tensorrt.compile(
    model,
    inputs=[torch_tensorrt.Input((1, 3, 224, 224))],
    enabled_precisions={torch.float, torch.half}
)

# Save
torch.jit.save(trt_model, 'model_trt.ts')
```

## Monitoring and Logging

### Basic Logging

```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    logger.info('Received prediction request')
    
    try:
        # Prediction code
        logger.info(f'Prediction successful: {prediction}')
        return jsonify({'prediction': prediction})
    except Exception as e:
        logger.error(f'Prediction failed: {str(e)}')
        return jsonify({'error': str(e)}), 500
```

### Performance Monitoring

```python
import time

class ModelMonitor:
    def __init__(self):
        self.request_count = 0
        self.total_time = 0
    
    def record_inference(self, inference_time):
        self.request_count += 1
        self.total_time += inference_time
    
    def get_stats(self):
        avg_time = self.total_time / self.request_count if self.request_count > 0 else 0
        return {
            'total_requests': self.request_count,
            'average_inference_time': avg_time
        }

monitor = ModelMonitor()

@app.route('/predict', methods=['POST'])
def predict():
    start_time = time.time()
    
    # Inference
    prediction = model(input_tensor)
    
    inference_time = time.time() - start_time
    monitor.record_inference(inference_time)
    
    return jsonify({'prediction': prediction})

@app.route('/metrics', methods=['GET'])
def metrics():
    return jsonify(monitor.get_stats())
```

## Best Practices

### Pre-deployment Checklist

1. **Model validation**: Test on representative data
2. **Version control**: Tag model versions
3. **Documentation**: Document input/output formats
4. **Error handling**: Handle edge cases gracefully
5. **Monitoring**: Set up logging and metrics
6. **Security**: Validate inputs, use authentication
7. **Scalability**: Test under load
8. **Backup**: Keep backup of models

### Optimization Tips

1. Use TorchScript for production
2. Enable mixed precision inference
3. Batch requests when possible
4. Use GPU for large models
5. Consider model quantization
6. Cache preprocessing results
7. Use async processing for APIs
8. Monitor and profile performance

### Common Issues

**Issue: Model too large**
- Use quantization
- Prune unnecessary layers
- Use distillation

**Issue: Slow inference**
- Enable mixed precision
- Use TensorRT
- Batch processing
- Model compilation

**Issue: Memory errors**
- Reduce batch size
- Clear cache between requests
- Use model quantization
