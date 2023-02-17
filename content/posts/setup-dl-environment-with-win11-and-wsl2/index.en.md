---
title: "Setup Deep Learning Environment With Windows 11 and WSL2"
date: 2023-02-17T16:07:45+08:00
draft: false
author: Felix Nguyen
tags: ["installation", "configuration"]
categories: ["Setup"]
---

After long time saving money, finally I already bought a high-end gaming laptop, not just for games but also for working. For sure somebody wonder why I don't build a powerful PC instead a laptop. When your job needs the frequent movement or your room lacks of space to put an big PC, a high-end gaming laptop can be an optimal solution. 

My laptop is Lenovo 7 16IAX7 with Core i7 12800HX CPU, Geforce RTX 3070 GPU and DDR5 16GB RAM. It's a beast for games and deep learning (at least for testing the code)!

Now when Windows 11 introduces Windows Subsystem Linux 2 (WSL2) with more supports, we don't to install the additional Linux system that you can struggle to install along side Windows in your laptop.

The GPU deep learning environment in Windows 11 can be consist of following steps.

## 1. Install WSL2 on Windows 11

Let's install WSL2 on Windows 11. First, you open Windows Power Shell and see which available Linux distributions for installation on WSL2 with following command:

```bash
# list all Linux distribution available
wsl --list --online
```

This time we will install Ubuntu 22.04.

```bash
# install Linux distribution Ubuntu-22.04
wsl --install -d Ubuntu-22.04
```

This command completes the installation.

If you have many WSL distributions, you can try following commands:

```bash
# shutdown all wsl distributions
wsl --shutdown

# define default wsl distribution to use with wsl
wsl -s <DistributionName>
```

{{< admonition note >}}
The WSL distrubution will be installed in system drive in default, if you want to locate your WSL distribution in a non-system drive, please read more in [here](https://castorfou.github.io/guillaume_blog/blog/wsl2-conda-mamba-cuda.html).
{{< /admonition >}}

## 2. Install Developement Tools

Before installing the drivers and cuDNN, I suggest you update and install some necessary tools for your distribution.

```bash
# update the system
sudo apt update -y

# upgrade the system
sudo apt upgrade -y

# install some development tools
sudo apt install -y build-essential pkg-config cmake

# install additional tools
sudo apt install -y curl wget uget tar zip unzip rar unrar

# install python3
sudo apt install -y python3 python3-dev python3-pip python3-setuptools python3-venv

# install git
sudo apt install -y git
git config --global user.name "name"
git config --global user.email "name@domain.com"
```

{{< admonition note >}}
Copy your own Github SSH keys to `~/.ssh`.
{{< /admonition >}}

## 3 Install NVIDIA Graphics Drivers on Windows 11

I recommend to install GeForce Experience Drivers. GeForce Experience is a utility that manages the graphics drivers of NVIDIA's GeForce family of products, optimizes them for various PC games, and provides recording capabilities.

From checking for the latest drivers to installing, you can easily do it with the GUI. The download is available at [this site](https://www.nvidia.com/ja-jp/geforce/geforce-experience/).

The graphics driver is installed at the same time that you install GeForce Experience.

## 3. Install CUDA on WSL2

Once the graphics driver is installed, install CUDA. If you select items according to the system at hand from [CUDA Toolkit download site](https://developer.nvidia.com/cuda-downloads), it will suggest commands according to it.

![cuda download page](cuda-download.png)

We will continue to execute the commands that have appeared.

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda-repo-wsl-ubuntu-12-0-local_12.0.1-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-0-local_12.0.1-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
```

Finally, you Set up the development environment by modifying the `PATH` and `LD_LIBRARY_PATH` variables by adding folllowing lines to `~/.bashrc`.

```bash
nano ~/.bashrc

# at the end of ~/.bashrc file
export PATH=$PATH:/usr/local/cuda-12.0/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.0/lib64:/usr/local/cuda-12.0/extras/CUPTI/lib64
# Ctrl + S to save the modification
# Ctrl + X to exit the editor

# activate .bashrc file's change
source .bashrc
```

If it finishes successfully, CUDA operation is fine.

## 4. Install cuDNN

cuDNN is a library for deep learning provided by NVIDIA. Since the calculation of neural networks is accelerated, it is an essential library for those who do deep learning. 

Download from [this site](https://developer.nvidia.com/cudnn). You must participate in the NVIDIA Developer Program to download. When the download is completed, execute the following command.

```bash
tar -xvf cudnn-linux-x86_64-8.x.x.x_cuda.X.Y-archive.tar.xz
sudo cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include
sudo cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
```

Next we will perform the installation

```bash
sudo dpkg -i cudnn-local-repo-${OS}-8.x.x.x_1.0-1_amd64.deb
sudo apt-key add /var/cudnn-local-repo-*/7fa2af80.pub
sudo apt-get update
sudo apt-get install libcudnn8=8.x.x.x-1+cudaX.Y
sudo apt-get install libcudnn8-dev=8.x.x.x-1+cudaX.Y
sudo apt-get install libcudnn8-samples=8.x.x.x-1+cudaX.Y
```

Finally, check the operation of cuDNN.

```bash
$ cp -r /usr/src/cudnn_samples_v8/ $HOME
$ cd  $HOME/cudnn_samples_v8/mnistCUDNN
$ make clean && make
$ ./mnistCUDNN
```

A sample program to solve the classification problem of the MNIST data set will work. If Test passed!is displayed, the installation is complete.

## 5. Install Mamba

Mamba is a fast, robust, and cross-platform package manager.

It runs on Windows, OS X and Linux (ARM64 and PPC64LE included) and is fully compatible with conda packages and supports most of conda’s commands.

For Linux platform, you can download [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge) for Windows, macOS and Linux, and then run the script for installation.

```bash
# download the installer
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"

# run the downloaded script
bash Mambaforge-$(uname)-$(uname -m).sh
```

{{< admonition note >}}
If you’d prefer that conda’s base environment not be activated on startup, set the auto_activate_base parameter to false: 

```bash
mamba config --set auto_activate_base false
``` 

Then close the current shell, and open new shell to activate the effect.
{{< /admonition >}}

Mambaforge comes with the popular conda-forge channel preconfigured, but you can modify the configuration to use any channel you like.

## 6. Setup Deep Learning Environement

### 6.1. PyTorch-GPU

```bash
# create virtual env
mamba create -n torchgpu python=3.10

# activate created venv
mamba activate torchgpu

# install necessary packages
pip install --upgrade pip setuptools wheel
mamba install pytorch torchvision torchaudio cudatoolkit=11.7 -c pytorch -c conda-forge
mamba install pytorch-lightning
mamba install scikit-learn scikit-image scipy
mamba install matplotlib seaborn
pip install pandas
pip install --upgrade opencv-python opencv-contrib-python
mamba install tqdm yacs
mamba install jupyter
```

Verification

```bash
$ mamba activate torchgpu
(torchgpu) $ python
>>> import torch
>>> torch.cuda.is_available()
>>> exit()
(torchgpu) $ mamba deactivat
```

### 6.2. Tensorflow-GPU

```bash
mamba create -n tfgpu python=3.10
mamba activate tfgpu
pip install --upgrade pip setuptools wheel
mamba install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
pip install tensorflow
mamba install scikit-learn scikit-image scipy
mamba install matplotlib seaborn
pip install pandas
pip install --upgrade opencv-python opencv-contrib-python
mamba install tqdm yacs
```

Verification

```bash
$ mamba activate tfgpu
(tfgpu) $ python
>>> import tensorflow as tf
>>> from tensorflow.python.client import device_lib
>>> print(tf.config.list_physical_devices('GPU'))
>>> device_lib.list_local_devices()
>>> exit()
(tfgpu) $ mamba deactivate
```
