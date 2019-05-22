> * 原文地址：[How I built an async form validation library in ~100 lines of code with React Hooks](https://medium.freecodecamp.org/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks-81dbff6c4a04)
> * 原文作者：[Austin Malerba](https://medium.com/@austinmalerba)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-an-async-form-validation-library-in-100-lines-of-code-with-react-hooks.md)
> * 译者：
> * 校对者：

# How I built an async form validation library in ~100 lines of code with React Hooks

![](https://cdn-images-1.medium.com/max/2706/1*EGRMyNT8x7gb0LdLmj4xMQ.png)

Form validation can be a tricky thing. There are a surprising number of edge cases as you get into the guts of a form implementation. Thankfully, there are many form validation libraries out there which provide the necessary flags and handlers to implement a robust form, but I challenged myself to build one in under 100 lines of code using the [React Hooks API](https://reactjs.org/docs/hooks-reference.html) (currently in alpha). As React Hooks are still an experimental proposal, this is a proof of concept for the application of React Hooks to implement form validation.

Also, fair warning, the **library** I build is 100 lines of code, but this tutorial has ~200 lines of code because I need to show how the library is used.

Many form tutorials I’ve seen fail to address three big topics: **async validation**, field validations that should be triggered when **other** **fields change**, and optimization of **validation frequency**. I am bothered by tutorials that focus on a single use case and hold all other variables constant because that’s not how the real world works, so I will try to hit a variety of use cases.

Let’s aim to satisfy the following:

* Synchronously validate a field and any dependent fields when the field value changes

* Asynchronously validate a field and any dependent fields when the field value changes

* Synchronously validate all fields before submitting

* Asynchronously validate all fields before submitting

* Attempt async submission and if the form fails to submit, display errors from the response

* Expose validation methods to the developer so the developer can validate onBlur or at other times that make sense

* Allow multiple validations per field

* Disable submission if the form has errors

* Do not show a field’s errors until it has been changed or until a form submission has been attempted

We will hit these use cases by implementing an account registration form with a username, password, and password confirmation. Below I’ve outlined the kind of interface we’re looking for, we will build a library to satisfy this contract.

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

This is a relatively simple API, but should give us a lot of flexibility. You might have noticed that this interface includes two similarly named functions, validation and validate. We will define a validation as a function that takes in form data and a field name and returns an error message if an issue is found, otherwise it will return a falsey value. On the other hand, a validate function will run all validation functions for a field and will update the field’s error list.

First things first, we need a skeleton to handle value changes and form submission. Our first iteration will not include any validation, it will merely handle form state.

```JSX
// Skipping some boilerplate: imports, ReactDOM, etc.

export const useField = (name, form, { defaultValue } = {}) => {
  let [value, setValue] = useState(defaultValue);

  let field = {
    name,
    value,
    onChange: e => {
      setValue(e.target.value);
    }
  };
  // Register field with the form
  form.addField(field);
  return field;
};

export const useForm = ({ onSubmit }) => {
  let fields = [];

  const getFormData = () => {
    // Get an object containing raw form data
    return fields.reduce((formData, field) => {
      formData[field.name] = field.value;
      return formData;
    }, {});
  };

  return {
    onSubmit: async e => {
      e.preventDefault(); // Prevent default form submission
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

There’s nothing too crazy happening in this code. The only state we track is the field values. We have each field register itself with the form at the end of its initialization. Our onChange handlers are simple. The most intimidating function in here is getFormData, but even this is pretty trivial behind the unsightly reduce syntax. getFormData iterates over the form fields and gives us a plain object representation of the form values. The last thing I feel I should explain is that we need to call preventDefault on submit to prevent the page from reloading.

This is good and dandy, but let’s add support for validations now. We won’t yet specify which fields should be validated when a field value changes. Instead, we’ll validate all fields whenever a value changes and whenever the form is submitted.

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
      form.validateFields(); // Validate fields when value changes
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
  // Register field with the form
  form.addField(field);
  return field;
};

export const useForm = ({ onSubmit }) => {
  let fields = [];

  const getFormData = () => {
    // Get an object containing raw form data
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
      e.preventDefault(); // Prevent default form submission
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

The above code is an improvement and, at first glance, it seems like it could work well, but it’s actually quite [sloppy to the end user](https://codesandbox.io/s/wy074qmk98?module=%2Fsrc%2FformHooks.js). It’s missing a lot of necessary flags that help prevent errors from showing at inappropriate times. It immediately validates fields before the user has had a chance to modify them and displays corresponding errors.

At the very least we need a pristine flag to tell the UI not to show errors if the user hasn’t changed a field. But let’s go further. In addition to a pristine flag, we will want a few more flags.

We will want a flag to indicated that the user has attempted to submit the form and we will want flags to indicate when the form is submitting and when each field is validating asynchronously. You may also be wondering why we invoke validateFields inside useEffect as opposed to inside of the onChange handler. We need useEffect because setValue happens asynchronously and neither returns a promise nor offers a callback. Therefore, the only way we can be sure setValue has completed, is by listening to a value change via useEffect.

Let’s implement the flags I mentioned to help clean up the UI and to handle some edge cases.

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
      // this is the most recent invocation
      setErrors(errorMessages);
      setValidating(false);
    }
    let fieldValid = errorMessages.length === 0;
    return fieldValid;
  };

  useEffect(
    () => {
      if (pristine) return; // Avoid validate on mount
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
      //if fieldNames not provided, validate all fields
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
      setSubmitted(true); // User has attempted to submit form at least once
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
      await timeout(2000); // Simulate network time
      if (formData.username.length < 10) {
        //Simulate 400 response from server
        usernameField.setErrors(["Make a longer username"]);
      } else {
        //Simulate 201 response from server
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

Our final iteration adds a lot. It adds four flags: pristine, validating, submitted, and submitting. It also adds the fieldsToValidateOnChange parameter, which is passed to validateFields to indicate which fields should be validated when a field value changes. We use these flags in the UI to control when spinners and errors are displayed as well as to disable the submit button.

One peculiar thing you may have noticed is the validateCounter. We need to track how many times the validate function has been called because by the time our validate function has reached completion, it’s possible that validate will have been called again. If this is the case, we need to ignore the results of this invocation and only use the results of the most recent invocation to update the error state for a field.

When all is said and done, here is the functional result.

- https://codesandbox.io/embed/x964kxp2vo

React Hooks provide a neat solution to form validation. This is my first experimentation with the proposed API and I have found it powerful, but a little awkward. The interface is peculiar, with a bit too much magic for my liking. However, once I accepted its blemishes, it proved quite capable.

I did feel it was lacking a few features, namely a callback mechanism to indicate when a useState setter has finished updating the state and also a way to inspect prop deltas in the useEffect hook.

### After Note

I have intentionally left out some argument validation and error handling in order to keep this tutorial brief and simple to follow. Take, for example, the way I do not check whether the form passed into a field is indeed a form. It would be a lot nicer to check this explicitly and to throw a verbose error. However, as I have written it, the code would bomb out with something like

```
Cannot read property ‘addField’ of undefined
```

This code needs proper argument validation and error handling before it could ever be published as an npm library. That said, I have implemented a [more robust version](https://codesandbox.io/s/1417995kx4) that includes argument validation via [superstruct](https://github.com/ianstormtaylor/superstruct) if you would care to check it out.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
