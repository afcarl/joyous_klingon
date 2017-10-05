# joyous_klingon

To install this and starting tinkering around with STAN, Do the following

1. Install conda
If you have MAC, do

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
chmod a+x Miniconda3-latest-MacOSX-x86_64.sh
./Miniconda3-latest-MacOSX-x86_64.sh
source ~/.bash_profile
```

If you have Linux, do

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
```

If you have Windows -- then uninstall Windows and install [Ubuntu](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-desktop#0).  Let's face it Windows sucks ...

2. Install a conda environment

```
conda create -n stan pandas pystan numpy scipy matplotlib jupyter notebook
source activate stan
```

3. Open up the jupyter notebook and have fun!
```
jupyter notebook
```
