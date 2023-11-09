> * 原文地址：[Building an Amazon Bedrock App for Text and Image Retrieval](hhttps://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal)
> * 原文作者：[Rashwan Lazkani](https://dev.to/rashwanlazkani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/building-an-amazon-bedrock-app-for-text-and-image-retrieval.md](https://github.com/xitu/gold-miner/blob/master/article/2023/building-an-amazon-bedrock-app-for-text-and-image-retrieval.md)
> * 译者：

[![Cover image for Building an Amazon Bedrock App for Text and Image Retrieval](https://res.cloudinary.com/practicaldev/image/fetch/s--IqV2UoUX--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5pvbl6rnra2z7cuveuqd.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--IqV2UoUX--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5pvbl6rnra2z7cuveuqd.jpg)

Introducing [Amazon Bedrock](https://aws.amazon.com/bedrock/), a fully managed service, that provides a range of top-performing foundation models (FMs) from leading AI companies. It empowers you to effortlessly experiment with these FMs, customize them with your data through techniques like fine-tuning and retrieval augmented generation (RAG), and build managed agents for executing intricate business tasks and private projects.

[Source Amazon](https://aws.amazon.com/bedrock/).

As a fully managed service, it eliminates the need for server management or similar tasks. This means you won't have to worry about server provisioning, scaling, or maintenance.

In the context of serverless computing, services like AWS Lambda enable you to run code without managing servers. When you trigger a Lambda function, AWS automatically handles the infrastructure, scaling, and execution of your code. It's a pay-as-you-go model where you're only charged for the compute time your code actually uses, making it a cost-efficient and hassle-free option for running code in the cloud.

Tools that we'll be using:

-   Amazon Bedrock
-   AWS Lambda
-   Serverless Framework
-   TypeScript

Today, we'll be building two Lambda functions for text and image retrieval from Amazon Bedrock. We'll deploy these using Infrastructure as Code, make them accessible via API Gateway, and ensure everything remains Serverless.

You can use these functions to create applications similar to the ones I've showcased below:

**Bedrock with Text**  
[![Bedrock with Text](https://res.cloudinary.com/practicaldev/image/fetch/s--HAbhq2S0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7r69srtdtlw5pl5uuyn9.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--HAbhq2S0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7r69srtdtlw5pl5uuyn9.png)

**Bedrock with Images**  
[![Bedrock with Images](https://res.cloudinary.com/practicaldev/image/fetch/s--fiZag7C4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gi7j60b2cqsm4v29p1io.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--fiZag7C4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gi7j60b2cqsm4v29p1io.png)

Let's start!

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#accessing-bedrock-begins-with-the-following-steps)Accessing BedRock begins with the following steps:

1.  Login to your AWS Console
2.  Go to Amazon Bedrock
3.  In the left navigation click on Model access
4.  Request access

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#lets-proceed-to-develop-our-lambda-functions)Let's proceed to develop our Lambda functions:

You can choose which tool you want to use for deploying your Lambda functions by yourself but I'll provide the code for creating the Lambdas:

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#text-lambda)Text Lambda:

**Please take note of a few important points below:**

1.  You need to import the `client-bedrock-runtime` package
2.  You need to add the modelId
3.  The prompt is the search text provided from your API

```
import { BedrockRuntimeClient, InvokeModelCommand } from '@aws-sdk/client-bedrock-runtime';

const client = new BedrockRuntimeClient({ region: 'us-east-1' });

export async function handler(event: any) {
  const prompt = JSON.parse(event.body).prompt;
  const input = {
    modelId: 'ai21.j2-mid-v1',
    contentType: 'application/json',
    accept: '*/*',
    headers: {
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': true,
      'Access-Control-Allow-Methods': 'POST'
    },
    body: JSON.stringify({
      prompt: prompt,
      maxTokens: 200,
      temperature: 0.7,
      topP: 1,
      stopSequences: [],
      countPenalty: { scale: 0 },
      presencePenalty: { scale: 0 },
      frequencyPenalty: { scale: 0 }
    })
  };

  try {
    const data = await client.send(new InvokeModelCommand(input));
    const jsonString = Buffer.from(data.body).toString('utf8');
    const parsedData = JSON.parse(jsonString);
    const text = parsedData.completions[0].data.text;
    return text;
  } catch (error) {
    console.error(error);
  }
}
```

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#image-lambda)Image Lambda

```
import { BedrockRuntimeClient, InvokeModelCommand } from '@aws-sdk/client-bedrock-runtime';

const client = new BedrockRuntimeClient({ region: 'us-east-1' });

export async function handler(event: any) {
  const prompt = JSON.parse(event.body).text_prompts;
  const input = {
    modelId: 'stability.stable-diffusion-xl-v0',
    contentType: 'application/json',
    accept: 'application/json',
    headers: {
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': true,
      'Access-Control-Allow-Methods': 'POST'
    },
    body: JSON.stringify({
      text_prompts: prompt,
      cfg_scale: 10,
      seed: 0,
      steps: 50
    })
  };

  try {
    const command = new InvokeModelCommand(input);
    const response = await client.send(command);

    const blobAdapter = response.body;

    const textDecoder = new TextDecoder('utf-8');
    const jsonString = textDecoder.decode(blobAdapter.buffer);

    try {
      const parsedData = JSON.parse(jsonString);
      return parsedData.artifacts[0].base64;
    } catch (error) {
      console.error('Error parsing JSON:', error);
      return 'TextError';
    }
  } catch (error) {
    console.error(error);
  }
}

```

Now deploy your Lambdas, if you're using Serverless Framework you can use the following configuration:  

```
service: aws-bedrock-ts
frameworkVersion: '3'

provider:
  name: aws
  runtime: nodejs18.x
  iam:
    role:
      statements:
        - Effect: 'Allow'
          Action:
            - 'bedrock:InvokeModel'
          Resource: '*'

functions:
  bedrockText:
    handler: src/bedrock/text.handler
    name: 'aws-bedrock-text'
    events:
      - httpApi:
          path: /bedrock/text
          method: post
  bedrockImage:
    handler: src/bedrock/image.handler
    name: 'aws-bedrock-image'
    events:
      - httpApi:
          path: /bedrock/image
          method: post
```

Let's test our functions in Postman:

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#text)Text

Create a new POST request with the following data:

1.  URL: add the URL to your newly created Text Lambda
2.  Body: add the following body:

```
{
    "prompt": "Your search text"
}

```

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#images)Images

Create a new POST request with the following data:

1.  URL: add the URL to your newly created Image Lambda
2.  Body: add the following body:

```
{
    "text_prompts": [
        {
            "text": "Your search text"
        }
    ],
    "cfg_scale": 10,
    "seed": 0,
    "steps": 50
}
```

Now that your functions are prepared to be utilized with API Gateway, you can begin integrating them into your applications, much like the example I presented in the beginning of this article.

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#note-a-couple-of-things)Note a couple of things

As this is a local app for testing, I've set the `Access-Control-Allow-Origin` to `*`. Additionally, you may need to adjust the CORS settings in API Gateway. Please be aware that there will be a small cost associated with your API calls. For detailed pricing information, refer to the [Amazon Bedrock pricing model](https://aws.amazon.com/bedrock/pricing/).

### [](https://dev.to/aws-builders/building-an-amazon-bedrock-app-for-text-and-image-retrieval-3hal#conclusion)Conclusion

Amazon Bedrock provides a robust selection of high-performing foundation models from top AI companies. Integrating it into your application is straightforward and enhances its capabilities. If you haven't tried it yet, I highly recommend doing so!

Interested in the complete project? Feel free to let me know, and I'll create a part two that covers the UI aspect.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。