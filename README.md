# Raison d'être

This repository packages together a few boilerplate files to simplify the deployment of python virtual environment containers. It was designed with scientific computing in mind, but should be useful for anyone wanting a lightweight solution to deploy code without building a pip package; possible uses could be
  - sending a software solution by email;
  - deploying an internal sofware solution to multiple machines.

Because every code author has different needs, and packaging requirements/standards change anyway, there is no automated setup. These are little more than glorified template files I keep to make the process as painless for myself as possible. 

What this provides:

  - Painless packaging of a software solution into a container.
  - A standard Readme file explaining in as little words as possible how to run the code.
    Instructions are self-contained and do not require the user have previous experience with virtual environments.

# How to use this template

  1. Create a new directory. Give it a name like "ProjectY-Container"
  2. Copy these files into the new directory.
  3. Edit `DEPLOY_README`: Add/remove sections based on your code's needs.
     Lines with chevrons ("`>>>>`" and "`<<<<`") provide guidance instructions and should be edited out.
  4. Run `pip freeze -r requirements-template.txt > requirements.txt`.
  5. Clean up `requirements.txt` by removing packages for which you don't need to track their versions. You can edit `requirements-template` before running step 4. to make them easier to identify (packages listed therein will appear first).
  6. Delete `README` (this file). You may also want to delete `requirements-template.txt`.
  7. Rename `DEPLOY_README` to `README`.
  7. Deploy (via zip file, GitHub repository, etc.)
  
  
(The current package list in `requirements-example` is quite ad-hoc; suggestions for packages to add or remove are encouraged !)

# What is a "virtual environment container" ?

A virtual environment container is a light-weight, self-contained python package that runs in its own virtual environment. It can be sent by email to a user, who only needs to execute the simple `install.sh` bash script in order to be able to run the code. And because it runs in its own virtual environment, it will not perturb the development environment of the user.

When I work on a research project, I quickly end up with a stack of package my code requires to run – from the ubiquitous [`numpy`](https://numpy.org/) to less common packages like [`parameters`](https://parameters.readthedocs.io/en/latest/). Some are likely to be development versions, especially if I'm developing more generic library code in parallel, and so keeping track of version numbers is essential. 

My research involves developing software tools to perform inference on dynamical systems [[1]](https://github.com/mackelab/fsGIF) [[2]](https://github.com/mackelab/sinn). As such my projects almost always depend on at least two repositories: one for project-specific code, and another for the library shared across projects. Different projects however will depend on different versions of the library, depending on the time at which they were started / finished. This can become a problem when

  1. sharing code with a collaborator
  2. working simultaneously on different projects
  3. archiving the exact code used to produce published research.

This container solution was developed to solve all three above problems.

# Why not make a proper PyPI package ?

First because its more work.
But more importantly, putting project-specific code on PyPI doesn't make much sense.

  - If I want to send updated code to a collaborator, he shouldn't have to wait for the PyPI index to update.
  - I want to be able to share development versions to collaborators without making them public.
  - A PyPI package doesn't solve problem 2. above.
  - When I do want to share the code publicly, it is *frozen*: I will never update it, and so don't need the version management provided by `pip`.
  - If a new PyPI package was created for every computational paper, the index would quickly become a mess.
