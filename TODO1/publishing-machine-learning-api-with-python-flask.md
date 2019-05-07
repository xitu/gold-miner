> * 原文地址：[Publishing Machine Learning API with Python Flask](https://towardsdatascience.com/publishing-machine-learning-api-with-python-flask-98be46fb2440)
> * 原文作者：[Andrejus Baranovskis](https://medium.com/@andrejusb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-machine-learning-api-with-python-flask.md](https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-machine-learning-api-with-python-flask.md)
> * 译者：
> * 校对者：

# Publishing Machine Learning API with Python Flask

> A set of instructions describing how to expose Machine Learning model to the outside world through Python Flask REST API

![Source: Pixabay](https://cdn-images-1.medium.com/max/12000/1*kz-3jQbSoa0rPsjzHtQcLg.jpeg)

Flask is fun and easy to setup, as it says on Flask [website](http://flask.pocoo.org/). And that's true. This microframework for Python offers a powerful way of annotating Python function with REST endpoint. I’m using Flask to publish ML model API to be accessible by the 3rd party business applications.

This example is based on XGBoost.

For better code maintenance, I would recommend using a separate Jupyter notebook where ML model API will be published. Import Flask module along with Flask CORS:

```python
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin

import pickle
import pandas as pd
```

Model is trained on [Pima Indians Diabetes Database](https://raw.githubusercontent.com/jbrownlee/Datasets/master/pima-indians-diabetes.names). CSV data can be downloaded from [here](https://raw.githubusercontent.com/jbrownlee/Datasets/master/pima-indians-diabetes.data.csv). To construct Pandas data frame variable as input for model **predict** function, we need to define an array of dataset columns:

```python
# Get headers for payload
headers = ['times_pregnant', 'glucose', 'blood_pressure', 'skin_fold_thick', 'serum_insuling', 'mass_index', 'diabetes_pedigree', 'age']
```

Previously trained and saved model is loaded using Pickle:

```python
# Use pickle to load in the pre-trained model
with open(f'diabetes-model.pkl', 'rb') as f:
    model = pickle.load(f)
```

It is always a good practice to do a test run and check if the model performs well. Construct data frame with an array of column names and an array of data (using new data, the one which is not present in train or test datasets). Calling two functions — **model.predict** and **model.predict_proba**. Often I prefer **model.predict_proba**, it returns probability which describes how likely will be 0/1, this helps to interpret the result based on a certain range (0.25 to 0.75 for example). Pandas data frame is constructed with sample payload and then the model prediction is executed:

```python
# Test model with data frame
input_variables = pd.DataFrame([[1, 106, 70, 28, 135, 34.2, 0.142, 22]],
                                columns=headers, 
                                dtype=float,
                                index=['input'])

# Get the model's prediction
prediction = model.predict(input_variables)
print("Prediction: ", prediction)
prediction_proba = model.predict_proba(input_variables)
print("Probabilities: ", prediction_proba)
```

Flask API. Make sure you enable CORS, otherwise API call will not work from another host. Write annotation before the function you want to expose through REST API. Provide an endpoint name and supported REST methods (POST in this example). Payload data is retrieved from the request, Pandas data frame is constructed and model **predict_proba** function is executed:

```python
app = Flask(__name__)
CORS(app)

@app.route("/katana-ml/api/v1.0/diabetes", methods=['POST'])
def predict():
    payload = request.json['data']
    values = [float(i) for i in payload.split(',')]
    
    input_variables = pd.DataFrame([values],
                                columns=headers, 
                                dtype=float,
                                index=['input'])

    # Get the model's prediction
    prediction_proba = model.predict_proba(input_variables)
    prediction = (prediction_proba[0])[1]
    
    ret = '{"prediction":' + str(float(prediction)) + '}'
    
    return ret

# running REST interface, port=5000 for direct test
if __name__ == "__main__":
    app.run(debug=False, host='0.0.0.0', port=5000)
```

Response JSON string is constructed and returned as a function result. I’m running Flask in Docker container, that's why using 0.0.0.0 as the host on which it runs. Port 5000 is mapped as external port and this allows calls from the outside.

While it works to start Flask interface directly in Jupyter notebook, I would recommend to convert it to Python script and run from command line as a service. Use Jupyter **nbconvert** command to convert to Python script:

**jupyter nbconvert — to python diabetes_redsamurai_endpoint_db.ipynb**

Python script with Flask endpoint can be started as the background process with PM2 process manager. This allows to run endpoint as a service and start other processes on different ports. PM2 start command:

**pm2 start diabetes_redsamurai_endpoint_db.py**

![](https://cdn-images-1.medium.com/max/3552/1*ymbjE3X9BAgcyqZA3CLJPQ.png)

**pm2 monit** helps to display info about running processes:

![](https://cdn-images-1.medium.com/max/6344/1*ZtdDZqNcgFhCF4lLjQVnLg.png)

ML model classification REST API call from Postman through endpoint served by Flask:

![](https://cdn-images-1.medium.com/max/2616/1*nnMgVWFXiUlJj9NnF4peHA.png)

More info:

* GitHub [repo](https://github.com/abaranovskis-redsamurai/automation-repo) with source code

* Previous [post](https://bit.ly/2Hs38C5) about XGBoost model training

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
