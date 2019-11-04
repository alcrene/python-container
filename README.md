# Raison d'être

This repository packages together a few boilerplate files to simplify the deployment of python virtual environment containers. It was designed with scientific computing in mind, but should be useful for anyone wanting a lightweight solution to deploy code without building a pip package; possible uses could be
  - deploying an internal sofware solution to multiple machines;
  - sending a software solution by email;
  - sharing a coding environment for a hands-on tutorial.

Especially for the last two objectives, a process that is as painless as possible is essential, which is why I include a simple script which at least automates the environment setup on Linux. That said, every code author has different needs, and packaging requirements/standards change anyway, so it may well make sense to simply use these files as templates.

What this provides:

  - Painless packaging of a software solution into a container.
  - A standard Readme file explaining in as little words as possible how to run the code.
    Instructions are self-contained and do not require the user have previous experience with virtual environments.

# Current limitations

  The install script only works on Linux because that's the only environment I can test on. PRs providing MacOS or Windows versions would be highly appreciated !
  
# Cautions

  Avoid spaces in the directory name since many versions of virtualenv can't deal with them. This is supposed to be [fixed](https://github.com/pypa/virtualenv/issues/53#issuecomment-434461292), but its best to avoid them since your user's version may be older.
  
    
# How to use this template

  1. If it doesn't already exist, create a project directory.
  2. Copy these files and directories into the project directory.
  3. Place the project code in the `code` directory. <br>
     (Optional but highly recommended) This folder layout means code is imported in a python script with `import code`, which is a bit silly. Rename the `code` directory to something short and more descriptive to change this. *--> Don't forget to also update* `packages` *in *setup.py* to match !*
  3. Edit `DEPLOY_README` and `setup.py`: Add/remove sections based on your code's needs.
     Lines with chevrons ("`>>>>`" and "`<<<<`") provide guidance instructions and should be edited out.
  4. Activate the virtual environment you use to run your code.
  5. Run `pip freeze -r requirements-template.txt > requirements.txt` from within the container directory.
     For more information on `requirements` files, see the section [Using git repositories](#using-git-repositories-in-requirements.txt) below or [the full documenation](https://pip.readthedocs.io/en/1.1/requirements.html).
  6. Clean up `requirements.txt` by removing packages for which you don't need to track their versions. You can edit `requirements-template` before running step 4 to make them easier to identify (packages listed therein will appear first).
  7. Delete `README` (this file). You may also want to delete `requirements-template.txt`.
  8. Change the `LICENSE` file as appropriate.
  8. Rename `DEPLOY_README` to `README`.
  9. Deploy (via zip file, GitHub repository, etc.)
  
  
(PRs suggesting for packages to add or remove from `requirements-template` are encouraged !)

# What is a "virtual environment container" ?

A virtual environment container is a light-weight, self-contained python package that runs in its own virtual environment. It can be sent by email to a user, who only needs to execute the simple `install.sh` bash script in order to be able to run the code. And because it runs in its own virtual environment, it will not perturb the development environment of the user.

When I work on a research project, I quickly end up with a stack of package my code requires to run – from the ubiquitous [`numpy`](https://numpy.org/) to less common packages like [`parameters`](https://parameters.readthedocs.io/en/latest/). Some are likely to be development versions, especially if I'm developing more generic library code in parallel, and so keeping track of version numbers is essential. 

An important part of my research involves developing software tools to perform inference on dynamical systems [[1]](https://github.com/mackelab/fsGIF) [[2]](https://github.com/mackelab/sinn). As such my projects almost always depend on at least two repositories: one for project-specific code, and another for the library shared across projects. Different projects however will depend on different versions of the library, depending on the time at which they were started / finished. This can become a problem when

  1. sharing code with a collaborator
  2. working simultaneously on different projects
  3. archiving the exact code used to produce published research.

This container solution was developed to solve all three above problems.

# Why not make a proper PyPI package ?

First because its more work.
But more importantly, putting project-specific code on PyPI doesn't make much sense.

  - If I want to send updated code to a collaborator, he shouldn't have to wait for the PyPI index to update.
  - I want to be able to share development versions to collaborators without making them public.
  - A PyPI package doesn't solve problem 2 above.
  - When I do want to share the project-specific code publicly, it is *frozen*: I will never update it, and so don't need the version management provided by `pip` (c.f. problem 3).
  - If every computational researcher cretated a new PyPI package for each of his papers, the index would quickly become a mess.

# Using local packages

If your package depends on your own librairies, you may not want to push a library commit every time you want to test your package. For this situation you can use the `lib` directory. You can add two packages in two ways:

  - clone your local repository in `lib`
  - add place a symlink in `lib` to your library code

`install.sh` will loop over directories in `lib` and for each call

    pip install -e lib/$package
    
The `lib` folder is intended for development and testing; when deployment you should make sure dependencies are install with the `requirements` file. The install script prints a warning if there are directories in `lib`.
  
# Using git repositories in `requirements.txt`

For whatever reason, `pip freeze` writes out git dependencies in a slightly different format as expected by `pip install` [^1]. You will want to change it to the following format

    -e git+ssh://git@github.com/path/to/repo.git@da39a3ee5e6b4b0d3255bfef95601890afd80709#egg=MyProject
              ^                ^-- This is a slash, not a colon                                  ^
              ^-- Don't forget the colon here                                                    ^
                                                 What the package will be named once installed --^

(More info and variations [here](https://pip.readthedocs.io/en/1.1/requirements.html#git).) If you don't have `ssh` login set up on `GitHub` you can use `git` instead, but note that this won't work with private repositories (see [Using private repositories](#using-private-repositories)).

## Using private repositories
To be able to access private repositories, set up SSH connection with your GitHub account. Then you can run

    ssh-add

once, and to use SSH to connect to the repositories:

    git+ssh://git@github.com:myrepo/myproject.git

Note that for private repositories the username is required (so `git+ssh://user@github.com...`).

[^1]: I think this is because `pip freeze` grabs the commit ID with `git -v` while `pip install` expects an [ssh URI](https://tools.ietf.org/html/draft-ietf-secsh-scp-sftp-ssh-uri-04#section-3.3). None of which makes this any less stupid for the user.

