
# >>>>> See https://github.com/pypa/sampleproject/blob/master/setup.py <<<<<<

from setuptools import setup

setup(
      name='',
      version='0.0.1dev',
      description="",

      author="author",
      author_email="email",

      license='MIT',

      # >>>>>> See https://pypi.org/classifiers/ <<<<<<<<
      classifiers=[
          #'Development Status :: 1 - Planning',
          #'Development Status :: 2 - Pre-Alpha',
          'Development Status :: 3 - Alpha',
          'Intended Audience :: Science/Research',
          'Programming Language :: Python :: 3',
          'Programming Language :: Python :: 3 :: Only'
      ],
      
      python_requires='>=3.6',
      
      packages=["code"],

      install_requires=['numpy']
     )
