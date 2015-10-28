title: "Syberia. Story of one project"
author:
  name: Kirill Sevastyanenko
  email: kirill.sevastyanenko@avant.com
  twitter: kirillseva
  github: syberia/examples

output: pres.html
controls: false
--

# Syberia
## a story of one project

--

### Who is Avant?

<img src="http://photos.prnewswire.com/prnvar/20150330/195281LOGO" width="100%">
--

### Data Science at Avant

Initially only US credit model. Now also:
- credit models for other countries
- fraud modeling
- lead conversion
- direct mail
- prepayment
- debt management
- ...

--

### How can you build and deploy so many models?

- Team understood early on that most tasks should be automated.
- Built infrastructure prototype on weekends :) called it **Syberia**.
- Now we have 6 people working solely on Syberia and internal modules.

--

### What is Syberia and why would I care?

Syberia is an opinionated data science framework written in R.

- Data science is hard (because math)
- Transferring math into code is very hard
- Validating results is extremely hard!

Need a set of conventions to help get the team on the same page.

--

### Story of the framework

It took about a year to build the framework to its full grace.

Let's, however, pretend that instead of hacking on a weekend
(mostly done by one person) there was a team and a formal process.

N.B. If you do not talk about process - you still end up with a process, and
there is no guarantee it's the right one :)

--

### Let's choose a process!

Imagine you need to build a framework
to reproducibly build, train, deploy statistical models.

--

### How about [XP](https://en.wikipedia.org/wiki/Extreme_programming)?

- Use TDD
- Hack the features away, refactor if needed
- To minimize refactoring keep the final big picture in mind

What is the big picture?

Final acceptance test! :)

--

### Initial inputs

- Business owners pay you money for models produced
- Main app is Ruby on Rails, no existing frameworks
- Dataset is evolving frequently
- New ideas come up every day, need to frequently retrain
- Should be easy to use for math PhDs

--

### Phase one! Write the final acceptance test

1. Define minimal modules
  - Import data
  - Munge data
  - Model
  - Validate
  - Deploy
  - ...

TOO MANY MODULES... approaches like PMML don't cut it

--

### Resulting exit criteria

- A model file should be self contained and reference other common modules
- New stages can be added by modifying only one file
  and be available in model file immediately
- Should provide interactivity to inspect the full data pipeline

--

### Start working on the prototype

The rest is unsure for now... Start building, new requirements will be unlocked :)

What language should we use? What can we refer to that has similar requirements?

We chose R, and the inspiration was Ruby on Rails for clear module structure.

--

### Why R?

- A lot of machine learning packages simply available
- Easy to hire data scientists
- R is a LISP! Interactive in its core
- Hence object serialization comes for free
- Everything is a list, easy to make new custom rules and structures

--

### Write a prototype in R

Start with acceptance test! Write a model file

```r
list(
  import = list(s3 = 'path/to/s3/bucket'),
  data   = list(
     "Rename dep_var" = list( renamer ~ NULL, c(X1  = 'dep_var'))
    ,"Do something"   = list( do_smth )             
  ),
  model  = list('randomForest', param1, param2, ...),
  export = list(s3 = 'path/to/model/object')
)
```

--

### Now make this work!

- Work in one `environment`.
- Write `controllers` to transform these kind of minimal imports to actual code
- New dependency unlocked! [stagerunner](http://github.com/robertzk/stagerunner)

Every name in the model file corresponds to a stage.
How to define a stage? Write a function like `lib/stages/import.R` that
transforms a list into a stagerunner.

--

### What is a stagerunner?

> A stagerunner describes a linear sequence of execution: import data, perform
  this munging step, then that munging, then do some modeling, etc. However, it
  is structured hierarchically as a nested list for easier usability.

![little picture](http://i.imgur.com/NKN3hnk.png)

--

### Moving on

Implemented import, data munging, model, export stages.

Each of them should further logically be parametrized.

- Model stage should know which classifier to use
- Import/export should be able to import from/write to anywhere
- Data stage should be able to correctly work in train and predict

These are new requirements!

--

### Parametrization through routes

Much like `routes.rb` in Rails, there is a `routes.R` in Syberia.

You can define custom preprocessors that will turn your inputs
(like your model file) into reasonable code (stagerunner)

```r
list(
  'lib/adapters'            = 'adapters',
  'lib/classifiers'         = 'classifiers',
  'models'                  = 'models'
)
```

--

### Example of flexibility of this approach
