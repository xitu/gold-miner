> * 原文地址：[How I built an async form validation library in ~100 lines of code with React Hooks](https://medium.freecodecamp.org/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks-81dbff6c4a04)
> * 原文作者：[Austin Malerba](https://medium.com/@austinmalerba)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks.md)
> * 译者：[Jerry-FD](https://github.com/Jerry-FD)
> * 校对者：[yoyoyohamapi](https://github.com/yoyoyohamapi)，[Xuyuey](https://github.com/Xuyuey)，[xiaonizi1994](https://github.com/xiaonizi1994)

# 如何用 React Hooks 打造一个不到 100 行代码的异步表单校验库

![](https://cdn-images-1.medium.com/max/2706/1*EGRMyNT8x7gb0LdLmj4xMQ.png)

表单校验是一件很棘手的事情。深入了解表单的实现之后，你会发现有大量的边界场景要处理。幸运的是，市面上有很多表单校验库，它们提供了必要的表计量（译注：如 dirty、invalid、inItialized、pristine 等等）和处理函数，来让我们实现一个健壮的表单。但我要使用 [React Hooks API](https://reactjs.org/docs/hooks-reference.html) 来打造一个 100 行代码以下的表单校验库来挑战自我。虽然 React Hooks 还在实验性阶段，但是这是一个 React Hooks 实现表单校验的证明。

我要声明的是，我写的这个**库**确实是不到 100 行代码。但这个教程却有 200 行左右的代码，是因为我需要阐释清楚这个库是如何使用的。

我看过的大多数表单库的新手教程都离不开三个核心话题：**异步校验**，表单联动：某些表单项的校验需要在**其他表单项改变时**触发，**表单校验效率**的优化。我非常反感那些教程把使用场景固定，而忽略其他可变因素的影响的做法。因为在真实场景中往往事与愿违，所以我的教程会尽量覆盖更多真实场景。

我们的目标需要满足：

* 同步校验单个表单项，包括当表单项的值发生变化时，会跟随变化的有依赖的表单项

* 异步校验单个表单项，包括当表单项的值发生变化时，会跟随变化的有依赖的表单项

* 在提交表单前，同步校验所有表单项

* 在提交表单前，异步校验所有表单项

* 尝试异步提交，如果表单提交失败，展示返回的错误信息

* 给开发者提供校验表单的函数，让开发者能够在合适的时机，比如 onBlur 的时候校验表单

* 允许单个表单项的多重校验

* 当表单校验未通过时禁止提交

* 表单的错误信息只在有错误信息变化或者尝试提交表单的时候才展示出来

我们将会通过实现一个包含用户名，密码，密码二次确认的账户注册表单来覆盖这些场景。下面是个简单的界面，我们来一起打造这个库吧。

```JSX
const form = useForm({
  onSubmit,
});

const usernameField = useField("username", form, {
  defaultValue: "",
  validations: [
    async formData => {
      await timeout(2000);
      return formData.username.length < 6 && "Username already exists";
    }
  ],
  fieldsToValidateOnChange: []
});
const passwordField = useField("password", form, {
  defaultValue: "",
  validations: [
    formData =>
      formData.password.length < 6 && "Password must be at least 6 characters"
  ],
  fieldsToValidateOnChange: ["password", "confirmPassword"]
});
const confirmPasswordField = useField("confirmPassword", form, {
  defaultValue: "",
  validations: [
    formData =>
      formData.password !== formData.confirmPassword &&
      "Passwords do not match"
  ],
  fieldsToValidateOnChange: ["password", "confirmPassword"]
});

// const { onSubmit, getFormData, addField, isValid, validateFields, submitted, submitting } = form
// const { name, value, onChange, errors, setErrors, pristine, validate, validating } = usernameField
```

这是一个非常简单的 API，但着实给了我们很大的灵活性。你可能已经意识到了，这个接口包含两个名字很像的函数, validation 和 validate。validation 被定义成一个函数，它以表单数据和表单项的 name 为参数，如果验证出了问题，则返回一个错误信息，与此同时它会返回一个虚值（译者注：可转换为 false 的值）。另一方面，validate 函数会执行这个表单项的所有 validation 函数，并且更新这个表单项的错误列表。

重中之重，我们需要一个来处理表单值的变化和表单提交的骨架。我们的第一次尝试不会包含任何校验，它仅仅用来处理表单的状态。

```JSX
// 跳过样板代码: imports, ReactDOM, 等等.

export const useField = (name, form, { defaultValue } = {}) => {
  let [value, setValue] = useState(defaultValue);

  let field = {
    name,
    value,
    onChange: e => {
      setValue(e.target.value);
    }
  };
  // 注册表单项
  form.addField(field);
  return field;
};

export const useForm = ({ onSubmit }) => {
  let fields = [];

  const getFormData = () => {
    // 获得一个包含原始表单数据的 object
    return fields.reduce((formData, field) => {
      formData[field.name] = field.value;
      return formData;
    }, {});
  };

  return {
    onSubmit: async e => {
      e.preventDefault(); // 阻止默认表单提交
      return onSubmit(getFormData());
    },
    addField: field => fields.push(field),
    getFormData
  };
};

const Field = ({ label, name, value, onChange, ...other }) => {
  return (
    <FormControl className="field">
      <InputLabel htmlFor={name}>{label}</InputLabel>
      <Input value={value} onChange={onChange} {...other} />
    </FormControl>
  );
};

const App = props => {
  const form = useForm({
    onSubmit: async formData => {
      window.alert("Account created!");
    }
  });

  const usernameField = useField("username", form, {
    defaultValue: ""
  });
  const passwordField = useField("password", form, {
    defaultValue: ""
  });
  const confirmPasswordField = useField("confirmPassword", form, {
    defaultValue: ""
  });

  return (
    <div id="form-container">
      <form onSubmit={form.onSubmit}>
        <Field {...usernameField} label="Username" />
        <Field {...passwordField} label="Password" type="password" />
        <Field {...confirmPasswordField} label="Confirm Password" type="password" />
        <Button type="submit">Submit</Button>
      </form>
    </div>
  );
};
```

这里没有太难理解的代码。表单的值是我们唯一所关心的。每个表单项在它初始化结束之前把自身注册在表单上。我们的 onChange 函数也很简单。这里最复杂的函数就是 getFormData，即便如此，这也无法跟抽象的 reduce 语法相比。getFormData 遍历所有表单项，并返回一个 plain object 来表示表单的值。最后值得一提的就是在表单提交的时候，我们需要调用 preventDefault 来阻止页面重新加载。

事情发展的很顺利，现在我们来把验证加上吧。当表单项的值发生变化或者提交表单的时候，我们不是指明哪些具体的表单项需要被校验，而是校验所有的表单项。

```JSX
export const useField = (
  name,
  form,
  { defaultValue, validations = [] } = {}
) => {
  let [value, setValue] = useState(defaultValue);
  let [errors, setErrors] = useState([]);

  const validate = async () => {
    let formData = form.getFormData();
    let errorMessages = await Promise.all(
      validations.map(validation => validation(formData, name))
    );
    errorMessages = errorMessages.filter(errorMsg => !!errorMsg);
    setErrors(errorMessages);
    let fieldValid = errorMessages.length === 0;
    return fieldValid;
  };

  useEffect(
    () => {
      form.validateFields(); // 当 value 变化的时候校验表单项
    },
    [value]
  );

  let field = {
    name,
    value,
    errors,
    validate,
    setErrors,
    onChange: e => {
      setValue(e.target.value);
    }
  };
  // 注册表单项
  form.addField(field);
  return field;
};

export const useForm = ({ onSubmit }) => {
  let fields = [];

  const getFormData = () => {
    // 获得一个 object 包含原始表单数据
    return fields.reduce((formData, field) => {
      formData[field.name] = field.value;
      return formData;
    }, {});
  };

  const validateFields = async () => {
    let fieldsToValidate = fields;
    let fieldsValid = await Promise.all(
      fieldsToValidate.map(field => field.validate())
    );
    let formValid = fieldsValid.every(isValid => isValid === true);
    return formValid;
  };

  return {
    onSubmit: async e => {
      e.preventDefault(); // 阻止表单提交默认事件
      let formValid = await validateFields();
      return onSubmit(getFormData(), formValid);
    },
    addField: field => fields.push(field),
    getFormData,
    validateFields
  };
};

const Field = ({
  label,
  name,
  value,
  onChange,
  errors,
  setErrors,
  validate,
  ...other
}) => {
  let showErrors = !!errors.length;
  return (
    <FormControl className="field" error={showErrors}>
      <InputLabel htmlFor={name}>{label}</InputLabel>
      <Input
        id={name}
        value={value}
        onChange={onChange}
        onBlur={validate}
        {...other}
      />
      <FormHelperText component="div">
        {showErrors &&
          errors.map(errorMsg => <div key={errorMsg}>{errorMsg}</div>)}
      </FormHelperText>
    </FormControl>
  );
};

const App = props => {
  const form = useForm({
    onSubmit: async formData => {
      window.alert("Account created!");
    }
  });

  const usernameField = useField("username", form, {
    defaultValue: "",
    validations: [
      async formData => {
        await timeout(2000);
        return formData.username.length < 6 && "Username already exists";
      }
    ]
  });
  const passwordField = useField("password", form, {
    defaultValue: "",
    validations: [
      formData =>
        formData.password.length < 6 && "Password must be at least 6 characters"
    ]
  });
  const confirmPasswordField = useField("confirmPassword", form, {
    defaultValue: "",
    validations: [
      formData =>
        formData.password !== formData.confirmPassword &&
        "Passwords do not match"
    ]
  });

  return (
    <div id="form-container">
      <form onSubmit={form.onSubmit}>
        <Field {...usernameField} label="Username" />
        <Field {...passwordField} label="Password" type="password" />
        <Field {...confirmPasswordField} label="Confirm Password" type="password" />
        <Button type="submit">Submit</Button>
      </form>
    </div>
  );
};

```

上面的代码是改进版，大体浏览一下似乎可以跑起来了，但是要做到[交付给用户](https://codesandbox.io/s/wy074qmk98?module=%2Fsrc%2FformHooks.js)还远远不够。这个版本丢掉了很多用于隐藏错误信息的标记态（译者注：flag），这些错误信息可能会在不恰当的时机出现。比如在用户还没修改完输入信息的时候，表单就立马校验并展示相应的错误信息了。

最基本的，我们需要一些基础的标记状态来告知 UI，如果用户没有修改表单项的值，那么就不展示错误信息。再进一步，除了这些基础的，我们还需要一些额外的标记状态。

我们需要一个标记态来记录用户已经尝试提交表单了，以及一个标记态来记录表单正在提交中或者表单项正在进行异步校验。你可能也想弄清楚我们为什么要在 useEffect 的内部调用 validateFields，而不是在 onChange 里调用。我们需要 useEffect 是因为 setValue 是异步发生的，它既不会返回一个 promise，也不会给我们提供一个 callback。因此，唯一能让我们确定 setValue 是否完成的方法，就是通过 useEffect 来监听值的变化。

现在我们一起来实现这些所谓的标记态吧。用它们来更好的完善 UI 和细节。

```JSX
export const useField = (
  name,
  form,
  { defaultValue, validations = [], fieldsToValidateOnChange = [name] } = {}
) => {
  let [value, setValue] = useState(defaultValue);
  let [errors, setErrors] = useState([]);
  let [pristine, setPristine] = useState(true);
  let [validating, setValidating] = useState(false);
  let validateCounter = useRef(0);

  const validate = async () => {
    let validateIteration = ++validateCounter.current;
    setValidating(true);
    let formData = form.getFormData();
    let errorMessages = await Promise.all(
      validations.map(validation => validation(formData, name))
    );
    errorMessages = errorMessages.filter(errorMsg => !!errorMsg);
    if (validateIteration === validateCounter.current) {
      // 最近一次调用
      setErrors(errorMessages);
      setValidating(false);
    }
    let fieldValid = errorMessages.length === 0;
    return fieldValid;
  };

  useEffect(
    () => {
      if (pristine) return; // 避免渲染完成后的第一次校验
      form.validateFields(fieldsToValidateOnChange);
    },
    [value]
  );

  let field = {
    name,
    value,
    errors,
    setErrors,
    pristine,
    onChange: e => {
      if (pristine) {
        setPristine(false);
      }
      setValue(e.target.value);
    },
    validate,
    validating
  };
  form.addField(field);
  return field;
};

export const useForm = ({ onSubmit }) => {
  let [submitted, setSubmitted] = useState(false);
  let [submitting, setSubmitting] = useState(false);
  let fields = [];

  const validateFields = async fieldNames => {
    let fieldsToValidate;
    if (fieldNames instanceof Array) {
      fieldsToValidate = fields.filter(field =>
        fieldNames.includes(field.name)
      );
    } else {
      // 如果 fieldNames 缺省，则验证所有表单项
      fieldsToValidate = fields;
    }
    let fieldsValid = await Promise.all(
      fieldsToValidate.map(field => field.validate())
    );
    let formValid = fieldsValid.every(isValid => isValid === true);
    return formValid;
  };

  const getFormData = () => {
    return fields.reduce((formData, f) => {
      formData[f.name] = f.value;
      return formData;
    }, {});
  };

  return {
    onSubmit: async e => {
      e.preventDefault();
      setSubmitting(true);
      setSubmitted(true); // 用户已经至少提交过一次表单
      let formValid = await validateFields();
      let returnVal = await onSubmit(getFormData(), formValid);
      setSubmitting(false);
      return returnVal;
    },
    isValid: () => fields.every(f => f.errors.length === 0),
    addField: field => fields.push(field),
    getFormData,
    validateFields,
    submitted,
    submitting
  };
};

const Field = ({
  label,
  name,
  value,
  onChange,
  errors,
  setErrors,
  pristine,
  validating,
  validate,
  formSubmitted,
  ...other
}) => {
  let showErrors = (!pristine || formSubmitted) && !!errors.length;
  return (
    <FormControl className="field" error={showErrors}>
      <InputLabel htmlFor={name}>{label}</InputLabel>
      <Input
        id={name}
        value={value}
        onChange={onChange}
        onBlur={() => !pristine && validate()}
        endAdornment={
          <InputAdornment position="end">
            {validating && <LoadingIcon className="rotate" />}
          </InputAdornment>
        }
        {...other}
      />
      <FormHelperText component="div">
        {showErrors &&
          errors.map(errorMsg => <div key={errorMsg}>{errorMsg}</div>)}
      </FormHelperText>
    </FormControl>
  );
};

const App = props => {
  const form = useForm({
    onSubmit: async (formData, valid) => {
      if (!valid) return;
      await timeout(2000); // 模拟网络延迟
      if (formData.username.length < 10) {
        //模拟服务端返回 400 
        usernameField.setErrors(["Make a longer username"]);
      } else {
        //模拟服务端返回 201 
        window.alert(
          `form valid: ${valid}, form data: ${JSON.stringify(formData)}`
        );
      }
    }
  });

  const usernameField = useField("username", form, {
    defaultValue: "",
    validations: [
      async formData => {
        await timeout(2000);
        return formData.username.length < 6 && "Username already exists";
      }
    ],
    fieldsToValidateOnChange: []
  });
  const passwordField = useField("password", form, {
    defaultValue: "",
    validations: [
      formData =>
        formData.password.length < 6 && "Password must be at least 6 characters"
    ],
    fieldsToValidateOnChange: ["password", "confirmPassword"]
  });
  const confirmPasswordField = useField("confirmPassword", form, {
    defaultValue: "",
    validations: [
      formData =>
        formData.password !== formData.confirmPassword &&
        "Passwords do not match"
    ],
    fieldsToValidateOnChange: ["password", "confirmPassword"]
  });

  let requiredFields = [usernameField, passwordField, confirmPasswordField];

  return (
    <div id="form-container">
      <form onSubmit={form.onSubmit}>
        <Field
          {...usernameField}
          formSubmitted={form.submitted}
          label="Username"
        />
        <Field
          {...passwordField}
          formSubmitted={form.submitted}
          label="Password"
          type="password"
        />
        <Field
          {...confirmPasswordField}
          formSubmitted={form.submitted}
          label="Confirm Password"
          type="password"
        />
        <Button
          type="submit"
          disabled={
            !form.isValid() ||
            form.submitting ||
            requiredFields.some(f => f.pristine)
          }
        >
          {form.submitting ? "Submitting" : "Submit"}
        </Button>
      </form>
    </div>
  );
};
```

最后一次尝试，我们加了很多东西进去。包括四个标记态：pristine、validating、submitted 和 submitting。还添加了 fieldsToValidateOnChange，将它传给 validateFields 来声明当表单的值发生变化的时候哪些表单项需要被校验。我们在 UI 层通过这些标记状态来控制何时展示错误信息和加载动画以及禁用提交按钮。

你可能注意到了一个很特别的东西 validateCounter。我们需要记录 validate 函数的调用次数，因为 validate 在当前的调用完成之前，它有可能会被再次调用。如果是这种场景的话，我们应该放弃当前调用的结果，而只使用最新一次的调用结果来更新表单项的错误状态。

一切就绪之后，这就是我们的成果了。

- https://codesandbox.io/embed/x964kxp2vo

React Hooks 提供了一个简洁的表单校验解决方案。这是我使用这个 API 的第一次尝试。尽管有一点瑕疵，但是我依然感到了它的强大。这个接口有些奇怪，因为是按照我喜欢的样子来的。然而除了这些瑕疵以外，它的功能还是很强大的。

我觉得它还少了一些特性，比如一个 callback 机制来表明何时 useState 更新 state 完毕，这也是一个在 useEffect hook 中检查对比 prop 变化的方法。

### 后记

为了保证这个教程的易于上手，我刻意省略了一些参数的校验和异常错误处理。比如，我没有校验传入的 form 参数是否真的是一个 form 对象。如果我能明确地校验它的类型并抛出一个详细的异常信息会更好。事实上，我已经写了，代码会像这样报错。

```
Cannot read property ‘addField’ of undefined
```

在把这份代码发布成 npm 包之前，还需要合适的参数校验和异常错误处理。如我所说，如果你想深入了解的话，我已经用 [superstruct](https://github.com/ianstormtaylor/superstruct) 实现了一个包含参数校验的[更健壮的版本](https://codesandbox.io/s/1417995kx4)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
